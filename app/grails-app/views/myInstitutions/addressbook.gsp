<%@ page
import="com.k_int.kbplus.Org"  
import="com.k_int.kbplus.Person" 
import="com.k_int.kbplus.PersonRole"
import="com.k_int.kbplus.RefdataValue" 
import="com.k_int.kbplus.RefdataCategory" 
%>

<!doctype html>
<r:require module="annotations" />

<html>
    <head>
        <meta name="layout" content="semanticUI"/>
        <title>${message(code:'laser', default:'LAS:eR')} ${institution.name} - ${message(code:'menu.institutions.addressbook', default:'Addressbook')}</title>
    </head>
    <body>

        <semui:breadcrumbs>
            <semui:crumb controller="myInstitutions" action="dashboard" params="${[shortcode:params.shortcode]}" text="${institution.name}" />
            <semui:crumb message="menu.institutions.addressbook" class="active"/>
        </semui:breadcrumbs>

        <h1 class="ui header">${institution?.name} - ${message(code:'menu.institutions.addressbook', default:'Addressbook')}</h1>

        <semui:messages data="${flash}" />

        <div class="ui grid">
            <div class="twelve wide column">
		        <p>${message(code:'myinst.addressBook.visible', default:'These persons are visible to you due your membership')} ..</p>
		
                <dl>
                    <g:if test="${visiblePersons}">
                        <dt><g:message code="org.prsLinks.label" default="Persons" /></dt>
                        <g:each in="${visiblePersons}" var="p">
                            <g:render template="/templates/cpa/person_details" model="${[person: p]}"></g:render>
                        </g:each>
                    </g:if>
                </dl>
            </div>
            <div class="four wide column">
                <semui:card message="person.create_new.label" class="card-grey">

                    <input class="ui button"
                           value="${message(code: 'default.add.label', args: [message(code: 'person.label', default: 'Person')])}"
                           data-semui="modal"
                           href="#personFormModal" />
                    <g:render template="/person/formModal" model="['org': institution, 'isPublic': RefdataValue.findByOwnerAndValue(RefdataCategory.findByDesc('YN'), 'No')]"/>
                </semui:card>
            </div>
        </div><!--.grid-->

  </body>
</html>
