<%@ page import="com.k_int.kbplus.SurveyInfo; de.laser.helper.RDStore; com.k_int.kbplus.OrgRole;com.k_int.kbplus.RefdataCategory;com.k_int.kbplus.RefdataValue;com.k_int.properties.PropertyDefinition;com.k_int.kbplus.Subscription;com.k_int.kbplus.CostItem;com.k_int.kbplus.Org;com.k_int.kbplus.SurveyResult" %>
<laser:serviceInjection/>

<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI">
    <title>${message(code: 'laser')} : ${message(code: 'manageParticipantSurveys.header')}</title>
</head>

<body>

<semui:breadcrumbs>
    <semui:crumb message="manageParticipantSurveys.header" class="active"/>
</semui:breadcrumbs>
<semui:controlButtons>
    <semui:exportDropdown>
        <semui:exportDropdownItem>
            <g:link class="item" controller="myInstitution" action="manageParticipantSurveys"
                    params="${params + [exportXLSX: true]}">${message(code: 'survey.exportSurveys')}</g:link>
        </semui:exportDropdownItem>
    </semui:exportDropdown>
</semui:controlButtons>

<br>
<h1 class="ui left floated aligned icon header la-clear-before">
    <semui:headerIcon/>${message(code: 'manageParticipantSurveys.header')}
    <semui:totalNumber total="${countSurveys.values().sum { it }}"/>
</h1>

<semui:messages data="${flash}"/>

<g:render template="../templates/filter/javascript" />
<semui:filter showFilterButton="true">
    <g:form action="manageParticipantSurveys" controller="myInstitution" method="post" id="${params.id}"
            params="[tab: params.tab]" class="ui small form">

        <div class="two fields">
            <div class="field">
                <label for="name">${message(code: 'surveyInfo.name.label')}
                </label>

                <div class="ui input">
                    <input type="text" id="name" name="name"
                           placeholder="${message(code: 'default.search.ph')}"
                           value="${params.name}"/>
                </div>
            </div>

            <div class="field fieldcontain">
                <semui:datepicker label="default.valid_on.label" id="validOn" name="validOn" placeholder="filter.placeholder" value="${params.validOn}" />
            </div>

        </div>

        <div class="two fields">

            <div class="field">
                <label>${message(code: 'surveyInfo.type.label')}</label>
                <laser:select class="ui dropdown" name="type"
                              from="${RefdataCategory.getAllRefdataValues(de.laser.helper.RDConstants.SURVEY_TYPE)}"
                              optionKey="id"
                              optionValue="value"
                              value="${params.type}"
                              noSelection="${['': message(code: 'default.select.choose.label')]}"/>
            </div>

            <div class="field">
                <label>${message(code: 'surveyInfo.options')}</label>

                <div class="inline fields la-filter-inline">
                    <div class="inline field">
                        <div class="ui checkbox">
                            <label for="checkMandatory">${message(code: 'surveyInfo.isMandatory.label')}</label>
                            <input id="checkMandatory" name="mandatory" type="checkbox"
                                   <g:if test="${params.mandatory}">checked=""</g:if>
                                   tabindex="0">
                        </div>
                    </div>

                    <div class="inline field">
                        <div class="ui checkbox">
                            <label for="checkNoMandatory">${message(code: 'surveyInfo.isNotMandatory.label')}</label>
                            <input id="checkNoMandatory" name="noMandatory" type="checkbox"
                                   <g:if test="${params.noMandatory}">checked=""</g:if>
                                   tabindex="0">
                        </div>
                    </div>

                    <div class="inline field">
                        <div class="ui checkbox">
                            <label for="checkSubSurveyUseForTransfer">${message(code: 'surveyConfig.subSurveyUseForTransfer.label')}</label>
                            <input id="checkSubSurveyUseForTransfer" name="checkSubSurveyUseForTransfer" type="checkbox"
                                   <g:if test="${params.checkSubSurveyUseForTransfer}">checked=""</g:if>
                                   tabindex="0">
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <div class="field la-field-right-aligned">

            <div class="field la-field-right-aligned">
                <a href="${request.forwardURI}"
                   class="ui reset primary button">${message(code: 'default.button.reset.label')}</a>
                <input type="submit" class="ui secondary button"
                       value="${message(code: 'default.button.filter.label')}">
            </div>

        </div>
    </g:form>
</semui:filter>

<g:if test="${participant}">
    <g:set var="choosenOrg" value="${Org.findById(participant.id)}"/>
    <g:set var="choosenOrgCPAs" value="${choosenOrg?.getGeneralContactPersons(false)}"/>

    <table class="ui table la-table la-table-small">
        <tbody>
        <tr>
            <td>
                <p><strong>${choosenOrg?.name} (${choosenOrg?.shortname})</strong></p>

                ${choosenOrg?.libraryType?.getI10n('value')}
            </td>
            <td>
                <g:if test="${choosenOrgCPAs}">
                    <g:set var="oldEditable" value="${editable}"/>
                    <g:set var="editable" value="${false}" scope="request"/>
                    <g:each in="${choosenOrgCPAs}" var="gcp">
                        <g:render template="/templates/cpa/person_details"
                                  model="${[person: gcp, tmplHideLinkToAddressbook: true]}"/>
                    </g:each>
                    <g:set var="editable" value="${oldEditable ?: false}" scope="request"/>
                </g:if>
            </td>
        </tr>
        </tbody>
    </table>
</g:if>


<div>

    <semui:form>

        <semui:tabs actionName="${actionName}">
            <semui:tabsItem controller="myInstitution" action="manageParticipantSurveys"
                            params="${[id: params.id, tab: 'new']}" text="neu" tab="new"
                            counts="${countSurveys?.new}"/>
            <semui:tabsItem controller="myInstitution" action="manageParticipantSurveys"
                            params="${[id: params.id, tab: 'processed']}" text="bearbeitet" tab="processed"
                            counts="${countSurveys?.processed}"/>
            <semui:tabsItem controller="myInstitution" action="manageParticipantSurveys"
                            params="${[id: params.id, tab: 'finish']}" text="abgeschlossen" tab="finish"
                            counts="${countSurveys?.finish}"/>
            <semui:tabsItem controller="myInstitution" action="manageParticipantSurveys" class="ui red"
                            countsClass="red"
                            params="${[id: params.id, tab: 'notFinish']}" text="vorsorgliche Kündigungen"
                            tab="notFinish"
                            counts="${countSurveys?.notFinish}"/>
        </semui:tabs>

        <table class="ui celled sortable table la-table">
            <thead>
            <tr>
                <th rowspan="2" class="center aligned">
                    ${message(code: 'sidewide.number')}
                </th>
                <g:sortableColumn params="${params}" property="surveyInfo.name"
                                  title="${message(code: 'surveyInfo.slash.name')}"/>
                <g:sortableColumn params="${params}" property="surveyInfo.type"
                                  title="${message(code: 'surveyInfo.type.label')}"/>
                <g:sortableColumn params="${params}" property="surveyInfo.endDate"
                                  title="${message(code: 'default.endDate.label')}"/>
                <th><g:message code="surveyInfo.finished"/></th>
                <g:if test="${params.tab == 'finish'}">
                    <th><g:message code="surveyInfo.finishedDate"/></th>
                </g:if>
                <th class="la-action-info">${message(code: 'default.actions.label')}</th>
            </tr>

            </thead>
            <g:each in="${surveyResults}" var="surveyResult" status="i">

                <g:set var="surveyConfig"
                       value="${com.k_int.kbplus.SurveyConfig.get(surveyResult.key)}"/>

                <g:set var="surveyInfo"
                       value="${surveyConfig.surveyInfo}"/>

                <tr>
                    <td class="center aligned">
                        ${(params.int('offset') ?: 0) + i + 1}
                    </td>
                    <td>
                        <div class="la-flexbox">
                            <g:if test="${surveyConfig?.subSurveyUseForTransfer}">
                                <span class="la-long-tooltip la-popup-tooltip la-delay" data-position="right center"
                                      data-content="${message(code: "surveyConfig.subSurveyUseForTransfer.label.info2")}">
                                    <i class="yellow icon envelope large "></i>
                                </span>
                            </g:if>
                            <i class="icon chart pie la-list-icon"></i>
                            <g:link controller="survey" action="show" id="${surveyInfo.id}" class="ui ">
                                ${surveyConfig?.getSurveyName()}
                            </g:link>
                        </div>
                    </td>
                    <td>
                        <div class="ui label survey-${surveyInfo.type.value}">
                            ${surveyInfo.type.getI10n('value')}
                        </div>

                        <g:if test="${surveyInfo.isMandatory}">
                            <span class="la-long-tooltip la-popup-tooltip la-delay" data-position="right center"
                                  data-content="${message(code: "surveyInfo.isMandatory.label.info2")}">
                                <i class="yellow icon exclamation triangle"></i>
                            </span>
                        </g:if>
                    </td>
                    <td>
                        <g:formatDate formatName="default.date.format.notime" date="${surveyInfo.endDate}"/>
                    </td>

                    <td class="center aligned">
                        <semui:surveyFinishIcon participant="${Org.get(params.id)}" surveyConfig="${surveyConfig}" surveyOwnerView="${true}"/>
                    </td>
                    <g:if test="${params.tab == 'finish'}">
                        <td class="center aligned">
                            <semui:surveyFinishDate participant="${Org.get(params.id)}" surveyConfig="${surveyConfig}"/>
                        </td>
                    </g:if>
                    <td>
                        <g:if test="${!surveyConfig.pickAndChoose}">
                            <span class="la-popup-tooltip la-delay"
                                  data-content="${message(code: 'surveyInfo.toSurveyInfos')}">
                                <g:link controller="survey" action="evaluationParticipant"
                                        params="[id: surveyInfo.id, surveyConfigID: surveyConfig.id, participant: participant.id]" class="ui icon button">
                                    <i class="write icon"></i>
                                </g:link>
                            </span>
                        </g:if>

                        <g:if test="${surveyConfig.pickAndChoose}">
                            <g:link controller="survey" action="surveyTitlesSubscriber"
                                    id="${surveyConfig?.id}" params="[participant: participant?.id]"
                                    class="ui icon button"><i
                                    class="write icon"></i>
                            </g:link>
                        </g:if>

                    </td>

                </tr>

            </g:each>
        </table>
    </semui:form>
</div>
</div>

%{--<g:if test="${countSurveys}">
    <semui:paginate action="${actionName}" controller="${controllerName}" params="${params}"
                    next="${message(code: 'default.paginate.next')}"
                    prev="${message(code: 'default.paginate.prev')}" max="${max}"
                    total="${countSurveys."${params.tab}"}"/>
</g:if>--}%

</body>
</html>
