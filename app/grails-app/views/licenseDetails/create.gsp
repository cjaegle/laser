<%@ page import="com.k_int.kbplus.Package" %>
<!doctype html>
<html>
  <head>
    <meta name="layout" content="mmbootstrap">
    <title><g:message code="default.edit.label" args="[entityName]" /></title>
  </head>
  <body>
      <div class="container">
        <div class="row">
          <div class="span12">

            <div class="page-header">
              <h1>${message(code: 'license.template.new')}</h1>
            </div>

            <g:if test="${flash.message}">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
            </g:if>

            <g:if test="${flash.error}">
            <bootstrap:alert class="alert-info">${flash.error}</bootstrap:alert>
            </g:if>

            <p>${message(code: 'license.template.howto')}</p>

            <p>
              <g:form action="processNewTemplateLicense">${message(code: 'license.template.label')} : <input type="text" name="reference"/>
              <br/><input class="btn btn-primary" type="submit" value="${message(code: 'default.button.create.label')}"/></g:form>
            </p>

          </div>
        </div>
      </div>

  </body>
</html>
