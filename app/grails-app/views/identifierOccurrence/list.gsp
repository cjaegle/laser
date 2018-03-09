
<%@ page import="com.k_int.kbplus.IdentifierOccurrence" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="semanticUI">
		<g:set var="entityName" value="${message(code: 'identifierOccurrence.label', default: 'IdentifierOccurrence')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<div>

					<h1 class="ui header"><semui:headerIcon /><g:message code="default.list.label" args="[entityName]" /></h1>

					<semui:messages data="${flash}" />
				
				<table class="ui celled la-table table">
					<thead>
						<tr>
						
							<th class="header"><g:message code="identifierOccurrence.org.label" default="Org" /></th>
						
							<th class="header"><g:message code="identifierOccurrence.ti.label" default="Ti" /></th>
						
							<th class="header"><g:message code="identifierOccurrence.tipp.label" default="Tipp" /></th>
						
							<th class="header"><g:message code="identifierOccurrence.identifier.label" default="Identifier" /></th>
						
							<th></th>
						</tr>
					</thead>
					<tbody>
					<g:each in="${identifierOccurrenceInstanceList}" var="identifierOccurrenceInstance">
						<tr>
						
							<td>${fieldValue(bean: identifierOccurrenceInstance, field: "org")}</td>
						
							<td>${fieldValue(bean: identifierOccurrenceInstance, field: "ti")}</td>
						
							<td>${fieldValue(bean: identifierOccurrenceInstance, field: "tipp")}</td>
						
							<td>${fieldValue(bean: identifierOccurrenceInstance, field: "identifier")}</td>
						
							<td class="link">
								<g:link action="show" id="${identifierOccurrenceInstance.id}" class="ui tiny button">${message('code':'default.button.show.label')}</g:link>
							</td>
						</tr>
					</g:each>
					</tbody>
				</table>

					<semui:paginate total="${identifierOccurrenceInstanceTotal}" />


		</div>
	</body>
</html>
