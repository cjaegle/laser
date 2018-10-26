<%@ page import="com.k_int.kbplus.IssueEntitlement" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="semanticUI">
    <g:set var="entityName" value="${message(code: 'issueEntitlement.label', default: 'IssueEntitlement')}" />
    <title><g:message code="default.show.label" args="[entityName]" /></title>
</head>
<body>
    <semui:breadcrumbs>
        <g:if test="${issueEntitlementInstance?.subscription.subscriber}">
            <semui:crumb controller="myInstitution" action="currentSubscriptions" params="${[shortcode:issueEntitlementInstance?.subscription.subscriber.shortcode]}" text="${issueEntitlementInstance?.subscription.subscriber.name} - ${message(code:'subscription.plural', default:'Subscriptions')}"/>
        </g:if>
        <semui:crumb controller="subscriptionDetails" action="index" id="${issueEntitlementInstance?.subscription.id}"  text="${issueEntitlementInstance?.subscription.name}" />
        <semui:crumb class="active" id="${issueEntitlementInstance?.id}" text="${issueEntitlementInstance?.tipp.title.title}" />
    </semui:breadcrumbs>

    <h1 class="ui header"><semui:headerTitleIcon type="${issueEntitlementInstance?.tipp?.title.type.getI10n('value')}"/>

        ${message(code:'issueEntitlement.for_title.label', default:'Issue Entitlements for')} "${issueEntitlementInstance?.tipp.title.title}"
    </h1>

    <semui:messages data="${flash}" />

        <div class="inline-lists">

            <dl>
                <g:if test="${issueEntitlementInstance?.subscription}">
                    <dt><g:message code="subscription.label" default="Subscription" /></dt>

                    <dd><g:link controller="subscriptionDetails" action="index" id="${issueEntitlementInstance?.subscription?.id}">${issueEntitlementInstance?.subscription?.name}</g:link></dd>

                </g:if>
            <g:if test="${issueEntitlementInstance?.subscription.owner}">
                <dt><g:message code="licence.label" default="License" /></dt>

                <dd><g:link controller="licenseDetails" action="show" id="${issueEntitlementInstance?.subscription?.owner.id}">${issueEntitlementInstance?.subscription?.owner.reference}</g:link></dd>

            </g:if>
            <g:if test="${issueEntitlementInstance?.subscription?.owner?.onixplLicense}">
                <dt><g:message code="onixplLicence.licence.label" default="ONIX-PL Licence" /></dt>

                <dd><g:link controller="onixplLicenseDetails" action="index" id="${issueEntitlementInstance.subscription.owner.onixplLicense.id}">${issueEntitlementInstance.subscription.owner.onixplLicense.title}</g:link></dd>
            </g:if>

            <g:if test="${issueEntitlementInstance?.tipp}">
                    <dt><g:message code="title.label" default="Title" /></dt>
                    <dd><g:link controller="titleDetails" action="show" id="${issueEntitlementInstance?.tipp?.title.id}">${issueEntitlementInstance?.tipp?.title.title}</g:link> (${message(code:'title.type.label')}: ${issueEntitlementInstance?.tipp?.title.type.getI10n('value')})</dd>
                    <dt><g:message code="tipp.delayedOA" default="TIPP Delayed OA" /></dt>
                    <dd>${issueEntitlementInstance?.tipp.delayedOA?.value}</dd>
                    <dt><g:message code="tipp.hybridOA" default="TIPP Hybrid OA" /></dt>
                    <dd>${issueEntitlementInstance?.tipp.hybridOA?.value}</dd>
                    <dt><g:message code="tipp.show.accessStart" default="Date Title Joined Package" /></dt>
                    <dd><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${issueEntitlementInstance.tipp.accessStartDate}"/></dd>
            </g:if>

                <g:if test="${issueEntitlementInstance?.tipp.title?.ids}">
                    <dt>${message(code:'title.identifiers.label', default:'Title Identifiers')}</dt>
                    <dd><ul>
                      <g:each in="${issueEntitlementInstance?.tipp.title?.ids.sort{it.identifier.ns.ns}}" var="i">
                          <li>${i.identifier.ns.ns}: <g:if test="${i.identifier.ns.ns == 'originediturl'}"><a href="${i.identifier.value}">${i.identifier.value}</a></g:if><g:else>${i.identifier.value}</g:else>
<!--                            <g:if test="${i.identifier.ns.ns.equalsIgnoreCase('issn')}">
                              (<a href="http://suncat.edina.ac.uk/F?func=find-c&ccl_term=022=${i.identifier.value}">search on SUNCAT</a>)
                            </g:if>
                            <g:if test="${i.identifier.ns.ns.equalsIgnoreCase('eissn')}">
                              (<a href="http://suncat.edina.ac.uk/F?func=find-c&ccl_term=022=${i.identifier.value}">search on SUNCAT</a>)
                            </g:if>-->
                          </li>
                      </g:each>
                    <ul></dd>

                </g:if>


                <dt><g:message code="issueEntitlement.globalUID.label" default="Global UID" /></dt>
                <dd>
                    <g:fieldValue bean="${issueEntitlementInstance}" field="globalUID"/>
                </dd>


                <g:if test="${issueEntitlementInstance?.coreStatus}">
                    <dt>${message(code:'subscription.details.core_medium', default:'Core Medium')}</dt>
                    <dd><semui:xEditableRefData owner="${issueEntitlementInstance}" field="coreStatus" config='CoreStatus'/> </dd>
                </g:if>
              <g:set var="iecorestatus" value="${issueEntitlementInstance.getTIP()?.coreStatus(null)}"/>
<%--<dt>${message(code:'subscription.details.core_status', default:'Core Status')}</dt>
<dd>
  <g:render template="/templates/coreStatus" model="${['issueEntitlement': issueEntitlementInstance]}"/>
</dd> --%>

  <g:if test="${issueEntitlementInstance?.tipp.hostPlatformURL}">
      <dt>${message(code:'tipp.hostPlatformURL', default:'Title URL')}</dt>
      <dd> <a href="${issueEntitlementInstance.tipp?.hostPlatformURL.contains('http') ?:'http://'+issueEntitlementInstance.tipp?.hostPlatformURL}" target="_blank" TITLE="${issueEntitlementInstance.tipp?.hostPlatformURL}">${issueEntitlementInstance.tipp.platform.name}</a></dd>
  </g:if>
</dl>

<br/>

<h3 class="ui header"><strong>${message(code:'issueEntitlement.subscription_access.label', default:'Access through subscription')}</strong> : ${issueEntitlementInstance.subscription.name}</h3>

<table class="ui celled la-table table">
  <thead>
      <tr>
          <th>${message(code:'tipp.startDate', default:'From Date')}</th><th>${message(code:'tipp.startVolume', default:'From Volume')}</th><th>${message(code:'tipp.startIssue', default:'From Issue')}</th>
          <th>${message(code:'tipp.startDate', default:'To Date')}</th><th>${message(code:'tipp.endVolume', default:'To Volume')}</th><th>${message(code:'tipp.endIssue', default:'To Issue')}</th>
      </tr>
  </thead>
  <tbody>
      <tr>
        <td><semui:xEditable owner="${issueEntitlementInstance}" field="startDate" type="date"/></td>
        <td><semui:xEditable owner="${issueEntitlementInstance}" field="startVolume"/></td>
        <td><semui:xEditable owner="${issueEntitlementInstance}" field="startIssue"/></td>
        <td><semui:xEditable owner="${issueEntitlementInstance}" field="endDate" type="date"/></td>
        <td><semui:xEditable owner="${issueEntitlementInstance}" field="endVolume"/></td>
        <td><semui:xEditable owner="${issueEntitlementInstance}" field="endIssue"/></td>
      </tr>
  </tbody>
</table>

<dl>
  <dt>${message(code:'tipp.embargo', default:'Embargo')}</dt>
  <dd><semui:xEditable owner="${issueEntitlementInstance}" field="embargo"/></dd>
</dl>

<dl>
  <dt>${message(code:'tipp.coverageDepth', default:'Coverage Depth')}</dt>
  <dd><semui:xEditable owner="${issueEntitlementInstance}" field="coverageDepth"/></dd>
</dl>

<dl>
  <dt>${message(code:'tipp.coverageNote', default:'Coverage Note')}</dt>
  <dd><semui:xEditable owner="${issueEntitlementInstance}" field="coverageNote"/></dd>
</dl>

<br/>

<h3 class="ui header"><strong>${message(code:'issueEntitlement.package_defaults.label', default:'Defaults from package')}</strong> : ${issueEntitlementInstance.tipp.pkg.name}</h3>

<table class="ui celled la-table table">
  <thead>
      <tr>
          <th>${message(code:'tipp.startDate', default:'From Date')}</th><th>${message(code:'tipp.startVolume', default:'From Volume')}</th><th>${message(code:'tipp.startIssue', default:'From Issue')}</th>
          <th>${message(code:'tipp.startDate', default:'To Date')}</th><th>${message(code:'tipp.endVolume', default:'To Volume')}</th><th>${message(code:'tipp.endIssue', default:'To Issue')}</th>
      </tr>
  </thead>
  <tbody>
      <tr>
        <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${issueEntitlementInstance.tipp.startDate}"/></td>
        <td>${issueEntitlementInstance.tipp.startVolume}</td>
        <td>${issueEntitlementInstance.tipp.startIssue}</td>
        <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${issueEntitlementInstance.tipp.endDate}"/></td>
        <td>${issueEntitlementInstance.tipp.endVolume}</td>
        <td>${issueEntitlementInstance.tipp.endIssue}</td>
      </tr>
  </tbody>
</table>

<dl>
  <dt>${message(code:'tipp.embargo', default:'Embargo')} (tipp)</dt>
  <dd>${issueEntitlementInstance.tipp.embargo}</dd>
</dl>

<dl>
  <dt>${message(code:'tipp.coverageDepth', default:'Coverage Depth')}</dt>
  <dd>${issueEntitlementInstance.tipp.coverageDepth}</dd>
</dl>

<dl>
  <dt>${message(code:'tipp.coverageNote', default:'Coverage Note')}</dt>
  <dd>${issueEntitlementInstance.tipp.coverageNote}</dd>
</dl>

<g:if test="${(institutional_usage_identifier) && ( usage != null ) && ( usage.size() > 0 ) }">
<span class="pull-right">
    <laser:statsLink class="ui basic negative"
                     base="${grailsApplication.config.statsApiUrl}"
                     module="statistics"
                     controller="default"
                     action="select"
                     target="_blank"
                     params="[mode:usageMode,
                              packages:issueEntitlementInstance.subscription.getCommaSeperatedPackagesIsilList(),
                              vendors     : natStatSupplierId,
                              institutions:statsWibid
                     ]"
                     title="Springe zu Statistik im Nationalen Statistikserver">
        <i class="chart bar outline icon"></i>
    </laser:statsLink>
</span>
<h3 class="ui header">${message(code:'default.usage.header')}</h3>
<table class="ui celled la-table table">
    <thead>
    <tr>
        <th>${message(code: 'default.usage.reportType')}</th>
        <g:each in="${x_axis_labels}" var="l">
            <th>${l}</th>
        </g:each>
    </tr>
    </thead>
    <tbody>
    <g:set var="counter" value="${0}"/>
    <g:each in="${usage}" var="v">
        <tr>
          <g:set var="reportMetric" value="${y_axis_labels[counter++]}" />
            <td>${reportMetric}</td>
            <g:each in="${v}" status="i" var="v2">
                <td>
                    <laser:statsLink
                            base="${grailsApplication.config.statsApiUrl}"
                            module="statistics"
                            controller="default"
                            action="select"
                            target="_blank"
                            params="[mode        : usageMode,
                                     packages    : issueEntitlementInstance.subscription.getCommaSeperatedPackagesIsilList(),
                                     vendors     : natStatSupplierId,
                                     institutions: statsWibid,
                                     reports     : reportMetric.split(':')[0],
                                     years: x_axis_labels[i]
                            ]"
                            title="Springe zu Statistik im Nationalen Statistikserver">
                        ${v2}
                    </laser:statsLink>
                </td>
            </g:each>
        </tr>
    </g:each>
    </tbody>
</table>
<h3 class="ui">${message(code: 'default.usage.licenseGrid.header')}</h3>
<table class="ui celled la-table table">
    <thead>
    <tr>
        <th>${message(code: 'default.usage.reportType')}</th>
        <g:each in="${l_x_axis_labels}" var="l">
            <th>${l}</th>
        </g:each>
    </tr>
    </thead>
    <tbody>
    <g:set var="counter" value="${0}"/>
    <g:each in="${lusage}" var="v">
        <tr>
            <td>${l_y_axis_labels[counter++]}</td>
            <g:each in="${v}" var="v2">
                <td>${v2}</td>
            </g:each>
        </tr>
    </g:each>
    </tbody>
</table>
</g:if>

<g:if test="${issueEntitlementInstance.tipp.title?.tipps}">

  <br/>

  <h3 class="ui header"><strong><g:message code="titleInstance.tipps.label" default="Occurrences of this title against Packages / Platforms" /></strong></h3>


  <semui:filter>
      <g:form action="show" params="${params}" method="get" class="ui form">
        <input type="hidden" name="sort" value="${params.sort}">
        <input type="hidden" name="order" value="${params.order}">

          <div class="fields three">
              <div class="field">
                  <label>${message(code:'tipp.show.filter_pkg', default:'Filters - Package Name')}</label>
                  <input name="filter" value="${params.filter}"/>
              </div>
              <div class="field">
                  <semui:datepicker label="default.startsBefore.label" name="startsBefore" value="${params.startsBefore}" />
              </div>
              <div class="field">
                  <semui:datepicker label="default.endsAfter.label" name="endsAfter" value="${params.endsAfter}" />
              </div>
          </div>
          <div class="field">
              <input type="submit" class="ui secondary button" value="${message(code:'default.button.submit.label', default:'Submit')}">
          </div>

      </g:form>
  </semui:filter>

  <table class="ui celled la-table table">
      <thead>
          <tr>
              <th>${message(code:'tipp.startDate', default:'From Date')}</th><th>${message(code:'tipp.startVolume', default:'From Volume')}</th><th>${message(code:'tipp.startIssue', default:'From Issue')}</th>
              <th>${message(code:'tipp.startDate', default:'To Date')}</th><th>${message(code:'tipp.endVolume', default:'To Volume')}</th><th>${message(code:'tipp.endIssue', default:'To Issue')}</th>
              <th>${message(code:'tipp.coverageDepth', default:'Coverage Depth')}</th>
              <th>${message(code:'platform.label', default:'Platform')}</th><th>${message(code:'package.label', default:'Package')}</th><th>${message(code:'default.actions.label', default:'Actions')}</th>
          </tr>
      </thead>
      <tbody>
          <g:each in="${tippList}" var="t">
              <tr>
                  <td><g:formatDate format="${message(code:'default.date.format.notime', default:'yyyy-MM-dd')}" date="${t.startDate}"/></td>
              <td>${t.startVolume}</td>
              <td>${t.startIssue}</td>
              <td><g:formatDate format="${message(code:'default.date.format.notime', default:'yyyy-MM-dd')}" date="${t.endDate}"/></td>
              <td>${t.endVolume}</td>
              <td>${t.endIssue}</td>
              <td>${t.coverageDepth}</td>
              <td><g:link controller="platform" action="show" id="${t.platform.id}">${t.platform.name}</g:link></td>
              <td><g:link controller="packageDetails" action="show" id="${t.pkg.id}">${t.pkg.name}</g:link></td>
              <td><g:link controller="tipp" action="show" id="${t.id}">${message(code:'tipp.details', default:'View Details')}</g:link></td>
              </tr>
          </g:each>
      </tbody>
  </table>
</g:if>
</div>


<div id="magicArea">

    <g:set var="yodaService" bean="yodaService" />

<g:if test="${yodaService.showDebugInfo()}">
<g:render template="coreAssertionsModal" contextPath="../templates" model="${[tipID:-1,coreDates:[]]}"/>
</g:if>
</div>
<r:script language="JavaScript">
function hideModal(){
$("[name='coreAssertionEdit']").modal('hide');
}
function showCoreAssertionModal(){
$("input.datepicker-class").datepicker({
format:"${message(code:'default.date.format.notime', default:'yyyy-MM-dd').toLowerCase()}",
language:"${message(code:'default.locale.label', default:'en')}",
autoclose:true
});
$("[name='coreAssertionEdit']").modal('show');
$('.xEditableValue').editable();
}
</r:script>
</body>
</html>
