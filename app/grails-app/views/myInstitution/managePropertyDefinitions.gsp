<%@ page import="de.laser.domain.I10nTranslation; com.k_int.properties.PropertyDefinition" %>
<%@ page import="grails.plugin.springsecurity.SpringSecurityUtils" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="semanticUI">
        <g:set var="entityName" value="${message(code: 'org.label')}" />
        <title>${message(code:'laser')} : ${message(code: 'menu.institutions.prop_defs')}</title>
    </head>
    <body>

    <semui:breadcrumbs>
        <semui:crumb message="menu.institutions.manage_props" class="active" />
    </semui:breadcrumbs>
    <br>
    <h1 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon />${message(code: 'menu.institutions.manage_props')}</h1>

    <g:render template="nav" />

    <semui:messages data="${flash}" />

    <g:if test="${false}">
        <div class="content ui form">
            <div class="fields">
                <div class="field">
                    <button class="ui button" value="" data-href="#addPropertyDefinitionModal" data-semui="modal" >${message(code:'propertyDefinition.create_new.label')}</button>
                </div>
            </div>
        </div>
    </g:if>
    <g:else>
        <br />
        <br />
    </g:else>
		<div class="ui styled fluid accordion">
			<g:each in="${propertyDefinitions}" var="entry">
                <div class="title">
                    <i class="dropdown icon"></i>
                    <g:message code="propertyDefinitions.${entry.key}.label" default="${entry.key}" />
                </div>
                <div class="content">
                    <table class="ui celled la-table la-table-small table">
                        <thead>
                        <tr>
                            <th></th>
                            %{--<th>${message(code:'propertyDefinition.key.label')}</th>--}%
                            <th>${message(code:'default.name.label')}</th>
                            <th>${message(code:'propertyDefinition.expl.label')}</th>
                            <th>${message(code:'default.type.label')}</th>
                            <%--<th class="la-action-info">${message(code:'default.actions.label')}</th>--%>
                        </tr>
                        </thead>
                        <tbody>
                            <g:each in="${entry.value}" var="pd">
                                <tr>
                                    <td>
                                        <g:if test="${pd.isHardData}">
                                            <span data-position="top left"  class="la-popup-tooltip la-delay" data-content="${message(code:'default.hardData.tooltip')}">
                                                <i class="check circle icon green"></i>
                                            </span>
                                        </g:if>
                                        <g:if test="${pd.multipleOccurrence}">
                                            <span data-position="top right"  class="la-popup-tooltip la-delay" data-content="${message(code:'default.multipleOccurrence.tooltip')}">
                                                <i class="redo icon orange"></i>
                                            </span>
                                        </g:if>

                                        <g:if test="${pd.isUsedForLogic}">
                                            <span data-position="top left"  class="la-popup-tooltip la-delay" data-content="${message(code:'default.isUsedForLogic.tooltip')}">
                                                <i class="ui icon orange cube"></i>
                                            </span>
                                        </g:if>
                                    </td>
                                    %{--<td>--}%
                                        %{--<g:if test="${pd.isUsedForLogic}">--}%
                                            %{--<span style="color:orange">${fieldValue(bean: pd, field: "name")}</span>--}%
                                        %{--</g:if>--}%
                                        %{--<g:else>--}%
                                            %{--${fieldValue(bean: pd, field: "name")}--}%
                                        %{--</g:else>--}%
                                    %{--</td>--}%
                                    <td>
                                        <g:if test="${!pd.isHardData && SpringSecurityUtils.ifAnyGranted('ROLE_YODA')}">
                                            <semui:xEditable owner="${pd}" field="name_${languageSuffix}" />
                                        </g:if>
                                        <g:else>
                                            ${pd.getI10n('name')}
                                        </g:else>
                                    </td>
                                    <td>
                                        <g:if test="${!pd.isHardData && SpringSecurityUtils.ifAnyGranted('ROLE_YODA')}">
                                            <semui:xEditable owner="${pd}" field="expl_${languageSuffix}" type="textarea" />
                                        </g:if>
                                        <g:else>
                                            ${pd.getI10n('expl')}
                                        </g:else>
                                    </td>
                                    <td>
                                        ${PropertyDefinition.getLocalizedValue(pd?.type)}
                                        <g:if test="${pd?.type == 'class com.k_int.kbplus.RefdataValue'}">
                                            <g:set var="refdataValues" value="${[]}"/>
                                            <g:each in="${com.k_int.kbplus.RefdataCategory.getAllRefdataValues(pd.refdataCategory)}" var="refdataValue">
                                                <g:if test="${refdataValue.getI10n('value')}">
                                                    <g:set var="refdataValues" value="${refdataValues + refdataValue.getI10n('value')}"/>
                                                </g:if>
                                            </g:each>
                                            <br>
                                            (${refdataValues.join('/')})
                                        </g:if>
                                    </td>
                                    <%--<td class="x">

                                        <g:if test="${false}">
                                        <sec:ifAnyGranted roles="ROLE_YODA">
                                            <g:if test="${usedPdList?.contains(pd.id)}">
                                                <span class="la-popup-tooltip la-delay" data-position="top right" data-content="${message(code:'propertyDefinition.exchange.label')}">
                                                    <button class="ui icon button" data-href="#replacePropertyDefinitionModal" data-semui="modal"
                                                            data-xcg-pd="${pd.class.name}:${pd.id}"
                                                            data-xcg-type="${pd.type}"
                                                            data-xcg-rdc="${pd.refdataCategory}"
                                                            data-xcg-debug="${pd.getI10n('name')} (${pd.name})"
                                                    ><i class="exchange icon"></i></button>
                                                </span>
                                            </g:if>
                                        </sec:ifAnyGranted>

                                        <g:if test="${! pd.isHardData && ! usedPdList?.contains(pd.id)}">
                                            <g:link controller="admin" action="managePropertyDefinitions"
                                                    params="${[cmd: 'deletePropertyDefinition', pd: 'com.k_int.properties.PropertyDefinition:' + pd.id]}" class="ui icon negative button">
                                                <i class="trash alternate icon"></i>
                                            </g:link>
                                        </g:if>
                                        </g:if>
                                    </td>--%>

                                </tr>
                            </g:each>

                        </tbody>
                    </table>
                </div>
			</g:each>
        </div>

	</body>
</html>
