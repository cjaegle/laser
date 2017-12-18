<%@ page import="com.k_int.kbplus.Package" %>
<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI">
    <g:set var="entityName" value="${message(code: 'package.label', default: 'Package')}" />
    <title><g:message code="default.edit.label" args="[entityName]" /></title>
  </head>
  <body>
      <div>


          <h1 class="ui header">${message(code:'menu.datamanager.uploadPackage', default:'Upload New Package')}</h1>


        <semui:messages data="${flash}" />

        <semui:errors bean="${packageInstance}" />

        <g:form action="reviewPackage" method="post" enctype="multipart/form-data">
            ${message(code:'package.upload.file', default:'Upload File')}: <input type="file" id="soFile" name="soFile"/><br/>

            ${message(code:'package.upload.docStyle', default:'Doc Style')}: <select name="docstyle">
              <option value="csv" selected>${message(code:'package.upload.docStyle.csv', default:'Comma Separated')}</option>
              <option value="tsv">${message(code:'package.upload.docStyle.tsv', default:'Tab Separated')}</option>
            </select></br>

            ${message(code:'package.upload.override', default:'Override Character Set Test')}: <input style="vertical-align:text-bottom;margin-right:10px;" type="checkbox" name="OverrideCharset" checked="false"/>

            <button type="submit" class="ui button">${message(code:'package.upload.upload', default:'Upload Package')}</button>
        </g:form>
        
        <br/>

        <g:if test="${validationResult}">
          <g:if test="${validationResult.stats != null}">
            <h3 class="ui header">${message(code:'default.stats.label', default:'Stats')}</h3>
            <ul>
              <g:each in="${validationResult?.stats}" var="msg">
                <li>${msg.key} = ${msg.value}</li>
              </g:each>
            </ul>
          </g:if>

          <g:each in="${validationResult?.messages}" var="msg">
            <div class="alert alert-error">${msg}</div>
          </g:each>

          <hr/>

          <g:if test="${validationResult.processFile==true}">
            <bootstrap:alert class="alert-success">${message(code:'package.upload.passed', default:'File passed validation checks, new SO details follow')}:<br/>
              <g:link controller="packageDetails" action="show" id="${validationResult.new_pkg_id}">${message(code:'package.upload.details', default:'New Package Details')}</g:link><br/>
            </bootstrap:alert>
          </g:if>
          <g:else>
            <div class="alert alert-error">${message(code:'package.upload.failed', default:'File failed validation checks, details follow')}</div>
          </g:else>
          <table class="ui table">
            <tbody>
              <g:each in="${['soName', 'soIdentifier', 'soProvider', 'soPackageIdentifier', 'soPackageName', 'aggreementTermStartYear', 'aggreementTermEndYear', 'consortium', 'numPlatformsListed']}" var="fld">
                <tr>
                  <td>${fld}</td>
                  <td>${validationResult[fld]?.value} 
                    <g:if test="${validationResult[fld]?.messages != null}">
                      <hr/>
                      <g:each in="${validationResult[fld]?.messages}" var="msg">
                        <div class="alert alert-error">${msg}</div>
                      </g:each>
                    </g:if>
                  </td>
                </tr>
              </g:each>
            </tbody>
          </table>

          <table class="ui table">
            <thead>
              <tr>
                <g:each in="${validationResult.soHeaderLine}" var="c">
                  <th>${c}</th>
                </g:each>
              </tr>
            </thead>
            <tbody>
              <g:each in="${validationResult.tipps}" var="tipp">
              
                <tr>
                  <g:each in="${tipp.row}" var="c">
                    <td>${c}</td>
                  </g:each>
                </tr>
                
                <g:if test="${tipp.messages?.size() > 0}">
                  <tr>
                    <td colspan="${validationResult.soHeaderLine.size()}">
                      <ul>
                        <g:each in="${tipp.messages}" var="msg">
                          <g:if test="${msg instanceof java.lang.String || msg instanceof org.codehaus.groovy.runtime.GStringImpl}">
                            <div class="alert alert-error">${msg}</div>
                          </g:if>
                          <g:else>
                            <div class="alert ${msg.type}">${msg.message}</div>
                          </g:else>
                        </g:each>
                      </ul>
                    </td>
                  </tr>
                </g:if>
              </g:each>
            </tbody>
          </table>
          
        </g:if>
        
      </div>

  </body>
</html>
