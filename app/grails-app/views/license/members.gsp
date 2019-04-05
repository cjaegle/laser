<%@ page import="com.k_int.kbplus.License" %>
<%@ page import="com.k_int.kbplus.RefdataValue" %>
<laser:serviceInjection />

<!doctype html>
<html>
<head>
  <meta name="layout" content="semanticUI"/>
  <title>${message(code:'laser', default:'LAS:eR')} : ${message(code:'license.details.incoming.childs')}</title>
</head>
<body>

    <g:render template="breadcrumb" model="${[ license:license, params:params ]}"/>

    <semui:controlButtons>
        <g:render template="actions" />
    </semui:controlButtons>

    <h1 class="ui left aligned icon header"><semui:headerIcon />
        <g:if test="${license.type?.value == 'Template'}">${message(code:'license.label')} (${license.type.getI10n('value')}):</g:if>
        <semui:xEditable owner="${license}" field="reference" id="reference"/>
    </h1>

<g:render template="nav" />

<table class="ui celled la-table table">
    <thead>
        <tr>
            <th>${message(code:'sidewide.number')}</th>
            <th>${message(code:'license')}</th>
            <th>${message(code:'subscriptionDetails.members.members')}</th>
            <th>${message(code:'license.details.status')}</th>
            <th></th>
        </tr>
    </thead>
    <tbody>

        <g:each in="${validMemberLicenses}" status="i" var="lic">
            <tr>
                <td>${i + 1}</td>
                <td>
                    <g:link controller="license" action="show" id="${lic.id}">${lic.genericLabel}</g:link>

                    <g:if test="${lic.isSlaved?.value?.equalsIgnoreCase('yes')}">
                        <span data-position="top right" data-tooltip="${message(code:'license.details.isSlaved.tooltip')}">
                            <i class="thumbtack blue icon"></i>
                        </span>
                    </g:if>
                </td>
                <td>
                    <g:each in="${lic.orgLinks}" var="orgRole">
                        <g:if test="${orgRole?.roleType.value in ['Licensee_Consortial', 'Licensee']}">
                            <g:link controller="organisation" action="show" id="${orgRole?.org.id}">
                                ${orgRole?.org.getDesignation()}
                            </g:link>
                            , ${orgRole?.roleType.getI10n('value')} <br />
                        </g:if>

                        <g:if test="${license.isTemplate() && orgRole?.roleType.value in ['Licensing Consortium']}">
                            <g:link controller="organisation" action="show" id="${orgRole?.org.id}">
                                ${orgRole?.org.getDesignation()}
                            </g:link>
                            , ${orgRole?.roleType.getI10n('value')} <br />
                        </g:if>
                    </g:each>
                </td>
                <td>
                    ${lic.status.getI10n('value')}
                </td>
                <td class="x">
                    <g:if test="${editable}">
                        <g:link class="ui icon negative button js-open-confirm-modal"
                                data-confirm-term-what="license"
                                data-confirm-term-what-detail="${lic.reference}"
                                data-confirm-term-how="delete"
                                controller="license"
                                params="${[id:license.id, target: lic.class.name + ':' + lic.id]}"
                                action="deleteMember">
                            <i class="trash alternate icon"></i>
                        </g:link>

                    </g:if>
                </td>
            </tr>
        </g:each>

    </tbody>
</table>

</body>
</html>