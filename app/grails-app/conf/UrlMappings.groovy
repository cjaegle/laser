class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?" {
            constraints {
                // apply constraints here
            }
        }

        "/lic/$action?/$id?"        (controller: 'license')

        "/org/$action?/$id?"        (controller: 'organisation')

        //"/myInstitution/tipview/$id"    (controller: 'myInstitution', action: 'tip')
        "/myInstitution/finance"        (controller: 'finance', action: 'index')
        name subfinance:                "/subscription/$sub/finance/"   (controller: 'finance', action: 'subFinancialData')
        name subfinanceEditCI:          "/subscription/$sub/editCostItem/$id"   (controller: 'finance', action: 'editCostItem')
        name subfinanceCopyCI:          "/subscription/$sub/copyCostItem/$id"   (controller: 'finance', action: 'copyCostItem')



        "/ajax/$action?/$id?"(controller: 'ajax')

        // new custom api
        "/api/push/orgs"        (controller: 'api', action: 'importInstitutions', parseRequest: false)

        "/api/$version/spec"    (controller: 'api', action: 'loadSpec')
        "/api/$version/$obj"    (controller: 'api', action: 'dispatch')

        "/"                     (controller: 'public', action: 'index')
        "/gasco"                (controller: 'public', action: 'gasco')

        "/oai/$id"(controller: 'oai', action: 'index')

        "500"(view: '/serverCodes/error')
        "401"(view: '/serverCodes/forbidden')
        "403"(view: '/serverCodes/error')
        "404"(view: '/serverCodes/notFound404')

    }
}
