
<%@ page import="com.k_int.kbplus.Contact" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="semanticUI">
		<g:set var="entityName" value="${message(code: 'contact.label', default: 'Contact')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<div>
				

					<h1 class="ui header"><g:message code="default.list.label" args="[entityName]" /></h1>


			<semui:messages data="${flash}" />
				
				<table class="ui sortable celled la-table table">
					<thead>
						<tr>
						
							<g:sortableColumn property="contentType" title="${message(code: 'contact.contentType.label', default: 'ContentType')}" />
						
							<g:sortableColumn property="content" title="${message(code: 'contact.content.label', default: 'Content')}" />
						
							<th class="header"><g:message code="contact.type.label" default="Type" /></th>

               <th class="header"><g:message code="contact.prs.label" default="Prs" /></th>

							<th class="header"><g:message code="contact.org.label" default="Org" /></th>

							<th class="header"><g:message code="person.isPublic.label" default="IsPublic" /></th>

							<th></th>
						</tr>
					</thead>
					<tbody>
					<g:each in="${contactInstanceList}" var="contactInstance">
						<tr>
						
							<td>${contactInstance?.contentType}</td>
						
							<td>${fieldValue(bean: contactInstance, field: "content")}</td>
						
							<td>${fieldValue(bean: contactInstance, field: "type")}</td>

							<td>${fieldValue(bean: contactInstance, field: "prs")}</td>

							<td>${fieldValue(bean: contactInstance, field: "org")}</td>
						
							<td>${contactInstance?.prs?.isPublic?.encodeAsHTML()}</td>
							
							<td class="link">
								<g:link action="show" id="${contactInstance.id}" class="ui tiny button">${message('code':'default.button.show.label')}</g:link>
								<g:link action="edit" id="${contactInstance.id}" class="ui tiny button">${message('code':'default.button.edit.label')}</g:link>
							</td>
						</tr>
					</g:each>
					</tbody>
				</table>

					<semui:paginate total="${contactInstanceTotal}" />


		</div>
	</body>
</html>
