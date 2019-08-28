package com.k_int.kbplus

import com.k_int.properties.PropertyDefinition
import de.laser.domain.I10nTranslation
import de.laser.helper.RefdataAnnotation
import de.laser.interfaces.TemplateSupport
import grails.util.Holders
import org.springframework.context.i18n.LocaleContextHolder

import javax.persistence.Transient
import java.text.SimpleDateFormat

class SurveyConfig {

    @Transient
    public static final ALL_RESULTS_FINISH_BY_ORG = "Finish"

    @Transient
    public static final ALL_RESULTS_NOT_FINISH_BY_ORG = "Not Finish"

    @Transient
    public static final ALL_RESULTS_HALF_FINISH_BY_ORG = "Half Finish"

    Integer configOrder

    Subscription subscription
    SurveyProperty surveyProperty

    SurveyInfo surveyInfo

    Date scheduledStartDate
    Date scheduledEndDate

    String type
    String header
    String comment
    String internalComment

    Date dateCreated
    Date lastUpdated

    boolean pickAndChoose
    boolean configFinish
    boolean costItemsFinish

    static hasMany = [
            documents       : DocContext,
            surveyProperties: SurveyConfigProperties,
            orgs            : SurveyOrg
    ]

    static constraints = {
        subscription(nullable: true, blank: false)
        surveyProperty(nullable: true, blank: false)

        header(nullable: true, blank: false)
        comment(nullable: true, blank: false)
        pickAndChoose(nullable: true, blank: false)
        documents(nullable: true, blank: false)
        orgs(nullable: true, blank: false)
        configFinish(nullable: true, blank: false)
        costItemsFinish (nullable: true, blank: false)
        scheduledStartDate (nullable: true, blank: false)
        scheduledEndDate (nullable: true, blank: false)
        internalComment(nullable: true, blank: false)
    }

    static mapping = {
        id column: 'surconf_id'
        version column: 'surconf_version'

        type column: 'surconf_type'
        header column: 'surconf_header'
        comment column: 'surconf_comment', type: 'text'
        internalComment column: 'surconf_internal_comment', type: 'text'
        pickAndChoose column: 'surconf_pickandchoose'
        configFinish column: 'surconf_config_finish', default: false
        costItemsFinish column: 'surconf_costitems_finish', default: false

        scheduledStartDate column: 'surconf_scheduled_startdate'
        scheduledEndDate column: 'surconf_scheduled_enddate'

        dateCreated column: 'surconf_date_created'
        lastUpdated column: 'surconf_last_updated'

        surveyInfo column: 'surconf_surinfo_fk'
        subscription column: 'surconf_sub_fk'
        surveyProperty column: 'surconf_surprop_fk'

        configOrder column: 'surconf_config_order'
    }

    @Transient
    static def validTypes = [
            'Subscription'  : ['de': 'Lizenz', 'en': 'Subscription'],
            'SurveyProperty': ['de': 'Umfrage-Merkmal', 'en': 'Survey-Property']
    ]

    static getLocalizedValue(key) {
        def locale = I10nTranslation.decodeLocale(LocaleContextHolder.getLocale().toString())

        //println locale
        if (SurveyConfig.validTypes.containsKey(key)) {
            return (SurveyConfig.validTypes.get(key)."${locale}") ?: SurveyConfig.validTypes.get(key)
        } else {
            return null
        }
    }

    def getCurrentDocs() {

        return documents.findAll { (it.status?.value != 'Deleted' && ((it.owner?.contentType == 1) || (it.owner?.contentType == 3)))}
    }

    def getConfigNameShort() {

        if (type == 'Subscription') {
            return subscription?.name
        } else {
            return surveyProperty?.getI10n('name')
        }
    }

    def getConfigName() {

        def messageSource = Holders.grailsApplication.mainContext.getBean('messageSource')
        SimpleDateFormat sdf = new SimpleDateFormat(messageSource.getMessage('default.date.format.notime', null, LocaleContextHolder.getLocale()))

        if (type == 'Subscription') {
            return subscription?.name + ' - ' + subscription?.status?.getI10n('value') + ' ' +
                    (subscription?.startDate ? '(' : '') + sdf.format(subscription?.startDate) +
                    (subscription?.endDate ? ' - ' : '') + sdf.format(subscription?.endDate) +
                    (subscription?.startDate ? ')' : '')

        } else {
            return surveyProperty?.getI10n('name')
        }
    }

    def getTypeInLocaleI10n() {

        return this.getLocalizedValue(this?.type)
    }


    def getSurveyOrgsIDs() {
        def result = [:]

        result.orgsWithoutSubIDs = this.orgs?.org?.id?.minus(this?.subscription?.getDerivedSubscribers()?.id) ?: null

        result.orgsWithSubIDs = this.orgs.org.id.minus(result.orgsWithoutSubIDs) ?: null

        return result
    }

    def checkResultsFinishByOrg(Org org) {

        if (SurveyOrg.findBySurveyConfigAndOrg(this, org)?.existsMultiYearTerm()) {
            println("Test")
            return ALL_RESULTS_FINISH_BY_ORG
        } else {

            def countFinish = 0
            def countNotFinish = 0

            def surveyResult = SurveyResult.findAllBySurveyConfigAndParticipant(this, org)

                surveyResult.each {
                    if (it.getFinish()) {
                        countFinish++
                    } else {
                        countNotFinish++
                    }
                }
                if (countFinish > 0 && countNotFinish == 0) {
                    return ALL_RESULTS_FINISH_BY_ORG
                } else if (countFinish > 0 && countNotFinish > 0) {
                    return ALL_RESULTS_HALF_FINISH_BY_ORG
                } else {
                    return ALL_RESULTS_NOT_FINISH_BY_ORG
                }
        }


    }

    def nextConfig()
    {
        def next

        for(int i = 0 ; i < this.surveyInfo?.surveyConfigs?.size() ; i++ ) {
            def curr = this.surveyInfo.surveyConfigs[ i ]

            if(curr?.id == this.id)
            {
                next = i < this.surveyInfo.surveyConfigs.size() - 1 ? this.surveyInfo.surveyConfigs[ i + 1 ] : this
            }
        }
        return (next?.id == this?.id) ? null : next
    }

    def prevConfig()
    {
        def prev
        this.surveyInfo.surveyConfigs.sort {it.configOrder}.reverse(true).each { config ->
            if(prev)
            {
                prev = this
            }

            if(config.id == this.id)
            {
                prev = this
            }
        }
        return (prev?.id == this?.id) ? null : prev
    }

    def getConfigNavigation(){

        def result = [:]
        result.prev = prevConfig()
        result.next = nextConfig()
        result.total = this.surveyInfo.surveyConfigs?.size() ?: null

        if(!result.total && result.total < 1 && !result.prev && !result.next)
        {
            result = null
        }
        return result
    }

    public String toString() {
        subscription ? "${subscription?.name}" : "Survey Element ${id}"
    }


    boolean showUIShareButton() {
        return false
    }


}
