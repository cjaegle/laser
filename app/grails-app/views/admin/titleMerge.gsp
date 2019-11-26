<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser', default:'LAS:eR')} : Admin::Title Merge</title>
  </head>

  <body>

        <semui:breadcrumbs>
            <semui:crumb message="menu.admin.dash" controller="admin" action="index" />
            <semui:crumb text="Title Merge" class="active"/>
        </semui:breadcrumbs>
        <br>
        <h1 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon />Title Merge</h1>

        <semui:messages data="${flash}" />

        <semui:form>
            <g:form action="titleMerge" method="get" class="ui form">
              <p>Add the appropriate ID's below. Detailed information and confirmation will be presented before proceeding</p>

                <div class="control-group">
                    <div class="field">
                        <label for="titleIdToDeprecate">Database ID of Title To Deprecate</label>

                        <input type="text" id="titleIdToDeprecate" name="titleIdToDeprecate" value="${params.titleIdToDeprecate}" />
                    <g:if test="${title_to_deprecate != null}">
                       <h3 class="ui header">Title To Deprecate: <strong>${title_to_deprecate.title}</strong></h3>
                       <p>The following TIPPs will be updated to point at the authorized title</p>
                       <table class="ui celled la-table table">
                         <thead>
                           <th>Internal Id</th>
                           <th>Package</th>
                           <th>Platform</th>
                           <th>Start</th>
                           <th>End</th>
                           <th>Coverage</th>
                         </thead>
                         <tbody>
                           <g:each in="${title_to_deprecate.tipps}" var="tipp">
                             <tr>
                               <td>${tipp.id}</td>
                               <td><g:link controller="package" action="show" id="${tipp.pkg.id}">${tipp.pkg.name}</g:link></td>
                               <td>${tipp.platform.name}</td>

                               <td style="white-space: nowrap">
                                 Date: <g:formatDate format="${message(code:'default.date.format.notime')}" date="${tipp.startDate}"/><br/>
                                 Volume: ${tipp.startVolume}<br/>
                                 Issue: ${tipp.startIssue}
                               </td>

                               <td style="white-space: nowrap">
                                  Date: <g:formatDate format="${message(code:'default.date.format.notime')}" date="${tipp.endDate}"/><br/>
                                  Volume: ${tipp.endVolume}<br/>
                                  Issue: ${tipp.endIssue}
                               </td>
                               <td>${tipp.coverageDepth}
                             </tr>
                           </g:each>
                         </tbody>
                       </table>
                    </g:if>
                  </div>
                </div>

                <div class="control-group">
                    <div class="field">
                        <label for="correctTitleId">Database ID of Correct Title </label>

                        <input type="text" id="correctTitleId" name="correctTitleId" value="${params.correctTitleId}"/>
                        <g:if test="${correct_title != null}">
                           <br/>Authorized Title:${correct_title.title}
                        </g:if>
                    </div>
                </div>

                <div class="field">
                    <g:if test="${correct_title != null && title_to_deprecate != null}">
                        <button name="MergeButton" type="submit" value="Go" class="ui button">**MERGE**</button>
                    </g:if>
                    <button name="LookupButton" type="submit" value="Go" class="ui button">Look Up Title Info...</button>
                </div>
            </g:form>
        </semui:form>

  </body>
</html>
