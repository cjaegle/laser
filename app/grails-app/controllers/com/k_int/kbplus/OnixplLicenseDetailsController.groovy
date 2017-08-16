package com.k_int.kbplus

import com.k_int.kbplus.auth.User
import grails.plugins.springsecurity.Secured
import org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent

class OnixplLicenseDetailsController {

    def springSecurityService

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def index() {
        def user = User.get(springSecurityService.principal.id)
        // def onixplLicense = OnixplLicense.get(params.id)
//        if ( ! onixplLicense.hasPerm("view",user) ) {
//            log.debug("return 401....");
//            response.sendError(401);
//            return
//        }

        def ghost_license = OnixplLicense.findByTitle(grails.util.Holders.config.onix_ghost_license)
        def licenses = ghost_license?[params.id,ghost_license.id] : params.id
        forward (action:'matrix', params:[Compare:"Compare", id:"compare",compareAll:true,selectedLicenses:licenses],controller:"onixplLicenseCompare")
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def notes() {
        log.debug("licenseDetails id:${params.id}");
        def user = User.get(springSecurityService.principal.id)
        def onixplLicense = OnixplLicense.get(params.id)
//        if ( ! onixplLicense.hasPerm("view",user) ) {
//            response.sendError(401);
//            return
//        }
        [onixplLicense: onixplLicense, user: user]
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def documents() {
        log.debug("licenseDetails id:${params.id}");
        def user = User.get(springSecurityService.principal.id)
        def onixplLicense = OnixplLicense.get(params.id)
//        if ( ! onixplLicense.hasPerm("view",user) ) {
//            response.sendError(401);
//            return
//        }
        [onixplLicense: onixplLicense, user: user]
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def history() {
        log.debug("licenseDetails id:${params.id}");
        def user = User.get(springSecurityService.principal.id)
        def onixplLicense = OnixplLicense.get(params.id)

//        if ( ! onixplLicense.hasPerm("view",user) ) {
//            response.sendError(401);
//            return
//        }
        def max = params.max ?: 20;
        def offset = params.offset ?: 0;

        def qry_params = [onixplLicense.class.name, "${onixplLicense.id}"]
        def historyLines = AuditLogEvent.executeQuery("select e from AuditLogEvent as e where className=? and persistedObjectId=? order by id desc", qry_params, [max:max, offset:offset]);
        def historyLinesTotal = AuditLogEvent.executeQuery("select count(e.id) from AuditLogEvent as e where className=? and persistedObjectId=?",qry_params)[0];
        [onixplLicense: onixplLicense, user: user, max: max, offset: offset, historyLines: historyLines, historyLinesTotal: historyLinesTotal]
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def additionalInfo() {
        def user = User.get(springSecurityService.principal.id)
        def onixplLicense = OnixplLicense.get(params.id)
        [onixplLicense: onixplLicense, user: user]
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [onixplLicenseInstanceList: OnixplLicense.list(params), onixplLicenseInstanceTotal: OnixplLicense.count()]
    }
}
