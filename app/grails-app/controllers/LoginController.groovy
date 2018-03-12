import grails.converters.JSON
import org.springframework.security.access.annotation.Secured

import javax.servlet.http.HttpServletResponse

import grails.plugin.springsecurity.SpringSecurityUtils // 2.0

import org.springframework.security.authentication.AccountExpiredException
import org.springframework.security.authentication.CredentialsExpiredException
import org.springframework.security.authentication.DisabledException
import org.springframework.security.authentication.LockedException
import org.springframework.security.core.context.SecurityContextHolder as SCH
import org.springframework.security.web.WebAttributes
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter
//import org.springframework.security.web.authentication.AbstractProcessingFilter // 2.0
import org.springframework.security.web.savedrequest.*;
import java.security.MessageDigest

@Secured('permitAll')
class LoginController {

  def grailsApplication

  /**
   * Dependency injection for the authenticationTrustResolver.
   */
  def authenticationTrustResolver

  /**
   * Dependency injection for the springSecurityService.
   */
  def springSecurityService

  /**
   * Default action; redirects to 'defaultTargetUrl' if logged in, /login/auth otherwise.
   */
  def index = {
    if (springSecurityService.isLoggedIn()) {
      redirect uri: SpringSecurityUtils.securityConfig.successHandler.defaultTargetUrl
    }
    else {
      redirect action: 'auth', params: params
    }
  }

  /**
   * Show the login page.
   */
  def auth = {
    log.debug("auth session:${request.session.id} localauth:${grailsApplication.config.localauth}");

    def config = SpringSecurityUtils.securityConfig

    if (springSecurityService.isLoggedIn()) {
      log.debug("already logged in");
      redirect uri: config.successHandler.defaultTargetUrl
      return
    }
    else {
      log.debug("Attempting login");
    }

    SavedRequest savedRequest = new HttpSessionRequestCache().getRequest(request, response);
    // String requestUrl = savedRequest?.getRequestURL();
    log.debug("auth action - the original ua request was for...");

    String requestUrl = savedRequest?.getRedirectUrl();

    if ( grailsApplication.config.apikeyon &&
         savedRequest.parameterMap.apikey != null && 
         savedRequest.parameterMap.apitime != null && 
         savedRequest.parameterMap.apisig != null ) {

      log.debug("Request contains APIKey signing... attempt");
      def dbuser = com.k_int.kbplus.auth.User.findByApikey(savedRequest.parameterMap.apikey) 
      if ( dbuser != null && dbuser.apisecret != null ) {
        def sig = "${savedRequest.parameterMap.apikey[0]}:${savedRequest.parameterMap.apitime[0]}:${dbuser.apisecret}".toString()

        log.debug("Sig = ${sig}");

        MessageDigest md5_digest = MessageDigest.getInstance("MD5");
        md5_digest.update(sig.getBytes())
        byte[] md5sum = md5_digest.digest();
        String md5sumHex = new BigInteger(1, md5sum).toString(16);

        log.debug("computed md5: ${md5sumHex}, sent=${savedRequest.parameterMap.apisig[0]}");

        if ( md5sumHex.equals(savedRequest.parameterMap.apisig[0]) ) {
          log.debug("AUTH OK - Create session and forward to request");
        }
      }
      else {
        log.debug("User with APIKey ${savedRequest.parameterMap.apikey[0]} not found or has null apisecret");
      }

      // SecurityContextHolder.getContext().setAuthentication(authResult)
    }
    else if ( grailsApplication.config.localauth ) {
      log.debug("Using localauth... send login form");
      String view = 'auth'
      String postUrl = "${request.contextPath}${config.apf.filterProcessesUrl}"
      render view: view, model: [postUrl: postUrl, rememberMeParameter: config.rememberMe.parameter]
    }
    else {
      log.debug("Redirecting to ${grailsApplication.config.authuri}, context will be ${requestUrl}");
      redirect(uri:"${grailsApplication.config.authuri}?context=${requestUrl}");
    }
    log.debug("auth completed");
  }

  /**
   * The redirect action for Ajax requests.
   */
  def authAjax = {
    response.setHeader 'Location', SpringSecurityUtils.securityConfig.auth.ajaxLoginFormUrl
    response.sendError HttpServletResponse.SC_UNAUTHORIZED
  }

  /**
   * Show denied page.
   */
  def denied = {
    if (springSecurityService.isLoggedIn() &&
        authenticationTrustResolver.isRememberMe(SCH.context?.authentication)) {
      // have cookie but the page is guarded with IS_AUTHENTICATED_FULLY
      redirect action: 'full', params: params
    }
  }

  /**
   * Login page for users with a remember-me cookie but accessing a IS_AUTHENTICATED_FULLY page.
   */
  def full = {
    def config = SpringSecurityUtils.securityConfig
    render view: 'auth', params: params,
      model: [hasCookie: authenticationTrustResolver.isRememberMe(SCH.context?.authentication),
              postUrl: "${request.contextPath}${config.apf.filterProcessesUrl}"]
  }

  /**
   * Callback after a failed login. Redirects to the auth page with a warning message.
   */
  def authfail = {

    def username = session[UsernamePasswordAuthenticationFilter.SPRING_SECURITY_LAST_USERNAME_KEY]
    String msg = ''
    def exception = session[WebAttributes.AUTHENTICATION_EXCEPTION]
    if (exception) {
      if (exception instanceof AccountExpiredException) {
        msg = g.message(code: "springSecurity.errors.login.expired")
      }
      else if (exception instanceof CredentialsExpiredException) {
        msg = g.message(code: "springSecurity.errors.login.passwordExpired")
      }
      else if (exception instanceof DisabledException) {
        msg = g.message(code: "springSecurity.errors.login.disabled")
      }
      else if (exception instanceof LockedException) {
        msg = g.message(code: "springSecurity.errors.login.locked")
      }
      else {
        msg = g.message(code: "springSecurity.errors.login.fail")
      }
    }

    if (springSecurityService.isAjax(request)) {
      render([error: msg] as JSON)
    }
    else {
      flash.message = msg
      redirect action: 'auth', params: params
    }
  }

  /**
   * The Ajax success redirect url.
   */
  def ajaxSuccess = {
    render([success: true, username: springSecurityService.authentication.name] as JSON)
  }

  /**
   * The Ajax denied redirect url.
   */
  def ajaxDenied = {
    render([error: 'access denied'] as JSON)
  }
}
