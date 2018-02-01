<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI">
    <g:set var="entityName" value="${message(code: 'package.label', default: 'Package')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
  </head>
  <body>


        <h1 class="ui header">Track ${item.name}(${item.identifier}) from ${item.source.name}</h1>
        <semui:messages data="${flash}" />

    <g:form action="createTracker" controller="globalDataSync" id="${params.id}">

      <input type="hidden" name="localPkg" value="${params.localPkg}"/>
      <input type="hidden" name="synctype" value="${type}"/>

      <div class="container well">
        <h1 class="ui header">Review Tracker</h1>
        <g:if test="${type=='new'}">
          <p>This tracker will create a new local package for "${item.name}" from "${item.source.name}". Set the new package name below.</p>
          <dl>
            <dt>New Package Name</dt>
            <dd><input type="text" name="newPackageName" value="${item.name}" class="input-xxlarge"/></dd>
          </dl>
        </g:if>
        <g:else>
          <p>This tracker will synchronize package "<strong><em>${item.name}</em></strong>" from "<strong><em>${item.source.name}</em></strong>" with the existing local package <strong><em>${localPkg.name}</em></strong> </p>
        </g:else>

        <dl>
          <td>Auto accept the following changes</dt>
          <dd>
          <table class="ui table">
            <tr>
              <td><input type="Checkbox" name="autoAcceptTippAddition"/>TIPP Addition</td>
              <td><input type="Checkbox" name="autoAcceptTippUpdate"/>TIPP Update</td>
              <td><input type="Checkbox" name="autoAcceptTippDelete"/>TIPP Delete</td>
              <td><input type="Checkbox" name="autoAcceptPackageChange"/>Package Changes</td>
            </tr>
          </table>
          </dd>
        </dl>
          <input type="submit" onclick="toggleAlert()"/>
      </div>
</g:form>

    <div class="ui icon message" id="durationAlert" style="display: none">
        <i class="notched circle loading icon"></i>
        <div class="content">
            <div class="header">
                Ihre Anfrage ist in Bearbeitung.
            </div>
            <p>Bitte haben sie einen Moment Geduld</p>
            <p>Die Verarbeitung kann einige Minuten dauern</p>
        </div>
    </div>

    <script>
        function toggleAlert() {
            $('#durationAlert').toggle();
        }
    </script>

    <div class="container well">
      <h1 class="ui header">Package Sync Impact</h1>
      <table class="ui extra table">
        <tr>
          <th>
            <g:if test="${type=='new'}">
              No current package
            </g:if>
            <g:else>
              ${localPkg.name} as now
            </g:else>
          </th>
          <th>Action</th>
          <th>
            <g:if test="${type=='new'}">
              New Package After Processing
            </g:if>
            <g:else>
              ${localPkg.name} after sync
            </g:else>
          </th>
        </tr>
        <g:each in="${impact}" var="i">
          <tr>
            <td width="47%">
              <g:if test="${i.action=='i'}">
              </g:if>
              <g:else>
                <g:if test="${i.action=='-'}">
                  <strong><em>${i.tipp?.title?.name}</em></strong> (<g:each in="${i.tipp?.title?.identifiers}" var="id">${id.namespace}:${id.value} </g:each>) <br/>
                  <table class="ui table">
                    <tr><th></th><th>Volume</th><th>Issue</th><th>Date</th></tr>
                    <g:each in="${i.tipp.coverage}" var="c">
                      <tr><th>Start</th> <td>${c.startVolume}</td><td>${c.startIssue}</td>
                          <td>${c.startDate}</td></tr>
                      <tr><th>End</th> <td>${c.endVolume}</td><td> ${c.endIssue}</td><td>${c.endDate}</td></tr>
                      <tr><td colspan="4"> ${c.coverageDepth} ${c.coverageNote}</td></tr>
                    </g:each>
                  </table>
                </g:if>
                <g:else>
                  <strong><em>${i.oldtipp?.title?.name}</em></strong> (<g:each in="${i.oldtipp?.title?.identifiers}" var="id">${id.namespace}:${id.value} </g:each>) <br/>
                  <table class="ui table">
                    <tr><th></th><th>Volume</th><th>Issue</th><th>Date</th></tr>
                    <g:each in="${i.oldtipp.coverage}" var="c">
                      <tr><th>Start</th> <td>${c.startVolume}</td><td>${c.startIssue}</td>
                          <td>${c.startDate}</td></tr>
                      <tr><th>End</th> <td>${c.endVolume}</td><td> ${c.endIssue}</td><td>${c.endDate}</td></tr>
                      <tr><td colspan="4"> ${c.coverageDepth} ${c.coverageNote}</td></tr>
                    </g:each>
                  </table>
                </g:else>
              </g:else>
            </td>
            <td width="6%">${i.action}</td>
            <td width="47%">
              <g:if test="${i.action=='d'}">
                <strong><em>Removed</em></strong>
              </g:if>
              <g:else>
                <strong><em>${i.tipp?.title?.name}</em></strong> (<g:each in="${i.tipp.title.identifiers}" var="id">${id.namespace}:${id.value} </g:each>) <br/>
                <table class="ui table">
                  <tr><th></th><th>Volume</th><th>Issue</th><th>Date</th></tr>
                  <g:each in="${i.tipp.coverage}" var="c">
                    <tr><th>Start</th> <td>${c.startVolume}</td><td>${c.startIssue}</td><td>${c.startDate}</td></tr>
                    <tr><th>End</th> <td>${c.endVolume}</td><td> ${c.endIssue}</td><td>${c.endDate}</td></tr>
                    <tr><td colspan="4"> ${c.coverageDepth} ${c.coverageNote}</td></tr>
                  </g:each>
                </table>
              </g:else>
            </td>
            </td>
          </tr>
        </g:each>
      
      </table>
    </div>

  </body>
</html>
