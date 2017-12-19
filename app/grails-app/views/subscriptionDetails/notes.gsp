<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser', default:'LAS:eR')} ${message(code:'subscription.label', default:'Subscription')}</title>
  </head>

    <body>

        <semui:breadcrumbs>
            <g:if test="${params.shortcode}">
                <semui:crumb controller="myInstitutions" action="currentSubscriptions" params="${[shortcode:params.shortcode]}" text="${params.shortcode} - ${message(code:'myinst.currentSubscriptions.label', default:'Current Subscriptions')}" />
            </g:if>
            <semui:crumb controller="subscriptionDetails" action="index" id="${subscriptionInstance.id}"  text="${subscriptionInstance.name}" />
            <semui:crumb class="active" text="${message(code:'default.notes.label', default:'Notes')}" />
        </semui:breadcrumbs>

        <g:render template="actions" />

        <h1 class="ui header">
            <semui:editableLabel editable="${editable}" />
            <semui:xEditable owner="${subscriptionInstance}" field="name" />
        </h1>

        <g:render template="nav" />

        <g:render template="/templates/notes_table" model="${[instance: subscriptionInstance, redirect: 'notes']}"/>

        <g:render template="/templates/addNote"
            model="${[doclist: subscriptionInstance.documents, ownobj: subscriptionInstance, owntp: 'subscription']}"/>
    
  </body>
</html>
