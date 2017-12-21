<%@ page import="com.k_int.kbplus.Org; com.k_int.properties.PropertyDefinition" %>

<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI">
    <title>${message(code:'laser', default:'LAS:eR')} App Config</title>
    <r:require module="annotations" />
    <g:javascript src="properties.js"/>
</head>
<body>

    <semui:breadcrumbs>
        <semui:crumb message="menu.admin.dash" controller="admin" action="index"/>
        <semui:crumb text="Application Config" class="active"/>
    </semui:breadcrumbs>

<div>

    <h6 class="ui header">${message(code:'sys.properties')}</h6>

    <div id="custom_props_div_1">
        <g:render template="/templates/properties/custom" model="${[
                prop_desc: PropertyDefinition.SYS_CONF,
                ownobj: adminObj,
                custom_props_div: "custom_props_div_1" ]}"/>
    </div>
    <r:script language="JavaScript">
    $(document).ready(function(){
        initPropertiesScript("<g:createLink controller='ajax' action='lookup'/>", "#custom_props_div_1");
    });
    </r:script>

    <g:form action="appConfig" method="POST" class="ui form">
        <input type="submit" name="one"class="ui button" value="Refresh"  />
    </g:form>
    <h3 class="ui header"> Current output for Holders.config</h3>
    <div class="ui form">
        <g:each in="${currentconf.keySet().sort()}" var="key">
            <div class="field">
                <label>${key}</label>
                <g:textArea readonly="" rows="2" style="width:95%" name="key" value="${currentconf.get(key)}"/>
            </div>
        </g:each>
    </div>
</div>
</body>
</html>
