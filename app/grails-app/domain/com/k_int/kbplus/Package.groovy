package com.k_int.kbplus

import de.laser.domain.AbstractBaseDomain
import de.laser.domain.IssueEntitlementCoverage
import de.laser.helper.RDStore
import de.laser.helper.RefdataAnnotation
import de.laser.interfaces.ShareSupport
import de.laser.traits.ShareableTrait
import groovy.util.slurpersupport.NodeChildren
import groovyx.net.http.HTTPBuilder
import static groovyx.net.http.ContentType.XML
import static groovyx.net.http.Method.GET
import org.apache.commons.logging.Log
import org.apache.commons.logging.LogFactory

import javax.persistence.Transient
import java.text.Normalizer
import java.text.SimpleDateFormat

class Package
        extends AbstractBaseDomain
        implements ShareSupport {

    // TODO AuditTrail
  static auditable = [ignore:['version','lastUpdated','pendingChanges']]
    // ??? org.quartz.JobExecutionException: groovy.lang.MissingPropertyException: No such property: auditable for class: com.k_int.kbplus.Package

  static Log static_logger = LogFactory.getLog(Package)

  @Transient
  def grailsApplication
  @Transient
  def deletionService

  //String identifier
  String name
  String sortName
  String gokbId
   //URL originEditUrl
  String vendorURL
  String cancellationAllowances

  Date listVerifiedDate

    @RefdataAnnotation(cat = '?')
    RefdataValue packageType

    @RefdataAnnotation(cat = 'Package Status')
    RefdataValue packageStatus

    @RefdataAnnotation(cat = 'Package.ListStatus')
    RefdataValue packageListStatus

    @RefdataAnnotation(cat = '?')
    RefdataValue breakable

    @RefdataAnnotation(cat = '?')
    RefdataValue consistent

    @RefdataAnnotation(cat = '?')
    RefdataValue fixed

    boolean isPublic

    @RefdataAnnotation(cat = '?')
    RefdataValue packageScope

    Platform nominalPlatform
    Date startDate
    Date endDate
    Date dateCreated
    Date lastUpdated
    License license
    String forumId
    Set pendingChanges
    Boolean autoAccept = false

static hasMany = [  tipps:     TitleInstancePackagePlatform,
                    orgs:      OrgRole,
                    prsLinks:  PersonRole,
                    documents: DocContext,
                    subscriptions:  SubscriptionPackage,
                    pendingChanges: PendingChange,
                    ids: Identifier ]

  static mappedBy = [tipps:     'pkg',
                     orgs:      'pkg',
                     prsLinks:  'pkg',
                     documents: 'pkg',
                     subscriptions: 'pkg',
                     pendingChanges: 'pkg',
                     ids:       'pkg'
                     ]


  static mapping = {
                    sort sortName: 'asc'
                      id column:'pkg_id'
                 version column:'pkg_version'
               globalUID column:'pkg_guid'
            //identifier column:'pkg_identifier'
                    name column:'pkg_name'
                sortName column:'pkg_sort_name'
                  gokbId column:'pkg_gokb_id', type:'text'
         //originEditUrl column:'pkg_origin_edit_url'
             packageType column:'pkg_type_rv_fk'
           packageStatus column:'pkg_status_rv_fk'
       packageListStatus column:'pkg_list_status_rv_fk'
               breakable column:'pkg_breakable_rv_fk'
              consistent column:'pkg_consistent_rv_fk'
                   fixed column:'pkg_fixed_rv_fk'
         nominalPlatform column:'pkg_nominal_platform_fk'
               startDate column:'pkg_start_date',   index:'pkg_dates_idx'
                 endDate column:'pkg_end_date',     index:'pkg_dates_idx'
                 license column:'pkg_license_fk'
                isPublic column:'pkg_is_public'
            packageScope column:'pkg_scope_rv_fk'
               vendorURL column:'pkg_vendor_url'
  cancellationAllowances column:'pkg_cancellation_allowances', type:'text'
                 forumId column:'pkg_forum_id'
                     tipps sort:'title.title', order: 'asc', batchSize: 10
            pendingChanges sort:'ts', order: 'asc', batchSize: 10

            listVerifiedDate column: 'pkg_list_verified_date'

            orgs            batchSize: 10
            prsLinks        batchSize: 10
            documents       batchSize: 10
            subscriptions   batchSize: 10
            ids             batchSize: 10
  }

  static constraints = {
                 globalUID(nullable:true, blank:false, unique:true, maxSize:255)
               packageType(nullable:true, blank:false)
             packageStatus(nullable:true, blank:false)
           nominalPlatform(nullable:true, blank:false)
         packageListStatus(nullable:true, blank:false)
                 breakable(nullable:true, blank:false)
                consistent(nullable:true, blank:false)
                     fixed(nullable:true, blank:false)
                 startDate(nullable:true, blank:false)
                   endDate(nullable:true, blank:false)
                   license(nullable:true, blank:false)
                  isPublic(nullable:false, blank:false)
              packageScope(nullable:true, blank:false)
                   forumId(nullable:true, blank:false)
                    gokbId(nullable:true, blank:false)
           //originEditUrl(nullable:true, blank:false)
                 vendorURL(nullable:true, blank:false)
    cancellationAllowances(nullable:true, blank:false)
                  sortName(nullable:true, blank:false)
      listVerifiedDate(nullable:true, blank:false)
  }

    def afterDelete() {
        deletionService.deleteDocumentFromIndex(this.globalUID)
    }

    @Override
    boolean checkSharePreconditions(ShareableTrait sharedObject) {
        false // NO SHARES
    }

    boolean showUIShareButton() {
        false // NO SHARES
    }

    void updateShare(ShareableTrait sharedObject) {
        false // NO SHARES
    }

    void syncAllShares(List<ShareSupport> targets) {
        false // NO SHARES
    }

  @Deprecated
  Org getConsortia() {
    Org result
    orgs.each { or ->
      if ( ( or?.roleType?.value=='Subscription Consortia' ) || ( or?.roleType?.value=='Package Consortia' ) )
        result = or.org
    }
    result
  }

  /**
   * Materialise this package into a subscription of the given type (taken or offered)
   * @param subtype One of 'Subscription Offered' or 'Subscription Taken'
   */
  @Deprecated
  @Transient
  def createSubscription(subtype,
                         subname,
                         subidentifier,
                         startdate,
                         enddate,
                         consortium_org) {
    createSubscription(subtype,subname,subidentifier,startdate,enddate,consortium_org,true)
  }
 @Deprecated
 @Transient
  def createSubscription(subtype,
                         subname,
                         subidentifier,
                         startdate,
                         enddate,
                         consortium_org,
                         add_entitlements) {
    createSubscription(subtype, subname,subidentifier,startdate,
                  enddate,consortium_org,add_entitlements,false)
  }
  @Deprecated
  @Transient
  def createSubscription(subtype,
                         subname,
                         subidentifier,
                         startdate,
                         enddate,
                         consortium_org,
                         add_entitlements,slaved) {
    createSubscription(subtype, subname,subidentifier,startdate,
                  enddate,consortium_org,"Package Consortia",add_entitlements,false)
  }
  @Deprecated
  @Transient
  def createSubscription(subtype,
                         subname,
                         subidentifier,
                         startdate,
                         enddate,
                         consortium_org,org_role,
                         add_entitlements,slaved) {
    // Create the header
    log.debug("Package: createSubscription called")
    def result = new Subscription( name:subname,
                                   status:RefdataValue.getByValueAndCategory('Current','Subscription Status'),
                                   identifier:subidentifier,
                                   startDate:startdate,
                                   endDate:enddate,
                                   isPublic: false,
                                   type: RefdataValue.findByValue(subtype),
                                   isSlaved: (slaved == "Yes" || slaved == true))

    if ( result.save(flush:true) ) {
      if ( consortium_org ) {
        def sc_role = RefdataValue.getByValueAndCategory(org_role,'Organisational Role')
        def or = new OrgRole(org: consortium_org, sub:result, roleType:sc_role).save();
        log.debug("Create Org role ${or}")
      }
      addToSubscription(result, add_entitlements)

    }
    else {
      result.errors.each { err ->
        log.error("Problem creating new sub: ${err}");
      }
    }

    result
  }

  @Transient
  Org getContentProvider() {
    Org result

    orgs.each { or ->
      if ( or?.roleType?.value=='Content Provider' )
        result = or.org
    }
    result
  }

  @Deprecated
  @Transient
  void updateNominalPlatform() {
      Map<String, Object> platforms = [:]
    tipps.each{ tipp ->
      if ( !platforms.keySet().contains(tipp.platform.id) ) {
        platforms[tipp.platform.id] = [count:1, platform:tipp.platform]
      }
      else {
        platforms[tipp.platform.id].count++
      }
    }

    def selected_platform = null;
    def largest = 0;
    platforms.values().each { pl ->
      log.debug("Processing ${pl}");
      if ( pl['count'] > largest ) {
        selected_platform = pl['platform']
      }
    }

    nominalPlatform = selected_platform
  }

  @Transient
  void addToSubscription(subscription, createEntitlements) {
    // Add this package to the specified subscription
    // Step 1 - Make sure this package is not already attached to the sub
    // Step 2 - Connect
    List<SubscriptionPackage> dupe = SubscriptionPackage.executeQuery(
            "from SubscriptionPackage where subscription = ? and pkg = ?", [subscription, this])

    if (!dupe){
        SubscriptionPackage new_pkg_sub = new SubscriptionPackage(subscription:subscription, pkg:this).save();
      // Step 3 - If createEntitlements ...

      if ( createEntitlements ) {
        def live_issue_entitlement = RDStore.TIPP_STATUS_CURRENT
        TitleInstancePackagePlatform.findAllByPkg(this).each { tipp ->
          if(tipp.status?.value == "Current"){
              IssueEntitlement new_ie = new IssueEntitlement(
                                              status: live_issue_entitlement,
                                              subscription: subscription,
                                              tipp: tipp,
                                              accessStartDate:tipp.accessStartDate,
                                              accessEndDate:tipp.accessEndDate,
                                              acceptStatus: RDStore.IE_ACCEPT_STATUS_FIXED)
              if(new_ie.save()) {
                  tipp.coverages.each { covStmt ->
                      IssueEntitlementCoverage ieCoverage = new IssueEntitlementCoverage(
                              startDate:covStmt.startDate,
                              startVolume:covStmt.startVolume,
                              startIssue:covStmt.startIssue,
                              endDate:covStmt.endDate,
                              endVolume:covStmt.endVolume,
                              endIssue:covStmt.endIssue,
                              embargo:covStmt.embargo,
                              coverageDepth:covStmt.coverageDepth,
                              coverageNote:covStmt.coverageNote,
                              issueEntitlement: new_ie
                      )
                      ieCoverage.save()
                  }
              }
          }
        }
      }

    }
  }

    @Transient
    void addToSubscriptionCurrentStock(Subscription target, Subscription consortia) {

        // copy from: addToSubscription(subscription, createEntitlements) { .. }

        List<SubscriptionPackage> dupe = SubscriptionPackage.executeQuery(
                "from SubscriptionPackage where subscription = ? and pkg = ?", [target, this])

        if (! dupe){

            RefdataValue statusCurrent = RDStore.TIPP_STATUS_CURRENT

            new SubscriptionPackage(subscription:target, pkg:this).save()

            TitleInstancePackagePlatform.executeQuery(
                "select tipp from IssueEntitlement ie join ie.tipp tipp " +
                "where tipp.pkg = :pkg and tipp.status = :current and ie.subscription = :consortia ", [
                      pkg: this, current: statusCurrent, consortia: consortia

            ]).each { TitleInstancePackagePlatform tipp ->
                IssueEntitlement newIe = new IssueEntitlement(
                        status: statusCurrent,
                        subscription: target,
                        tipp: tipp,
                        accessStartDate: tipp.accessStartDate,
                        accessEndDate: tipp.accessEndDate,
                        acceptStatus: RDStore.IE_ACCEPT_STATUS_FIXED
                )
                if(newIe.save()) {
                    tipp.coverages.each { covStmt ->
                        IssueEntitlementCoverage ieCoverage = new IssueEntitlementCoverage(
                                startDate: covStmt.startDate,
                                startVolume: covStmt.startVolume,
                                startIssue: covStmt.startIssue,
                                endDate: covStmt.endDate,
                                endVolume: covStmt.endVolume,
                                endIssue: covStmt.endIssue,
                                embargo: covStmt.embargo,
                                coverageDepth: covStmt.coverageDepth,
                                coverageNote: covStmt.coverageNote,
                                issueEntitlement: newIe
                        )
                        ieCoverage.save()
                    }
                }
            }
        }
    }

  /**
   *  Tell the event notification service how this object is known to any registered notification
   *  systems.
   */
  @Transient
  def getNotificationEndpoints() {
    [
      //[ service:'zendesk.forum', remoteid:this.forumId ],
      [ service:'announcements' ]
    ]
  }

  String toString() {
    name ? "${name}" : "Package ${id}"
  }

  /*@Transient
   String getURL() {
    "${grailsApplication.config.grails.serverURL}/package/show/${id}".toString();
  }*/

    /*
    def onChange = { oldMap, newMap ->
        log.debug("OVERWRITE onChange")
    }*/

  // @Transient
  // def onChange = { oldMap,newMap ->

  //   log.debug("onChange")

  //   def changeNotificationService = grailsApplication.mainContext.getBean("changeNotificationService")

  //   controlledProperties.each { cp ->
  //    if ( oldMap[cp] != newMap[cp] ) {
  //      changeNotificationService.notifyChangeEvent([
  //                                                   OID:"${this.class.name}:${this.id}",
  //                                                   event:'TitleInstance.propertyChange',
  //                                                   prop:cp, old:oldMap[cp], new:newMap[cp]
  //                                                  ])
  //    }
  //   }
  // }

    /*
 @Transient
  def onSave = {
    log.debug("onSave")
    def changeNotificationService = grailsApplication.mainContext.getBean("changeNotificationService")

    changeNotificationService.fireEvent([
                                                 OID:"com.k_int.kbplus.Package:${id}",
                                                 event:'Package.created'
                                                ])

  }
    */
  /**
  * OPTIONS: startDate, endDate, hideIdent, inclPkgStartDate, hideDeleted
  */
    /*
  @Transient
  def notifyDependencies_trait(changeDocument) {
    def changeNotificationService = grailsApplication.mainContext.getBean("changeNotificationService")
    if ( changeDocument.event=='Package.created' ) {
      changeNotificationService.broadcastEvent("com.k_int.kbplus.SystemObject:1", changeDocument);
    }
  }
     */

  @Transient
  static def refdataFind(params) {
    def result = [];

    String hqlString = "select pkg from Package pkg where lower(pkg.name) like ? "
    def hqlParams = [((params.q ? params.q.toLowerCase() : '' ) + "%")]
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")

    if(params.hasDate ){

      def startDate = params.startDate.length() > 1 ? sdf.parse(params.startDate) : null
      def endDate =  params.endDate.length() > 1 ? sdf.parse(params.endDate)  : null

      if(startDate) {
        hqlString += " AND pkg.startDate >= ?"
        hqlParams += startDate
      }
      if(endDate) {
        hqlString += " AND pkg.endDate <= ?"
        hqlParams += endDate
      }
    }

    if(params.hideDeleted == 'true'){
      hqlString += " AND pkg.packageStatus.value != 'Deleted'"
    }

    def queryResults = Package.executeQuery(hqlString,hqlParams);

    queryResults?.each { t ->
      def resultText = t.name
      def date = t.startDate? " (${sdf.format(t.startDate)})" :""
      resultText = params.inclPkgStartDate == "true" ? resultText + date : resultText
      resultText = params.hideIdent == "true" ? resultText : resultText+" (${t.identifier})"
      result.add([id:"${t.class.name}:${t.id}",text:resultText])
    }

    result
  }

  @Deprecated
  @Transient
  def toComparablePackage() {
    Map<String, Object> result = [:]
    println "converting old package to comparable package"
    def sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    println "processing metadata"
    result.packageName = this.name
    result.packageId = this.identifier
    result.gokbId = this.gokbId

    result.tipps = []
    println "before tipps"
    this.tipps.each { tip ->
        println "Now processing TIPP ${tip}"
      //NO DELETED TIPPS because from only come no deleted tipps
      if(tip.status?.id != RDStore.TIPP_DELETED.id){
      // Title.ID needs to be the global identifier, so we need to pull out the global id for each title
      // and use that.
          println "getting identifier value of title ..."
      def title_id = tip.title.getIdentifierValue('uri')?:"uri://KBPlus/localhost/title/${tip.title.id}"
          println "getting identifier value of TIPP ..."
      def tipp_id = tip.getIdentifierValue('uri')?:"uri://KBPlus/localhost/tipp/${tip.id}"

          println "preparing TIPP ..."
      def newtip = [
                     title: [
                       name:tip.title.title,
                       identifiers:[],
                       titleType: tip.title.class.name ?: null
                     ],
                     titleId:title_id,
                     titleUuid:tip.title.gokbId,
                     tippId:tipp_id,
                     tippUuid:tip.gokbId,
                     platform:tip.platform.name,
                     platformId:tip.platform.id,
                     platformUuid:tip.platform.gokbId,
                     platformPrimaryUrl:tip.platform.primaryUrl,
                     coverage:[],
                     url:tip.hostPlatformURL ?: '',
                     identifiers:[],
                     status: tip.status,
                     accessStart: tip.accessStartDate ?: null,
                     accessEnd: tip.accessEndDate ?: null
                   ];

          println "adding coverage ..."
      // Need to format these dates using correct mask
          tip.coverages.each { tc ->
              newtip.coverage.add([
                      startDate:tc.startDate ?: null,
                      endDate:tc.endDate ?: null,
                      startVolume:tc.startVolume ?: '',
                      endVolume:tc.endVolume ?: '',
                      startIssue:tc.startIssue ?: '',
                      endIssue:tc.endIssue ?: '',
                      coverageDepth:tc.coverageDepth ?: '',
                      coverageNote:tc.coverageNote ?: '',
                      embargo: tc.embargo ?: ''
              ])
          }

          println "processing IDs ..."
      tip?.title?.ids.each { id ->
          println "adding identifier ${id}"
        newtip.title.identifiers.add([namespace:id.ns.ns, value:id.value]);
      }

      result.tipps.add(newtip)
          }
    }

    result.tipps.sort{it.titleId}
    println "Rec conversion for package returns object with title ${result.title} and ${result.tipps?.size()} tipps"

    result
  }

    def beforeInsert() {
        if ( name != null ) {
            sortName = generateSortName(name)
        }

        super.beforeInsert()
    }

    def beforeUpdate() {
        if ( name != null ) {
            sortName = generateSortName(name)
        }
        super.beforeUpdate()
    }

  def checkAndAddMissingIdentifier(ns,value) {
    boolean found = false
    println "processing identifier ${value}"
    this.ids.each {
        println "processing identifier occurrence ${it}"
      if ( it.ns?.ns == ns && it.value == value ) {
          println "occurrence found"
        found = true
      }
    }

    if ( ! found && ns.toLowerCase() != 'originediturl' ) {
        // TODO [ticket=1789]
      //def id = Identifier.lookupOrCreateCanonicalIdentifier(ns, value)
      //  println "before execute query"
      //def id_occ = IdentifierOccurrence.executeQuery("select io from IdentifierOccurrence as io where io.identifier = ? and io.pkg = ?", [id,this])
      //  println "id_occ query executed"

      //if ( !id_occ || id_occ.size() == 0 ){
      //  println "Create new identifier occurrence for pid:${getId()} ns:${ns} value:${value}"
      //  new IdentifierOccurrence(identifier:id, pkg:this).save()
      //}
        Identifier.construct([value:value, reference:this, namespace:ns])
    }
    else if(ns.toLowerCase() == 'originediturl') {
        println "package identifier namespace for ${value} is deprecated originEditUrl ... ignoring."
    }
  }

  static String generateSortName(String input_title) {
    if (!input_title) return null
    String s1 = Normalizer.normalize(input_title, Normalizer.Form.NFKD).trim().toLowerCase()
    s1 = s1.replaceFirst('^copy of ','')
    s1 = s1.replaceFirst('^the ','')
    s1 = s1.replaceFirst('^a ','')
    s1 = s1.replaceFirst('^der ','')

    return s1.trim()

  }

    Identifier getIdentifierByType(idtype) {
        def result = null
        ids.each { ident ->
            if ( ident.ns.ns.equalsIgnoreCase(idtype) ) {
                result = ident
            }
        }
        result
    }

    List<TitleInstancePackagePlatform> getCurrentTipps() {
        List<TitleInstancePackagePlatform> result = []
        if (this.tipps) {
            result = this.tipps?.findAll{it?.status?.id == RDStore.TIPP_STATUS_CURRENT.id}
        }
        result
    }
}
