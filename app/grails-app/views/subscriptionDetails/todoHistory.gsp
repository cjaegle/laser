<!doctype html>
<html>
    <head>
        <meta name="layout" content="semanticUI"/>
        <title>${message(code:'laser', default:'LAS:eR')} ${message(code:'subscription.label', default:'Subscription')}</title>
</head>

<body>

    <g:render template="breadcrumb" model="${[ subscriptionInstance: subscription, params:params ]}"/>

    <g:render template="actions" />

    <h1 class="ui header">
        <semui:editableLabel editable="${editable}" />
        <semui:xEditable owner="${subscription}" field="name" />
    </h1>

    <g:render template="nav" contextPath="." />

      <h3 class="ui header">${message(code:'subscription.details.todo_history.label', default:'ToDo History')}</h3>

      <table  class="ui celled striped table">
          <thead>
            <tr>
              <th>${message(code:'subscription.details.todo_history.descr', default:'ToDo Description')}</th>
              <th>${message(code:'subscription.details.todo_history.outcome', default:'Outcome')}</th>
              <th>${message(code:'default.date.label', default:'Date')}</th>
            </tr>
          </thead>
        <g:if test="${todoHistoryLines}">
          <g:each in="${todoHistoryLines}" var="hl">
            <tr>
              <td>${hl.desc}</td>
              <td>${hl.status?.value?:'Pending'}
                <g:if test="${((hl.status?.value=='Accepted')||(hl.status?.value=='Rejected'))}">
                  ${message(code:'subscription.details.todo_history.by_on', args:[hl.user?.display?:hl.user?.username])} <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${hl.actionDate}"/>
                </g:if>
              </td>
              <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${hl.ts}"/></td>
            </tr>
          </g:each>
        </g:if>
      </table>

        <semui:paginate  action="todoHistory" controller="subscriptionDetails" params="${params}" next="${message(code:'default.paginate.next', default:'Next')}" prev="${message(code:'default.paginate.prev', default:'Prev')}" max="${max}" total="${todoHistoryLinesTotal}" />

</body>
</html>