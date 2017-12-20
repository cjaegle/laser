<%@ page import="com.k_int.kbplus.TitleInstance" %>
<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI">
    <title>${message(code:'tipp.show.label', args:[titleInstanceInstance?.title,tipp.pkg.name,tipp.platform.name])}</title>
  </head>
  <body>

    <semui:breadcrumbs>
      <semui:crumb controller="packageDetails" action="show" id="${tipp.pkg.id}" text="${tipp.pkg.name} [${message(code:'package.label', default:'package')}]" />
      <semui:crumb text="${tipp.title.title} [${message(code:'title.label', default:'title')}]" class="active" />
    </semui:breadcrumbs>

    <h1 class="ui header">
      <semui:editableLabel editable="${editable}" />
      ${message(code:'tipp.show.label', args:[titleInstanceInstance?.title,tipp.pkg.name,tipp.platform.name])}
    </h1>

    <semui:messages data="${flash}" />

  <div class="inline-lists">
        <dl>
          <g:if test="${titleInstanceInstance?.ids}">
            <dt><g:message code="titleInstance.ids.label" default="Ids" /></dt>
            
              <dd><g:each in="${titleInstanceInstance.ids}" var="i">
                <g:if test="${i.identifier.ns.ns != 'originediturl'}">
                  ${i.identifier.ns.ns}:${i.identifier.value}<br/>
                </g:if>
                <g:else>
                  GOKb: <a href="${i.identifier.value}">${message(code:'component.originediturl.label')}</a><br/>
                </g:else>
              </g:each>
              </dd>
            
          </g:if>
        </dl>

          <dl><!-- TODO: error? -->
              <dt><g:message code="titleInstance.globalUID.label" default="Global UID" /></dt>
              <dd> <g:fieldValue bean="${titleInstanceInstance}" field="globalUID"/> </dd>
          </dl>

        <dl>
          <dt>${message(code:'tipp.show.avStatus', default:'Availability Status')}</dt>
          <dd> <span title="${tipp.availabilityStatusExplanation}">${tipp.availabilityStatus?.value}</span></dd>
        </dl>
        <dl>
          <dt>${message(code:'tipp.show.accessStart', default:'Access Start Date (Enters Package)')}</dt>
          <dd><semui:xEditable owner="${tipp}" type="date" field="accessStartDate" /></dd>
        </dl>
        <dl>
          <dt>${message(code:'tipp.show.accessEnd', default:'Access End Date (Leaves Package)')}</dt>
          <dd><semui:xEditable owner="${tipp}" type="date" field="accessEndDate" /></dd>
        </dl>
        <dl>
          <dt>${message(code:'tipp.show.tippStartDate', default:'TIPP Start Date')}</dt>
          <dd><semui:xEditable owner="${tipp}" type="date" field="startDate"/></dd>
        </dl>
        <dl>
          <dt>${message(code:'tipp.show.tippStartVol', default:'TIPP Start Volume')}</dt>
          <dd><semui:xEditable owner="${tipp}" field="startVolume"/></dd>
        </dl>
        <dl>
          <dt>${message(code:'tipp.show.tippStartIss', default:'TIPP Start Issue')}</dt>
          <dd><semui:xEditable owner="${tipp}" field="startIssue"/></dd>
        </dl>
        <dl>

          <dt>${message(code:'tipp.show.tippEndDate', default:'TIPP End Date')}</dt>
          <dd><semui:xEditable owner="${tipp}"  type="date" field="endDate"/></dd>
        </dl>
        <dl>

          <dt>${message(code:'tipp.show.tippEndVol', default:'TIPP End Volume')}</dt>
          <dd><semui:xEditable owner="${tipp}" field="endVolume"/></dd>
        </dl>
        <dl>

          <dt>${message(code:'tipp.show.tippEndIss', default:'TIPP End Issue')}</dt>
          <dd><semui:xEditable owner="${tipp}" field="endIssue"/></dd>
        </dl>
        <dl>

          <dt>${message(code:'tipp.coverageDepth', default:'Coverage Depth')}</dt>
          <dd><semui:xEditable owner="${tipp}" field="coverageDepth"/></dd>
        </dl>
        <dl>

          <dt>${message(code:'tipp.coverageNote', default:'Coverage Note')}</dt>
          <dd><semui:xEditable owner="${tipp}" field="coverageNote"/></dd>
        </dl>
        <dl>

          <dt>${message(code:'tipp.embargo', default:'Embargo')}</dt>
          <dd><semui:xEditable owner="${tipp}" field="embargo"/></dd>
        </dl>
        <dl>

          <dt>${message(code:'tipp.hostPlatformURL', default:'Host Platform URL')}</dt>
          <dd><semui:xEditable type="text" owner="${tipp}" field="hostPlatformURL"/></dd>
        </dl>
        <dl>

          <dt>${message(code:'default.status.label', default:'Status')}</dt>
          <dd><semui:xEditableRefData owner="${tipp}" field="status" config='TIPP Status'/><dd>
        </dl>
        <dl>

          <dt>${message(code:'tipp.show.statusReason', default:'Status Reason')}</dt>
          <dd><semui:xEditableRefData owner="${tipp}" field="statusReason" config="Tipp.StatusReason"/><dd>
        </dl>

        <dl>
          <dt>${message(code:'tipp.delayedOA', default:'Delayed OA')}</dt>
          <dd><semui:xEditableRefData owner="${tipp}" field="delayedOA" config='TitleInstancePackagePlatform.DelayedOA'/><dd>
        </dl>

        <dl>
          <dt>${message(code:'tipp.hybridOA', default:'Hybrid OA')}</dt>
          <dd><semui:xEditableRefData owner="${tipp}" field="hybridOA" config='TitleInstancePackagePlatform.HybridOA'/><dd>
        </dl>

        <dl>
          <dt>${message(code:'tipp.paymentType', default:'Payment')}</dt>
          <dd><semui:xEditableRefData owner="${tipp}" field="payment" config='TitleInstancePackagePlatform.PaymentType'/><dd>
        </dl>

        <dl>
          <dt>${message(code:'tipp.host_platform', default:'Host Platform')}</dt>
          <dd>${tipp.platform.name}</dd>
        </dl>
        <dl>
          <dt style="margin-top:10px">${message(code:'tipp.additionalPlatforms', default:'Additional Platforms')}</dt>
          <dd>
            <table class="ui celled table">
              <thead>
                <tr><th>${message(code:'default.relation.label', default:'Relation')}</th><th>${message(code:'tipp.show.platformName', default:'Platform Name')}</th><th>${message(code:'platform.primaryURL', default:'Primary URL')}</th></tr>
              </thead>
              <tbody>
                <g:each in="${tipp.additionalPlatforms}" var="ap">
                  <tr>
                    <td>${ap.rel}</td>
                    <td>${ap.platform.name}</td>
                    <td>${ap.platform.primaryUrl}</td>
                  </tr>
                </g:each>
              </tbody>
            </table>
          </dd>
        </dl>



          <g:if test="${titleInstanceInstance?.tipps}">
            <dl>
            <dt><g:message code="titleInstance.tipps.label" default="${message(code:'titleInstance.tipps.label', default:'Occurences of this title against Packages / Platforms')}" /></dt>
            <dd>

                <semui:filter>
                   <g:form action="show" params="${params}" method="get" class="ui form">
                      <input type="hidden" name="sort" value="${params.sort}">
                      <input type="hidden" name="order" value="${params.order}">
                      <label>${message(code:'tipp.show.filter_pkg', default:'Filters - Package Name')}:</label> <input name="filter" value="${params.filter}"/> &nbsp;
                      &nbsp; <label>${message(code:'default.startsBefore.label', default:'Starts Before')}: </label>
                      <semui:simpleHiddenValue id="startsBefore" name="startsBefore" type="date" value="${params.startsBefore}"/>
                      &nbsp; <label>${message(code:'default.endsAfter.label', default:'Ends After')}: </label>
                      <semui:simpleHiddenValue id="endsAfter" name="endsAfter" type="date" value="${params.endsAfter}"/>
                      <input type="submit" class="ui button" value="${message(code:'default.button.submit.label', default:'Submit')}">
                    </g:form>
                </semui:filter>

            <table class="ui celled table">
              <thead>
              <tr>
                <th>${message(code:'tipp.coverage_start')}</th>
                <th>${message(code:'tipp.coverage_end')}</th>
                <th>${message(code:'tipp.coverageDepth', default:'Coverage Depth')}</th>
                <th>${message(code:'platform.label', default:'Platform')}</th>
                <th>${message(code:'package.label', default:'Package')}</th>
                <th>${message(code:'default.actions.label', default:'Actions')}</th>
              </tr>
              </thead>
              <tbody>
              <g:each in="${tippList}" var="t">
                <tr>
                  <td>
                    <div>
                      <span>${message(code:'default.date.label', default:'Date')}: <g:formatDate format="${message(code:'default.date.format.notime', default:'yyyy-MM-dd')}" date="${t.startDate}"/></span>
                    </div>
                    <div>
                      <span>${message(code:'tipp.volume', default:'Volume')}: ${t.startVolume}</span>
                    </div>
                    <div>
                      <span>${message(code:'tipp.issue', default:'Issue')}: ${t.startIssue}</span>
                    </div>
                  </td>
                  <td>
                    <div>
                      <span>${message(code:'default.date.label', default:'Date')}: <g:formatDate format="${message(code:'default.date.format.notime', default:'yyyy-MM-dd')}" date="${t.endDate}"/></span>
                    </div>
                    <div>
                      <span>${message(code:'tipp.volume', default:'Volume')}: ${t.endVolume}</span>
                    </div>
                    <div>
                      <span>${message(code:'tipp.issue', default:'Issue')}: ${t.endIssue}</span>
                    </div>
                  </td>
                  <td>${t.coverageDepth}</td>
                  <td><g:link controller="platform" action="show" id="${t.platform.id}">${t.platform.name}</g:link></td>
                  <td><g:link controller="packageDetails" action="show" id="${t.pkg.id}">${t.pkg.name} (${t.pkg.contentProvider?.name})</g:link></td>
                  <td></td>
                </tr>
              </g:each>
              </tbody>
            </table>
            </dd>
            </dl>
          </g:if>
    </div>
  </body>
</html>
