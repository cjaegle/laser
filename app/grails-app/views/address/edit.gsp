<%@ page import="de.laser.helper.RDStore; com.k_int.kbplus.Address" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="semanticUI">
		<g:set var="entityName" value="${message(code: 'address.label')}" />
		<title>${message(code:'laser')} : <g:message code="default.edit.label" args="[entityName]" /></title>
	</head>

	<body>
	<semui:breadcrumbs>
		<g:if test="${addressInstance.org && (RDStore.OT_PROVIDER.id in addressInstance.org.getallOrgTypeIds())}">
			<semui:crumb message="menu.public.all_providers" controller="organisation" action="listProvider"/>
			<semui:crumb message="${addressInstance.org.getDesignation()}" controller="organisation" action="show" id="${addressInstance.org.id}"/>
		</g:if>
		<g:else>
			<semui:crumb message="menu.public.all_orgs" controller="organisation" action="index"/>
		</g:else>
		<semui:crumb text="${g.message(code:'default.edit.label', args:[entityName])}" class="active"/>
	</semui:breadcrumbs>
	<br>
		<h1 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon /><g:message code="default.edit.label" args="[entityName]" /></h1>

		<semui:messages data="${flash}" />

		<semui:errors bean="${addressInstance}" />

		<div class="ui grid">
			
			<div class="twelve wide column">

				<fieldset>
					<g:form class="ui form" action="edit" id="${addressInstance.id}" >
						<g:hiddenField name="version" value="${addressInstance.version}" />
						<fieldset>
							<% // <f:all bean="addressInstance"/> %>
							<g:render template="form"/>
							
							<div class="ui form-actions">
								<button type="submit" class="ui button">
									<i class="checkmark icon"></i>
									<g:message code="default.button.update.label" />
								</button>
								<button type="submit" class="ui negative button" name="_action_delete" formnovalidate>
									<i class="trash alternate icon"></i>
									<g:message code="default.button.delete.label" />
								</button>
							</div>
						</fieldset>
					</g:form>
				</fieldset>

			</div><!-- .twelve -->

            <aside class="four wide column">
            </aside><!-- .four -->

		</div><!-- .grid -->
	</body>
</html>
