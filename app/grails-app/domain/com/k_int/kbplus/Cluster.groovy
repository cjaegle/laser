package com.k_int.kbplus

import de.laser.helper.RefdataAnnotation

class Cluster {

    String       name
    String       definition

    @RefdataAnnotation(cat = 'ClusterType')
    RefdataValue type
    
    static hasMany = [
        orgs:     OrgRole,
        prsLinks: PersonRole,
    ]
    
    static mappedBy = [
        orgs:     'cluster',
        prsLinks: 'cluster'
    ]

    static mapping = {
        id         column:'cl_id'
        version    column:'cl_version'
        name       column:'cl_name'
        definition column:'cl_definition'
        type       column:'cl_type_rv_fk'

        orgs        batchSize: 10
        prsLinks    batchSize: 10
    }

    static getAllRefdataValues() {
        RefdataCategory.getAllRefdataValues('ClusterType')
    }
    
    @Override
    String toString() {
        name + ', ' + definition + ' (' + id + ')'
    }
}
