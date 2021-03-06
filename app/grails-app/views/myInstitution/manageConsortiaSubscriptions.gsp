<%@ page import="de.laser.helper.RDStore;de.laser.helper.RDConstants;com.k_int.kbplus.OrgRole;com.k_int.kbplus.RefdataCategory;com.k_int.kbplus.RefdataValue;com.k_int.properties.PropertyDefinition;com.k_int.kbplus.Subscription;com.k_int.kbplus.CostItem" %>
<laser:serviceInjection />

<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI">
    <g:set var="entityName" value="${message(code: 'org.label')}"/>
    <title>${message(code: 'laser')} : ${message(code: 'menu.my.consortiaSubscriptions')}</title>
</head>

<body>

<semui:debugInfo>
    <g:render template="/templates/debug/benchMark" model="[debug: benchMark]" />
</semui:debugInfo>

<semui:breadcrumbs>
    <semui:crumb message="menu.my.consortiaSubscriptions" class="active"/>
</semui:breadcrumbs>

<semui:controlButtons>
    <semui:exportDropdown>
        <semui:exportDropdownItem>
            <g:if test="${filterSet || defaultSet}">
                <g:link class="item js-open-confirm-modal"
                        data-confirm-tokenMsg = "${message(code: 'confirmation.content.exportPartial')}"
                        data-confirm-term-how="ok" controller="myInstitution" action="manageConsortiaSubscriptions"
                        params="${params+[exportXLS:true]}">
                    ${message(code:'default.button.exports.xls')}
                </g:link>
            </g:if>
            <g:else>
                <g:link class="item" controller="myInstitution" action="manageConsortiaSubscriptions" params="${params+[exportXLS:true]}">${message(code:'default.button.exports.xls')}</g:link>
            </g:else>
        </semui:exportDropdownItem>
        <semui:exportDropdownItem>
            <g:if test="${filterSet || defaultSet}">
                <g:link class="item js-open-confirm-modal"
                        data-confirm-tokenMsg = "${message(code: 'confirmation.content.exportPartial')}"
                        data-confirm-term-how="ok" controller="myInstitution" action="manageConsortiaSubscriptions"
                        params="${params+[format:'csv']}">
                    ${message(code:'default.button.exports.csv')}
                </g:link>
            </g:if>
            <g:else>
                <g:link class="item" controller="myInstitution" action="manageConsortiaSubscriptions" params="${params+[format:'csv']}">${message(code:'default.button.exports.csv')}</g:link>
            </g:else>
        </semui:exportDropdownItem>

    </semui:exportDropdown>
    <semui:actionsDropdown>
        <semui:actionsDropdownItem data-semui="modal" href="#copyEmailaddresses_ajaxModal" message="menu.institutions.copy_emailaddresses.button"/>
    </semui:actionsDropdown>
</semui:controlButtons>

<h1 class="ui left floated aligned icon header la-clear-before">
    <semui:headerIcon />${message(code: 'menu.my.consortiaSubscriptions')}
    <semui:totalNumber total="${countCostItems}"/>
</h1>

<semui:messages data="${flash}"/>

<g:render template="/templates/filter/javascript" />
<semui:filter showFilterButton="true">
    <g:form action="manageConsortiaSubscriptions" controller="myInstitution" method="get" class="ui small form">

        <div class="three fields">
            <div class="field">
                <%--
               <label>${message(code: 'default.search.text')}
                   <span data-position="right center" data-variation="tiny" data-content="${message(code:'default.search.tooltip.subscription')}">
                       <i class="question circle icon"></i>
                   </span>
               </label>
               <div class="ui input">
                   <input type="text" name="q"
                          placeholder="${message(code: 'default.search.ph')}"
                          value="${params.q}"/>
               </div>
               --%>

                <label>${message(code:'myinst.consortiaSubscriptions.consortia')}</label>
                <g:select class="ui search selection dropdown" name="member"
                              from="${filterConsortiaMembers}"
                              optionKey="id"
                              optionValue="${{ it.sortname + ' (' + it.name + ')'}}"
                              value="${params.member}"
                              noSelection="${['' : message(code:'default.select.choose.label')]}"/>
            </div>

            <div class="field fieldcontain">
                <label for="identifier">${message(code: 'default.search.identifier')}</label>
                <div class="ui input">
                    <input type="text" id="identifier" name="identifier"
                           placeholder="${message(code: 'default.search.identifier.ph')}"
                           value="${params.identifier}"/>
                </div>
            </div>

            <div class="field fieldcontain">
                <semui:datepicker label="default.valid_on.label" id="validOn" name="validOn" placeholder="filter.placeholder" value="${validOn}" />
            </div>

            <div class="field fieldcontain">
                <label>${message(code: 'default.status.label')}</label>
                <%
                    def fakeList = []
                    fakeList.addAll(RefdataCategory.getAllRefdataValues(RDConstants.SUBSCRIPTION_STATUS))
                    fakeList.add(RefdataValue.getByValueAndCategory('subscription.status.no.status.set.but.null', 'filter.fake.values'))
                %>
                <laser:select class="ui dropdown" name="status"
                              from="${ fakeList }"
                              optionKey="id"
                              optionValue="value"
                              value="${params.status}"
                              noSelection="${['' : message(code:'default.select.choose.label')]}"/>
            </div>
        </div>

        <div class="four fields">
            <g:render template="../templates/properties/genericFilter" model="[propList: filterPropList]"/>

            <div class="field">
                <label>${message(code:'subscription.form.label')}</label>
                <laser:select class="ui dropdown" name="form"
                              from="${RefdataCategory.getAllRefdataValues(RDConstants.SUBSCRIPTION_FORM)}"
                              optionKey="id"
                              optionValue="value"
                              value="${params.form}"
                              noSelection="${['' : message(code:'default.select.choose.label')]}"/>
            </div>

            <div class="field">
                <label>${message(code:'subscription.resource.label')}</label>
                <laser:select class="ui dropdown" name="resource"
                              from="${RefdataCategory.getAllRefdataValues(RDConstants.SUBSCRIPTION_RESOURCE)}"
                              optionKey="id"
                              optionValue="value"
                              value="${params.resource}"
                              noSelection="${['' : message(code:'default.select.choose.label')]}"/>
            </div>
        </div>

        <div class="three fields">
            <g:if test="${institution.globalUID == com.k_int.kbplus.Org.findByName('LAS:eR Backoffice').globalUID}">
                <div class="field">
                    <fieldset id="subscritionType">
                        <legend >${message(code: 'myinst.currentSubscriptions.subscription_type')}</legend>
                        <div class="inline fields la-filter-inline">
                            <%
                                List subTypes = RefdataCategory.getAllRefdataValues(RDConstants.SUBSCRIPTION_TYPE)
                                subTypes -= RDStore.SUBSCRIPTION_TYPE_LOCAL
                            %>
                            <g:each in="${subTypes}" var="subType">
                                <div class="inline field">
                                    <div class="ui checkbox">
                                        <label for="checkSubType-${subType.id}">${subType.getI10n('value')}</label>
                                        <input id="checkSubType-${subType.id}" name="subTypes" type="checkbox" value="${subType.id}"
                                            <g:if test="${params.list('subTypes').contains(subType.id.toString())}"> checked="" </g:if>
                                               tabindex="0">
                                    </div>
                                </div>
                            </g:each>
                        </div>
                    </fieldset>
                </div>
            </g:if>
            <div class="field">
                <legend >${message(code: 'myinst.currentSubscriptions.subscription_kind')}</legend>
                <select id="subKinds" name="subKinds" multiple="" class="ui search selection fluid dropdown">
                    <option value="">${message(code: 'default.select.choose.label')}</option>

                    <g:each in="${RefdataCategory.getAllRefdataValues(RDConstants.SUBSCRIPTION_KIND).sort{it.getI10n('value')}}" var="subKind">
                        <option <%=(params.list('subKinds').contains(subKind.id.toString())) ? 'selected="selected"' : ''%>
                        value="${subKind.id}" ">
                        ${subKind.getI10n('value')}
                        </option>
                    </g:each>
                </select>

            </div>

            <div class="field">
                <label>${message(code:'subscription.isPublicForApi.label')}</label>
                <laser:select class="ui fluid dropdown" name="isPublicForApi"
                              from="${RefdataCategory.getAllRefdataValues(RDConstants.Y_N)}"
                              optionKey="id"
                              optionValue="value"
                              value="${params.isPublicForApi}"
                              noSelection="${['' : message(code:'default.select.choose.label')]}"/>
            </div>
            <div class="field">
                <label>${message(code:'subscription.hasPerpetualAccess.label')}</label>
                <laser:select class="ui fluid dropdown" name="hasPerpetualAccess"
                              from="${RefdataCategory.getAllRefdataValues(RDConstants.Y_N)}"
                              optionKey="id"
                              optionValue="value"
                              value="${params.hasPerpetualAccess}"
                              noSelection="${['' : message(code:'default.select.choose.label')]}"/>
            </div>


        </div>

        <div class="two fields">

            <div class="field">
                <label>${message(code: 'myinst.currentSubscriptions.subscription.runTime')}</label>
                <div class="inline fields la-filter-inline">
                    <div class="inline field">
                        <div class="ui checkbox">
                            <label for="checkSubRunTimeMultiYear">${message(code: 'myinst.currentSubscriptions.subscription.runTime.multiYear')}</label>
                            <input id="checkSubRunTimeMultiYear" name="subRunTimeMultiYear" type="checkbox" <g:if test="${params.subRunTimeMultiYear}">checked=""</g:if>
                                   tabindex="0">
                        </div>
                    </div>
                    <div class="inline field">
                        <div class="ui checkbox">
                            <label for="checkSubRunTimeNoMultiYear">${message(code: 'myinst.currentSubscriptions.subscription.runTime.NoMultiYear')}</label>
                            <input id="checkSubRunTimeNoMultiYear" name="subRunTime" type="checkbox" <g:if test="${params.subRunTime}">checked=""</g:if>
                                   tabindex="0">
                        </div>
                    </div>
                </div>
            </div>

            <div class="field la-field-right-aligned">
                <a href="${request.forwardURI}" class="ui reset primary button">${message(code:'default.button.reset.label')}</a>
                <input type="submit" class="ui secondary button" value="${message(code:'default.button.filter.label')}">
            </div>

        </div>
    </g:form>
</semui:filter>
<g:if test="${params.member}">
    <g:set var="chosenOrg" value="${com.k_int.kbplus.Org.findById(params.member)}" />
    <g:set var="chosenOrgCPAs" value="${chosenOrg?.getGeneralContactPersons(false)}" />

    <table class="ui table la-table la-table-small">
        <tbody>
            <tr>
                <td>
                    <p>
                        <strong>
                            ${chosenOrg?.name}
                            <g:if test="${chosenOrg?.shortname}">(${chosenOrg?.shortname})</g:if>
                            <g:if test="${chosenOrg.getCustomerType() in ['ORG_INST', 'ORG_INST_COLLECTIVE']}">
                                <span class="la-long-tooltip la-popup-tooltip la-delay" data-position="bottom center"
                                      data-content="${chosenOrg.getCustomerTypeI10n()}">
                                    <i class="chess rook grey icon"></i>
                                </span>
                            </g:if>
                        </strong>
                    </p>
                    ${chosenOrg?.libraryType?.getI10n('value')}
                </td>
                <td>
                    <g:if test="${chosenOrgCPAs}">
                        <g:each in="${chosenOrgCPAs}" var="gcp">
                            <g:render template="/templates/cpa/person_details" model="${[person: gcp, tmplHideLinkToAddressbook: true, overwriteEditable: false]}" />
                        </g:each>
                    </g:if>
                </td>
            </tr>
        </tbody>
    </table>
</g:if>
<g:if test="${costItems}">
<table class="ui celled sortable table table-tworow la-table la-ignore-fixed">
    <thead>
        <tr>
            <th rowspan="2" class="center aligned">${message(code:'sidewide.number')}</th>
            <g:sortableColumn property="roleT.org.sortname" params="${params}" title="${message(code:'myinst.consortiaSubscriptions.member')}" rowspan="2" />
            <g:sortableColumn property="subT.name" params="${params}" title="${message(code:'myinst.consortiaSubscriptions.subscription')}" class="la-smaller-table-head" />
            <th rowspan="2">${message(code:'myinst.consortiaSubscriptions.packages')}</th>
            <th rowspan="2">${message(code:'myinst.consortiaSubscriptions.provider')}</th>
            <th rowspan="2">${message(code:'myinst.consortiaSubscriptions.runningTimes')}</th>
            <th rowspan="2">${message(code:'financials.amountFinal')}</th>
            <th class="la-no-uppercase" rowspan="2">
                <span  class="la-popup-tooltip la-delay" data-content="${message(code:'financials.costItemConfiguration')}" data-position="left center">
                    <i class="money bill alternate icon"></i>
                </span>&nbsp;/&nbsp;
                <span data-position="top right"  class="la-popup-tooltip la-delay" data-content="${message(code:'financials.isVisibleForSubscriber')}" style="margin-left:10px">
                    <i class="ui icon eye orange"></i>
                </span>
            </th>
            <th class="la-no-uppercase" rowspan="2" >
                <span class="la-long-tooltip la-popup-tooltip la-delay" data-position="bottom center"
                      data-content="${message(code: 'subscription.isMultiYear.consortial.label')}">
                    <i class="map orange icon"></i>
                </span>
            </th>
        </tr>
        <tr>
            <g:sortableColumn property="subK.owner.reference" params="${params}" title="${message(code:'license.label')}" class="la-smaller-table-head" />
        </tr>
    </thead>
    <tbody>
        <g:each in="${costItems}" var="entry" status="jj">
            <%
                com.k_int.kbplus.CostItem ci = entry[0] ?: new CostItem()
                com.k_int.kbplus.Subscription subCons = entry[1]
                com.k_int.kbplus.Org subscr = entry[2]
            %>
            <tr>
                <td>
                    ${ jj + 1 }
                </td>
                <td>
                    <g:link controller="organisation" action="show" id="${subscr.id}">
                        <g:if test="${subscr.sortname}">${subscr.sortname}</g:if>
                        (${subscr.name})
                    </g:link>
                    <g:if test="${OrgRole.findBySubAndOrgAndRoleType(subCons, subscr, RDStore.OR_SUBSCRIBER_CONS_HIDDEN)}">
                        <span data-position="top left" class="la-popup-tooltip la-delay" data-content="${message(code:'financials.isNotVisibleForSubscriber')}">
                            <i class="low vision grey icon"></i>
                        </span>
                    </g:if>
                    <g:if test="${subscr.getCustomerType() in ['ORG_INST', 'ORG_INST_COLLECTIVE']}">
                        <span class="la-long-tooltip la-popup-tooltip la-delay" data-position="bottom center"
                              data-content="${subscr.getCustomerTypeI10n()}">
                            <i class="chess rook grey icon"></i>
                        </span>
                    </g:if>

                </td>
                <td>

                    <div class="la-flexbox la-main-object">

                        <i class="icon clipboard outline outline la-list-icon"></i>
                        <g:link controller="subscription" action="show" id="${subCons.id}">${subCons.name}</g:link>
                        <g:if test="${subCons.getCalculatedPrevious()}">
                            <span data-position="top left" class="la-popup-tooltip la-delay" data-content="${message(code:'subscription.hasPreviousSubscription')}">
                                <i class="arrow left grey icon"></i>
                            </span>
                        </g:if>
                    </div>
                    <g:if test="${subCons.owner}">
                        <div class="la-flexbox">
                            <i class="icon balance scale la-list-icon"></i>
                            <g:link controller="license" action="show" id="${subCons.owner.id}">${subCons.owner.reference}</g:link>
                        </div>
                    </g:if>
                </td>
                <td>
                    <g:each in="${subCons.packages}" var="subPkg">
                        <div class="la-flexbox">
                            <i class="icon gift la-list-icon"></i>
                            <g:link controller="package" action="show" id="${subPkg.pkg.id}">${subPkg.pkg.name}</g:link>
                        </div>
                    </g:each>
                </td>
                <td>
                    <g:each in="${subCons.providers}" var="p">
                        <g:link controller="organisation" action="show" id="${p.id}">${p.getDesignation()}</g:link> <br/>
                    </g:each>
                </td>
                <td>
                    <g:if test="${ci.id}"> <%-- only existing cost item --%>
                        <g:if test="${ci.getDerivedStartDate()}">
                            <g:formatDate date="${ci.getDerivedStartDate()}" format="${message(code:'default.date.format.notime')}"/>
                            <br />
                        </g:if>
                        <g:if test="${ci.getDerivedEndDate()}">
                            <g:formatDate date="${ci.getDerivedEndDate()}" format="${message(code:'default.date.format.notime')}"/>
                        </g:if>
                    </g:if>
                </td>
                <td>
                    <g:if test="${ci.id}"> <%-- only existing cost item --%>
                        <g:formatNumber number="${ci.costInBillingCurrencyAfterTax ?: 0.0}"
                                    type="currency"
                                    currencySymbol="${ci.billingCurrency ?: 'EUR'}" />
                    </g:if>
                </td>

                <%  // TODO .. copied from finance/_result_tab_cons.gsp

                    def elementSign = 'notSet'
                    def icon = ''
                    def dataTooltip = ""
                    if (ci.costItemElementConfiguration) {
                        elementSign = ci.costItemElementConfiguration
                    }

                    switch(elementSign) {
                        case RDStore.CIEC_POSITIVE:
                            dataTooltip = message(code:'financials.costItemConfiguration.positive')
                            icon = '<i class="plus green circle icon"></i>'
                            break
                        case RDStore.CIEC_NEGATIVE:
                            dataTooltip = message(code:'financials.costItemConfiguration.negative')
                            icon = '<i class="minus red circle icon"></i>'
                            break
                        case RDStore.CIEC_NEUTRAL:
                            dataTooltip = message(code:'financials.costItemConfiguration.neutral')
                            icon = '<i class="circle yellow icon"></i>'
                            break
                        default:
                            dataTooltip = message(code:'financials.costItemConfiguration.notSet')
                            icon = '<i class="question circle icon"></i>'
                            break
                    }
                %>

                <td>
                    <g:if test="${ci.id}">
                        <span data-position="top left"  class="la-popup-tooltip la-delay" data-content="${dataTooltip}">${raw(icon)}</span>
                    </g:if>

                    <g:if test="${ci.isVisibleForSubscriber}">
                        <span data-position="top right"  class="la-popup-tooltip la-delay" data-content="${message(code:'financials.isVisibleForSubscriber')}" style="margin-left:10px">
                            <i class="ui icon eye orange"></i>
                        </span>
                    </g:if>
                </td>
                <td>
                    <g:if test="${subCons.isMultiYear}">
                        <span class="la-long-tooltip la-popup-tooltip la-delay" data-position="bottom center"
                              data-content="${message(code: 'subscription.isMultiYear.consortial.label')}">
                            <i class="map orange icon"></i>
                        </span>
                    </g:if>
                </td>
            </tr>
        </g:each>
    </tbody>

    <tfoot>
        <tr>
            <th colspan="8">
                ${message(code:'financials.totalCostOnPage')}
            </th>
        </tr>
        <g:each in="${finances}" var="entry">
            <tr>
                <td colspan="6">
                    ${message(code:'financials.sum.billing')} ${entry.key}<br>
                </td>
                <td class="la-exposed-bg">
                    <g:formatNumber number="${entry.value}" type="currency" currencySymbol="${entry.key}"/>
                </td>
                <td colspan="1">

                </td>
            </tr>
        </g:each>

    </tfoot>
</table>
</g:if>
<g:else>
    <g:if test="${filterSet}">
        <br><strong><g:message code="filter.result.empty"/></strong>
    </g:if>
    <g:else>
        <br><strong><g:message code="result.empty"/></strong>
    </g:else>
</g:else>

<semui:paginate action="manageConsortiaSubscriptions" controller="myInstitution" params="${params}"
                next="${message(code:'default.paginate.next')}"
                prev="${message(code:'default.paginate.prev')}"
                max="${max}" total="${countCostItems}" />

<g:render template="../templates/copyEmailaddresses" model="[orgList: totalMembers]"/>

</body>
</html>
