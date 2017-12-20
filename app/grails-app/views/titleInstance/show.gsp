
<%@ page import="com.k_int.kbplus.TitleInstance" %>
<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI">
    <g:set var="entityName" value="${message(code: 'titleInstance.label', default: 'TitleInstance')}" />
    <title><g:message code="default.show.label" args="[entityName]" /></title>
  </head>
  <body>

    <h1 class="ui header">${message(code:'titleInstance.label', default:'Title Instance')}: ${titleInstanceInstance?.title}</h1>
    <semui:messages data="${flash}" />

    <div class="ui grid">

      <div class="twelve wide column">
          <div class="inline-lists">
            <g:if test="${titleInstanceInstance?.title}">
                <dl>
                    <dt><g:message code="title.label" default="Title" /></dt>
                    <dd><g:fieldValue bean="${titleInstanceInstance}" field="title"/></dd>
                </dl>
            </g:if>

            <g:if test="${titleInstanceInstance?.ids}">
                <dl>
                    <dt><g:message code="title.identifiers.label" default="Ids" /></dt>
                    <dd>
                      <g:each in="${titleInstanceInstance.ids}" var="i">
                          <div>${i.identifier.ns.ns}:${i.identifier.value}</div>
                      </g:each>
                    </dd>
                </dl>
            </g:if>

            <g:if test="${titleInstanceInstance?.impId}">
                <dl>
                    <dt><g:message code="default.impId.label" default="Imp Id" /></dt>
                    <dd><g:fieldValue bean="${titleInstanceInstance}" field="impId"/></dd>
                </dl>
            </g:if>

            <g:if test="${titleInstanceInstance?.prsLinks}">
              <dl>
                <dt><g:message code="title.prsLinks.label" default="Responsibilites" /></dt>
                <dd><ul>
                  <g:each in="${titleInstanceInstance.prsLinks}" var="p">
                    <li>
                      ${p.responsibilityType?.getI10n("value")} -

                      <g:if test="${p.cluster}">
                              <g:link controller="cluster" action="show" id="${p.cluster.id}">Cluster: ${p.cluster.name}</g:link>
                      </g:if>
                      <g:if test="${p.org}">
                              <g:link controller="org" action="show" id="${p.org.id}">${message(code:'org.label', default:'Org')}: ${p.org.name}</g:link>
                      </g:if>
                      <g:if test="${p.pkg}">
                              <g:link controller="packageDetails" action="show" id="${p.pkg.id}">${message(code:'package.label', default:'Package')}: ${p.pkg.name}</g:link>
                      </g:if>
                      <g:if test="${p.sub}">
                              <g:link controller="subscriptionDetails" action="show" id="${p.sub.id}">${message(code:'subscription.label', default:'Subscription')}: ${p.sub.name}</g:link>
                      </g:if>
                      <g:if test="${p.lic}">${message(code:'license.label', default:'License')}: ${p.lic.id}</g:if>
                    </li>
                  </g:each>
                </ul></dd>
              </dl>
            </g:if>
          </div>

          <g:if test="${titleInstanceInstance?.tipps}">
              <h6 class="ui header"><g:message code="titleInstance.tipps.label" default="Occurences of this title against Packages / Platforms" /></h6>

              <table class="ui celled striped table">
                  <thead>
                      <tr>
                          <th>${message(code:'tipp.startDate', default:'From Date')}</th><th>${message(code:'tipp.startVolume', default:'From Volume')}</th><th>${message(code:'tipp.startIssue', default:'From Issue')}</th>
                          <th>${message(code:'tipp.endDate', default:'To Date')}</th><th>${message(code:'tipp.endVolume', default:'To Volume')}</th><th>${message(code:'tipp.endIssue', default:'To Issue')}</th><th>${message(code:'tipp.coverageDepth', default:'Coverage Depth')}</th>
                          <th>${message(code:'platform.label', default:'Platform')}</th><th>${message(code:'package.label', default:'Package')}</th><th>${message(code:'default.actions.label', default:'Actions')}</th>
                      </tr>
                  </thead>
                  <g:each in="${titleInstanceInstance.tipps}" var="t">
                      <tr>
                          <td><g:formatDate formatName="default.date.format.notime" date="${t.startDate}"/></td>
                      <td>${t.startVolume}</td>
                      <td>${t.startIssue}</td>
                      <td><g:formatDate format="default.date.format.notime" date="${t.endDate}"/></td>
                      <td>${t.endVolume}</td>
                      <td>${t.endIssue}</td>
                      <td>${t.coverageDepth}</td>
                      <td><g:link controller="platform" action="show" id="${t.platform.id}">${t.platform.name}</g:link></td>
                      <td><g:link controller="packageDetails" action="show" id="${t.pkg.id}">${t.pkg.name} (${t.pkg.contentProvider?.name})</g:link></td>
                      <td><g:link controller="titleInstancePackagePlatform" action="show" id="${t.id}">${message(code:'platform.show.full_tipp', default:'Full TIPP record')}</g:link></td>
                      </tr>
                  </g:each>
              </table>
          </g:if>
			
          <g:form>
              <sec:ifAnyGranted roles="ROLE_ADMIN">
                  <g:hiddenField name="id" value="${titleInstanceInstance?.id}" />

                  <div class="ui segment form-actions">
                      <g:link class="ui button" action="edit" id="${titleInstanceInstance?.id}">
                          <i class="icon-pencil"></i>
                          <g:message code="default.button.edit.label" default="Edit" />
                      </g:link>
                      <button class="ui negative button" type="submit" name="_action_delete">
                          <i class="icon-trash icon-white"></i>
                          <g:message code="default.button.delete.label" default="Delete" />
                      </button>
                  </div>
              </sec:ifAnyGranted>
          </g:form>

      </div><!-- .twelve -->

      <div class="four wide column">
          <div class="well">
              <ul class="nav nav-list">
                  <li class="nav-header">${entityName}</li>
                  <li>
                      <g:link class="list" action="list">
                          <i class="icon-list"></i>
                          <g:message code="default.list.label" args="[entityName]" />
                      </g:link>
                  </li>
                  <sec:ifAnyGranted roles="ROLE_ADMIN">
                      <li>
                          <g:link class="create" action="create">
                              <i class="icon-plus"></i>
                              <g:message code="default.create.label" args="[entityName]" />
                          </g:link>
                      </li>
                  </sec:ifAnyGranted>
              </ul>
          </div>
      </div><!-- .four -->

    </div><!-- .grid -->
  </body>
</html>
