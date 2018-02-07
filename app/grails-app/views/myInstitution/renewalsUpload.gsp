<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser', default:'LAS:eR')} ${message(code:'myinst.renewalUpload.label', default:'Renewals Upload')}</title>
  </head>

  <body>

  <semui:breadcrumbs>
    <semui:crumb controller="myInstitution" action="dashboard" text="${institution.getDesignation()}" />
    <semui:crumb controller="myInstitution" action="currentSubscriptions" message="myinst.currentSubscriptions.label" />
    <semui:crumb message="menu.institutions.imp_renew" class="active" />
  </semui:breadcrumbs>

    <semui:form>
      <g:form class="ui form" action="renewalsUpload" method="post" enctype="multipart/form-data" params="${params}">
        <input type="file" id="renewalsWorksheet" name="renewalsWorksheet"/><br /><br />
        <button type="submit" class="ui button">${message(code:'myinst.renewalUpload.upload', default:'Upload Renewals Worksheet')}</button>
      </g:form>
    </semui:form>

    <g:if test="${(errors && (errors.size() > 0))}">
      <div>
        <ul>
          <g:each in="${errors}" var="e">
            <li>${e}</li>
          </g:each>
        </ul>
      </div>
    </g:if>

   <semui:messages data="${flash}" />

    <g:set var="counter" value="${-1}" />

      <g:form action="processRenewal" method="post" enctype="multipart/form-data" params="${params}">


        <div>
        <hr/>
          ${message(code:'myinst.renewalUpload.upload.note', args:[institution.name])}<br/>
          <table class="ui celled la-table table">
            <tbody>
            <input type="hidden" name="subscription.start_date" value="${permissionInfo?.sub_startDate}"/>
            <input type="hidden" name="subscription.end_date" value="${permissionInfo?.sub_endDate}"/>
            <input type="hidden" name="subscription.copy_docs" value="${permissionInfo?.sub_id}"/>

              <tr><th>${message(code:'default.select.label', default:'Select')}</th><th >${message(code:'myinst.renewalUpload.props', default:'Subscription Properties')}</th><th>${message(code:'default.value.label', default:'Value')}</th></tr>
              <tr>
                <th><g:checkBox name="subscription.copyStart" value="${true}" /></th>
                <th>${message(code:'default.startDate.label', default:'Start Date')}</th>
                <td>${permissionInfo?.sub_startDate}</td>
              </tr>
              <tr>
                <th><g:checkBox name="subscription.copyEnd" value="${true}" /></th>
                <th>${message(code:'default.endDate.label', default:'End Date')}</th>
                <td>${permissionInfo?.sub_endDate}</td>
              </tr>
              <tr>
                <th><g:checkBox name="subscription.copyDocs" value="${true}" /></th>
                <th>${message(code:'myinst.renewalUpload.copy', default:'Copy Documents and Notes from Subscription')}</th>
                <td>${permissionInfo?.sub_name}</td>
              </tr>
            </tbody>
          </table>
          <table class="ui celled la-table table">
            <thead>
              <tr>
                <th>${message(code:'title.label', default:'Title')}</th>
                <th>${message(code:'subscription.details.from_pkg', default:'From Pkg')}</th>
                <th>ISSN</th>
                <th>eISSN</th>
                <th>${message(code:'default.startDate.label', default:'Start Date')}</th>
                <th>${message(code:'tipp.startVolume', default:'Start Volume')}</th>
                <th>${message(code:'tipp.startIssue', default:'Start Issue')}</th>
                <th>${message(code:'default.endDate.label', default:'End Date')}</th>
                <th>${message(code:'tipp.endVolume', default:'End Volume')}</th>
                <th>${message(code:'tipp.endIssue', default:'End Issue')}</th>
                <th>${message(code:'subscription.details.core_medium', default:'Core Medium')}</th>
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
                      ${e.base_entitlement.title.title}</td>
                  <td><g:link controller="packageDetails" action="show" id="${e.base_entitlement.pkg.id}">${e.base_entitlement.pkg.name}(${e.base_entitlement.pkg.id})</g:link></td>
                  <td>${e.base_entitlement.title.getIdentifierValue('ISSN')}</td>
                  <td>${e.base_entitlement.title.getIdentifierValue('eISSN')}</td>
                  <td>${e.start_date} (Default:<g:formatDate  formatName="default.date.format.notime" date="${e.base_entitlement.startDate}"/>)</td>
                  <td>${e.base_entitlement.startVolume}</td>
                  <td>${e.base_entitlement.startIssue}</td>
                  <td>${e.end_date} (Default:<g:formatDate formatName="default.date.format.notime" date="${e.base_entitlement.endDate}"/>)</td>
                  <td>${e.base_entitlement.endVolume}</td>
                  <td>${e.base_entitlement.endIssue}</td>
                  <td>${e.core_status?:'N'}</td>
                </tr>
              </g:each>
            </tbody>
          </table>

          <div class="pull-right">
            <button type="submit" class="ui button">${message(code:'myinst.renewalUpload.accept', default:'Accept and Process')}</button>
          </div>
        </div>
        <input type="hidden" name="ecount" value="${counter}"/>
      </g:form>

  </body>
</html>
