<%@ page import="com.k_int.kbplus.Org; com.k_int.properties.PropertyDefinition; com.k_int.kbplus.RefdataCategory; de.laser.domain.I10nTranslation" %>

<!doctype html>
<html>
    <head>
        <meta name="layout" content="semanticUI">
        <g:set var="entityName" value="${message(code: 'org.label')}" />
        <title>${message(code:'laser')} : ${message(code: 'menu.institutions.private_props')}</title>
    </head>
    <body>

    <semui:breadcrumbs>
        <semui:crumb message="menu.institutions.manage_props" class="active" />
    </semui:breadcrumbs>
    <br>
    <h1 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon />${message(code: 'menu.institutions.manage_props')}</h1>

    <g:render template="nav" />

    <semui:messages data="${flash}" />

    <g:if test="${editable}">
        <input class="ui button" value="${message(code:'menu.institutions.manage_props.create_new')}"
               data-semui="modal" data-href="#addPropertyDefinitionModal" type="submit">
    </g:if>

    <g:if test="${propertyDefinitions}">

        <div class="ui info message">
            ${message(code:'propertyDefinition.private.info')}
        </div>
        <div class="ui styled fluid accordion">
            <g:each in="${propertyDefinitions}" var="entry">
                <div class="title">
                    <i class="dropdown icon"></i>
                    <g:message code="propertyDefinitions.${entry.key}.label" default="${entry.key}" />
                </div>
                <div class="content">
                    <g:form class="ui form" action="managePrivatePropertyDefinitions" method="post">
                        <table class="ui celled la-table la-table-small table">
                            <thead>
                                <tr>
                                    <th></th>
                                    %{--<th>${message(code:'propertyDefinition.key.label')}</th>--}%
                                    <th>${message(code:'default.name.label')}</th>
                                    <th>${message(code:'propertyDefinition.expl.label')}</th>
                                    <th>${message(code:'default.type.label')}</th>
                                    <th>${message(code:'propertyDefinition.count.label')}</th>
                                    <g:if test="${editable}">
                                        <th class="la-action-info">${message(code:'default.actions.label')}</th>
                                    </g:if>
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
                                            <semui:xEditable owner="${pd}" field="name_${languageSuffix}" />
                                        </td>
                                        <td>
                                            <semui:xEditable owner="${pd}" field="expl_${languageSuffix}" type="textarea" />
                                        </td>
                                        <td>
                                            ${PropertyDefinition.getLocalizedValue(pd?.type)}
                                            <g:if test="${pd?.type == 'class com.k_int.kbplus.RefdataValue'}">
                                                <g:set var="refdataValues" value="${[]}"/>
                                                <g:each in="${com.k_int.kbplus.RefdataCategory.getAllRefdataValues(pd.refdataCategory)}"
                                                        var="refdataValue">
                                                    <g:if test="${refdataValue.getI10n('value')}">
                                                        <g:set var="refdataValues" value="${refdataValues + refdataValue.getI10n('value')}"/>
                                                    </g:if>
                                                </g:each>
                                                <br>
                                                (${refdataValues.join('/')})
                                            </g:if>
                                        </td>
                                        <td>
                                            <span class="ui circular label">${pd.countUsages()}</span>
                                        </td>
                                        <g:if test="${editable}">
                                            <td class="x">
                                                <g:if test="${pd.countUsages()==0}">
                                                    <g:link action="managePrivatePropertyDefinitions"
                                                            params="[cmd:'delete', deleteIds: pd?.id]"
                                                            data-confirm-tokenMsg="${message(code: "confirm.dialog.delete.property", args: [fieldValue(bean: pd, field: "name")])}"
                                                            data-confirm-term-how="delete"
                                                            class="ui icon negative button js-open-confirm-modal"
                                                            role="button">
                                                        <i class="trash alternate icon"></i>
                                                    </g:link>
                                                </g:if>
                                            </td>
                                        </g:if>
                                    </tr>
                                </g:each>
                            </tbody>
                        </table>
                    </g:form>
                </div>
            </g:each>
        </div>
     </g:if>


    <semui:modal id="addPropertyDefinitionModal" message="propertyDefinition.create_new.label">

        <g:form class="ui form" action="managePrivatePropertyDefinitions" >
            <g:field type="hidden" name="cmd" value="add" />

            <div class="field">
                <label class="property-label">Name</label>
                <input type="text" name="pd_name"/>
            </div>

            <div class="field">
                <label class="property-label">${message(code:'propertyDefinition.expl.label')}</label>
                <textarea name="pd_expl" id="pd_expl" class="ui textarea" rows="2"></textarea>
            </div>

            <div class="fields">

                <div class="field six wide">
                    <label class="property-label">${message(code:'propertyDefinition.descr.label')}</label>
                    <%--<g:select name="pd_descr" from="${PropertyDefinition.AVAILABLE_PRIVATE_DESCR}"/>--%>
                    <select name="pd_descr" id="pd_descr" class="ui dropdown">
                        <g:each in="${PropertyDefinition.AVAILABLE_PRIVATE_DESCR}" var="pd">
                            <option value="${pd}"><g:message code="propertyDefinition.${pd}.label" default="${pd}"/></option>
                        </g:each>
                    </select>
                </div>

                <div class="field five wide">
                    <label class="property-label"><g:message code="default.type.label" /></label>
                    <g:select class="ui dropdown"
                        from="${PropertyDefinition.validTypes2.entrySet()}"
                        optionKey="key" optionValue="${{PropertyDefinition.getLocalizedValue(it.key)}}"
                        name="pd_type"
                        id="cust_prop_modal_select" />
                </div>

                <div class="field four wide">
                    <label class="property-label">Optionen</label>

                    <g:checkBox type="text" name="pd_mandatory" /> ${message(code:'default.mandatory.tooltip')}
                    <br />
                    <g:checkBox type="text" name="pd_multiple_occurrence" /> ${message(code:'default.multipleOccurrence.tooltip')}
                </div>

            </div>

            <div class="fields">
                <div class="field hide" id="cust_prop_ref_data_name" style="width: 100%">
                    <label class="property-label"><g:message code="refdataCategory.label" /></label>

                    <input type="hidden" name="refdatacategory" id="cust_prop_refdatacatsearch"/>
                    <g:set var="propertyService" bean="propertyService"/>

                    <div class="ui grid" style="margin-top:1em">
                        <div class="ten wide column">
                            <g:each in="${propertyService.getRefdataCategoryUsage()}" var="cat">

                                <p class="hidden" data-prop-def-desc="${cat.key}">
                                    Häufig verwendete Kategorien: <br />

                                    <%
                                        List catList =  cat.value?.take(3)
                                        catList = catList.collect { entry ->
                                            '&nbsp; - ' + (RefdataCategory.getByDesc(entry[0]))?.getI10n('desc')
                                        }
                                        println catList.join('<br />')
                                    %>

                                </p>
                            </g:each>
                        </div>
                        <div class="six wide column">
                            <br />
                            <a href="<g:createLink controller="profile" action="properties" />" target="_blank">
                                <i class="icon external alternate"></i>
                                Alle Kategorien und Referenzwerte<br />als Übersicht öffnen
                            </a>
                        </div>
                    </div><!-- .grid -->
                </div>
            </div>

        </g:form>
    </semui:modal>

    <g:javascript>

    $('#pd_descr').change(function() {
        $('#cust_prop_modal_select').trigger('change');
    });

    $('#cust_prop_modal_select').change(function() {
        var selectedText = $( "#cust_prop_modal_select option:selected" ).val();
        if( selectedText == "class com.k_int.kbplus.RefdataValue") {
            $("#cust_prop_ref_data_name").show();

            var $pMatch = $( "p[data-prop-def-desc='" + $( "#pd_descr option:selected" ).val() + "']" )
            if ($pMatch) {
                $( "p[data-prop-def-desc]" ).addClass('hidden')
                $pMatch.removeClass('hidden')
            }
        }
        else {
            $("#cust_prop_ref_data_name").hide();
        }
    });

    $('#cust_prop_modal_select').trigger('change');

    $("#cust_prop_refdatacatsearch").select2({
        placeholder: "Kategorie eintippen...",
        minimumInputLength: 1,

        formatInputTooShort: function () {
            return "${message(code:'select2.minChars.note', default:'Please enter 1 or more character')}";
        },
        formatNoMatches: function() {
            return "${message(code:'select2.noMatchesFound')}";
        },
        formatSearching:  function() {
            return "${message(code:'select2.formatSearching')}";
        },
        ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
            url: '${createLink(controller:'ajax', action:'lookup')}',
            dataType: 'json',
            data: function (term, page) {
                return {
                    q: term, // search term
                    page_limit: 10,
                    baseClass:'com.k_int.kbplus.RefdataCategory'
                };
            },
            results: function (data, page) {
                return {results: data.values};
            }
        }
    });

    </g:javascript>

  </body>
</html>
