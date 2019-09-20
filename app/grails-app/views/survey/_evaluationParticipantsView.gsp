
<g:set var="participants" value="${params.tab == 'participantsViewAllFinish' ? participantsFinish : (params.tab == 'participantsViewAllNotFinish' ? participantsNotFinish : participants ) }"/>

<h2 class="ui left aligned icon header"><g:message code="surveyEvaluation.participants"/><semui:totalNumber
        total="${participants?.size()}"/></h2>
<br>

<semui:form>

    <h4><g:message code="surveyParticipants.hasAccess"/></h4>

    <g:set var="surveyParticipantsHasAccess"
           value="${participants?.findAll { it?.hasAccessOrg() }?.sort {
               it?.sortname
           }}"/>

    <div class="four wide column">
        <g:link data-orgIdList="${(surveyParticipantsHasAccess?.id).join(',')}"
                data-targetId="copyEmailaddresses_ajaxModal2"
                class="ui icon button right floated trigger-modal">
            <g:message code="survey.copyEmailaddresses.participantsHasAccess"/>
        </g:link>
    </div>

    <br>
    <br>

    <table class="ui celled sortable table la-table">
        <thead>
        <tr>
            <th class="center aligned">
                ${message(code: 'sidewide.number')}
            </th>
            <th>
                ${message(code: 'org.sortname.label')}
            </th>
            <th>
                ${message(code: 'org.name.label')}
            </th>
            <th>
                ${message(code: 'surveyInfo.finished')}
            </th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${surveyParticipantsHasAccess}" var="participant" status="i">
            <tr>
                <td>
                    ${i + 1}
                </td>
                <td>
                    <g:link controller="myInstitution" action="manageParticipantSurveys" id="${participant?.id}">
                        ${participant?.sortname}
                    </g:link>
                </td>
                <td>
                    <g:link controller="organisation" action="show" id="${participant.id}">
                        ${fieldValue(bean: participant, field: "name")}
                    </g:link>
                </td>
               %{-- <td class="center aligned">
                    <g:set var="finish" value="${surveyInfo?.checkSurveyInfoFinishByOrg(participant)}"/>
                    <g:if test="${finish == com.k_int.kbplus.SurveyConfig.ALL_RESULTS_FINISH_BY_ORG}">
                        <span class="la-long-tooltip la-popup-tooltip la-delay" data-position="right center"
                              data-content="${message(code: 'surveyConfig.allResultsFinishByOrg')}">
                            <i class="circle green icon"></i>
                        </span>
                    </g:if>
                    <g:elseif test="${finish == com.k_int.kbplus.SurveyConfig.ALL_RESULTS_HALF_FINISH_BY_ORG}">
                        <span class="la-long-tooltip la-popup-tooltip la-delay" data-position="right center"
                              data-content="${message(code: 'surveyConfig.allResultsHalfFinishByOrg')}">
                            <i class="circle yellow icon"></i>
                        </span>
                    </g:elseif>
                    <g:else>
                        <span class="la-long-tooltip la-popup-tooltip la-delay" data-position="right center"
                              data-content="${message(code: 'surveyConfig.allResultsNotFinishByOrg')}">
                            <i class="circle red icon"></i>
                        </span>
                    </g:else>
                </td>--}%
                <td>

                    <g:link controller="survey" action="evaluationParticipantInfo" id="${surveyInfo.id}"
                            params="[participant: participant?.id]" class="ui icon button"><i
                            class="chart pie icon"></i></g:link>

                </td>

            </tr>

        </g:each>
        </tbody>
    </table>

    <h4><g:message code="surveyParticipants.hasNotAccess"/></h4>

    <g:set var="surveyParticipantsHasNotAccess" value="${participants.findAll { !it?.hasAccessOrg() }.sort { it?.sortname }}"/>

    <div class="four wide column">
        <g:link data-orgIdList="${(surveyParticipantsHasNotAccess?.id).join(',')}"
                data-targetId="copyEmailaddresses_ajaxModal3"
                class="ui icon button right floated trigger-modal">
            <g:message code="survey.copyEmailaddresses.participantsHasNoAccess"/>
        </g:link>
    </div>

    <br>
    <br>

    <table class="ui celled sortable table la-table">
        <thead>
        <tr>
            <th class="center aligned">
                ${message(code: 'sidewide.number')}
            </th>
            <th>
                ${message(code: 'org.sortname.label')}
            </th>
            <th>
                ${message(code: 'org.name.label')}
            </th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${surveyParticipantsHasNotAccess}" var="participant" status="i">
            <tr>
                <td>
                    ${i + 1}
                </td>
                <td>
                    <g:link controller="myInstitution" action="manageParticipantSurveys" id="${participant?.id}">
                        ${participant?.sortname}
                    </g:link>
                </td>
                <td>
                    <g:link controller="organisation" action="show" id="${participant.id}">
                        ${fieldValue(bean: participant, field: "name")}
                    </g:link>
                </td>
                <td>

                    <g:link controller="survey" action="evaluationParticipantInfo" id="${surveyInfo.id}"
                            params="[participant: participant?.id]" class="ui icon button"><i
                            class="chart pie icon"></i></g:link>

                </td>
            </tr>

        </g:each>
        </tbody>
    </table>

</semui:form>