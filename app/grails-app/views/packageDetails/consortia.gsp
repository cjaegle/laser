<%@ page import="com.k_int.kbplus.Package" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI">
    <g:set var="entityName" value="${message(code: 'package.label', default: 'Package')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>

<body>

<div>
    <ul class="breadcrumb">
        <li><g:link controller="home" action="index">Home</g:link> <span class="divider">/</span></li>
        <li><g:link controller="packageDetails" action="index">All Packages</g:link><span class="divider">/</span></li>
        <li><g:link controller="packageDetails" action="show"
                    id="${packageInstance.id}">${packageInstance.name}</g:link></li>

        

    </ul>
</div>
<g:if test="${flash.message}">
    <div><bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert></div>
</g:if>

<g:if test="${flash.error}">
    <div><bootstrap:alert class="alert-error">${flash.error}</bootstrap:alert></div>
</g:if>

<div>
    <h1>${packageInstance?.name}</h1>
    <g:render template="nav"/>
</div>

<div>
<h3> Institutions for ${consortia.name} consortia </h3>
<br><p> The following list displays all members of ${consortia.name} consortia. To create child subscriptions
    select the desired checkboxes and click 'Create child subscriptions'</p><br>
<g:form action="generateSlaveSubscriptions" controller="packageDetails" method="POST">
<input type="hidden" name="id" value="${id}">
<table class="ui celled table">
<thead>
    <tr>
        <th>Organisation</th>
        <th>Contains Package</th>
        <th>Create Child Subscription</th>
    </tr>
</thead>
<tbody>
    <g:each in="${consortiaInstsWithStatus}" var="pair">
        <tr>
            <td>${pair.getKey().name}</td>
            <td><g:refdataValue cat="YNO" val="${pair.getValue()}" /></td>
            <td><g:if test="${editable}"><input type="checkbox" name="_create.${pair.getKey().id}" value="true"/>
                    </g:if></td>
        </tr>
    </g:each>
</tbody>
</table>

 <dl>
<dt>Subscription name: <input type="text" name="genSubName" 
    value="Child subscription for ${packageInstance?.name}"/></dt>
<dd><input type="submit" class="ui primary button" value="Create child subscriptions"/></dd>
</dl>


</g:form>
</div>
</body>
</html>
