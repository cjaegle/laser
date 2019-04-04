<%@ page import="com.k_int.kbplus.RefdataCategory;com.k_int.kbplus.SurveyProperty;" %>
<laser:serviceInjection/>

<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code: 'laser', default: 'LAS:eR')} : ${message(code: 'createSurvey.label')}</title>
</head>

<body>

<semui:breadcrumbs>
    <semui:crumb controller="myInstitution" action="dashboard" text="${institution?.getDesignation()}"/>
    <semui:crumb controller="survey" action="currentSurveys" message="currentSurveys.label"/>
    <semui:crumb message="createSurvey.label" class="active"/>
</semui:breadcrumbs>

<h1 class="ui left aligned icon header"><semui:headerIcon/>${institution?.name} - ${message(code: 'createSurvey.label')}</h1>


<g:render template="steps"/>
<br>

<semui:messages data="${flash}"/>

<br>

<div class="ui grid">
    <div class="sixteen wide column">

        <div class="la-inline-lists">
            <div class="ui card">
                <div class="content">

                    <div class="header">
                        <div class="ui grid">
                            <div class="twelve wide column">
                                ${message(code: 'showSurveyInfo.step.first.title')}
                            </div>
                        </div>
                    </div>
                    <dl>
                        <dt>${message(code: 'surveyInfo.status.label', default: 'Survey Status')}</dt>
                        <dd>${surveyInfo.status?.getI10n('value')}</dd>
                    </dl>
                    <dl>
                        <dt>${message(code: 'surveyInfo.name.label', default: 'New Survey Name')}</dt>
                        <dd>${surveyInfo.name}</dd>
                    </dl>
                    <dl>
                        <dt>${message(code: 'surveyInfo.startDate.label')}</dt>
                        <dd><g:formatDate formatName="default.date.format.notime"
                                          date="${surveyInfo.startDate ?: null}"/></dd>
                    </dl>
                    <dl>
                        <dt>${message(code: 'surveyInfo.endDate.label')}</dt>
                        <dd><g:formatDate formatName="default.date.format.notime"
                                          date="${surveyInfo.endDate ?: null}"/></dd>
                    </dl>

                    <dl>
                        <dt>${message(code: 'surveyInfo.type.label')}</dt>
                        <dd>${com.k_int.kbplus.RefdataValue.get(surveyInfo?.type?.id)?.getI10n('value')}</dd>
                    </dl>

                </div>
            </div>
        </div>
    </div>
</div>
<br>

<h2 class="ui left aligned icon header">${message(code: 'showSurveyConfig.list')} <semui:totalNumber
        total="${surveyConfigs.size()}"/></h2>

<br>

<div class="ui grid">
    <div class="four wide column">
        <div class="ui vertical fluid tabular menu">
            <g:each in="${surveyConfigs}" var="config" status="i">

                <g:link class="item ${params.surveyConfigID == config?.id.toString() ? 'active' : ''}"
                        controller="survey" action="showSurveyParticipants"
                        id="${config?.surveyInfo?.id}" params="[surveyConfigID: config?.id]">

                    <g:if test="${config?.type == 'Subscription'}">
                        ${config?.subscription?.name}
                        <br>${config?.subscription?.startDate ? '(' : ''}
                        <g:formatDate format="${message(code: 'default.date.format.notime')}"
                                      date="${config?.subscription?.startDate}"/>
                        ${config?.subscription?.endDate ? '-' : ''}
                        <g:formatDate format="${message(code: 'default.date.format.notime')}"
                                      date="${config?.subscription?.endDate}"/>
                        ${config?.subscription?.startDate ? ')' : ''}
                    </g:if>

                    <g:if test="${config?.type == 'SurveyProperty'}">
                        ${config?.surveyProperty?.getI10n('name')}
                    </g:if>

                    ${com.k_int.kbplus.SurveyConfig.getLocalizedValue(config?.type)}

                    <semui:totalNumber class="ui icon "
                            total="${0}"/>


                </g:link>
            </g:each>
        </div>
    </div>

    <div class="twelve wide stretched column">
        <div class="ui top attached tabular menu">
            <a class="item ${params.tab == 'selectedParticipants' ? 'active' : ''}"
               data-tab="selectedParticipants">${message(code: 'showSurveyParticipants.selectedParticipants')}</a>

            <a class="item ${params.tab == 'consortiaMembers' ? 'active' : ''}"
               data-tab="consortiaMembers">${message(code: 'showSurveyParticipants.consortiaMembers')}</a>
        </div>

        <div class="ui bottom attached tab segment ${params.tab == 'selectedParticipants' ? 'active' : ''}"
             data-tab="selectedParticipants">

            <div>
                <g:render template="selectedParticipants"/>
            </div>

        </div>


        <div class="ui bottom attached tab segment ${params.tab == 'consortiaMembers' ? 'active' : ''}"
             data-tab="consortiaMembers">
            <div>
                <g:render template="consortiaMembers"/>
            </div>
        </div>
    </div>
</div>

<r:script>
    $(document).ready(function () {
        $('.tabular.menu .item').tab()
    });
</r:script>

</body>
</html>