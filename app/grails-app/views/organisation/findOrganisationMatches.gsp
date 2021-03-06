<%@ page import="de.laser.helper.RDStore; com.k_int.kbplus.Org; grails.plugin.springsecurity.SpringSecurityUtils" %>
<laser:serviceInjection/>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="semanticUI">
		<g:if test="${comboType == RDStore.COMBO_TYPE_CONSORTIUM}">
			<g:set var="entityName" value="${message(code: 'default.institution')}" />
		</g:if>
		<g:elseif test="${comboType == RDStore.COMBO_TYPE_DEPARTMENT}">
			<g:set var="entityName" value="${message(code: 'default.department')}" />
		</g:elseif>
		<title>${message(code:'laser')} : <g:message code="default.create.label" args="[entityName]" /></title>
	</head>
	<body>
	<semui:breadcrumbs>
		<g:if test="${comboType == RDStore.COMBO_TYPE_CONSORTIUM}">
			<semui:crumb message="menu.public.all_insts" controller="organisation" action="listInstitution"  />
			<semui:crumb text="${message(code:"default.create.label",args:[entityName])}" class="active"/>
		</g:if>
		<g:elseif test="${comboType == RDStore.COMBO_TYPE_DEPARTMENT}">
			<semui:crumb message="menu.my.departments" controller="myInstitution" action="manageMembers"  />
			<semui:crumb text="${message(code:"default.create.label",args:[entityName])}" class="active"/>
		</g:elseif>
	</semui:breadcrumbs>
	<br>
		<h1 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon /><g:message code="default.create.label" args="[entityName]" /></h1>

		<semui:messages data="${flash}" />

		<semui:errors bean="${orgInstance}" />

		<p>${message(code:'org.findInstitutionMatches.note')}</p>

		<semui:searchSegment controller="organisation" action="findOrganisationMatches" method="get">
			<div class="field">
				<label>${message(code:'org.findInstitutionMatches.proposed')}</label>
				<input type="text" name="proposedOrganisation" value="${params.proposedOrganisation}" />
			</div>
			<g:if test="${comboType == 'Consortium'}">
				<div class="field">
                    <label>${message(code:'org.findInstitutionMatches.searchId')}</label>
					<input type="text" name="proposedOrganisationID" value="${params.proposedOrganisationID}" />
				</div>
			</g:if>
			<div class="field la-field-right-aligned">
				<a href="${request.forwardURI}" class="ui reset primary button">${message(code:'default.button.searchreset.label')}</a>
				<input type="submit" value="${message(code:'default.button.search.label')}" class="ui secondary button">
			</div>
		</semui:searchSegment>



				<g:if test="${organisationMatches != null}">
					<g:if test="${organisationMatches.size()>0}">
						<table class="ui celled la-table table">
							<thead>
								<tr>
									<th>${message(code:'default.name.label')}</th>
									<g:if test="${comboType == RDStore.COMBO_TYPE_CONSORTIUM}">
										<th>${message(code:'identifier.plural')}</th>
										<th>${message(code:'org.shortname.label')}</th>
										<th>${message(code:'org.country.label')}</th>
										<th>${message(code: 'org.consortiaToggle.label')}</th>
									</g:if>
									<g:elseif test="${comboType == RDStore.COMBO_TYPE_DEPARTMENT}">
										<th>
											${message(code: 'org.departmentRemoval.label')}
										</th>
									</g:elseif>
								</tr>
							</thead>
							<tbody>
							<g:each in="${organisationMatches}" var="organisationInstance">
								<tr>
									<td>
										${organisationInstance.name}
										<g:if test="${(accessService.checkPerm('ORG_CONSORTIUM') && members.get(organisationInstance.id)?.contains(institution.id) && members.get(organisationInstance.id)?.size() == 1) || SpringSecurityUtils.ifAnyGranted("ROLE_ADMIN,ROLE_YODA")}">
											<g:link controller="organisation" action="show" id="${organisationInstance.id}">(${message(code:'default.button.edit.label')})</g:link>
										</g:if>
									</td>
									<g:if test="${comboType == RDStore.COMBO_TYPE_CONSORTIUM}">
										<td>
											<ul>
												<li><g:message code="org.globalUID.label" />: <g:fieldValue bean="${organisationInstance}" field="globalUID"/></li>
												<g:if test="${organisationInstance.gokbId}">
													<li><g:message code="org.gokbId.label" />: <g:fieldValue bean="${organisationInstance}" field="gokbId"/></li>
												</g:if>
												<g:each in="${organisationInstance.ids?.sort{it?.ns?.ns}}" var="id"><li>${id.ns.ns}: ${id.value}</li></g:each>
											</ul>
										</td>
										<td>${organisationInstance.shortname}</td>
										<td>${organisationInstance.country}</td>
										<td>
										<%-- here: switch if in consortia or not --%>
											<g:if test="${members.get(organisationInstance.id)?.contains(institution.id)}">
												<g:link class="ui icon negative button la-popup-tooltip la-delay js-open-confirm-modal"
														data-confirm-tokenMsg="${message(code: "confirm.dialog.unlink.consortiaToggle", args: [organisationInstance.name])}"
														data-confirm-term-how="unlink"
														data-content="${message(code:'org.consortiaToggle.remove.label')}"
														controller="organisation"
														action="toggleCombo"
														params="${params+[direction:'remove', fromOrg:organisationInstance.id]}">
													<i class="minus icon"></i>
												</g:link>
											</g:if>
											<g:else>
												<g:link class="ui icon positive button la-popup-tooltip la-delay" data-content="${message(code:'org.consortiaToggle.add.label')}" controller="organisation" action="toggleCombo" params="${params+[direction:'add', fromOrg:organisationInstance.id]}">
													<i class="plus icon"></i>
												</g:link>
											</g:else>
										</td>
									</g:if>
									<g:elseif test="${comboType == RDStore.COMBO_TYPE_DEPARTMENT}">
										<td>
											<g:if test="${!organisationInstance.isEmpty()}">
												<span  class="la-popup-tooltip la-delay" data-content="${message(code:'org.departmentRemoval.departmentNotEmpty')}">
													<button class="ui icon negative button" disabled="disabled">
														<i class="trash alternate icon"></i>
													</button>
												</span>
											</g:if>
											<g:else>
												<g:link class="ui icon negative button la-popup-tooltip la-delay"
														data-confirm-tokenMsg="${message(code: "confirm.dialog.delete.department.institution", args: [organisationInstance.name.institution])}"
														data-confirm-term-how="delete"
														data-content="${message(code:'org.departmentRemoval.remove.label')}"
														controller="myInstitution" action="removeDepartment"
														params="${[dept:organisationInstance.id]}">
													<i class="trash alternate icon"></i>
												</g:link>
											</g:else>
										</td>
									</g:elseif>
								</tr>
							</g:each>
							</tbody>
						</table>
						<g:if test="${params.proposedOrganisation && !params.proposedOrganisation.isEmpty()}">
							<semui:msg class="warning" message="org.findInstitutionMatches.match" args="[params.proposedOrganisation]" />
							<g:link controller="organisation" action="createMember" class="ui negative button" params="${[institution:params.proposedOrganisation]}">${message(code:'org.findInstitutionMatches.matches.create', default:'Create New Institution with the Name', args: [params.proposedOrganisation])}</g:link>
						</g:if>
						<g:else if="${params.proposedOrganisation.isEmpty()}">
							<semui:msg class="warning" message="org.findInstitutionMatches.matchNoName" args="[params.proposedOrganisation]" />

						</g:else>
					</g:if>
					<g:elseif test="${params.proposedOrganisation && !params.proposedOrganisation.isEmpty()}">
						<g:if test="${comboType == RDStore.COMBO_TYPE_CONSORTIUM}">
							<semui:msg class="warning" message="org.findInstitutionMatches.no_match" args="[params.proposedOrganisation]" />
							<g:link controller="organisation" action="createMember" class="ui positive button" params="${[institution:params.proposedOrganisation]}">${message(code:'org.findInstitutionMatches.no_matches.create', args: [params.proposedOrganisation])}</g:link>
						</g:if>
						<g:elseif test="${comboType == RDStore.COMBO_TYPE_DEPARTMENT}">
							<semui:msg class="warning" message="org.findDepartmentMatches.no_match" args="[params.proposedOrganisation]" />
							<g:link controller="organisation" action="createMember" class="ui positive button" params="${[department:params.proposedOrganisation]}">${message(code:'org.findDepartmentMatches.no_matches.create', args: [params.proposedOrganisation])}</g:link>
						</g:elseif>
					</g:elseif>
					<g:elseif test="${params.proposedOrganisationID && !params.proposedOrganisationID.isEmpty()}">
						<semui:msg class="warning" message="org.findInstitutionMatches.no_id_match" args="[params.proposedOrganisationID]" />
					</g:elseif>
				</g:if>


	</body>
</html>
