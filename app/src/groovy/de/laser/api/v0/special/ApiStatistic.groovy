package de.laser.api.v0.special

import com.k_int.kbplus.IssueEntitlement
import com.k_int.kbplus.License
import com.k_int.kbplus.Org
import com.k_int.kbplus.OrgRole
import com.k_int.kbplus.Package
import com.k_int.kbplus.OrgSettings
import com.k_int.kbplus.Platform
import com.k_int.kbplus.RefdataValue
import com.k_int.kbplus.SubscriptionPackage
import com.k_int.kbplus.TitleInstancePackagePlatform
import de.laser.api.v0.ApiReader
import de.laser.api.v0.ApiReaderHelper
import de.laser.helper.RDStore
import grails.converters.JSON
import groovy.util.logging.Log4j

@Log4j
class ApiStatistic {

    static private List<Org> getAccessibleOrgs() {
        List<Org> orgs = OrgSettings.executeQuery(
                "select o from OrgSettings os join os.org o where os.key = :key and os.rdValue = :rdValue", [
                key    : OrgSettings.KEYS.STATISTICS_SERVER_ACCESS,
                rdValue: RefdataValue.getByValueAndCategory('Yes', 'YN')])
        orgs
    }

    /**
     * @return [] | HTTP_FORBIDDEN
     */
    static getAllOrgs() {
        def result = []

        // if (requestingOrghasNoAccess) { return Constants.HTTP_FORBIDDEN }

        List<Org> orgs = getAccessibleOrgs()
        orgs.each{ o ->
            result << ApiReaderHelper.resolveOrganisationStub(o, o)
        }

        return (result ? new JSON(result) : null)
    }

    static getAllPackages() {
        def result = []

        List<Org> orgs = getAccessibleOrgs()

        List<Package> packages = com.k_int.kbplus.Package.executeQuery(
                "select sp.pkg from SubscriptionPackage sp " +
                        "join sp.subscription s join s.orgRelations ogr join ogr.org o " +
                        "where o in :orgs ", [orgs: orgs]
        )
        packages.each{ p ->
            result << ApiReaderHelper.resolvePackageStub(p, null) // ? null
        }

        return (result ? new JSON(result) : null)
    }

    static getPackage(Package pkg) {
        if (! pkg) {
            return null
        }
        def result = [:]

        result.globalUID        = pkg.globalUID
        result.startDate        = pkg.startDate
        result.endDate          = pkg.endDate
        result.lastUpdated      = pkg.lastUpdated
        result.packageType      = pkg.packageType?.value
        result.packageStatus    = pkg.packageStatus?.value
        result.name             = pkg.name
        result.variantNames     = ['TODO-TODO-TODO'] // todo

        // References
        result.contentProvider  = resolvePkgOrganisations(pkg.orgs)
        result.license          = resolvePkgLicense(pkg.license)
        result.identifiers      = ApiReaderHelper.resolveIdentifiers(pkg.ids) // com.k_int.kbplus.IdentifierOccurrence
        //result.platforms        = resolvePkgPlatforms(pkg.nominalPlatform)
        //result.tipps            = resolvePkgTipps(pkg.tipps)
        result.subscriptions    = resolvePkgSubscriptions(pkg.subscriptions)

        result = ApiReaderHelper.cleanUp(result, true, true)

        return (result ? new JSON(result) : null)
    }

    static List resolvePkgOrganisations(Set<OrgRole> orgRoles) {
        if (! orgRoles) {
            return null
        }
        def result = []
        orgRoles.each { ogr ->
            if (ogr.roleType.id == RDStore.OR_CONTENT_PROVIDER.id) {
                result.add( ApiReaderHelper.resolveOrganisationStub(ogr.org, null))
            }
        }

        return ApiReaderHelper.cleanUp(result, true, true)
    }

    static resolvePkgLicense(License lic) {
        if (! lic) {
            return null
        }
        def result = ApiReaderHelper.resolveLicenseStub(lic, null, true)

        return ApiReaderHelper.cleanUp(result, true, true)
    }

    /*
    // TODO nominalPlatform? or tipps?
    static resolvePkgPlatforms(Platform  pform) {
        if (! pform) {
            return null
        }
        def result = [:]

        result.globalUID    = pform.globalUID
        result.name         = pform.name
        //result.identifiers  = ApiReaderHelper.resolveIdentifiers(pform.ids) // com.k_int.kbplus.IdentifierOccurrence

        return ApiReaderHelper.cleanUp(result, true, true)
    }
    */

    /*
    static resolvePkgTipps(Set<TitleInstancePackagePlatform> tipps) {
        // TODO: def tipps = TitleInstancePackagePlatform.findAllByPkgAndSub(subPkg.pkg, subPkg.subscription) ??
        if (! tipps) {
            return null
        }
        def result = []
        tipps.each{ tipp ->
            result.add( ApiReaderHelper.resolveTipp(tipp, ApiReaderHelper.IGNORE_NONE, null))
        }

        return ApiReaderHelper.cleanUp(result, true, true)
    }
    */

    static resolvePkgSubscriptions(Set<SubscriptionPackage> subscriptionPackages) {
        if (! subscriptionPackages) {
            return null
        }

        def result = []
        subscriptionPackages.each { subPkg ->
            def sub = ApiReaderHelper.resolveSubscriptionStub(subPkg.subscription, null, true)

            List<Org> orgList = []

            OrgRole.findAllBySub(subPkg.subscription).each { ogr ->

                if (ogr.roleType?.id in [RDStore.OR_SUBSCRIBER.id, RDStore.OR_SUBSCRIBER_CONS.id]) {

                    def org = ApiReaderHelper.resolveOrganisationStub(ogr.org, null)
                    if (org) {
                        orgList.add(ApiReaderHelper.cleanUp(org, true, true))
                    }
                }
            }
            if (orgList) {
                sub?.put('organisations', ApiReaderHelper.cleanUp(orgList, true, true))
            }

            List<IssueEntitlement> ieList = []
            def tipps = TitleInstancePackagePlatform.findAllByPkgAndSub(subPkg.pkg, subPkg.subscription)

            println subPkg.pkg?.id + " , " + subPkg.subscription?.id + " > " + tipps
            tipps.each{ tipp ->
                def ie = IssueEntitlement.findBySubscriptionAndTipp(subPkg.subscription, tipp)
                if (ie) {
                    ieList.add( ApiReaderHelper.resolveIssueEntitlement(ie, ApiReaderHelper.IGNORE_SUBSCRIPTION_AND_PACKAGE, null))
                }
            }
            if (ieList) {
                sub?.put('issueEntitlements', ApiReaderHelper.cleanUp(ieList, true, true))
            }

            //result.add( ApiReaderHelper.resolveSubscriptionStub(subPkg.subscription, null, true))
            //result.add( ApiReader.exportIssueEntitlements(subPkg, ApiReaderHelper.IGNORE_TIPP, null))
            result.add( sub )
        }

        return ApiReaderHelper.cleanUp(result, true, true)
    }

    /**
     * @return []
     */
    static getDummy() {
        def result = ['dummy']
        result
    }

}