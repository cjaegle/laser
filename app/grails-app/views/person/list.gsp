
<%@ page import="com.k_int.kbplus.Person" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="semanticUI">
		<g:set var="entityName" value="${message(code: 'person.label', default: 'Person')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<div>
				

					<h1 class="ui header"><g:message code="default.list.label" args="[entityName]" /></h1>


			<semui:messages data="${flash}" />
				
				<table class="ui sortable table">
					<thead>
						<tr>
						
							<g:sortableColumn property="first_name" title="${message(code: 'person.first_name.label', default: 'Firstname')}" />
						
							<g:sortableColumn property="middle_name" title="${message(code: 'person.middle_name.label', default: 'Middlename')}" />
						
							<g:sortableColumn property="last_name" title="${message(code: 'person.last_name.label', default: 'Lastname')}" />
											
							<th class="header"><g:message code="person.gender.label" default="Gender" /></th>
						
							<th class="header"><g:message code="person.isPublic.label" default="IsPublic" /></th>
						
							<th></th>
						</tr>
					</thead>
					<tbody>
					<g:each in="${personInstanceList}" var="personInstance">
						<tr>
						
							<td>${fieldValue(bean: personInstance, field: "first_name")}</td>
						
							<td>${fieldValue(bean: personInstance, field: "middle_name")}</td>
						
							<td>${fieldValue(bean: personInstance, field: "last_name")}</td>
						
							<td>${fieldValue(bean: personInstance, field: "gender")}</td>
							
							<td>${fieldValue(bean: personInstance, field: "isPublic")}</td>
						
							<td class="link">
								<g:link action="show" id="${personInstance.id}" class="ui tiny button">${message('code':'default.button.show.label')}</g:link>
								<g:link action="edit" id="${personInstance.id}" class="ui tiny button">${message('code':'default.button.edit.label')}</g:link>
							</td>
						</tr>
					</g:each>
					</tbody>
				</table>

					<semui:paginate total="${personInstanceTotal}" />


		</div>
	</body>
</html>
