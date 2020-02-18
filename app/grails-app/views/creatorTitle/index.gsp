
<%@ page import="com.k_int.kbplus.CreatorTitle" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'creatorTitle.label', default: 'CreatorTitle')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-creatorTitle" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-creatorTitle" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<th><g:message code="creatorTitle.creator.label" default="Creator" /></th>
					
						<g:sortableColumn property="dateCreated" title="${message(code: 'default.dateCreated.label')}" />
					
						<g:sortableColumn property="lastUpdated" title="${message(code: 'default.lastUpdated.label')}" />
					
						<th><g:message code="creatorTitle.role.label" default="Role" /></th>
					
						<th><g:message code="creatorTitle.title.label" default="Title" /></th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${creatorTitleInstanceList}" status="i" var="creatorTitleInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${creatorTitleInstance.id}">${fieldValue(bean: creatorTitleInstance, field: "creator")}</g:link></td>
					
						<td><g:formatDate date="${creatorTitleInstance.dateCreated}" /></td>
					
						<td><g:formatDate date="${creatorTitleInstance.lastUpdated}" /></td>
					
						<td>${fieldValue(bean: creatorTitleInstance, field: "role")}</td>
					
						<td>${fieldValue(bean: creatorTitleInstance, field: "title")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${creatorTitleInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
