package de.laser

import com.k_int.kbplus.*
import com.k_int.kbplus.auth.User
import de.laser.helper.RDStore
import grails.transaction.Transactional

@Transactional
class TaskService {

    final static WITHOUT_TENANT_ONLY = "WITHOUT_TENANT_ONLY"

    def springSecurityService

    def getTasksByCreator(User user, flag) {
        def tasks = []
        if (user) {
            if (flag == WITHOUT_TENANT_ONLY) {
                tasks = Task.findAllByCreatorAndResponsibleOrgAndResponsibleUser(user, null, null)
            }
            else {
                tasks = Task.findAllByCreator(user)
            }
        }
        tasks.sort{ it.endDate }
    }

    def getTasksByResponsible(User user, Map queryMap) {
        def tasks = []
        if (user) {
            def query  = "select t from Task t where t.responsibleUser = :user" + queryMap.query
            def params = [user : user] << queryMap.queryParams
            tasks = Task.executeQuery(query, params)
        }
        tasks
    }

    def getTasksByResponsible(Org org, Map queryMap) {
        def tasks = []
        if (org) {
            def query  = "select t from Task t where t.responsibleOrg = :org" + queryMap.query
            def params = [org : org] << queryMap.queryParams
            tasks = Task.executeQuery(query, params)
        }
        tasks
    }

    def getTasksByResponsibles(User user, Org org, Map queryMap) {
        def tasks = []

        if (user && org) {
            def query = "select t from Task t where ( t.responsibleUser = :user or t.responsibleOrg = :org ) " + queryMap.query
            def params = [user : user, org: org] << queryMap.queryParams
            tasks = Task.executeQuery(query, params)
        } else if (user) {
            tasks = getTasksByResponsible(user, queryMap)
        } else if (org) {
            tasks = getTasksByResponsible(org, queryMap)
        }
        tasks
    }

    def getTasksByResponsibleAndObject(User user, Object obj) {
        def tasks = getTasksByResponsibleAndObject(user, obj, [])
        tasks.sort{ it.endDate }
    }

    def getTasksByResponsibleAndObject(Org org, Object obj) {
        def tasks = getTasksByResponsibleAndObject(org, obj, [])
        tasks.sort{ it.endDate }
    }

    def getTasksByResponsiblesAndObject(User user, Org org, Object obj) {
        def tasks = []
        def a = getTasksByResponsibleAndObject(user, obj)
        def b = getTasksByResponsibleAndObject(org, obj)

        tasks = a.plus(b).unique()
        tasks.sort{ it.endDate }
    }

    def getTasksByResponsibleAndObject(User user, Object obj,  Object params) {
        def tasks = []
        if (user && obj) {
            switch (obj.getClass().getSimpleName()) {
                case 'License':
                    tasks = Task.findAllByResponsibleUserAndLicense(user, obj, params)
                    break
                case 'Org':
                    tasks = Task.findAllByResponsibleUserAndOrg(user, obj, params)
                    break
                case 'Package':
                    tasks = Task.findAllByResponsibleUserAndPkg(user, obj, params)
                    break
                case 'Subscription':
                    tasks = Task.findAllByResponsibleUserAndSubscription(user, obj, params)
                    break
                case 'SurveyConfig':
                    tasks = Task.findAllByResponsibleUserAndSurveyConfig(user, obj, params)
                    break
            }
        }
        tasks
    }

    def getTasksByResponsibleAndObject(Org org, Object obj,  Object params) {
        def tasks = []
        if (org && obj) {
            switch (obj.getClass().getSimpleName()) {
                case 'License':
                    tasks = Task.findAllByResponsibleOrgAndLicense(org, obj, params)
                    break
                case 'Org':
                    tasks = Task.findAllByResponsibleOrgAndOrg(org, obj, params)
                    break
                case 'Package':
                    tasks = Task.findAllByResponsibleOrgAndPkg(org, obj, params)
                    break
                case 'Subscription':
                    tasks = Task.findAllByResponsibleOrgAndSubscription(org, obj, params)
                    break
                case 'SurveyConfig':
                    tasks = Task.findAllByResponsibleOrgAndSurveyConfig(org, obj, params)
                    break
            }
        }
        tasks
    }

    def getTasksByResponsiblesAndObject(User user, Org org, Object obj,  Object params) {
        def tasks = []
        def a = getTasksByResponsibleAndObject(user, obj, params)
        def b = getTasksByResponsibleAndObject(org, obj, params)

        tasks = a.plus(b).unique()
        tasks
    }

    def getPreconditions(Org contextOrg) {
        def result = [:]

        def qry_params1 = [
            lic_org:    contextOrg,
            org_roles:  [
                    RDStore.OR_LICENSEE,
                    RDStore.OR_LICENSEE_CONS
            ]
        ]
        def qry_params2 = [
            'roleTypes' : [
                    RDStore.OR_SUBSCRIBER,
                    RDStore.OR_SUBSCRIBER_CONS,
                    RDStore.OR_SUBSCRIPTION_CONSORTIA
            ],
            'activeInst': contextOrg
        ]

        def responsibleUsersQuery   = "select u from User as u where exists (select uo from UserOrg as uo where uo.user = u and uo.org = ? and (uo.status=1 or uo.status=3))"
        def validResponsibleOrgs    = contextOrg ? [contextOrg] : []
        def validResponsibleUsers   = contextOrg ? User.executeQuery(responsibleUsersQuery, [contextOrg]) : []

        if (contextOrg) {
            //TODO: MAX und OFFSET anders festlegen
            result.validLicenses = License.executeQuery('select l ' + MyInstitutionController.INSTITUTIONAL_LICENSES_QUERY +' order by l.sortableReference asc', qry_params1, [max: 1000, offset: 0])
            result.validSubscriptions = Subscription.executeQuery("select s " + MyInstitutionController.INSTITUTIONAL_SUBSCRIPTION_QUERY + ' order by s.name asc', qry_params2,  [max: 1000, offset: 0])
        }
        else { // TODO: admin and datamanager without contextOrg possible ?
            result.validLicenses = License.list()
            result.validSubscriptions = Subscription.list()
        }

        result.validOrgs            = Org.list() // TODO
        result.validPackages        = Package.list() // TODO

        result.taskCreator          = springSecurityService.getCurrentUser()
        result.validResponsibleOrgs = validResponsibleOrgs
        result.validResponsibleUsers = validResponsibleUsers

        result
    }
}
