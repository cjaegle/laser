package de.laser.domain

import com.k_int.kbplus.IssueEntitlement

class IssueEntitlementGroupItem {

    Date dateCreated
    Date lastUpdated

    static belongsTo = [
            ieGroup:    IssueEntitlementGroup,
            ie:         IssueEntitlement
    ]

    static mapping = {
        id              column: 'igi_id'
        version         column: 'igi_version'
        ieGroup         column: 'igi_ie_group_fk'
        ie              column: 'igi_ie_fk'
        lastUpdated     column: 'igi_last_updated'
        dateCreated     column: 'igi_date_created'
    }

    static constraints = {
        ieGroup     (nullable: false, blank: false)
        ie          (nullable: false, blank: false)
        lastUpdated (nullable: true, blank: false)
        dateCreated (nullable: true, blank: false)
    }
}
