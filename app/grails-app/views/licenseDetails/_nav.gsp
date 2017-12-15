<% def phService = grailsApplication.mainContext.getBean("permissionHelperService") %>
<g:set var="license" value="${com.k_int.kbplus.License.get(params.id)}"/>

<semui:subNav actionName="${actionName}">
    <semui:subNavItem controller="licenseDetails" action="index" params="${[id:params.id]}" message="license.nav.details" />
    <semui:subNavItem controller="licenseDetails" action="tasks" params="${[id:params.id]}" message="task.plural" />
    <semui:subNavItem controller="licenseDetails" action="documents" params="${[id:params.id]}" message="license.nav.docs" />
    <semui:subNavItem controller="licenseDetails" action="notes" params="${[id:params.id]}" message="license.nav.notes" />
    <semui:subNavItem controller="licenseDetails" action="todo_history" params="${[id:params.id]}" message="license.nav.todo_history" />
    <semui:subNavItem controller="licenseDetails" action="edit_history" params="${[id:params.id]}" message="license.nav.edit_history" />
    <semui:subNavItem controller="licenseDetails" action="permissionInfo" params="${[id:params.id]}" message="license.nav.permissionInfo" />

    <g:if test="${license.orgLinks?.find{it.roleType?.value == 'Licensing Consortium' && phService.hasUserWithRole(user, it.org, 'INST_ADM') && license.licenseType == 'Template'}}">
        <semui:subNavItem controller="licenseDetails" action="consortia" params="${[id:params.id]}" message="consortium.plural" />
    </g:if>
</semui:subNav>