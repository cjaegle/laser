package com.k_int.kbplus
import grails.converters.*
import org.elasticsearch.groovy.common.xcontent.*
import groovy.xml.MarkupBuilder
import grails.plugin.springsecurity.annotation.Secured
import com.k_int.kbplus.auth.*;
import grails.plugin.springsecurity.SpringSecurityUtils

@Secured(['IS_AUTHENTICATED_FULLY'])
class SpotlightController {
  def ESSearchService
  def springSecurityService
  def dataloadService


  def g = new org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib()

    @Secured(['ROLE_USER'])
  def index() { 
    log.debug("spotlight::index");
  }

    @Secured(['ROLE_YODA'])
  def managePages(){
    def result = [:]
    result.user = springSecurityService.getCurrentUser()

    def isAdmin = SpringSecurityUtils.ifAllGranted('ROLE_ADMIN')

    if ( isAdmin  ) {
       request.setAttribute("editable","true")
    }

    def newPage

    if(request.getMethod() == "POST"){
      if(params.newCtrl && params.newAction && params.newAlias){
        newPage = 
        new SitePage(controller:params.newCtrl,action:params.newAction, alias:params.newAlias).save(flush:true)
      }else{
        flash.error=message(code: 'spotlight.new.missingprop') 
      }      
    }else if(params.id){
       newPage = SitePage.get(params.id)
       newPage.delete(flush:true)
    }

    if(newPage){
      if(newPage.hasErrors()){
          log.error(newPage.errors)
          result.newPage = newPage
        }else{
          updateSiteES()
        }
    }

    result.pages = SitePage.findAll()

    result

  }

    private def updateSiteES() {
      dataloadService.updateSiteMapping()
  }

    @Secured(['ROLE_USER'])
  def search() { 
    log.debug("spotlight::search");
    def result = [:]
    def filtered
    def query = params.query
    result.user = springSecurityService.getCurrentUser()
    //params.max = result.user.getDefaultPageSizeTMP() ?: 15
    params.max = 50

        if (!query) {
      return result
    }

    if (springSecurityService.isLoggedIn()) {
      if (query.startsWith("\$") && query.length() > 2 && query.indexOf(" ") != -1 ) {
        def filter = query.substring(0,query.indexOf(" "))
        switch (filter) {
          case "\$t":
            params.type = "title"
            query = query.replace("\$t  ","")
            filtered = "Title Instance"
            break
          case "\$pa":
            params.type = "package"
            query = query.replace("\$pa ","")
            filtered = "Package"
            break
          case "\$p":
            params.type = "package"
            query = query.replace("\$p ","")
            filtered = "Package"
            break
          case "\$pl":
            params.type = "platform"
            query = query.replace("\$pl ","")
            filtered = "Platform"
            break;
          case "\$s":
            params.type = "subscription"
            query = query.replace("\$s ","")     
            filtered = "Subscription"     
            break
          case "\$o":
            params.type = "organisation"
            query = query.replace("\$o ","")
            filtered = "Organisation"
            break
          case "\$l":
            params.type = "license"
            query = query.replace("\$l ","")
            filtered = "License"
            break
          case "\$a":
            params.type = "action"
            query = query.replace("\$a ","")
            filtered = "Action"
        }

      }
      params.q = query
      //From the available orgs, see if any belongs to a consortium, and add consortium ID too
      params.availableToOrgs = getAvailableOrgs(result.user.getAuthorizedOrgs())

      if(query.startsWith("\$")){
        if( query.length()> 2){
        result = ESSearchService.search(params)
        }
      }else{
        result = ESSearchService.search(params)
      }
      result.filtered = filtered
        // result?.facets?.type?.pop()?.term
    }
    result
  }

    private def getAvailableOrgs(orgs) {
    def orgsWithConsortia = []
    for (org in orgs) {
      if(org.outgoingCombos){
        for(combo in org.outgoingCombos){
          if(combo.type.value.equals("Consortium")){
            println "ORG IN CONSORTIUM"
            if(!orgsWithConsortia.contains(combo.toOrg.id)){
              orgsWithConsortia.add(combo.toOrg.id)
            }
            break
          }
        }
      }
      if(!orgsWithConsortia.contains(org.id)){
        orgsWithConsortia.add(org.id)
      }
    }
    return orgsWithConsortia
  }

    private def getActionLinks(q) {
    def result = []
    result = allActions
    return result;
  }
}
