
<%@ page import="com.k_int.kbplus.Address" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="semanticUI">
		<g:set var="entityName" value="${message(code: 'address.label', default: 'Address')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<div>
				

					<h1 class="ui left aligned icon header"><semui:headerIcon /><g:message code="default.list.label" args="[entityName]" />
						<semui:totalNumber total="${addressInstanceTotal}"/>
					</h1>


			<semui:messages data="${flash}" />
				
				<table class="ui sortable celled la-table table">
					<thead>
						<tr>
						
							<g:sortableColumn property="street_1" title="${message(code: 'address.street_1.label', default: 'Street1')}" />
						
							<g:sortableColumn property="street_2" title="${message(code: 'address.street_2.label', default: 'Street2')}" />
						
							<g:sortableColumn property="pob" title="${message(code: 'address.pob.label', default: 'Pob')}" />
						
							<g:sortableColumn property="zipcode" title="${message(code: 'address.zipcode.label', default: 'Zipcode')}" />
						
							<g:sortableColumn property="city" title="${message(code: 'address.city.label', default: 'City')}" />
						
							<g:sortableColumn property="state" title="${message(code: 'address.state.label', default: 'State')}" />
							
							<th class="header"><g:message code="address.prs.label" default="Prs" /></th>
						
							<th class="header"><g:message code="address.org.label" default="Org" /></th>
							
							<th class="header"><g:message code="person.isPublic.label" default="IsPublic" /></th>
						
							<th></th>
						</tr>
					</thead>
					<tbody>
					<g:each in="${addressInstanceList}" var="addressInstance">
						<tr>
						
							<td>${fieldValue(bean: addressInstance, field: "street_1")}</td>
						
							<td>${fieldValue(bean: addressInstance, field: "street_2")}</td>
						
							<td>${fieldValue(bean: addressInstance, field: "pob")}</td>
						
							<td>${fieldValue(bean: addressInstance, field: "zipcode")}</td>
						
							<td>${fieldValue(bean: addressInstance, field: "city")}</td>
						
							<td>${fieldValue(bean: addressInstance, field: "state")}</td>
							
							<td>${fieldValue(bean: addressInstance, field: "prs")}</td>
						
							<td>${fieldValue(bean: addressInstance, field: "org")}</td>
							
							<td>${addressInstance?.prs?.isPublic ? RDStore.YN_YES.getI10n('value') : RDStore.YN_NO.getI10n('value')}</td>
						
							<td class="link">
								<g:link action="show" id="${addressInstance.id}" class="ui tiny button">${message('code':'default.button.show.label')}</g:link>
								<g:link action="edit" id="${addressInstance.id}" class="ui tiny button">${message('code':'default.button.edit.label')}</g:link>
							</td>
						</tr>
					</g:each>
					</tbody>
				</table>

					<semui:paginate total="${addressInstanceTotal}" />


		</div>
	</body>
</html>
