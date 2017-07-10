%{--To use, add the g:render custom_props inside a div with id=custom_props_div, add g:javascript src=properties.js--}%
%{--on head of container page, and on window load execute  initPropertiesScript("<g:createLink controller='ajax' action='lookup'/>");--}%

<%@ page import="com.k_int.kbplus.RefdataValue; com.k_int.properties.PropertyDefinition" %>

<g:hasErrors bean="${newProp}">
    <bootstrap:alert class="alert-error">
	    <ul>
	        <g:eachError bean="${newProp}" var="error">
	            <li> <g:message error="${error}"/></li>
	        </g:eachError>
	    </ul>
    </bootstrap:alert>
</g:hasErrors>

<g:if test="${error}">
    <bootstrap:alert class="alert-danger">${error}</bootstrap:alert>
</g:if>

<g:if test="${editable}">
	<g:formRemote url="[controller: 'ajax', action: 'addCustomPropertyValue']"
			method="post"
			name="cust_prop_add_value"
	        class="form-inline"
	        update="custom_props_div"
	        onComplete="initPropertiesScript('${createLink(controller:'ajax', action:'lookup')}')">

	    <input type="hidden" name="propIdent" desc="${prop_desc}" class="customPropSelect"/>
	    <input type="hidden" name="ownerId" value="${ownobj.id}"/>
	    <input type="hidden" name="editable" value="${editable}"/>
	    <input type="hidden" name="ownerClass" value="${ownobj.class}"/>
            <input type="submit" value="${message(code:'default.add.label', args:[message(code:'default.property.label')], default:'Add Property')}" class="btn btn-primary btn-small"/>
	</g:formRemote>
</g:if>

<br/>
<table id="custom_props_table" class="table table-bordered">
    <thead>
    <tr>
      <th>${message(code:'licence.property.table.property')}</th>
      <th>${message(code:'licence.property.table.value')}</th>
      <th>${message(code:'licence.property.table.notes')}</th>
      <th>${message(code:'licence.property.table.delete')}</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${ownobj.customProperties}" var="prop">
        <tr>
            <td>${prop.type.name}</td>
        <td>
            <g:if test="${prop.type.type == Integer.toString()}">
                <g:xEditable owner="${prop}" type="text" field="intValue"/>
            </g:if>
            <g:elseif test="${prop.type.type == String.toString()}">
                <g:xEditable owner="${prop}" type="text" field="stringValue"/>
            </g:elseif>
            <g:elseif test="${prop.type.type == BigDecimal.toString()}">
                <g:xEditable owner="${prop}" type="text" field="decValue"/>
            </g:elseif>
            <g:elseif test="${prop.type.type == RefdataValue.toString()}">
                <g:xEditableRefData owner="${prop}" type="text" field="refValue" config="${prop.type.refdataCategory}"/>
            </g:elseif>
        </td>
        <td>
        	<g:xEditable owner="${prop}" type="textarea" field="note"/>
        </td>
        <td>
            <g:if test="${editable == true}">
            <g:remoteLink controller="ajax" action="deleteCustomProperty"
                before="if(!confirm('Delete the property ${prop.type.name}?')) return false"
                params='[propclass: prop.getClass(),ownerId:"${ownobj.id}",ownerClass:"${ownobj.class}", editable:"${editable}"]' id="${prop.id}"
                onComplete="initPropertiesScript('${createLink(controller:'ajax', action:'lookup')}')" update="custom_props_div">${message(code:'default.button.delete.label', default:'Delete')}</g:remoteLink>
            </g:if>
        </td>
        </tr>
    </g:each></tbody>
</table>

<div id="cust_prop_add_modal" class="modal hide">

    <g:formRemote id="create_cust_prop" name="modal_create_cust_prop"
                  url="[controller: 'ajax', action: 'addCustomPropertyType']" method="post" update="custom_props_div"
                  onComplete="initPropertiesScript('${createLink(controller:'ajax', action:'lookup')}')">
        <input type="hidden" name="ownerId" value="${ownobj.id}"/>
        <input type="hidden" name="ownerClass" value="${ownobj.class}"/>
        <input type="hidden" name="editable" value="${editable}"/>

        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">×</button>

            <h3>Create Custom Property Definition</h3>
        </div>

        <input type="hidden" name="parent" value="${parent}"/>

        <div class="modal-body">
            <dl>
                <dt>
                	<label class="control-label">Property Definition:</label>
                </dt>
                <dd>
                    <label class="property-label">Name:</label>
                    <input type="text" name="cust_prop_name" />
                </dd>
                <dd>
                    <label class="property-label">Type:</label>
                    <g:select from="${PropertyDefinition.validTypes.entrySet()}"
							optionKey="value" optionValue="key"
							name="cust_prop_type"
							id="cust_prop_modal_select" />
                </dd>

                <div class="hide" id="cust_prop_ref_data_name">
                    <dd>
                        <label class="property-label">Refdata Category:</label>
						<input type="hidden" name="refdatacategory" id="cust_prop_refdatacatsearch"/>
                    </dd>
                </div>
                <dd>
                    <label class="property-label">Context:</label> <g:select name="cust_prop_desc" from="${PropertyDefinition.AVAILABLE_DESCR}"/>
                </dd>
                <dd>
                    Create value for this property: <g:checkBox name="autoAdd" checked="true"/>
                </dd>
            </dl>
        </div>

        <div class="modal-footer">
            <input id="new_cust_prop_add_btn" type="submit" class="btn btn-primary" value="${message(code:'default.button.add.label', default:'Add')}">
            <a href="#" data-dismiss="modal" class="btn btn-primary">${message(code:'default.button.close.label', default:'Close')}</a>
        </div>
    </g:formRemote>

</div>
