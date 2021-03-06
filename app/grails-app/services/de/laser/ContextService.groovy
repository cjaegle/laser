package de.laser

import com.k_int.kbplus.Org
import com.k_int.kbplus.UserSettings
import com.k_int.kbplus.auth.User
import de.laser.helper.EhcacheWrapper
import de.laser.helper.SessionCacheWrapper
import grails.plugin.springsecurity.SpringSecurityService
import groovy.transform.CompileStatic
import org.codehaus.groovy.grails.orm.hibernate.cfg.GrailsHibernateUtil
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsHttpSession
import org.codehaus.groovy.grails.web.util.WebUtils

@CompileStatic
class ContextService {

    SpringSecurityService springSecurityService
    CacheService cacheService

    static final SERVER_LOCAL = 'SERVER_LOCAL'
    static final SERVER_DEV   = 'SERVER_DEV'
    static final SERVER_QA    = 'SERVER_QA'
    static final SERVER_PROD  = 'SERVER_PROD'

    static final USER_SCOPE  = 'USER_SCOPE'
    static final ORG_SCOPE   = 'ORG_SCOPE'

    void setOrg(Org context) {
        try {
            GrailsHttpSession session = WebUtils.retrieveGrailsWebRequest().getSession()
            session.setAttribute('contextOrg', context)
        }
        catch (Exception e) {
            log.warn('accessing setOrg() without web request')
        }
    }

    Org getOrg() {
        try {
            GrailsHttpSession session  = WebUtils.retrieveGrailsWebRequest().getSession()

            def context = session.getAttribute('contextOrg') ?: getUser()?.getSettingsValue(UserSettings.KEYS.DASHBOARD)
            if (context) {
                return (Org) GrailsHibernateUtil.unwrapIfProxy(context)
            }
        }
        catch (Exception e) {
            log.warn('accessing getOrg() without web request')
        }
        return null
    }

    User getUser() {
        (User) springSecurityService.getCurrentUser()
    }

    List<Org> getMemberships() {
        getUser()?.authorizedOrgs
    }

    EhcacheWrapper getCache(String cacheKeyPrefix, String scope) {

        if (scope == ORG_SCOPE) {
            cacheService.getSharedOrgCache(getOrg(), cacheKeyPrefix)
        }
        else if (scope == USER_SCOPE) {
            cacheService.getSharedUserCache(getUser(), cacheKeyPrefix)
        }
    }

    SessionCacheWrapper getSessionCache() {
        return new SessionCacheWrapper()
    }
}
