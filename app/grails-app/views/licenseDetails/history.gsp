<!doctype html>
<html>
    <head>
        <meta name="layout" content="semanticUI"/>
        <title>${message(code:'laser', default:'LAS:eR')} ${message(code:'license.label', default:'License')}</title>
</head>

<body>

    <g:render template="breadcrumb" model="${[ license:license, params:params ]}"/>

    <h1 class="ui header"><semui:headerIcon />

        ${license.licensee?.name} ${license.type?.value} ${message(code:'license.label', default:'License')} : ${license.reference}
    </h1>

    <g:render template="nav" />

      <table  class="ui celled la-table table">
          <thead>
            <tr>
              <th>${message(code:'default.eventID.label', default:'Event ID')}</th>
              <th>${message(code:'person.label', default:'Person')}</th>
              <th>${message(code:'default.date.label', default:'Date')}</th>
              <th>${message(code:'default.event.label', default:'Event')}</th>
              <th>${message(code:'default.field.label', default:'Field')}</th>
              <th>${message(code:'default.oldValue.label', default:'Old Value')}</th>
              <th>${message(code:'default.newValue.label', default:'New Value')}</th>
            </tr>
          </thead>
        <g:if test="${historyLines}">
          <g:each in="${historyLines}" var="hl">
            <tr>
              <td>${hl.id}</td>
              <td style="white-space:nowrap;">${hl.actor}</td>
              <td style="white-space:nowrap;">${hl.dateCreated}</td>
              <td style="white-space:nowrap;">${hl.eventName}</td>
              <td style="white-space:nowrap;">${hl.propertyName}</td>
              <td>${hl.oldValue}</td>
              <td>${hl.newValue}</td>
            </tr>
          </g:each>
        </g:if>
      </table>

        <semui:paginate  action="editHistory" controller="licenseDetails" params="${params}" next="${message(code:'default.paginate.next', default:'Next')}" prev="${message(code:'default.paginate.prev', default:'Prev')}" max="${max}" total="${historyLinesTotal}" />

</body>
</html>
