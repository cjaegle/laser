<!doctype html>
<r:require module="scaffolding" />
<html>
  <head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser', default:'LAS:eR')} Spotlight</title>
  </head>

  <body>

    <semui:breadcrumbs>
        <semui:crumb  message="spotlight.addSpotlightPage" class="active"/>
    </semui:breadcrumbs>
   <div>

    <g:if test="${flash.error}">
        <bootstrap:alert class="alert-error">${flash.error}</bootstrap:alert>
    </g:if>

    <semui:errors bean="${newPage}" />

      <div class="span6"> 
          <table class="ui celled la-table table">
              <thead>
                <tr>
                  <th>Controller</th>
                  <th>Action</th>
                  <th>Alias</th>
                  <th>Preview</th>
                  <th>Remove</th>
                </tr>
              </thead>
              
              <tbody>
              <g:each in="${pages}" var="page">
                <tr>
                  <td>
                    <semui:xEditable owner="${page}" type="text" field="controller"/>
                  </td>
                  <td>
                    <semui:xEditable owner="${page}" type="text" field="action"/>
                  </td>
                  <td>
                    <semui:xEditable owner="${page}" type="text" field="alias"/>
                  </td>
                  <td><a href="${page.getLink().url}">${page.getLink().linktext}</a></td>
                  <td>
                    <g:link controller="spotlight" action="managePages" id="${page.id}">Remove</g:link>
                  </td>
                </tr>
              </g:each>
              
              </tbody>
          </table>
      <hr>
      <h4>${message(code: "spotlight.addSpotlightPage")}</h4>
      <g:form action="managePages" method="POST">
          <table class="ui celled la-table table">
              <tr><td><label>Controller:</label></td><td><input type="text" name="newCtrl"/></td></tr>
              <tr><td><label>Action:</label></td><td><input type="text" name="newAction"/></td></tr>
              <tr><td><label>Alias:</label></td><td><input type="text" name="newAlias"/></td></tr>
              <tr><td></td><td><input type="submit" value="Add New Page" class="ui button"/></td></tr>
          </table>
      </g:form>
      <hr>
      </div>
    </div>
      <r:script language="JavaScript">
        $('.xEditableValue').editable();
      </r:script>
  </body>

</html>
