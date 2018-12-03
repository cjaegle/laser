<%@ page import="org.codehaus.groovy.grails.web.servlet.GrailsApplicationAttributes;com.k_int.kbplus.Org;com.k_int.kbplus.UserSettings; com.k_int.kbplus.RefdataValue" %>

<!doctype html>

<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title><g:layoutTitle default="${meta(name: 'app.name')}"/></title>
    <meta name="description" content="">
    <meta name="viewport" content="initial-scale = 1.0">

    <r:require modules="semanticUI" />

    <script type="text/javascript">
        var gspLocale = "${message(code:'default.locale.label', default:'en')}";
        var gspDateFormat = "${message(code:'default.date.format.notime', default:'yyyy-mm-dd').toLowerCase()}";
    </script>

    <g:layoutHead/>

    <tmpl:/layouts/favicon />

    <r:layoutResources/>

</head>

<body class="${controllerName}_${actionName}" id="globalJumpMark">

    <laser:serviceInjection />

    <g:set var="contextOrg" value="${contextService.getOrg()}" />
    <g:set var="contextUser" value="${contextService.getUser()}" />
    <g:set var="contextMemberships" value="${contextService.getMemberships()}" />

    <g:if test="${grailsApplication.config.getCurrentServer() == contextService.SERVER_DEV}">
        <div class="ui green label big la-server-label">
            <span>DEV</span>
        </div>
    </g:if>
    <g:if test="${grailsApplication.config.getCurrentServer() == contextService.SERVER_QA}">
        <div class="ui red label big la-server-label">
            <span>QA</span>
        </div>
    </g:if>

    <div class="ui fixed inverted menu">
        <div class="ui container">
            <g:link controller="home" action="index" class="header item la-logo-item">
                <img class="logo" src="${resource(dir: 'images', file: 'laser.svg')}"/>
            </g:link>

            <sec:ifAnyGranted roles="ROLE_USER">

                <g:if test="${false}">
                    <div class="ui simple dropdown item">
                        Data Explorer
                        <i class="dropdown icon"></i>

                        <div class="menu">
                            <a class="item" href="${createLink(uri: '/home/search')}">Search</a>
                            <g:link class="item" controller="packageDetails">Package</g:link>
                            <g:link class="item" controller="organisations">Organisations</g:link>
                            <g:link class="item" controller="platform">Platform</g:link>
                            <g:link class="item" controller="titleDetails">Title Instance</g:link>
                            <g:link class="item" controller="tipp">Title Instance Package Platform</g:link>
                            <g:link class="item" controller="subscriptionDetails">Subscriptions</g:link>
                            <g:link class="item" controller="licenseDetails">Licenses</g:link>
                            <g:link class="item" controller="onixplLicenseDetails" action="list">ONIX-PL Licenses</g:link>
                        </div>
                    </div>
                </g:if>

                <g:if test="${contextOrg}">
                    <div class="ui simple dropdown item">
                        ${message(code:'menu.public')}
                        <i class="dropdown icon"></i>

                        <div class="menu">
                                <g:link class="item" controller="packageDetails" action="index">${message(code:'menu.institutions.all_pkg')}</g:link>
                                <g:link class="item" controller="titleDetails" action="index">${message(code:'menu.institutions.all_titles')}</g:link>
                            <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_ORG_EDITOR">
                                <g:link class="item" controller="organisations" action="index">${message(code:'menu.institutions.all_orgs')}</g:link>
                            </sec:ifAnyGranted>
                                <g:link class="item" controller="organisations" action="listProvider">${message(code:'menu.institutions.all_provider')}</g:link>
                                <g:link class="item" controller="platform" action="list">${message(code:'menu.institutions.all_platforms')}</g:link>

                            <%--<div class="divider"></div>

                            <g:link class="item" controller="myInstitution" action="currentTitles">${message(code:'menu.institutions.myTitles')}</g:link>
                            <g:link class="item" controller="myInstitution" action="tipview">${message(code:'menu.institutions.myCoreTitles')}</g:link>
                            --%>
                            <div class="divider"></div>

                            <g:if test="${grailsApplication.config.feature.eBooks}">
                                <a class="item" href="http://gokb.k-int.com/gokbLabs">${message(code:'menu.institutions.ebooks')}</a>
                                <div class="divider"></div>
                            </g:if>

                            <g:link class="item" controller="packageDetails" action="compare">${message(code:'menu.institutions.comp_pkg')}</g:link>
                            <g:link class="item" controller="onixplLicenseCompare" action="index">${message(code:'menu.institutions.comp_onix')}</g:link>
                        </div>
                    </div>

                    <div class="ui simple dropdown item">
                        ${message(code:'menu.my')}
                        <i class="dropdown icon"></i>

                        <div class="menu">

                            <semui:securedMainNavItem affiliation="INST_USER" controller="myInstitution" action="currentSubscriptions" message="menu.institutions.mySubs" />

                            <semui:securedMainNavItem affiliation="INST_USER" controller="myInstitution" action="currentLicenses" message="menu.institutions.myLics" />

                            <semui:securedMainNavItem affiliation="INST_USER" controller="myInstitution" action="currentProviders" message="menu.institutions.myProviders" />

                            <g:if test="${(com.k_int.kbplus.RefdataValue.getByValueAndCategory('Consortium', 'OrgRoleType')?.id in  contextService.getOrg()?.getallOrgRoleTypeIds())}">
                                <semui:securedMainNavItem affiliation="INST_ADM" controller="myInstitution" action="manageConsortia" message="menu.institutions.myConsortia" />
                            </g:if>

                            <semui:securedMainNavItem affiliation="INST_USER" controller="myInstitution" action="currentTitles" message="menu.institutions.myTitles" />

                            <%--<semui:securedMainNavItem affiliation="INST_USER" controller="myInstitution" action="tipview" message="menu.institutions.myCoreTitles" />--%>

                            <div class="divider"></div>

                            <semui:securedMainNavItem affiliation="INST_EDITOR" controller="myInstitution" action="emptySubscription" message="menu.institutions.emptySubscription" />

                            <semui:securedMainNavItem affiliation="INST_USER" controller="subscriptionDetails" action="compare" message="menu.institutions.comp_sub" />

                            <%--<g:link class="item" controller="subscriptionImport" action="generateImportWorksheet"
                                    params="${[id:contextOrg?.id]}">${message(code:'menu.institutions.sub_work')}</g:link>
                            <g:link class="item" controller="subscriptionImport" action="importSubscriptionWorksheet"
                                    params="${[id:contextOrg?.id]}">${message(code:'menu.institutions.imp_sub_work')}</g:link>--%>

                            <div class="divider"></div>

                            <semui:securedMainNavItem affiliation="INST_EDITOR" controller="myInstitution" action="emptyLicense" message="license.add.blank" />

                            <semui:securedMainNavItem affiliation="INST_USER" controller="licenseCompare" action="index" message="menu.institutions.comp_lic" />


                            <%--
                            <div class="divider"></div>
                            <g:link class="item" controller="subscriptionDetails" action="compare">${message(code:'menu.institutions.comp_sub')}</g:link>

                            <g:link class="item" controller="myInstitution" action="renewalsSearch">${message(code:'menu.institutions.gen_renewals')}</g:link>
                            <g:link class="item" controller="myInstitution" action="renewalsUpload">${message(code:'menu.institutions.imp_renew')}</g:link>

                            <g:link class="item" controller="subscriptionImport" action="generateImportWorksheet"
                                    params="${[id:contextOrg?.id]}">${message(code:'menu.institutions.sub_work')}</g:link>
                            <g:link class="item" controller="subscriptionImport" action="importSubscriptionWorksheet"
                                    params="${[id:contextOrg?.id]}">${message(code:'menu.institutions.imp_sub_work')}</g:link>--%>
                        </div>
                    </div>

                    <%--<sec:ifLoggedIn>
                   <div class="ui simple dropdown item">
                       ${message(code:'menu.institutions.lic')}
                       <i class="dropdown icon"></i>

                       <div class="menu">
                           <g:link class="item" controller="myInstitution" action="currentLicenses">${message(code:'menu.institutions.myLics')}</g:link>

                           <%--
                           <div class="divider"></div>

                           <g:link class="item" controller="licenseCompare" action="index">${message(code:'menu.institutions.comp_lic')}</g:link>

                            </div>
                        </div>
                    </sec:ifLoggedIn>--%>

                    <div class="ui simple dropdown item">
                        ${message(code:'menu.institutions.myInst')}
                        <i class="dropdown icon"></i>

                        <div class="menu">
                            <semui:securedMainNavItem affiliation="INST_USER" controller="myInstitution" action="dashboard" message="menu.institutions.dash" />

                            <g:link class="item" controller="organisations" action="show" params="[id: contextOrg?.id]">${message(code:'menu.institutions.org_info')}</g:link>

                            <semui:securedMainNavItem affiliation="INST_USER" controller="myInstitution" action="tasks" message="menu.institutions.tasks" />

                            <semui:securedMainNavItem affiliation="INST_USER" controller="myInstitution" action="changes" message="menu.institutions.todo" />

                            <semui:securedMainNavItem affiliation="INST_USER" controller="myInstitution" action="addressbook" message="menu.institutions.addressbook" />

                            <g:set var="newAffiliationRequests1" value="${com.k_int.kbplus.auth.UserOrg.findAllByStatusAndOrg(0, contextService.getOrg(), [sort:'dateRequested']).size()}" />
                            <semui:securedMainNavItem affiliation="INST_ADM" controller="myInstitution" action="manageAffiliationRequests" message="menu.institutions.affiliation_requests" newAffiliationRequests="${newAffiliationRequests1}" />


                            %{--<g:if test="${(com.k_int.kbplus.RefdataValue.getByValueAndCategory('Consortium', 'OrgRoleType')?.id in  contextService.getOrg()?.getallOrgRoleTypeIds())}">--}%
                                %{--<semui:securedMainNavItem affiliation="INST_ADM" controller="myInstitution" action="manageConsortia" message="menu.institutions.manage_consortia" />--}%
                            %{--</g:if>--}%

                            <semui:securedMainNavItem affiliation="INST_EDITOR" controller="myInstitution" action="managePrivateProperties" message="menu.institutions.manage_private_props" />
                            <semui:securedMainNavItem affiliation="INST_ADMIN"  controller="myInstitution" action="managePropertyGroups" message="menu.institutions.manage_prop_groups" />

                            <g:if test="${grailsApplication.config.feature_finance}">
                                <%-- <semui:securedMainNavItem affiliation="INST_EDITOR" controller="myInstitution" action="finance" message="menu.institutions.finance" /> --%>

                                <semui:securedMainNavItem affiliation="INST_EDITOR" controller="myInstitution" action="budgetCodes" message="menu.institutions.budgetCodes" />

                                <semui:securedMainNavItem affiliation="INST_EDITOR" controller="myInstitution" action="financeImport" message="menu.institutions.financeImport" />
                            </g:if>

                            <sec:ifAnyGranted roles="ROLE_YODA">
                                <div class="divider"></div>

                                <g:link class="item" controller="myInstitution" action="changeLog">${message(code:'menu.institutions.change_log')}</g:link>
                                <%--<semui:securedMainNavItem affiliation="INST_EDITOR" controller="myInstitution" action="changeLog" message="menu.institutions.change_log" />--%>
                            </sec:ifAnyGranted>

                        </div>
                    </div>
                </g:if>

                <sec:ifAnyGranted roles="ROLE_DATAMANAGER,ROLE_ADMIN,ROLE_GLOBAL_DATA">
                    <div class="ui simple dropdown item">
                        ${message(code:'menu.datamanager')}
                        <i class="dropdown icon"></i>

                        <div class="menu">
                            <sec:ifAnyGranted roles="ROLE_DATAMANAGER,ROLE_ADMIN">
                            <g:link class="item" controller="dataManager" action="index">${message(code:'menu.datamanager.dash')}</g:link>
                            <g:link class="item" controller="dataManager"
                                    action="deletedTitleManagement">${message(code: 'datamanager.deletedTitleManagement.label', default: 'Deleted Title management')}</g:link>

                            <div class="divider"></div>

                            <g:link class="item" controller="announcement" action="index">${message(code:'menu.datamanager.ann')}</g:link>
                            <g:link class="item" controller="packageDetails" action="list">${message(code:'menu.datamanager.searchPackages')}</g:link>
                            <g:link class="item" controller="platform" action="list">${message(code:'menu.datamanager.searchPlatforms')}</g:link>

                            <div class="divider"></div>

                            <g:link class="item" controller="upload" action="reviewPackage">${message(code:'menu.datamanager.uploadPackage')}</g:link>
                            <g:link class="item" controller="licenseImport" action="doImport">${message(code:'onix.import.license')}</g:link>

                            <div class="divider"></div>

                            <g:link class="item" controller="titleDetails" action="findTitleMatches">${message(code:'menu.datamanager.newTitle')}</g:link>
                            <g:link class="item" controller="licenseDetails" action="create">${message(code:'license.template.new')}</g:link>
                            <g:link class="item" controller="platform" action="create">${message(code:'menu.datamanager.newPlatform')}</g:link>

                            <g:link class="item" controller="subscriptionDetails" action="compare">${message(code:'menu.datamanager.compareSubscriptions')}</g:link>
                            <g:link class="item" controller="subscriptionImport" action="generateImportWorksheet">${message(code:'menu.datamanager.sub_work')}</g:link>
                            <g:link class="item" controller="subscriptionImport" action="importSubscriptionWorksheet" params="${[dm:'true']}">${message(code:'menu.datamanager.imp_sub_work')}</g:link>
                            <g:link class="item" controller="dataManager" action="changeLog">${message(code:'menu.datamanager.changelog')}</g:link><div class="divider"></div>
                            </sec:ifAnyGranted>

                            <g:link class="item" controller="globalDataSync" action="index" >${message(code:'menu.datamanager.global_data_sync')}</g:link>

                            <sec:ifAnyGranted roles="ROLE_DATAMANAGER,ROLE_ADMIN">
                            <div class="divider"></div>
                            <g:link class="item" controller="jasperReports" action="index">${message(code:'menu.datamanager.jasper_reports')}</g:link>
                            <g:link class="item" controller="titleDetails" action="dmIndex">${message(code:'menu.datamanager.titles')}</g:link>
                            </sec:ifAnyGranted>
                            </div>
                    </div>
                </sec:ifAnyGranted>

                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    <div class="ui simple dropdown item">
                        Admin
                        <i class="dropdown icon"></i>

                        <div class="menu">
                            <g:link class="item" controller="profile" action="errorOverview">
                                ${message(code: "menu.user.errorReport")}
                                <g:set var="newTickets" value="${com.k_int.kbplus.SystemTicket.getNew().size()}" />
                                <g:if test="${newTickets > 0}">
                                    <div class="ui floating red circular label">${newTickets}</div>
                                </g:if>
                            </g:link>

                            <g:link class="item" controller="admin" action="manageAffiliationRequests">
                                ${message(code: "menu.institutions.affiliation_requests")}
                                <g:set var="newAffiliationRequests" value="${com.k_int.kbplus.auth.UserOrg.findAllByStatus(0).size()}" />
                                <g:if test="${newAffiliationRequests > 0}">
                                    <div class="ui floating red circular label">${newAffiliationRequests}</div>
                                </g:if>
                            </g:link>

                            <div class="ui dropdown item">
                                System Admin
                                <i class="dropdown icon"></i>

                                <div class="menu">
                                    <g:link class="item" controller="yoda" action="appInfo">App Info</g:link>
                                    <g:link class="item" controller="admin" action="eventLog">Event Log</g:link>

                                    <div class="divider"></div>

                                    <g:link class="item" controller="admin" action="triggerHousekeeping" onclick="return confirm('${message(code:'confirm.start.HouseKeeping')}')">Trigger Housekeeping</g:link>
                                    <g:link class="item" controller="admin" action="initiateCoreMigration" onclick="return confirm('${message(code:'confirm.start.CoreMigration')}')">Initiate Core Migration</g:link>
                                    <g:if test="${grailsApplication.config.feature.issnl}">
                                        <g:link class="item" controller="admin" action="uploadIssnL">Upload ISSN to ISSN-L File</g:link>
                                    </g:if>
                                    <g:link class="item" controller="admin" action="dataCleanse" onclick="return confirm('${message(code:'confirm.start.DataCleaningNominalPlatforms')}')">Run Data Cleaning (Nominal Platforms)</g:link>
                                    <g:link class="item" controller="admin" action="titleAugment" onclick="return confirm('${message(code:'confirm.start.DataCleaningTitleAugment')}')">Run Data Cleaning (Title Augment)</g:link>
                                </div>
                            </div>

                            <div class="divider"></div>

                            <g:link class="item" controller="organisations" action="index">Manage Organisations</g:link>
                            <g:link class="item" controller="admin" action="showAffiliations">Show Affiliations</g:link>
                            <g:link class="item" controller="admin" action="allNotes">All Notes</g:link>
                            <g:link class="item" controller="userDetails" action="list">User Details</g:link>
                            <g:link class="item" controller="usage">Manage Usage Stats</g:link>
                            <% /* g:link class="item" controller="admin" action="forumSync">Run Forum Sync</g:link */ %>
                            <% /* g:link class="item" controller="admin" action="juspSync">Run JUSP Sync</g:link */ %>
                            <g:link class="item" controller="admin" action="forceSendNotifications">Send Pending Notifications</g:link>
                            <g:link class="item" controller="admin" action="checkPackageTIPPs">Tipps Check of GOKB and LAS:eR</g:link>

                            <div class="ui dropdown item">
                                Data Management
                                <i class="dropdown icon"></i>

                                <div class="menu">
                                    <g:link class="item" controller="dataManager" action="expungeDeletedTitles" onclick="return confirm('${message(code:'confirm.expunge.deleted.titles')}')">Expunge Deleted Titles</g:link>
                                    <g:link class="item" controller="dataManager" onclick="return confirm('${message(code:'confirm.expunge.deleted.tipps')}')" action="expungeDeletedTIPPS">Expunge Deleted TIPPS</g:link>
                                    <g:link class="item" controller="admin" action="titleMerge">Title Merge</g:link>
                                    <g:link class="item" controller="admin" action="tippTransfer">TIPP Transfer</g:link>
                                    <g:link class="item" controller="admin" action="ieTransfer">IE Transfer</g:link>
                                    <g:link class="item" controller="admin" action="userMerge">User Merge</g:link>
                                    <g:link class="item" controller="admin" action="hardDeletePkgs">Package Delete</g:link>
                                </div>
                            </div>

                            <div class="divider"></div>

                            <div class="ui dropdown item">
                               Bulk Operations
                               <i class="dropdown icon"></i>

                               <div class="menu">
                                    <g:link class="item" controller="admin" action="orgsExport">Bulk Export Organisations</g:link>
                                    <g:link class="item" controller="admin" action="orgsImport">Bulk Load Organisations</g:link>
                                    <g:link class="item" controller="admin" action="titlesImport">Bulk Load/Update Titles</g:link>
                                    <g:link class="item" controller="admin" action="financeImport">Bulk Load Financial Transaction</g:link>
                                </div>
                            </div>
                            <div class="divider"></div>

                            <g:link class="item" controller="admin" action="manageNamespaces">${message(code:'menu.admin.manageIdentifierNamespaces')}</g:link>
                            <g:link class="item" controller="admin" action="managePropertyDefinitions">${message(code:'menu.admin.managePropertyDefinitions')}</g:link>
                            <g:link class="item" controller="admin" action="managePropertyGroups">${message(code:'menu.institutions.manage_prop_groups')}</g:link>
                            <g:link class="item" controller="admin" action="manageRefdatas">${message(code:'menu.admin.manageRefdatas')}</g:link>
                            <g:link class="item" controller="admin" action="manageContentItems">${message(code:'menu.admin.manageContentItems')}</g:link>

                            <div class="divider"></div>

                            <g:link class="item" controller="stats" action="statsHome">Statistics</g:link>
                           %{-- <g:link class="item" controller="jasperReports" action="uploadReport">Upload Report Definitions</g:link>--}%

                        </div>
                    </div>
                </sec:ifAnyGranted>

                <sec:ifAnyGranted roles="ROLE_YODA">
                    <div class="ui simple dropdown item">
                        Yoda
                        <i class="dropdown icon"></i>

                        <div class="menu">
                            <div class="ui dropdown item">
                                Fällige Termine
                                <i class="dropdown icon"></i>

                                <div class="menu">
                                    <g:link class="item" controller="yoda" action="dueDates_updateDashboardDB">${message(code:'menu.admin.updateDashboardTable')}</g:link>
                                    <g:link class="item" controller="yoda" action="dueDates_sendAllEmails">${message(code:'menu.admin.sendEmailsForDueDates')}</g:link>
                                </div>
                            </div>
                            <div class="divider"></div>
                            <g:link class="item" controller="yoda" action="settings">System Settings</g:link>
                            <g:link class="item" controller="yoda" action="manageSystemMessage">${message(code: 'menu.admin.systemMessage', default: 'System Message')}</g:link>
                            <g:link class="item" controller="yoda" action="appConfig">App Config</g:link>
                            <g:link class="item" controller="yoda" action="appSecurity">App Security</g:link>
                            <g:link class="item" controller="yoda" action="cacheInfo">App Cache Info</g:link>
                            <a class="item" href="${g.createLink(uri:'/monitoring')}">App Monitoring</a>

                            <div class="divider"></div>

                            <g:link class="item" controller="yoda" action="pendingChanges">Pending Changes</g:link>

                            <div class="divider"></div>

                            <g:link class="item" controller="yoda" action="globalSync" onclick="return confirm('${message(code:'confirm.start.globalDataSync')}')">Start Global Data Sync</g:link>
                            <g:link class="item" controller="yoda" action="manageGlobalSources">Manage Global Sources</g:link>

                            <div class="divider"></div>

                            <g:link class="item" controller="yoda" action="fullReset" onclick="return confirm('${message(code:'confirm.start.resetESIndex')}')">Run Full ES Index Reset</g:link>
                            <g:link class="item" controller="yoda" action="esIndexUpdate" onclick="return confirm('${message(code:'confirm.start.ESUpdateIndex')}')">Start ES Index Update</g:link>
                            <%--<g:link class="item" controller="yoda" action="logViewer">Log Viewer</g:link>--%>
                            <g:link class="item" controller="yoda" action="manageESSources" >Manage ES Source</g:link>

                        </div>

                    </div>
                </sec:ifAnyGranted>

                <div class="right menu">
                    <div id="mainSearch" class="ui category search">
                        <div class="ui icon input">
                            <input  type="search" id="spotlightSearch" class="prompt" placeholder="Suche nach .. (ganzes Wort)" type="text">
                            <i id="btn-search"  class="search icon"></i>
                        </div>
                        <div class="results" style="overflow-y:scroll;max-height: 400px;min-height: content-box;"></div>
                    </div>

                    <g:if test="${contextUser}">
                        <div class="ui simple dropdown item la-noBorder">
                            ${contextUser.displayName}
                            <i class="dropdown icon"></i>

                            <div class="menu">

                                <g:set var="usaf" value="${contextUser.authorizedOrgs}" />
                                <g:if test="${usaf && usaf.size() > 0}">
                                    <g:each in="${usaf}" var="org">
                                        <g:if test="${org.id == contextOrg?.id}">
                                            <g:link class="item active" controller="myInstitution" action="switchContext" params="${[oid:"${org.class.name}:${org.id}"]}">${org.name}</g:link>
                                        </g:if>
                                        <g:else>
                                            <g:link class="item" controller="myInstitution" action="switchContext" params="${[oid:"${org.class.name}:${org.id}"]}">${org.name}</g:link>
                                        </g:else>
                                    </g:each>
                                </g:if>

                                <div class="divider"></div>

                                <g:link class="item" controller="profile" action="properties">${message(code: 'menu.user.properties', default: 'Properties and Refdatas')}</g:link>

                                <div class="divider"></div>

                                <g:link class="item" controller="profile" action="index">${message(code:'menu.user.profile')}</g:link>
                                <g:link class="item" controller="profile" action="help">${message(code:'menu.user.help')}</g:link>
                                <g:link class="item" controller="profile" action="errorReport">${message(code:'menu.user.errorReport')}</g:link>
                                <a href="https://www.hbz-nrw.de/datenschutz" class="item" target="_blank" >${message(code:'dse')}</a>

                                <div class="divider"></div>

                                <g:link class="item" controller="logout">${message(code:'menu.user.logout')}</g:link>
                                <div class="divider"></div>
                                <g:if test="${grailsApplication.metadata['app.version']}">
                                    <div class="header">Version: ${grailsApplication.metadata['app.version']} – ${grailsApplication.metadata['app.buildDate']}</div>
                                </g:if>
                            </div>
                        </div>
                    </g:if>
                </div>

            </sec:ifAnyGranted><%-- ROLE_USER --%>

            <sec:ifNotGranted roles="ROLE_USER">
                <sec:ifLoggedIn>
                    <g:link class="item" controller="logout">${message(code:'menu.user.logout')}</g:link>
                </sec:ifLoggedIn>
            </sec:ifNotGranted>

        </div><!-- container -->

    </div><!-- main menu -->

    <sec:ifAnyGranted roles="ROLE_USER">

        <div class="ui fixed menu la-contextBar"  >
            <div class="ui container">
                <div class="ui sub header item la-context-org">${contextOrg?.name}</div>
                <div class="right menu la-advanced-view">
                    <div class="item">
                        <g:if test="${cachedContent}">
                            <button class="ui icon button" data-tooltip="${message(code:'statusbar.cachedContent.tooltip')}" data-position="bottom right" data-variation="tiny">
                                <i class="hourglass end icon green"></i>
                            </button>
                        </g:if>
                    </div>

                        <g:if test="${controllerName=='subscriptionDetails' && actionName=='show'}">
                            <div class="item">
                                <g:if test="${user?.getSettingsValue(UserSettings.KEYS.SHOW_EDIT_MODE, RefdataValue.getByValueAndCategory('Yes','YN'))?.value=='Yes'}">
                                    <button class="ui icon toggle button la-toggle-controls" data-tooltip="${message(code:'statusbar.showButtons.tooltip')}" data-position="bottom right" data-variation="tiny">
                                        <i class="pencil alternate icon"></i>
                                    </button>
                                </g:if>
                                <g:else>
                                    <button class="ui icon toggle button active la-toggle-controls"  data-tooltip="${message(code:'statusbar.hideButtons.tooltip')}"  data-position="bottom right" data-variation="tiny">
                                        <i class="pencil alternate icon slash"></i>
                                    </button>
                                </g:else>

                            <r:script>
                                $(function(){
                                     <g:if test="${user?.getSettingsValue(UserSettings.KEYS.SHOW_EDIT_MODE, RefdataValue.getByValueAndCategory('Yes','YN'))?.value=='Yes'}">
                                        var editMode = true;
                                    </g:if>
                                    <g:else>
                                        var editMode = false;
                                    </g:else>
                                    $(".ui.toggle.button").click(function(){
                                        editMode = !editMode;
                                        $.ajax({
                                            url: '<g:createLink controller="ajax" action="toggleEditMode"/>',
                                            data: {
                                                showEditMode: editMode
                                            },
                                            success: function(){
                                                toggleEditableElements()
                                            }
                                        })
                                    });
                                    function toggleEditableElements(){
                                        // for future handling on other views
                                        // 1. add class 'hidden' via markup to all cards that might be toggled
                                        // 2. add class 'la-js-hideable' to all cards that might be toggled
                                        // 3. add class 'la-js-dont-hide-this-card' to markup that is rendered only in case of card has content, like to a table <th>
                                        // 4.
                                        var toggleButton = $(".ui.toggle.button");
                                        var toggleIcon = $(".ui.toggle.button .icon");
                                        $(".table").trigger('reflow');

                                        if (  editMode) {
                                            // show Contoll Elements
                                            $('.card').removeClass('hidden');
                                            $('.la-js-hide-this-card').removeClass('hidden');
                                            $('.ui .form').removeClass('hidden');
                                            $('#collapseableSubDetails').find('.button').removeClass('hidden');
                                            $(toggleButton).removeAttr("data-tooltip","${message(code:'statusbar.hideButtons.tooltip')}");
                                            $(toggleButton).attr("data-tooltip","${message(code:'statusbar.showButtons.tooltip')}");
                                            $(toggleIcon ).removeClass( "slash" );
                                            $(toggleButton).addClass('active');

                                            $('.xEditableValue').editable('option', 'disabled', false);
                                            $('.xEditable').editable('option', 'disabled', false);
                                            $('.xEditableDatepicker').editable('option', 'disabled', false);
                                            $('.xEditableManyToOne').editable('option', 'disabled', false);
                                        }
                                        else {
                                            // hide Contoll Elements
                                            $('.card').removeClass('hidden');
                                            $('.card.la-js-hideable').not( ":has(.la-js-dont-hide-this-card)" ).addClass('hidden');
                                            $('.la-js-hide-this-card').addClass('hidden');
                                            $('.ui .form').addClass('hidden');
                                            $('#collapseableSubDetails').find('.button').addClass('hidden');
                                            // hide all the x-editable
                                            $(toggleButton).removeAttr();
                                            $(toggleButton).attr("data-tooltip","${message(code:'statusbar.hideButtons.tooltip')}");
                                            $( toggleIcon ).addClass( "slash" );
                                            $(toggleButton).removeClass('active');

                                            $('.xEditableValue').editable('option', 'disabled', true);
                                            $('.xEditable').editable('option', 'disabled', true);
                                            $('.xEditableDatepicker').editable('option', 'disabled', true);
                                            $('.xEditableManyToOne').editable('option', 'disabled', true);
                                        }
                                    }
                                    toggleEditableElements();
                                });

                            </r:script>
                            </div>
                            </g:if>
                            <g:if test="${(params.mode)}">
                                <div class="item">
                                    <g:if test="${params.mode=='advanced'}">
                                        <div class="ui toggle la-toggle-advanced button" data-tooltip="${message(code:'statusbar.showAdvancedView.tooltip')}" data-position="bottom right" data-variation="tiny">
                                            <i class="icon plus square"></i>
                                    </g:if>
                                    <g:else>
                                        <div class="ui toggle la-toggle-advanced button" data-tooltip="${message(code:'statusbar.showBasicView.tooltip')}" data-position="bottom right" data-variation="tiny">
                                            <i class="icon plus square green slash"></i>
                                    </g:else>
                                </div>



                            <script>
                                var LaToggle = {};
                                LaToggle.advanced = {};
                                LaToggle.advanced.button = {};

                                // ready event
                                LaToggle.advanced.button.ready = function() {

                                    // selector cache
                                    var
                                        $button = $('.button.la-toggle-advanced'),

                                        // alias
                                        handler = {
                                            activate: function() {
                                                $icon = $(this).find('.icon');
                                                if ($icon.hasClass("slash")) {
                                                    $icon.removeClass("slash");
                                                    window.location.href = "<g:createLink action="${actionName}" params="${params + ['mode':'advanced']}" />";
                                                }
                                                 else {
                                                    $icon.addClass("slash");
                                                    window.location.href = "<g:createLink action="${actionName}" params="${params + ['mode':'basic']}" />" ;
                                                }
                                            }
                                        }
                                    ;
                                    $button
                                        .on('click', handler.activate)
                                    ;
                                };

                                // attach ready event
                                $(document)
                                    .ready(LaToggle.advanced.button.ready)
                                ;
                            </script>

                    </div>

                    </div>
                            </g:if>
                    <%--semui:editableLabel editable="${editable}" /--%>
            </div>
        </div>
        </div><!-- Context Bar -->

        <div class="ui right aligned sub header">${contextOrg?.name}</div>

    </sec:ifAnyGranted><%-- ROLE_USER --%>

        <div class="navbar-push"></div>

        <%-- global content container --%>
        <div class="ui main container">
            <g:layoutBody/>
        </div><!-- .main -->

        <div id="Footer">
            <div class="clearfix"></div>
            <div class="footer-links container">
                <div class="row"></div>
            </div>
        </div>

        <%-- global container for modals and ajax --%>
        <div id="dynamicModalContainer"></div>

        <%-- global loading indicator --%>
        <div id="loadingIndicator" style="display: none">
            <div class="ui text loader active">Loading</div>
        </div>

        <%-- global confirmation modal --%>
        <semui:confirmationModal  />

        <%-- <a href="#globalJumpMark" class="ui button icon" style="position:fixed;right:0;bottom:0;"><i class="angle up icon"></i></a> --%

        <%-- maintenance --%>
<g:if test="${com.k_int.kbplus.SystemMessage.findAllByShowNowAndOrg(true, contextOrg) || com.k_int.kbplus.SystemMessage.findAllByShowNowAndOrgIsNull(true)}">
            <div id="maintenance">
                <div class="ui segment center aligned inverted orange">
                    <strong>ACHTUNG:</strong>

                    <div class="ui list">
                        <g:each in="${com.k_int.kbplus.SystemMessage.findAllByShowNow(true)}" var="message">
                            <div class="item">
                                <g:if test="${message.org}">
                                    <g:if test="${contextOrg.id == message.org.id}">
                                        ${message.text}
                                    </g:if>
                                </g:if>
                                <g:else>
                                    ${message.text}
                                </g:else>
                            </div>
                        </g:each>
                    </div>
                </div>
            </div>
        </g:if>

        <r:layoutResources/>

        <% if(! flash.redirectFrom) { flash.clear() } %>
    </body>
</html>
