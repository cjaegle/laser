<%@ page import="com.k_int.kbplus.Task" %>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'license', 'error')} ">
	<label for="license">
		<g:message code="task.license.label" default="License" />
	</label>
	<g:select id="license" name="license.id" from="${validLicenses}" optionKey="id" value="${taskInstance?.license?.id}" class="many-to-one" noSelection="['null': '']"/>

</div>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'org', 'error')} ">
	<label for="org">
		<g:message code="task.org.label" default="Org" />
	</label>
	<g:select id="org" name="org.id" from="${validOrgs}" optionKey="id" value="${taskInstance?.org?.id}" class="many-to-one" noSelection="['null': '']"/>
</div>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'pkg', 'error')} ">
	<label for="pkg">
		<g:message code="task.pkg.label" default="Pkg" />
	</label>
	<g:select id="pkg" name="pkg.id" from="${validPackages}" optionKey="id" value="${taskInstance?.pkg?.id}" class="many-to-one" noSelection="['null': '']"/>
</div>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'subscription', 'error')} ">
	<label for="subscription">
		<g:message code="task.subscription.label" default="Subscription" />
	</label>
	<g:select id="subscription" name="subscription.id" from="${validSubscriptions}" optionKey="id" value="${taskInstance?.subscription?.id}" class="many-to-one" noSelection="['null': '']"/>
</div>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'title', 'error')} required">
	<label for="title">
		<g:message code="task.title.label" default="Title" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="title" required="" value="${taskInstance?.title}"/>
</div>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'description', 'error')} required">
	<label for="description">
		<g:message code="task.description.label" default="Description" />
	</label>
	<g:textField name="description" value="${taskInstance?.description}"/>
</div>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'status', 'error')} required">
	<label for="status">
		<g:message code="task.status.label" default="Status" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="status" name="status.id" from="${com.k_int.kbplus.RefdataCategory.getAllRefdataValues('Task Status')}" optionKey="id" required="" value="${taskInstance?.status?.id}" class="many-to-one"/>
</div>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'creator', 'error')} required">
	<label for="creator">
		<g:message code="task.creator.label" default="Creator" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="creator" name="creator.id" from="${taskCreator}" optionKey="id" optionValue="display" required="" value="${taskInstance?.creator?.id}" class="many-to-one"/>

</div>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'createDate', 'error')} required">
    <label for="createDate">
        <g:message code="task.createDate.label" default="Create Date" />
        <span class="required-indicator">*</span>
    </label>
    <semui:datepicker label="task.createDate.label" inputName="createDate" inputPlaceholder="default.date.label" inputValue="${taskInstance?.createDate}" />
</div>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'endDate', 'error')} required">
	<label for="endDate">
		<g:message code="task.endDate.label" default="End Date" />
		<span class="required-indicator">*</span>
	</label>
    <semui:datepicker label="task.endDate.label" inputName="endDate" inputPlaceholder="default.date.label" inputValue="${taskInstance?.endDate}" />
</div>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'responsibleUser', 'error')} required">
	<label for="responsibleUser">
		<g:message code="task.responsibleUser.label" default="Tenant User" />
	</label>
	<g:select id="responsibleUser" name="responsibleUser.id" from="${validResponsibleUsers}" optionKey="id" optionValue="display" value="${taskInstance?.responsibleUser?.id}" class="many-to-one" noSelection="['null': '']" />
</div>

<div class="field fieldcontain ${hasErrors(bean: taskInstance, field: 'responsibleOrg', 'error')} required">
	<label for="responsibleOrg">
		<g:message code="task.responsibleOrg.label" default="Tenant Org" />
	</label>
	<g:select id="responsibleOrg" name="responsibleOrg.id" from="${validResponsibleOrgs}" optionKey="id" value="${taskInstance?.responsibleOrg?.id}" class="many-to-one" noSelection="['null': '']" />
</div>
