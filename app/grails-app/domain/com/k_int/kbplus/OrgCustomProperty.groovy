package com.k_int.kbplus

import com.k_int.kbplus.abstract_domain.AbstractProperty
import com.k_int.properties.PropertyDefinition
import com.k_int.kbplus.abstract_domain.CustomProperty
import javax.persistence.Transient

/**Org custom properties are used to store Org related settings and options**/
class OrgCustomProperty extends CustomProperty {

    PropertyDefinition type
    Org owner

    static mapping = {
        includes AbstractProperty.mapping
    }

    static belongsTo = [
        type : PropertyDefinition,
        owner: Org
    ]
}
