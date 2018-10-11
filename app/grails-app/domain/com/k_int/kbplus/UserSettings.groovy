package com.k_int.kbplus

import com.k_int.kbplus.auth.User

import javax.persistence.Transient

class UserSettings {

    final static SETTING_NOT_FOUND = "SETTING_NOT_FOUND"

    @Transient
    def genericOIDService

    static enum KEYS {
        PAGE_SIZE         (Long),
        DASHBOARD         (Org),
        SHOW_SIMPLE_VIEWS (RefdataValue, 'YN'),
        SHOW_INFO_ICON    (RefdataValue, 'YN'),
        SHOW_EDIT_MODE    (RefdataValue, 'YN')

        KEYS(type, rdc) {
            this.type = type
            this.rdc = rdc
        }
        KEYS(type) {
            this.type = type
        }

        public def type
        public def rdc
    }

    User         user
    KEYS         key
    String       strValue
    RefdataValue rdValue
    Org          orgValue

    static mapping = {
        id         column:'us_id'
        version    column:'us_version'
        user       column:'us_user_fk'
        key        column:'us_key_enum'
        strValue   column:'us_string_value'
        rdValue    column:'us_rv_fk'
        orgValue   column:'us_org_fk'
    }

    static constraints = {
        user       (nullable: false, unique: 'key')
        key        (nullable: false, unique: 'user')
        strValue   (nullable: true)
        rdValue    (nullable: true)
        orgValue   (nullable: true)
    }

    /*
        returns user depending setting for given key
        or SETTING_NOT_FOUND if not
     */
    static get(User user, KEYS key) {

        def uss = findWhere(user: user, key: key)
        uss ?: SETTING_NOT_FOUND
    }

    /*
        adds new user depending setting (with value) for given key
     */
    static add(User user, KEYS key, def value) {

        def uss = new UserSettings(user: user, key: key)
        uss.setValue(value)
        uss.save(flush: true)

        uss
    }

    /*
        deletes user depending setting for given key
     */
    static delete(User user, KEYS key) {

        def uss = findWhere(user: user, key: key)
        uss.delete(flush: true)
    }

    /*
        gets parsed value by key.type
     */
    def getValue() {

        def result = null

        switch (key.type) {
            case Long:
                result = Long.parseLong(strValue)
                break
            case Org:
                result = orgValue
                break
            case RefdataValue:
                result = rdValue
                break
            default:
                result = strValue
                break
        }
        result
    }

    /*
        sets value by key.type
     */
    def setValue(def value) {

        switch (key.type) {
            case Org:
                orgValue = value
                break
            case RefdataValue:
                rdValue = value
                break
            default:
                strValue = (value ? value.toString() : null)
                break
        }
        save(flush: true)
    }
}