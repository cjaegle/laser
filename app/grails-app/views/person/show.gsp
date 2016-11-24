
<%@ page import="com.k_int.kbplus.Person" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="mmbootstrap">
		<g:set var="entityName" value="${message(code: 'person.label', default: 'Person')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<div class="row-fluid">
			
			<div class="span3">
				<div class="well">
					<ul class="nav nav-list">
						<li class="nav-header">${entityName}</li>
						<li>
							<g:link class="list" action="list">
								<i class="icon-list"></i>
								<g:message code="default.list.label" args="[entityName]" />
							</g:link>
						</li>
						<li>
							<g:link class="create" action="create">
								<i class="icon-plus"></i>
								<g:message code="default.create.label" args="[entityName]" />
							</g:link>
						</li>
					</ul>
				</div>
			</div>
			
			<div class="span9">

				<div class="page-header">
					<h1><g:message code="default.show.label" args="[entityName]" /></h1>
				</div>

				<g:if test="${flash.message}">
				<bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
				</g:if>

				<dl>
				
					<g:if test="${personInstance?.first_name}">
						<dt><g:message code="person.first_name.label" default="Firstname" /></dt>
						
							<dd><g:fieldValue bean="${personInstance}" field="first_name"/></dd>
						
					</g:if>
				
					<g:if test="${personInstance?.middle_name}">
						<dt><g:message code="person.middle_name.label" default="Middlename" /></dt>
						
							<dd><g:fieldValue bean="${personInstance}" field="middle_name"/></dd>
						
					</g:if>
				
					<g:if test="${personInstance?.last_name}">
						<dt><g:message code="person.last_name.label" default="Lastname" /></dt>
						
							<dd><g:fieldValue bean="${personInstance}" field="last_name"/></dd>
						
					</g:if>
				
					<g:if test="${personInstance?.gender}">
						<dt><g:message code="person.gender.label" default="Gender" /></dt>
						
							<dd><g:fieldValue bean="${personInstance}" field="gender"/></dd>
						
					</g:if>
				
					<g:if test="${personInstance?.org}">
						<dt><g:message code="person.org.label" default="Org" /></dt>
						
							<dd><g:link controller="org" action="show" id="${personInstance?.org?.id}">${personInstance?.org?.encodeAsHTML()}</g:link></dd>
						
					</g:if>
				
				</dl>

				<g:form>
					<g:hiddenField name="id" value="${personInstance?.id}" />
					<div class="form-actions">
						<g:link class="btn" action="edit" id="${personInstance?.id}">
							<i class="icon-pencil"></i>
							<g:message code="default.button.edit.label" default="Edit" />
						</g:link>
						<button class="btn btn-danger" type="submit" name="_action_delete">
							<i class="icon-trash icon-white"></i>
							<g:message code="default.button.delete.label" default="Delete" />
						</button>
					</div>
				</g:form>

			</div>

		</div>
	</body>
</html>
