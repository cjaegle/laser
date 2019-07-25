package com.k_int.properties

import com.k_int.kbplus.Org
import com.k_int.kbplus.RefdataCategory
import com.k_int.kbplus.RefdataValue
import com.k_int.kbplus.abstract_domain.AbstractProperty
import de.laser.CacheService
import de.laser.domain.AbstractI10nTranslatable
import de.laser.domain.I10nTranslation
import de.laser.helper.EhcacheWrapper
import grails.util.Holders
import groovy.util.logging.Log4j
import org.codehaus.groovy.grails.orm.hibernate.cfg.GrailsHibernateUtil

//import org.grails.orm.hibernate.cfg.GrailsHibernateUtil

import org.springframework.context.i18n.LocaleContextHolder

import javax.persistence.Transient
import javax.validation.UnexpectedTypeException

@Log4j
class PropertyDefinition extends AbstractI10nTranslatable implements Serializable , Comparable<PropertyDefinition> {

    @Transient
    final static TRUE  = true
    @Transient
    final static FALSE = false

    @Transient
    final static CUSTOM_PROPERTY  = "CUSTOM_PROPERTY"
    @Transient
    final static PRIVATE_PROPERTY = "PRIVATE_PROPERTY"


    @Transient
    final static String LIC_PROP    = 'License Property'

    //@Transient
    //@Deprecated
    //final static String LIC_OA_PROP = 'License Property: Open Access'
    //@Transient
    //@Deprecated
    //final static String LIC_ARC_PROP = 'License Property: Archive'

    @Transient
    final static String ORG_CONF    = 'Organisation Config'
    @Transient
    final static String SUB_PROP    = 'Subscription Property'
    @Transient
    final static String SYS_CONF    = 'System Config'
    @Transient
    final static String PRS_PROP    = 'Person Property'
    @Transient
    final static String ORG_PROP    = 'Organisation Property'

    @Transient
    final static String[] AVAILABLE_CUSTOM_DESCR = [
            LIC_PROP,
            //LIC_OA_PROP,
            //LIC_ARC_PROP,
            ORG_CONF,
            SUB_PROP,
            SYS_CONF,
            ORG_PROP
    ]
    @Transient
    final static String[] AVAILABLE_PRIVATE_DESCR = [
            LIC_PROP,
            SUB_PROP,
            ORG_PROP,
            PRS_PROP
    ]

    @Transient
    final static String[] AVAILABLE_GROUPS_DESCR = [
            LIC_PROP,
            SUB_PROP,
            ORG_PROP
    ]

    String name
    String descr
    String type
    String refdataCategory
    String expl

    // used for private properties
    Org tenant

    // allows multiple occurences
    boolean multipleOccurrence
    // mandatory
    boolean mandatory
    // indicates this object is created via current bootstrap
    boolean hardData
    // indicates hard coded logic
    boolean isUsedForLogic

    //Map keys can change and they wont affect any of the functionality
    @Deprecated
    @Transient
    static def validTypes = ["Number":  Integer.toString(), 
                             "Text":    String.toString(), 
                             "Refdata": RefdataValue.toString(), 
                             "Decimal": BigDecimal.toString(),
                             "Date":    Date.toString(),
                             "Url":     URL.toString()]

    @Transient
    static def validTypes2 = [
            'class java.lang.Integer'             : ['de': 'Zahl', 'en': 'Number'],
            'class java.lang.String'              : ['de': 'Text', 'en': 'Text'],
            'class com.k_int.kbplus.RefdataValue' : ['de': 'Referenzwert', 'en': 'Refdata'],
            'class java.math.BigDecimal'          : ['de': 'Dezimalzahl', 'en': 'Decimal'],
            'class java.util.Date'                : ['de': 'Datum', 'en': 'Date'],
            'class java.net.URL'                  : ['de': 'Url', 'en': 'Url']
    ]

    static hasMany = [
            propDefGroupItems: PropertyDefinitionGroupItem
    ]
    static mappedBy = [
            propDefGroupItems: 'propDef'
    ]

    static mapping = {
                      id column: 'pd_id'
                   descr column: 'pd_description', index: 'td_new_idx', type: 'text'
                    name column: 'pd_name',        index: 'td_new_idx'
                    expl column: 'pd_explanation', index: 'td_new_idx', type: 'text'
                    type column: 'pd_type',        index: 'td_type_idx'
         refdataCategory column: 'pd_rdc',         index: 'td_type_idx'
                  tenant column: 'pd_tenant_fk'
      multipleOccurrence column: 'pd_multiple_occurrence'
               mandatory column: 'pd_mandatory'
                hardData column: 'pd_hard_data'
          isUsedForLogic column: 'pd_used_for_logic'
                      sort name: 'desc'

        propDefGroupItems cascade: 'all'  // for deleting
    }

    static constraints = {
        name                (nullable: false, blank: false)
        descr               (nullable: true,  blank: false)
        expl                (nullable: true,  blank: true)
        type                (nullable: false, blank: false)
        refdataCategory     (nullable: true)
        tenant              (nullable: true,  blank: true)
        multipleOccurrence  (nullable: true,  blank: true,  default: false)
        mandatory           (nullable: false, blank: false, default: false)
        hardData            (nullable: false, blank: false, default: false)
        isUsedForLogic      (nullable: false, blank: false, default: false)
    }

    private static def typeIsValid(key) {
        if (validTypes2.containsKey(key)) {
            return true;
        } else {
            log.error("Provided prop type ${key} is not valid. Allowed types are ${validTypes2}")
            throw new UnexpectedTypeException()
        }
    }

    /*
    static def lookupOrCreateProp(id, owner){
        if(id instanceof String){
            id = id.toLong()
        }
        def type = get(id)
        createCustomProperty(owner, type)
    }
    */

    /**
     * Called from AjaxController.addCustomPropertyValue()
     * Called from AjaxController.addPrivatePropertyValue()
     *
     * @param owner: The class that will hold the property, e.g License
     */
    static AbstractProperty createGenericProperty(def flag, def owner, PropertyDefinition type) {
        String classString = owner.getClass().toString()
        def ownerClassName = classString.substring(classString.lastIndexOf(".") + 1)

        if (flag == PropertyDefinition.CUSTOM_PROPERTY) {
            ownerClassName = "com.k_int.kbplus.${ownerClassName}CustomProperty"
        }
        else if (flag == PropertyDefinition.PRIVATE_PROPERTY) {
            ownerClassName = "com.k_int.kbplus.${ownerClassName}PrivateProperty"
        }

        //def newProp = Class.forName(ownerClassName).newInstance(type: type, owner: owner)
        def newProp = (new GroovyClassLoader()).loadClass(ownerClassName).newInstance(type: type, owner: owner)
        newProp.setNote("")

        /*
        if (flag == PropertyDefinition.CUSTOM_PROPERTY) {
            owner.customProperties.add(newProp)
        }
        else if (flag == PropertyDefinition.PRIVATE_PROPERTY) {
            owner.privateProperties.add(newProp)
        } */

        newProp.save(flush:true)
        GrailsHibernateUtil.unwrapIfProxy(newProp)
    }

    static def loc(String name, String descr, String typeClass, RefdataCategory rdc, String expl, multipleOccurence, mandatory, Org tenant) {

        typeIsValid(typeClass)

        def type = findWhere(
            name:   name,
            descr:  descr,
            tenant: tenant
        )

        if (! type) {
            log.debug("No PropertyDefinition match for ${name} : ${descr} ( ${expl} ) @ ${tenant?.name}. Creating new one ..")

            type = new PropertyDefinition(
                    name:               name,
                    descr:              descr,
                    expl:               expl,
                    type:               typeClass,
                    refdataCategory:    rdc?.desc,
                    multipleOccurrence: (multipleOccurence ? true : false),
                    mandatory:          (mandatory ? true : false),
                    isUsedForLogic:     false,
                    tenant:             tenant
            )
            type.save(flush:true)
        }
        type
    }

    static def refdataFind(params) {
        def result = []

        CacheService cacheService = (CacheService) Holders.grailsApplication.mainContext.getBean('cacheService')
        EhcacheWrapper cache

        if (! params.tenant) {
            cache = cacheService.getTTL300Cache("PropertyDefinition/refdataFind/custom/${params.desc}/")
        } else {
            cache = cacheService.getTTL300Cache("PropertyDefinition/refdataFind/private/${params.desc}/tenant/${params.tenant}/")
        }

        if (cache.get('propDefs')) {
            result = cache.get('propDefs')
            log.debug('load propertyDefinitions from cache')
        }
        else {
            def matches = I10nTranslation.refdataFindHelper(
                    params.baseClass,
                    'name',
                    params.q,
                    LocaleContextHolder.getLocale()
            )
            matches.each { it ->
                // used for private properties
                def tenantMatch = (params.tenant.equals(it.getTenant()?.id?.toString()))

                if (tenantMatch) {
                    if (params.desc && params.desc != "*") {
                        if (it.getDescr() == params.desc) {
                            result.add([id: "${it.id}", text: "${it.getI10n('name')}"])
                        }
                    } else {
                        result.add([id: "${it.id}", text: "${it.getI10n('name')}"])
                    }
                }
            }
            cache.put('propDefs', result)
        }
        result
    }

    def getDescrClass() {
        getDescrClass(this.descr)
    }

    static getDescrClass(String descr) {
        def result
        def parts = descr.split(" ")

        if (parts.size() >= 2) {
            if (parts[0] == "Organisation") {
                parts[0] = "Org"
            }

            result = Class.forName('com.k_int.kbplus.' + parts[0])?.name
        }
        result
    }

    def getImplClass(String customOrPrivate) {
        getImplClass(this.descr, customOrPrivate)
    }

    static getImplClass(String descr, String customOrPrivate) {
        def result
        def parts = descr.split(" ")

        if (parts.size() >= 2) {
            if (parts[0] == "Organisation") {
                parts[0] = "Org"
            }
            def cp = 'com.k_int.kbplus.' + parts[0] + 'CustomProperty'
            def pp = 'com.k_int.kbplus.' + parts[0] + 'PrivateProperty'

            try {
                if (customOrPrivate.equalsIgnoreCase('custom') && Class.forName(cp)) {
                    result = cp
                }
                if (customOrPrivate.equalsIgnoreCase('private') && Class.forName(pp)) {
                    result = pp
                }
            } catch (Exception e) {

            }
        }
        result
    }

    def countUsages() {
        def table = getImplClass('private')?.minus('com.k_int.kbplus.')

        if (table) {
            def c = PropertyDefinition.executeQuery("select count(c) from " + table + " as c where c.type = ?", [this])
            return c[0]
        }
        return 0
    }

    def afterInsert() {
        I10nTranslation.createOrUpdateI10n(this, 'name',  [de: this.name, en: this.name])
        I10nTranslation.createOrUpdateI10n(this, 'descr', [de: this.descr, en: this.descr])
        I10nTranslation.createOrUpdateI10n(this, 'expl', [de: this.expl, en: this.expl])
    }

    def afterDelete() {
        def rc = this.getClass().getName()
        def id = this.getId()
        I10nTranslation.where{referenceClass == rc && referenceId == id}.deleteAll()
    }


  @Transient
  def getOccurrencesOwner(String[] cls){
    def all_owners = []
    cls.each{
        all_owners.add(getOccurrencesOwner(it)) 
    }
    return all_owners
  }

  @Transient
  def getOccurrencesOwner(String cls){
    def qparams = [this]
    def qry = 'select c.owner from ' + cls + " as c where c.type = ?"
    return PropertyDefinition.executeQuery(qry,qparams); 
  }

  @Transient
  def countOccurrences(String cls) {
    def qparams = [this]
    def qry = 'select count(c) from ' + cls + " as c where c.type = ?"
    return (PropertyDefinition.executeQuery(qry,qparams))[0]; 
  }
  @Transient
  def countOccurrences(String[] cls){
    def total_count = 0
    cls.each{
        total_count += countOccurrences(it)
    }
    return total_count
  }
    @Transient
    def removeProperty() {
        log.debug("Remove");
        PropertyDefinition.executeUpdate('delete from com.k_int.kbplus.LicenseCustomProperty c where c.type = ?', [this])
        PropertyDefinition.executeUpdate('delete from com.k_int.kbplus.LicensePrivateProperty c where c.type = ?', [this])
        PropertyDefinition.executeUpdate('delete from com.k_int.kbplus.SubscriptionCustomProperty c where c.type = ?', [this])
        PropertyDefinition.executeUpdate('delete from com.k_int.kbplus.OrgCustomProperty c where c.type = ?', [this])
        PropertyDefinition.executeUpdate('delete from com.k_int.kbplus.OrgPrivateProperty c where c.type = ?', [this])
        PropertyDefinition.executeUpdate('delete from com.k_int.kbplus.PersonPrivateProperty c where c.type = ?', [this])
        this.delete();
    }

    /* tmp only */
    static getAvailablePropertyDescriptions() {
        return [
                "com.k_int.kbplus.Org"      : PropertyDefinition.ORG_PROP,
                "com.k_int.kbplus.License"  : PropertyDefinition.LIC_PROP,
                "com.k_int.kbplus.Person"   : PropertyDefinition.PRS_PROP
        ]
    }

    static getLocalizedValue(key){
        def locale = I10nTranslation.decodeLocale(LocaleContextHolder.getLocale().toString())

        //println locale
        if (PropertyDefinition.validTypes2.containsKey(key)) {
            return (PropertyDefinition.validTypes2.get(key)."${locale}") ?: PropertyDefinition.validTypes2.get(key)
        } else {
            return null
        }
    }

    static findAllPublicAndPrivateOrgProp(Org contextOrg){
        def result = PropertyDefinition.findAll( "from PropertyDefinition as pd where pd.descr in :defList and (pd.tenant is null or pd.tenant = :tenant)", [
                        defList: [PropertyDefinition.ORG_PROP],
                        tenant: contextOrg
                    ])
        result
    }

    static findAllPublicAndPrivateProp(List propertyDefinitionList, Org contextOrg){
        def result = PropertyDefinition.findAll( "from PropertyDefinition as pd where pd.descr in :defList and (pd.tenant is null or pd.tenant = :tenant)", [
                        defList: propertyDefinitionList,
                        tenant: contextOrg
                    ])
        result
    }

    int compareTo(PropertyDefinition pd) {
        return this.getI10n('name').toLowerCase()?.compareTo(pd.getI10n('name').toLowerCase())
    }


}

