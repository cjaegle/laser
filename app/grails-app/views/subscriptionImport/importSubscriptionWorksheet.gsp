<!doctype html>
<html>
  <head>
    <meta name="layout" content="mmbootstrap"/>
    <title>${message(code:'laser', default:'LAS:eR')} ${message(code:'myinst.renewalUpload.label', default:'Renewals Upload')}</title>
  </head>

  <body>
    <div class="container">
      <g:form action="importSubscriptionWorksheet" method="post" enctype="multipart/form-data" params="${params}">
        <input type="file" id="renewalsWorksheet" name="renewalsWorksheet"/>
        <button type="submit" class="btn btn-primary"><g:message code="subscription.upload.worksheet" default="Upload New Subscription Taken Worksheet"/></button>
      </g:form>
    </div>

    <g:if test="${(errors && (errors.size() > 0))}">
      <div class="container">
        <ul>
          <g:each in="${errors}" var="e">
            <li>${e}</li>
          </g:each>
        </ul>
      </div>
    </g:if>

    <g:if test="${flash.message}">
      <div class="container">
        <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
      </div>
    </g:if>

    <g:if test="${flash.error}">
      <div class="container">
        <bootstrap:alert class="error-info">${flash.error}</bootstrap:alert>
      </div>
    </g:if>


    <g:set var="counter" value="${-1}" />

    <g:if test="${1==1}">
      <g:form  action="processSubscriptionImport" method="post" params="${params}" enctype="multipart/form-data" >
        <div class="container"> 
        <g:if test="${subOrg!=null}">
          ${message(code:'subscription.import.upload.note', default:'Import will create a subscription for')} ${subOrg.name}
          <input type="hidden" name="orgId" value="${subOrg.id}"/>
        </g:if>
        <hr/>
          <table class="table table-bordered">
            <thead>
              <tr>
                <td>${message(code:'title.label', default:'Title')}</td>
                <td>${message(code:'subscription.details.from_pkg', default:'From Pkg')}</td>
                <td>ISSN</td>
                <td>eISSN</td>
                <td>${message(code:'default.startDate.label', default:'Start Date')}</td>
                <td>${message(code:'tipp.startVolume', default:'Start Volume')}</td>
                <td>${message(code:'tipp.startIssue', default:'Start Issue')}</td>
                <td>${message(code:'default.endDate.label', default:'End Date')}</td>
                <td>${message(code:'tipp.endVolume', default:'End Volume')}</td>
                <td>${message(code:'tipp.endIssue', default:'End Issue')}</td>
                <td>${message(code:'subscription.details.core_medium', default:'Core Medium')}</td>
              </tr>
            </thead>
            <tbody>
              <g:each in="${entitlements}" var="e">
                <tr>
                  <td><input type="hidden" name="entitlements.${++counter}.tipp_id" value="${e.base_entitlement.id}"/>
                      <input type="hidden" name="entitlements.${counter}.core_status" value="${e.core_status}"/>
                      <input type="hidden" name="entitlements.${counter}.start_date" value="${e.start_date}"/>
                      <input type="hidden" name="entitlements.${counter}.end_date" value="${e.end_date}"/>
                      <input type="hidden" name="entitlements.${counter}.coverage" value="${e.coverage}"/>
                      <input type="hidden" name="entitlements.${counter}.coverage_note" value="${e.coverage_note}"/>
                      <input type="hidden" name="entitlements.${counter}.core_start_date" value="${e.core_start_date}"/>
                      <input type="hidden" name="entitlements.${counter}.core_end_date" value="${e.core_end_date}"/>
                      ${e.base_entitlement.title.title}</td>
                  <td><g:link controller="packageDetails" action="show" id="${e.base_entitlement.pkg.id}">${e.base_entitlement.pkg.name}(${e.base_entitlement.pkg.id})</g:link></td>
                  <td>${e.base_entitlement.title.getIdentifierValue('ISSN')}</td>
                  <td>${e.base_entitlement.title.getIdentifierValue('eISSN')}</td>
                  <td>${e.start_date} (Default:<g:formatDate format="${message(code:'default.date.format.notime', default:'yyyy-MM-dd')}" date="${e.base_entitlement.startDate}"/>)</td>
                  <td>${e.base_entitlement.startVolume}</td>
                  <td>${e.base_entitlement.startIssue}</td>
                  <td>${e.end_date} (Default:<g:formatDate format="${message(code:'default.date.format.notime', default:'yyyy-MM-dd')}" date="${e.base_entitlement.endDate}"/>)</td>
                  <td>${e.base_entitlement.endVolume}</td>
                  <td>${e.base_entitlement.endIssue}</td>
                  <td>${e.core_status?:'N'}</td>
                </tr>
              </g:each>
            </tbody>
          </table>
          <input type="hidden" name="ecount" value="${counter}"/>

          <div class="pull-right">
            <button type="submit" class="btn btn-primary">${message(code:'myinst.renewalUpload.accept', default:'Accept and Process')}</button>
          </div>
        </div>
      </g:form>
    </g:if>

  </body>
</html>
