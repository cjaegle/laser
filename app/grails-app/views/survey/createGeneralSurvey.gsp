<%@ page import="com.k_int.kbplus.RefdataValue; com.k_int.kbplus.RefdataCategory;" %>
<laser:serviceInjection/>

<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code: 'laser', default: 'LAS:eR')} : ${message(code: 'createGeneralSurvey.label')}</title>
</head>

<body>

<semui:breadcrumbs>
    <semui:crumb controller="myInstitution" action="dashboard" text="${institution?.getDesignation()}"/>
    <semui:crumb controller="survey" action="currentSurveysConsortia" message="currentSurveys.label"/>
    <semui:crumb message="createGeneralSurvey.label" class="active"/>
</semui:breadcrumbs>

<h1 class="ui left floated aligned icon header la-clear-before"><semui:headerTitleIcon type="Survey"/>${message(code: 'createGeneralSurvey.label')}</h1>

<semui:messages data="${flash}"/>

<semui:form>
    <g:form action="processCreateGeneralSurvey" controller="survey" method="post" class="ui form">

        <div class="field required ">
            <label>${message(code: 'surveyInfo.name.label', default: 'New Survey Name')}</label>
            <input type="text" name="name" placeholder="" value="${surveyInfo?.name}" required/>
        </div>

        <div class="two fields ">
            <semui:datepicker label="surveyInfo.startDate.label" id="startDate" name="startDate"
                              value="${surveyInfo?.startDate}" required="" />

            <semui:datepicker label="surveyInfo.endDate.label" id="endDate" name="endDate"
                              value="${surveyInfo?.endDate}" required="" />
        </div>


        <div class="field required ">
            <label>${message(code: 'surveyInfo.type.label')}</label>
            <g:if test="${surveyInfo?.type}">
                <b>${surveyInfo?.type?.getI10n('value')}</b>
            </g:if><g:else>
            %{--Erstmal erst nur Verlängerungsumfragen --}%
            <laser:select class="ui dropdown" name="type"
                          from="${com.k_int.kbplus.RefdataValue.getByValueAndCategory('renewal','Survey Type')}"
                          optionKey="id"
                          optionValue="value"
                          value="${surveyInfo?.type?.id}"
                          noSelection="${['': message(code: 'default.select.choose.label')]}" required=""/>
        </g:else>
        </div>

        <div class="field ">
            <label>${message(code: 'surveyInfo.comment.label', default: 'New Survey Name')}</label>

            <textarea name="comment"></textarea>
        </div>

        <br/>


        <input type="submit" class="ui button"
               value="${message(code: 'createGeneralSurvey.create', default: 'Create')}"/>

    </g:form>
</semui:form>

</body>
</html>
