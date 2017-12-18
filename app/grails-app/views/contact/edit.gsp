<%@ page import="com.k_int.kbplus.Contact" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="semanticUI">
		<g:set var="entityName" value="${message(code: 'contact.label', default: 'Contact')}" />
		<title><g:message code="default.edit.label" args="[entityName]" /></title>
	</head>
	<body>

		<h1 class="ui header"><g:message code="default.edit.label" args="[entityName]" /></h1>

		<semui:messages data="${flash}" />

		<semui:errors bean="${contactInstance}" />

		<div class="ui grid">

			<div class="twelve wide column">

				<fieldset>
					<g:form class="ui form" action="edit" id="${contactInstance?.id}" >
						<g:hiddenField name="version" value="${contactInstance?.version}" />
						<fieldset>
							<% // <f:all bean="contactInstance"/> %>
							<g:render template="form"/>
							
							<div class="ui segment form-actions">
								<button type="submit" class="ui button">
									<i class="icon-ok icon-white"></i>
									<g:message code="default.button.update.label" default="Update" />
								</button>
								<button type="submit" class="ui negative button" name="_action_delete" formnovalidate>
									<i class="icon-trash icon-white"></i>
									<g:message code="default.button.delete.label" default="Delete" />
								</button>
							</div>
						</fieldset>
					</g:form>
				</fieldset>

			</div><!-- .twelve -->

			<div class="four wide column">
				<g:render template="../templates/sideMenu" />
			</div><!-- .four -->

		</div><!-- .grid -->

	</body>
</html>
