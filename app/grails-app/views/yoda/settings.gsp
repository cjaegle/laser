<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser')} : ${message(code:'menu.yoda.systemSettings')}</title>
  </head>

  <body>

    <semui:breadcrumbs>
      <semui:crumb message="menu.yoda.dash" controller="yoda" action="index"/>
      <semui:crumb message="menu.yoda.systemSettings" class="active"/>
    </semui:breadcrumbs>

    <div>
      <h2 class="ui header">${message(code:'menu.yoda.systemSettings')}</h2>

      <table class="ui celled la-table table">
        <thead>
          <tr>
            <th>Setting</th>
            <th>Value</th>
          </tr>
        </thead>
        <tbody>
          <g:each in="${settings}" var="s">
            <tr>
              <td>${s.name}</td>
              <td>
                <g:if test="${s.tp==1}">
                  <g:link controller="yoda" action="toggleBoolSetting" params="${[setting:s.name]}">${s.value}</g:link>
                </g:if>
              </td>
            </tr>
          </g:each>
        </tbody>
      </table>
    </div>
  </body>
</html>
