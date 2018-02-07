package com.k_int.kbplus

import com.k_int.properties.PropertyDefinition
import grails.converters.*
import com.k_int.kbplus.auth.*;
import org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent
import org.springframework.security.access.annotation.Secured

@Mixin(com.k_int.kbplus.mixins.PendingChangeMixin)
class LicenseDetailsController {

    def springSecurityService
    def taskService
    def docstoreService
    def gazetteerService
    def alertsService
    def genericOIDService
    def transformerService
    def exportService
    def institutionsService
    def pendingChangeService
    def executorWrapperService
    def permissionHelperService
    def contextService
    def addressbookService

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def index() {
      log.debug("licenseDetails: ${params}");
      def result = [:]
      result.user = User.get(springSecurityService.principal.id)
      // result.institution = Org.findByShortcode(params.shortcode)
      result.license = License.get(params.id)
      result.transforms = grailsApplication.config.licenseTransforms

      userAccessCheck(result.license, result.user, 'view')

      //used for showing/hiding the License Actions menus
      def admin_role = Role.findAllByAuthority("INST_ADM")
      result.canCopyOrgs = UserOrg.executeQuery("select uo.org from UserOrg uo where uo.user=(:user) and uo.formalRole=(:role) and uo.status in (:status)", [user: result.user, role: admin_role, status: [1, 3]])

      result.editable = result.license.isEditableBy(result.user)

      def license_reference_str = result.license.reference ?: 'NO_LIC_REF_FOR_ID_' + params.id

      def filename = "licenseDetails_${license_reference_str.replace(" ", "_")}"
      result.onixplLicense = result.license.onixplLicense;

      if (executorWrapperService.hasRunningProcess(result.license)) {
          log.debug("PEndingChange processing in progress")
          result.processingpc = true
      } else {

          def pending_change_pending_status = RefdataCategory.lookupOrCreate("PendingChangeStatus", "Pending")
          def pendingChanges = PendingChange.executeQuery("select pc.id from PendingChange as pc where license=? and ( pc.status is null or pc.status = ? ) order by pc.ts desc", [result.license, pending_change_pending_status]);

          //Filter any deleted subscriptions out of displayed links
          Iterator<Subscription> it = result.license.subscriptions.iterator()
          while (it.hasNext()) {
              def sub = it.next();
              if (sub.status == RefdataCategory.lookupOrCreate('Subscription Status', 'Deleted')) {
                  it.remove();
              }
          }

          log.debug("pc result is ${result.pendingChanges}");
          if (result.license.incomingLinks.find { it?.isSlaved?.value == "Yes" } && pendingChanges) {
              log.debug("Slaved lincence, auto-accept pending changes")
              def changesDesc = []
              pendingChanges.each { change ->
                  if (!pendingChangeService.performAccept(change, request)) {
                      log.debug("Auto-accepting pending change has failed.")
                  } else {
                      changesDesc.add(PendingChange.get(change).desc)
                  }
              }
              flash.message = changesDesc
          } else {
              result.pendingChanges = pendingChanges.collect { PendingChange.get(it) }
          }
      }
      result.availableSubs = getAvailableSubscriptions(result.license, result.user)

      // tasks
      def contextOrg = contextService.getOrg()
      result.tasks = taskService.getTasksByResponsiblesAndObject(result.user, contextOrg, result.license)
      def preCon = taskService.getPreconditions(contextOrg)
      result << preCon

      // -- private properties

      result.authorizedOrgs = result.user?.authorizedOrgs
      result.contextOrg = contextService.getOrg()

      // create mandatory LicensePrivateProperties if not existing

      def mandatories = []
      result.user?.authorizedOrgs?.each { org ->
          def ppd = PropertyDefinition.findAllByDescrAndMandatoryAndTenant("License Property", true, org)
          if (ppd) {
              mandatories << ppd
          }
      }
      mandatories.flatten().each { pd ->
          if (!LicensePrivateProperty.findWhere(owner: result.license, type: pd)) {
              def newProp = PropertyDefinition.createGenericProperty(PropertyDefinition.PRIVATE_PROPERTY, result.license, pd)

              if (newProp.hasErrors()) {
                  log.error(newProp.errors)
              } else {
                  log.debug("New license private property created via mandatory: " + newProp.type.name)
              }
          }
      }

      // -- private properties

      result.modalPrsLinkRole    = RefdataValue.findByValue('Specific license editor')
      result.modalVisiblePersons = addressbookService.getVisiblePersonsByOrgRoles(result.user, result.license.orgLinks)

      result.license.orgLinks.each { or ->
          or.org.prsLinks.each { pl ->
              if (pl.prs?.isPublic?.value != 'No') {
                  if (! result.modalVisiblePersons.contains(pl.prs)) {
                      result.modalVisiblePersons << pl.prs
                  }
              }
          }
      }

      result.visiblePrsLinks = []

      result.license.prsLinks.each { pl ->
          if (! result.visiblePrsLinks.contains(pl.prs)) {
              if (pl.prs.isPublic?.value != 'No') {
                  result.visiblePrsLinks << pl
              }
              else {
                  // nasty lazy loading fix
                  result.user.authorizedOrgs.each{ ao ->
                      if (ao.getId() == pl.prs.tenant.getId()) {
                          result.visiblePrsLinks << pl
                      }
                  }
              }
          }
      }

      withFormat {
      html result
      json {
        def map = exportService.addLicensesToMap([:], [result.license])
        
        def json = map as JSON
        response.setHeader("Content-disposition", "attachment; filename=\"${filename}.json\"")
        response.contentType = "application/json"
        render json.toString()
      }
      xml {
        def doc = exportService.buildDocXML("Licenses")
            

        if ((params.transformId) && (result.transforms[params.transformId] != null)) {
            switch(params.transformId) {
              case "sub_ie":
                exportService.addLicenseSubPkgTitleXML(doc, doc.getDocumentElement(),[result.license])
              break;
              case "sub_pkg":
                exportService.addLicenseSubPkgXML(doc, doc.getDocumentElement(),[result.license])
                break;
            }
            String xml = exportService.streamOutXML(doc, new StringWriter()).getWriter().toString();
            transformerService.triggerTransform(result.user, filename, result.transforms[params.transformId], xml, response)
        }else{
            exportService.addLicensesIntoXML(doc, doc.getDocumentElement(), [result.license])
            
            response.setHeader("Content-disposition", "attachment; filename=\"${filename}.xml\"")
            response.contentType = "text/xml"
            exportService.streamOutXML(doc, response.outputStream)
        }
        
      }
      csv {
        response.setHeader("Content-disposition", "attachment; filename=\"${filename}.csv\"")
        response.contentType = "text/csv"
        def out = response.outputStream
        exportService.StreamOutLicenseCSV(out,null,[result.license])
        out.close()
      }
    }
  }

  def getAvailableSubscriptions(license,user){
    def licenseInstitutions = license?.orgLinks?.findAll{ orgRole ->
      orgRole.roleType?.value == "Licensee"
    }?.collect{  permissionHelperService.hasUserWithRole(user, it.org, 'INST_ADM') ? it.org : null  }

    def subscriptions = null
    if(licenseInstitutions){
      def sdf = new java.text.SimpleDateFormat(message(code:'default.date.format.notime', default:'yyyy-MM-dd'))
      def date_restriction =  new Date(System.currentTimeMillis())

      def base_qry = " from Subscription as s where  ( ( exists ( select o from s.orgRelations as o where o.roleType.value = 'Subscriber' and o.org in (:orgs) ) ) ) AND ( s.status.value != 'Deleted' ) AND (s.owner = null) "
      def qry_params = [orgs:licenseInstitutions]
      base_qry += " and s.startDate <= (:start) and s.endDate >= (:start) "
      qry_params.putAll([start:date_restriction])
      subscriptions = Subscription.executeQuery("select s ${base_qry}", qry_params)
    }
    return subscriptions
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def linkToSubscription(){
    log.debug("linkToSubscription :: ${params}")
    if(params.subscription && params.license){
      def sub = Subscription.get(params.subscription)
      def owner = License.get(params.license)
      owner.addToSubscriptions(sub)
      owner.save(flush:true)
    }
    redirect controller:'licenseDetails', action:'index', params: [id:params.license]

  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def consortia() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)
   
    def hasAccess
    def isAdmin
    if (result.user.getAuthorities().contains(Role.findByAuthority('ROLE_ADMIN'))) {
        isAdmin = true;
    }else{
       hasAccess = result.license.orgLinks.find{it.roleType?.value == 'Licensing Consortium' && permissionHelperService.hasUserWithRole(result.user, it.org, 'INST_ADM') }
    }
    if( !isAdmin && (result.license.licenseType != "Template" || hasAccess == null)) {
      flash.error = message(code:'license.consortia.access.error')
      response.sendError(401) 
      return
    }

    result.editable = result.license.isEditableBy(result.user)

    log.debug("consortia(${params.id}) - ${result.license}")
    def consortia = result.license?.orgLinks?.find{
      it.roleType?.value == 'Licensing Consortium'}?.org

    if(consortia){
      result.consortia = consortia
      result.consortiaInstsWithStatus = []
    def type = RefdataCategory.lookupOrCreate('Combo Type', 'Consortium')
    def institutions_in_consortia_hql = "select c.fromOrg from Combo as c where c.type = ? and c.toOrg = ? order by c.fromOrg.name"
    def consortiaInstitutions = Combo.executeQuery(institutions_in_consortia_hql, [type, consortia])

     result.consortiaInstsWithStatus = [ : ]
     def findOrgLicenses = "SELECT lic from License AS lic WHERE exists ( SELECT link from lic.orgLinks AS link WHERE link.org = ? and link.roleType.value = 'Licensee') AND exists ( SELECT incLink from lic.incomingLinks AS incLink WHERE incLink.fromLic = ? ) AND lic.status.value != 'Deleted'"
     consortiaInstitutions.each{ 
        def queryParams = [ it, result.license]
        def hasLicense = License.executeQuery(findOrgLicenses, queryParams)
        if (hasLicense){
          result.consortiaInstsWithStatus.put(it, RefdataCategory.lookupOrCreate("YNO","Yes") )    
        }else{
          result.consortiaInstsWithStatus.put(it, RefdataCategory.lookupOrCreate("YNO","No") )    
        }
      }
    }else{
      flash.error=message(code:'license.consortia.noneset')
    }

    result
  }
  
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def generateSlaveLicenses(){
    def slaved = RefdataCategory.lookupOrCreate('YN','Yes')
    params.each { p ->
        if(p.key.startsWith("_create.")){
         def orgID = p.key.substring(8)
         def orgaisation = Org.get(orgID)
          def attrMap = [baselicense:params.baselicense,lic_name:params.lic_name,isSlaved:slaved]
          log.debug("Create slave license for ${orgaisation.name}")
          attrMap.copyStartEnd = true
          institutionsService.copyLicense(attrMap);
        }
    }
    redirect controller:'licenseDetails', action:'consortia', params: [id:params.baselicense]
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def links() {
    log.debug("licenseDetails id:${params.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    // result.institution = Org.findByShortcode(params.shortcode)
    result.license = License.get(params.id)

    result.editable = result.license.isEditableBy(result.user)

    if ( ! result.license.hasPerm("view",result.user) ) {
      response.sendError(401);
      return
    }

    result
  }
  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def history() {
    log.debug("licenseDetails::history : ${params}");

    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)

    userAccessCheck(result.license,result.user,'view')

    result.editable = result.license.isEditableBy(result.user)

    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;
    result.offset = params.offset ?: 0;


    def qry_params = [licClass:result.license.class.name, prop:LicenseCustomProperty.class.name,owner:result.license, licId:"${result.license.id}"]

    result.historyLines = AuditLogEvent.executeQuery("select e from AuditLogEvent as e where (( className=:licClass and persistedObjectId=:licId ) or (className = :prop and persistedObjectId in (select lp.id from LicenseCustomProperty as lp where lp.owner=:owner))) order by e.dateCreated desc", qry_params, [max:result.max, offset:result.offset]);
    
    def propertyNameHql = "select pd.name from LicenseCustomProperty as licP, PropertyDefinition as pd where licP.id= ? and licP.type = pd"
    
    result.historyLines?.each{
      if(it.className == qry_params.prop ){
        def propertyName = LicenseCustomProperty.executeQuery(propertyNameHql,[it.persistedObjectId.toLong()])[0]
        it.propertyName = propertyName
      }
    }

    result.historyLinesTotal = AuditLogEvent.executeQuery("select count(e.id) from AuditLogEvent as e where ( (className=:licClass and persistedObjectId=:licId) or (className = :prop and persistedObjectId in (select lp.id from LicenseCustomProperty as lp where lp.owner=:owner))) ",qry_params)[0];

    result

  }


  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def changes() {
    log.debug("licenseDetails::changes : ${params}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)

    userAccessCheck(result.license,result.user,'view')

    result.editable = result.license.isEditableBy(result.user)

    result.max = params.max ? Integer.parseInt(params.max) : result.user.defaultPageSize;
    result.offset = params.offset ?: 0;

    result.todoHistoryLines = PendingChange.executeQuery("select pc from PendingChange as pc where pc.license=? order by pc.ts desc", [result.license],[max:result.max,offset:result.offset]);

    result.todoHistoryLinesTotal = PendingChange.executeQuery("select count(pc) from PendingChange as pc where pc.license=? order by pc.ts desc", [result.license])[0];
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def notes() {
    log.debug("licenseDetails id:${params.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    // result.institution = Org.findByShortcode(params.shortcode)
    result.license = License.get(params.id)

    userAccessCheck(result.license,result.user,'view')

    result.editable = result.license.isEditableBy(result.user)

    result
  }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def tasks() {
        log.debug("licenseDetails id:${params.id}")

        def result = [:]
        result.user     = User.get(springSecurityService.principal.id)
        result.license  = License.get(params.id)

        userAccessCheck(result.license,result.user,'view') // TODO
        result.editable = result.license.isEditableBy(result.user) // TODO

        result.taskInstanceList = taskService.getTasksByResponsiblesAndObject(result.user, contextService.getOrg(), result.license)
        log.debug(result.taskInstanceList)

        result
    }

    @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
    def properties() {
        def result = [:]

        log.debug("licenseDetails id: ${params.id}");

        def user    = User.get(springSecurityService.principal.id)
        result.user = user
        result.authorizedOrgs = user?.authorizedOrgs

        def licenseInstance = License.get(params.id)
        result.license      = licenseInstance

        result.editable = result.license.isEditableBy(result.user)

        // create mandatory LicensePrivateProperties if not existing

        def mandatories = []
        user?.authorizedOrgs?.each{ org ->
            def ppd = PropertyDefinition.findAllByDescrAndMandatoryAndTenant("License Property", true, org)
            if (ppd) {
                mandatories << ppd
            }
        }
        mandatories.flatten().each{ pd ->
            if (! LicensePrivateProperty.findWhere(owner: licenseInstance, type: pd)) {
                def newProp = PropertyDefinition.createGenericProperty(PropertyDefinition.PRIVATE_PROPERTY, licenseInstance, pd)

                if (newProp.hasErrors()) {
                    log.error(newProp.errors)
                } else {
                    log.debug("New license private property created via mandatory: " + newProp.type.name)
                }
            }
        }
        result
    }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def documents() {
    log.debug("licenseDetails id:${params.id}");
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)

    userAccessCheck(result.license,result.user,'view')

    result.editable = result.license.isEditableBy(result.user)

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def deleteDocuments() {
    def ctxlist = []

    log.debug("deleteDocuments ${params}");

    def user = User.get(springSecurityService.principal.id)
    def l = License.get(params.instanceId);

    userAccessCheck(l,user,'edit')

    params.each { p ->
      if (p.key.startsWith('_deleteflag.') ) {
        def docctx_to_delete = p.key.substring(12);
        log.debug("Looking up docctx ${docctx_to_delete} for delete");
        def docctx = DocContext.get(docctx_to_delete)
        docctx.status = RefdataCategory.lookupOrCreate('Document Context Status','Deleted');
        docctx.save(flush:true);
      }
    }

    redirect controller: 'licenseDetails', action:params.redirectAction, id:params.instanceId, fragment:'docstab'
  }

    def userAccessCheck(license, user, role_str) {
        if ((license == null || user == null ) || (! license?.hasPerm(role_str, user))) {
            log.debug("return 401....");
            def this_license = message(code:'license.details.flash.this_license')
            def this_inst = message(code:'license.details.flash.this_inst')
            flash.error = message(code:'license.details.flash.error', args:[role_str,(license?.reference?:this_license),(license?.licensee?.name?:this_inst)])
            response.sendError(401);
            return false
        }
        return true
    }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def acceptChange() {
    processAcceptChange(params, License.get(params.id), genericOIDService)
    redirect controller: 'licenseDetails', action:'index',id:params.id
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def rejectChange() {
    processRejectChange(params, License.get(params.id))
    redirect controller: 'licenseDetails', action:'index',id:params.id
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def permissionInfo() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result.license = License.get(params.id)
    userAccessCheck(result.license,result.user,'view')

    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def create() {
    def result = [:]
    result.user = User.get(springSecurityService.principal.id)
    result
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def processNewTemplateLicense() {
    if ( params.reference && ( ! params.reference.trim().equals('') ) ) {

      def template_license_type = RefdataCategory.lookupOrCreate('License Type','Template');
      def license_status_current = RefdataCategory.lookupOrCreate('License Status','Current');
      
      def new_template_license = new License(reference:params.reference,
                                             type:template_license_type,
                                             status:license_status_current).save(flush:true);
      redirect(action:'index', id:new_template_license.id);
    }
    else {
      redirect(action:'create');
    }
  }

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def unlinkLicense() {
      log.debug("unlinkLicense :: ${params}")
      License license = License.get(params.license_id);
      OnixplLicense opl = OnixplLicense.get(params.opl_id);
      if(! (opl && license)){
        log.error("Something has gone mysteriously wrong. Could not get License or OnixLicense. params:${params} license:${license} onix: ${opl}")
        flash.message = message(code:'license.unlink.error.unknown');
        redirect(action: 'index', id: license.id);
      }

      String oplTitle = opl?.title;
      DocContext dc = DocContext.findByOwner(opl.doc);
      Doc doc = opl.doc;
      license.removeFromDocuments(dc);
      opl.removeFromLicenses(license);
      // If there are no more links to this ONIX-PL License then delete the license and
      // associated data
      if (opl.licenses.isEmpty()) {
          opl.usageTerm.each{
            it.usageTermLicenseText.each{
              it.delete()
            }
          }
          opl.delete();
          dc.delete();
          doc.delete();
      }
      if (license.hasErrors()) {
          license.errors.each {
              log.error("License error: " + it);
          }
          flash.message = message(code:'license.unlink.error.known', args:[oplTitle]);
      } else {
          flash.message = message(code:'license.unlink.success', args:[oplTitle]);
      }
      redirect(action: 'index', id: license.id);
  }
}
