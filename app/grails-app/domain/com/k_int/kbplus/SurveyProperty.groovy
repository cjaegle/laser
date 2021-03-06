package com.k_int.kbplus

import de.laser.domain.AbstractI10nTranslatable
import de.laser.domain.I10nTranslation
import groovy.util.logging.Log4j
import org.springframework.context.i18n.LocaleContextHolder

import javax.persistence.Transient
import javax.validation.UnexpectedTypeException

@Log4j
class SurveyProperty extends AbstractI10nTranslatable {

    String name
    String type
    String expl
    String comment
    String introduction
    String refdataCategory

    Org owner

    Date dateCreated
    Date lastUpdated

    // indicates this object is created via current bootstrap
    boolean isHardData = false

    @Transient
    static def validTypes = [
            'class java.lang.Integer'            : ['de': 'Zahl', 'en': 'Number'],
            'class java.lang.String'             : ['de': 'Text', 'en': 'Text'],
            'class com.k_int.kbplus.RefdataValue': ['de': 'Referenzwert', 'en': 'Refdata'],
            'class java.math.BigDecimal'         : ['de': 'Dezimalzahl', 'en': 'Decimal'],
            'class java.util.Date'               : ['de': 'Datum', 'en': 'Date'],
            'class java.net.URL'                 : ['de': 'Url', 'en': 'Url']
    ]

    static constraints = {
        owner(nullable: true, blank: false)
        introduction(nullable: true, blank: false)
        comment(nullable: true, blank: false)
        expl(nullable: true, blank: false)
        isHardData(nullable: false, blank: false)
        refdataCategory(nullable: true, blank: false)
    }

    static mapping = {
        id column: 'surpro_id'
        version column: 'surpro_version'

        name column: 'surpro_name'
        type column: 'surpro_type', type: 'text'
        expl column: 'surpro_explain', type: 'text'
        comment column: 'surpro_comment', type: 'text'
        introduction column: 'surpro_introduction', type: 'text'
        refdataCategory column: 'surpro_refdata_category'
        isHardData column: 'hard_data'

        owner column: 'surpro_org_fk'

        dateCreated column: 'surpro_date_created'
        lastUpdated column: 'surpro_last_updated'
    }

    static getLocalizedValue(key) {
        String locale = I10nTranslation.decodeLocale(LocaleContextHolder.getLocale().toString())

        //println locale
        if (SurveyProperty.validTypes.containsKey(key)) {
            return (SurveyProperty.validTypes.get(key)."${locale}") ?: SurveyProperty.validTypes.get(key)
        } else {
            return null
        }
    }

    private static def typeIsValid(key) {
        if (validTypes.containsKey(key)) {
            return true;
        } else {
            log.error("Provided prop type ${key} is not valid. Allowed types are ${validTypes}")
            throw new UnexpectedTypeException()
        }
    }

    static def loc(String name, String typeClass, RefdataCategory rdc, String expl, String comment, String introduction, Org owner) {

        typeIsValid(typeClass)

        def prop = findWhere(
                name: name,
                type: typeClass,
                owner: owner
        )

        if (!prop) {
            log.debug("No SurveyProperty match for ${name} : ${typeClass} ( ${expl} ) @ ${owner?.name}. Creating new one ..")

            prop = new SurveyProperty(
                    name: name,
                    type: typeClass,
                    expl: expl ?: null,
                    comment: comment ?: null,
                    introduction: introduction ?: null,
                    refdataCategory: rdc?.desc,
                    owner: owner
            )
            prop.save(flush: true)
        }
        prop
    }

    String getLocalizedType() {

        def propertyType = this.getLocalizedValue(this.type)
        def refdataValues =[]
        if(this.type == 'class com.k_int.kbplus.RefdataValue'){

                com.k_int.kbplus.RefdataCategory.getAllRefdataValues(this.refdataCategory).each {
                    refdataValues << it?.getI10n('value')
                }
        }

        return propertyType + ((refdataValues?.size() > 0) ? " (" + refdataValues?.join('/')+")" : "")

    }

    def countUsages() {

            def scp = SurveyProperty.executeQuery("select count(scp) from SurveyConfigProperties as scp where scp.surveyProperty = ?", [this])
            def srp = SurveyProperty.executeQuery("select count(srp) from SurveyResult as srp where srp.type = ?", [this])
            return scp[0]+srp[0] ?: 0

    }

    static SurveyProperty getByName(String name)
    {
        SurveyProperty.findByName(name)
    }


}
