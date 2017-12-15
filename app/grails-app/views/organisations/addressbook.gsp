<%@ page
import="com.k_int.kbplus.Org"  
import="com.k_int.kbplus.Person" 
import="com.k_int.kbplus.PersonRole"
import="com.k_int.kbplus.RefdataValue" 
import="com.k_int.kbplus.RefdataCategory" 
%>

<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI">
    <g:set var="entityName" value="${message(code: 'org.label', default: 'Org')}" />
    <title>${message(code:'laser', default:'LAS:eR')} <g:message code="default.show.label" args="[entityName]" /></title>
  </head>
  <body>

      <h1 class="ui header">${orgInstance.name}</h1>

      <g:render template="nav" contextPath="." />

        <semui:messages data="${flash}" />

		<p>${message(code:'myinst.addressBook.visible', default:'These persons are visible to you due your membership ..')}</p>
		
		<div>
			<input class="ui button"
				   value="${message(code: 'default.add.label', args: [message(code: 'person.label', default: 'Person')])}"
				   data-semui="modal"
				   href="#personFormModal" />
			<g:render template="/person/formModal" model="['org': orgInstance, 'isPublic': RefdataValue.findByOwnerAndValue(RefdataCategory.findByDesc('YN'), 'No')]"/>
		</div>
		
		
        <dl>
			<g:if test="${visiblePersons}">
				<dt><g:message code="org.prsLinks.label" default="Persons" /></dt>
				<g:each in="${visiblePersons}" var="p">
					<g:render template="/templates/cpa/person_details" model="${[person: p]}"></g:render>
				</g:each>
			</g:if>
				
		</dl>

  </body>
</html>
