
<%@ page import="com.k_int.kbplus.Package" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="semanticUI">
		<g:set var="entityName" value="${message(code: 'package.label', default: 'Package')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<div>


					<h1 class="ui header"><semui:headerIcon /><g:message code="default.list.label" args="[entityName]" /></h1>


			<semui:messages data="${flash}" />
				
				<table class="ui sortable celled la-table table">
					<thead>
						<tr>
						
							<g:sortableColumn property="identifier" title="${message(code: 'package.identifier.label', default: 'Identifier')}" />
						
							<g:sortableColumn property="name" title="${message(code: 'package.name.label', default: 'Name')}" />
						
							<th></th>
						</tr>
					</thead>
					<tbody>
					<g:each in="${packageInstanceList}" var="packageInstance">
						<tr>
						
							<td>${fieldValue(bean: packageInstance, field: "identifier")}</td>
						
							<td>${fieldValue(bean: packageInstance, field: "name")} (${packageInstance?.contentProvider?.name})</td>
						
							<td class="link">
								<g:link action="show" id="${packageInstance.id}" class="ui tiny button">${message('code':'default.button.show.label')}</g:link>
							</td>
						</tr>
					</g:each>
					</tbody>
				</table>

				<semui:paginate total="${packageInstanceTotal}" />


		</div>
	</body>
</html>
