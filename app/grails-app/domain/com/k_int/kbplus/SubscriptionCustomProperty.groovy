package com.k_int.kbplus

import com.k_int.kbplus.abstract_domain.AbstractPropertyWithCalculatedLastUpdated
import com.k_int.kbplus.abstract_domain.CustomProperty
import com.k_int.properties.PropertyDefinition
import de.laser.AuditConfig
import de.laser.interfaces.AuditableSupport
import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONElement

import javax.persistence.Transient

class SubscriptionCustomProperty extends CustomProperty implements AuditableSupport {

    @Transient
    def genericOIDService
    @Transient
    def changeNotificationService
    @Transient
    def messageSource
    @Transient
    def pendingChangeService
    @Transient
    def deletionService
    @Transient
    def auditService

    static auditable            = [ ignore: ['version', 'lastUpdated', 'lastUpdatedCascading'] ]
    static controlledProperties = ['stringValue','intValue','decValue','refValue','note','dateValue']

    PropertyDefinition type
    Subscription owner
    SubscriptionCustomProperty instanceOf

    Date dateCreated
    Date lastUpdated

    static mapping = {
        includes    AbstractPropertyWithCalculatedLastUpdated.mapping
        owner       index:'scp_owner_idx'

        dateCreated column: 'scp_date_created'
        lastUpdated column: 'scp_last_updated'
    }

    static constraints = {
        importFrom  AbstractPropertyWithCalculatedLastUpdated
        instanceOf (nullable: true)

        // Nullable is true, because values are already in the database
        lastUpdated (nullable: true, blank: false)
        dateCreated (nullable: true, blank: false)
    }

    static belongsTo = [
        type:  PropertyDefinition,
        owner: Subscription
    ]

    def afterDelete() {
        static_logger.debug("afterDelete")
        cascadingUpdateService.update(this, new Date())

        deletionService.deleteDocumentFromIndex(this.getClass().getSimpleName().toLowerCase()+":"+this.id)
    }

    @Transient
    def onChange = { oldMap, newMap ->
        log.debug("onChange ${this}")
        auditService.onChangeHandler(this, oldMap, newMap)
    }

    @Transient
    def onDelete = { oldMap ->
        log.debug("onDelete ${this}")
        auditService.onDeleteHandler(this, oldMap)
    }

    def notifyDependencies_trait(changeDocument) {
        log.debug("notifyDependencies_trait(${changeDocument})")

        if (changeDocument.event.equalsIgnoreCase('SubscriptionCustomProperty.updated')) {

            // legacy ++

            Locale locale = org.springframework.context.i18n.LocaleContextHolder.getLocale()
            ContentItem contentItemDesc = ContentItem.findByKeyAndLocale("kbplus.change.subscription."+changeDocument.prop, locale.toString())
            String description = messageSource.getMessage('default.accept.placeholder',null, locale)
            if (contentItemDesc) {
                description = contentItemDesc.content
            }
            else {
                ContentItem defaultMsg = ContentItem.findByKeyAndLocale("kbplus.change.subscription.default", locale.toString())
                if( defaultMsg)
                    description = defaultMsg.content
            }

            // legacy ++

            List<PendingChange> slavedPendingChanges = []

            List<SubscriptionCustomProperty> depedingProps = SubscriptionCustomProperty.findAllByInstanceOf( this )
            depedingProps.each{ scp ->

                String definedType = 'text'
                if (scp.type.type == RefdataValue.class.toString()) {
                    definedType = 'rdv'
                }
                else if (scp.type.type == Date.class.toString()) {
                    definedType = 'date'
                }

                // overwrite specials ..
                if (changeDocument.prop == 'note') {
                    definedType = 'text'
                    description = '(NOTE)'
                }

                def msgParams = [
                        definedType,
                        "${scp.type.class.name}:${scp.type.id}",
                        (changeDocument.prop in ['note'] ? "${changeDocument.oldLabel}" : "${changeDocument.old}"),
                        (changeDocument.prop in ['note'] ? "${changeDocument.newLabel}" : "${changeDocument.new}"),
                        "${description}"
                ]

                PendingChange newPendingChange = changeNotificationService.registerPendingChange(
                        PendingChange.PROP_SUBSCRIPTION,
                        scp.owner,
                        scp.owner.getSubscriber(),
                        [
                                changeTarget:"com.k_int.kbplus.Subscription:${scp.owner.id}",
                                changeType:PendingChangeService.EVENT_PROPERTY_CHANGE,
                                changeDoc:changeDocument
                        ],
                        PendingChange.MSG_SU02,
                        msgParams,
                        "Das Merkmal <b>${scp.type.name}</b> hat sich von <b>\"${changeDocument.oldLabel?:changeDocument.old}\"</b> zu <b>\"${changeDocument.newLabel?:changeDocument.new}\"</b> von der Lizenzvorlage geändert. " + description
                )
                if (newPendingChange && scp.owner.isSlaved) {
                    slavedPendingChanges << newPendingChange
                }
            }

            slavedPendingChanges.each { spc ->
                log.debug('autoAccept! performing: ' + spc)
                pendingChangeService.performAccept(spc)
            }
        }
        else if (changeDocument.event.equalsIgnoreCase('SubscriptionCustomProperty.deleted')) {

            List<PendingChange> openPD = PendingChange.executeQuery("select pc from PendingChange as pc where pc.status is null and pc.payload is not null and pc.oid = :objectID",
                    [objectID: "${this.class.name}:${this.id}"] )
            openPD.each { pc ->
                if (pc.payload) {
                    JSONElement payload = JSON.parse(pc.payload)
                    if (payload.changeDoc) {
                        def scp = genericOIDService.resolveOID(payload.changeDoc.OID)
                        if (scp?.id == id) {
                            pc.delete()
                        }
                    }
                }
            }
        }

    }
}
