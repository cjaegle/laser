package de.laser

class LaserInjectionTagLib {

    def springSecurityService
    def contextService
    def accessService
    def yodaService
    def subscriptionsQueryService
    def genericOIDService
    def instAdmService
    def surveyService
    def taskService

    static namespace = "laser"

    def serviceInjection = { attrs, body ->
        // HTML Comment not useful in Txt Mail
        //out << "<!-- serviceInjection: springSecurityService, contextService, accessService, auditService, yodaService, subscriptionsQueryService, genericOIDService, instAdmService -->"

        g.set( var:'springSecurityService', bean:'springSecurityService' )
        g.set( var:'contextService', bean:'contextService' )
        g.set( var:'accessService', bean:'accessService' )
        g.set( var:'auditService', bean:'auditService' )
        g.set( var:'yodaService', bean:'yodaService' )
        g.set( var:'genericOIDService', bean:'genericOIDService' )
        g.set( var:'subscriptionsQueryService', bean:'subscriptionsQueryService' )
        g.set( var:'instAdmService', bean:'instAdmService' )
        g.set( var:'surveyService', bean:'surveyService' )
        g.set( var:'orgDocumentService', bean:'orgDocumentService' )
        g.set( var:'taskService', bean:'taskService' )
    }
}
