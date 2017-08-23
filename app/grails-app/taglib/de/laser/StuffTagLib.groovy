package de.laser

import com.k_int.kbplus.auth.User

// Bootstrap 2

class StuffTagLib {

    def springSecurityService

    //static defaultEncodeAs = [taglib:'html']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]

    static namespace = "laser"

    // <laser:modeSwitch controller="controller" action="action" params="params" />

    def modeSwitch = { attrs, body ->

        def mode = (attrs.params.mode=='basic') ? 'basic' : ((attrs.params.mode == 'advanced') ? 'advanced' : null)
        if (!mode) {
            def user = User.get(springSecurityService.principal.id)
            mode = (user.showSimpleViews?.value == 'No') ? 'advanced' : 'basic'

            // CAUTION: inject default mode
            attrs.params.mode = mode
        }

        out << '<div class="btn-group" data-toggle="buttons-radio">'
        out << g.link( "${message(code:'profile.simpleView', default:'Basic')}",
                    controller: attrs.controller,
                    action: attrs.action,
                    params: attrs.params + ['mode':'basic'],
                    class: "btn btn-primary btn-mini ${mode == 'basic' ? 'active' : ''}"
            )
        out << g.link( "${message(code:'profile.advancedView', default:'Advanced')}",
                    controller: attrs.controller,
                    action: attrs.action,
                    params: attrs.params + ['mode':'advanced'],
                    class: "btn btn-primary btn-mini ${mode == 'advanced' ? 'active' : ''}"
            )
        out << '</div>'
    }
}