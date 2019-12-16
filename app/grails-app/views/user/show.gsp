<%@ page import="com.k_int.kbplus.Org" %>
<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI">
    <title>${user.display}</title>
  </head>
  <body>

      <g:render template="breadcrumb" model="${[ params:params ]}"/>

      <semui:controlButtons>
        <g:render template="actions" />
      </semui:controlButtons>

      <h1 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon />${user.username} : ${user.displayName?:'No username'}</h1>

      <semui:messages data="${flash}" />

      <h3 class="ui header">${message(code:'user.affiliation.plural', default:'Affiliations')}</h3>

      <table class="ui celled la-table table">
        <thead>
          <tr>
            <th>${message(code:'user.id', default:'Id')}</th>
            <th>${message(code:'user.org', default:'Org')}</th>
            <th>${message(code:'user.role', default:'Role')}</th>
            <th>${message(code:'user.status', default:'Status')}</th>
          </tr>
        </thead>
        <tbody>
          <g:each in="${user.affiliations}" var="af">
            <tr>
              <td>${af.id}</td>
              <td>${af.org.name}</td>
              <td>${af.formalRole?.authority}</td>
              <td>${message(code:"cv.membership.status.${af.status}")}</td>
            </tr>
          </g:each>
        </tbody>
      </table>

      <h3 class="ui header">${message(code:'user.role.plural', default:'Roles')}</h3>

      <table class="ui celled la-table table">
        <thead>
          <tr>
            <th>${message(code:'user.role', default:'Role')}</th>
          </tr>
        </thead>
        <tbody>
          <g:each in="${user.roles}" var="rl">
            <tr>
              <td>${rl.role.authority}</td>
            </tr>
          </g:each>
        </tbody>
      </table>
  </body>
</html>
