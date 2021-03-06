package com.k_int.kbplus

import de.laser.helper.RDConstants
import de.laser.helper.RefdataAnnotation

class OrgSubjectGroup {

    @RefdataAnnotation(cat = RDConstants.SUBJECT_GROUP)
    RefdataValue subjectGroup

    Date dateCreated
    Date lastUpdated

    static belongsTo = [
            org:            Org,
            subjectGroup:   RefdataValue
    ]

    static mapping = {
        id           column: 'osg_id'
        org          column: 'osg_org'
        subjectGroup column: 'osg_subject_group'
        dateCreated  column: 'osg_date_created'
        lastUpdated  column: 'osg_last_updated'
    }
    static constraints = {
        org          (nullable:false)
        subjectGroup (nullable:false)
        lastUpdated  (nullable: true, blank: false)
        dateCreated  (nullable: true, blank: false)
    }
}
