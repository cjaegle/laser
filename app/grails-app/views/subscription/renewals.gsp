<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser')} : ${message(code:'default.subscription.label')}</title>
  </head>

  <body>
    <g:render template="breadcrumb" model="${[ params:params ]}"/>
    <semui:controlButtons>
        <g:render template="actions" />
    </semui:controlButtons>
    <h1 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon />

      <g:inPlaceEdit domain="Subscription" pk="${subscriptionInstance.id}" field="name" id="name" class="newipe">${subscriptionInstance?.name}</g:inPlaceEdit>
    </h1>

    <g:render template="nav" contextPath="." />

      <g:link controller="subscription"
                    action="launchRenewalsProcess" 
                    params="${[id:params.id]}">${message(code:'subscription.details.renewals.click_here', default:'Click Here')}</g:link> ${message(code:'subscription.details.renewals.note')}
    
  </body>
</html>
