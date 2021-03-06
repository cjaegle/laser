package de.laser.api.v0.entities

import com.k_int.kbplus.IssueEntitlement
import com.k_int.kbplus.Org
import de.laser.api.v0.ApiCollectionReader
import de.laser.api.v0.ApiMapReader
import de.laser.api.v0.ApiReader
import de.laser.api.v0.ApiStubReader
import de.laser.api.v0.ApiToolkit
import de.laser.api.v0.ApiUnsecuredMapReader
import de.laser.domain.IssueEntitlementCoverage
import groovy.util.logging.Log4j

@Log4j
class ApiIssueEntitlement {

    /**
     * @return xxx | BAD_REQUEST | PRECONDITION_FAILED
     */
//    static findSubscriptionPackageBy(String query, String value) {
//        def result
//
//        def queries = query.split(",")
//        def values  = value.split(",")
//        if (queries.size() != 2 || values.size() != 2) {
//            return Constants.HTTP_BAD_REQUEST
//        }
//
//        def sub = ApiSubscription.findSubscriptionBy(queries[0].trim(), values[0].trim())
//        def pkg = ApiPkg.findPackageBy(queries[1].trim(), values[1].trim())
//
//        if (sub instanceof Subscription && pkg instanceof Package) {
//            result = SubscriptionPackage.findAllBySubscriptionAndPkg(sub, pkg)
//            result = ApiToolkit.checkPreconditionFailed(result)
//        }
//
//        result
//    }

    /**
     * @return JSON | FORBIDDEN
     */
//    static requestIssueEntitlements(SubscriptionPackage subPkg, Org context){
//        Collection<Object> result = []
//
//        boolean hasAccess = false
//        if (! hasAccess) {
//            boolean hasAccess2 = false
//            // TODO
//            subPkg.subscription.orgRelations.each{ orgRole ->
//                if(orgRole.getOrg().id == context?.id) {
//                    hasAccess2 = true
//                }
//            }
//            subPkg.pkg.orgs.each{ orgRole ->
//                if(orgRole.getOrg().id == context?.id) {
//                    hasAccess = hasAccess2
//                }
//            }
//        }
//
//        if (hasAccess) {
//            result = ApiCollectionReader.getIssueEntitlementCollection(subPkg, ApiReader.IGNORE_NONE, context) // TODO check orgRole.roleType
//        }
//
//        return (hasAccess ? new JSON(result) : Constants.HTTP_FORBIDDEN)
//    }

    /**
     * @return Map<String, Object>
     */
    static Map<String, Object> getIssueEntitlementMap(IssueEntitlement ie, def ignoreRelation, Org context) {
        Map<String, Object> result = [:]
        if (! ie) {
            return null
        }

        result.globalUID        = ie.globalUID
        result.accessStartDate  = ApiToolkit.formatInternalDate(ie.accessStartDate)
        result.accessEndDate    = ApiToolkit.formatInternalDate(ie.accessEndDate)
        result.ieReason         = ie.ieReason
        result.coreStatusStart  = ApiToolkit.formatInternalDate(ie.coreStatusStart)
        result.coreStatusEnd    = ApiToolkit.formatInternalDate(ie.coreStatusEnd)
        result.lastUpdated      = ApiToolkit.formatInternalDate(ie.lastUpdated)

        // RefdataValues
        result.coreStatus       = ie.coreStatus?.value
        result.medium           = ie.medium?.value
        //result.status           = ie.status?.value // legacy; not needed ?

        result.coverages        = ApiCollectionReader.getIssueEntitlementCoverageCollection(ie.coverages) // com.k_int.kbplus.TitleInstancePackagePlatform

        // References
        if (ignoreRelation != ApiReader.IGNORE_ALL) {
            if (ignoreRelation == ApiReader.IGNORE_SUBSCRIPTION_AND_PACKAGE) {
                result.tipp = ApiMapReader.getTippMap(ie.tipp, ApiReader.IGNORE_ALL, context) // com.k_int.kbplus.TitleInstancePackagePlatform
            }
            else {
                if (ignoreRelation != ApiReader.IGNORE_TIPP) {
                    result.tipp = ApiMapReader.getTippMap(ie.tipp, ApiReader.IGNORE_NONE, context)
                    // com.k_int.kbplus.TitleInstancePackagePlatform
                }
                if (ignoreRelation != ApiReader.IGNORE_SUBSCRIPTION) {
                    result.subscription = ApiStubReader.requestSubscriptionStub(ie.subscription, context)
                    // com.k_int.kbplus.Subscription
                }
            }
        }

        ApiToolkit.cleanUp(result, true, true)
    }
}
