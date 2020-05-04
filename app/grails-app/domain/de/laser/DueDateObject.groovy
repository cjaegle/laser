package de.laser

import com.k_int.kbplus.Org
import com.k_int.kbplus.Subscription
import com.k_int.kbplus.SurveyInfo
import com.k_int.kbplus.Task
import com.k_int.kbplus.abstract_domain.AbstractProperty
import com.k_int.kbplus.auth.User
import grails.util.Holders
import groovy.util.logging.Log4j

@Log4j
class DueDateObject {
    String attribute_name
    String attribute_value_de
    String attribute_value_en
    Date date
    /** Subscription, CustomProperty, PrivateProperty oder Task*/
    String oid
    boolean isDone = false
    Date lastUpdated
    Date dateCreated

    DueDateObject(attribute_value_de, attribute_value_en, attribute_name, date, object, isDone){
        this(attribute_value_de, attribute_value_en, attribute_name, date, object, isDone, new Date(), new Date())
    }
    DueDateObject(attribute_value_de, attribute_value_en, attribute_name, date, object, isDone, dateCreated, lastUpdated){
        this.attribute_value_de = attribute_value_de
        this.attribute_value_en = attribute_value_en
        this.attribute_name = attribute_name
        this.date = date
        this.oid = "${object.class.name}:${object.id}"
        this.isDone = isDone
        this.dateCreated = dateCreated
        this.lastUpdated = lastUpdated
    }

    static mapping = {
        id                      column: 'ddo_id'
        version                 column: 'ddo_version'
        attribute_name          column: 'ddo_attribute_name'
        attribute_value_de      column: 'ddo_attribute_value_de'
        attribute_value_en      column: 'ddo_attribute_value_en'
        date                    column: 'ddo_date'
        oid                     column: 'ddo_oid'
        isDone                  column: 'ddo_is_done'
        dateCreated             column: 'ddo_date_created'
        lastUpdated             column: 'ddo_last_updated'
        autoTimestamp true
    }

    static constraints = {
//        attribute_value_de      (nullable:false, blank:false)
//        attribute_value_en      (nullable:false, blank:false)
//        attribute_name          (nullable:false, blank:false)
        date                    (nullable:false, blank:false)
        oid                     (nullable:false, blank:false)//, unique: ['attribut_name', 'ddo_oid'])
        isDone                  (nullable:false, blank:false)
        dateCreated             (nullable: true, blank: false)
        lastUpdated             (nullable:true, blank:false)
    }

}
