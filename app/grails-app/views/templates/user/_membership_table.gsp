<%@ page import="com.k_int.kbplus.auth.UserOrg" %>

<div class="column wide sixteen">
    <h4 class="ui dividing header">${message(code: 'profile.membership.existing')}</h4>
    <table class="ui celled la-table table">
        <thead>
        <tr>
            <th>${message(code: 'profile.membership.org', default:'Organisation')}</th>
            <th>${message(code: 'profile.membership.role', default:'Role')}</th>
            <th>${message(code: 'profile.membership.status', default:'Status')}</th>
            <th>${message(code: 'profile.membership.date', default:'Date Requested / Actioned')}</th>
            <th>${message(code: 'default.actions', default:'Actions')}</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${userInstance.affiliations}" var="aff">
            <tr>
                <td><g:link controller="organisations" action="show" id="${aff.org.id}">${aff.org.name}</g:link></td>
                <td><g:message code="cv.roles.${aff.formalRole?.authority}"/></td>
                <td><g:message code="cv.membership.status.${aff.status}"/></td>
                <td><g:formatDate format="${message(code:'default.date.format.notime', default:'yyyy-MM-dd')}" date="${aff.dateRequested}"/> / <g:formatDate format="${message(code:'default.date.format.notime', default:'yyyy-MM-dd')}" date="${aff.dateActioned}"/></td>
                <td class="x">
                    <g:if test="${tmplProfile}">
                        <g:if test="${aff.status != UserOrg.STATUS_CANCELLED}">
                            <g:link class="ui button" controller="profile" action="processCancelRequest" params="${[assoc:aff.id]}">${message(code:'default.button.revoke.label', default:'Revoke')}</g:link>
                        </g:if>
                    </g:if>
                    <g:if test="${tmplAdmin}">
                        <g:link controller="ajax" action="deleteThrough" params='${[contextOid:"${userInstance.class.name}:${userInstance.id}",contextProperty:"affiliations",targetOid:"${aff.class.name}:${aff.id}"]}'
                                class="ui icon negative button">
                            <i class="trash alternate icon"></i>
                        </g:link>
                    </g:if>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div><!--.column-->