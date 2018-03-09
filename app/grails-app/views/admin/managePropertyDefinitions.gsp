<%@ page import="de.laser.domain.I10nTranslation; com.k_int.properties.PropertyDefinition" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="semanticUI">
		<title>${message(code: 'menu.admin.managePropertyDefinitions')}</title>
	</head>

		<semui:breadcrumbs>
			<semui:crumb message="menu.admin.dash" controller="admin" action="index" />
			<semui:crumb message="menu.admin.manageI10n" class="active"/>
		</semui:breadcrumbs>

		<h1 class="ui header"><semui:headerIcon /><g:message code="menu.admin.managePropertyDefinitions"/></h1>

		<semui:messages data="${flash}" />

		<semui:card>
            <div class="content ui form">
                <div class="field">
                    <button class="ui button" value="" href="#addPropertyDefinitionModal" data-semui="modal" >${message(code:'propertyDefinition.create_new.label')}</button>
                </div>
            </div>
		</semui:card>

		<div class="ui styled fluid accordion">
			<g:each in="${propertyDefinitions}" var="entry">
                <div class="title">
                    <i class="dropdown icon"></i>
                    ${entry.key}
                </div>
                <div class="content">
                    <table class="ui celled la-table la-table-small table">
                        <thead>
                        <tr>
                            <th>${message(code:'propertyDefinition.name.label', default:'Name')}</th>
                            <th>Name (DE)</th>
                            <th>Name (EN)</th>
                            <!--<th>DE: Description</th>
                            <th>EN: Description</th>-->
                        </tr>
                        </thead>
                        <tbody>
                            <g:each in="${entry.value}" var="pd">
                                <g:set var="pdI10nName"  value="${I10nTranslation.createI10nOnTheFly(pd, 'name')}" />
                                <!--<g:set var="pdI10nDescr" value="${I10nTranslation.createI10nOnTheFly(pd, 'descr')}" />-->
                                <tr>
                                    <td>
                                        ${fieldValue(bean: pd, field: "name")}
                                        <g:if test="${pd.softData}">
                                            <span class="badge" title="${message(code:'default.softData.tooltip')}"> &#8623; </span>
                                        </g:if>
                                        <g:if test="${pd.multipleOccurrence}">
                                            <span class="badge badge-info" title="${message(code:'default.multipleOccurrence.tooltip')}"> &#9733; </span>
                                        </g:if>
                                    </td>
                                    <td><semui:xEditable owner="${pdI10nName}" field="valueDe" /></td>
                                    <td><semui:xEditable owner="${pdI10nName}" field="valueEn" /></td>
                                    <!--<td><semui:xEditable owner="${pdI10nDescr}" field="valueDe" /></td>
                                    <td><semui:xEditable owner="${pdI10nDescr}" field="valueEn" /></td>-->
                                </tr>
                            </g:each>

                        </tbody>
                    </table>
                </div>
			</g:each>
        </div>

        <semui:modal id="addPropertyDefinitionModal" message="propertyDefinition.create_new.label">

            <g:form class="ui form" id="create_cust_prop" url="[controller: 'ajax', action: 'addCustomPropertyType']" >
                <input type="hidden" name="reloadReferer" value="/admin/managePropertyDefinitions"/>
                <input type="hidden" name="ownerClass" value="${this.class}"/>

				<div class="field">
                	<label class="property-label">Name</label>
                	<input type="text" name="cust_prop_name"/>
                </div>

                <div class="fields">
                    <div class="field five wide">
                        <label class="property-label">Context:</label>
                        <g:select name="cust_prop_desc" from="${PropertyDefinition.AVAILABLE_CUSTOM_DESCR}"/>
                    </div>

                    <div class="field five wide">
                        <label class="property-label">Type</label>
                        <g:select
                            from="${PropertyDefinition.validTypes.entrySet()}"
                            optionKey="value" optionValue="key"
                            name="cust_prop_type"
                            id="cust_prop_modal_select" />
                    </div>

                    <div class="field six wide hide" id="cust_prop_ref_data_name">
                        <label class="property-label">Kategorie</label>
                        <input type="hidden" name="refdatacategory" id="cust_prop_refdatacatsearch"/>
                    </div>
                </div>

                <div class="fields">
                    <div class="field five wide">
                        <label class="property-label">${message(code:'default.multipleOccurrence.tooltip')}</label>
                        <g:checkBox type="text" name="cust_prop_multiple_occurence" />
                    </div>
                </div>

            </g:form>

        </semui:modal>

		<g:javascript>

			   if( $( "#cust_prop_modal_select option:selected" ).val() == "class com.k_int.kbplus.RefdataValue") {
					$("#cust_prop_ref_data_name").show();
			   }

			$('#cust_prop_modal_select').change(function() {
				var selectedText = $( "#cust_prop_modal_select option:selected" ).val();
				if( selectedText == "class com.k_int.kbplus.RefdataValue") {
					$("#cust_prop_ref_data_name").show();
				}else{
					$("#cust_prop_ref_data_name").hide();
				}
			});

			$("#cust_prop_refdatacatsearch").select2({
				placeholder: "Type category...",
				minimumInputLength: 1,
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
