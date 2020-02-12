<%@ page import="com.k_int.kbplus.TitleInstance" %>
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

        <table class="ui table">
            <tbody>
                <tr>
                    <th colspan="2">Reference list:</th>
                </tr>
                <g:each in="${duplicateRows.entrySet()}" var="duplicate">
                    <tr>
                        <td>
                            ${duplicate.getKey()}
                        </td>
                        <td>
                            <ul>
                                <g:each in="${duplicate.getValue()}" var="title">
                                    <li><g:link controller="title" action="show" id="${title.id}">${title.globalUID}</g:link> (${title.tipps.size()} TIPPs)</li>
                                </g:each>
                            </ul>
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>
        <semui:form>
            <g:form action="executeTiCleanup" method="post" class="ui form" data-confirm-id="clearUp_form">
                <table class="ui table">
                    <tbody>
                        <tr>
                            <th>Duplicate titles with UUID entirely missing in GOKb</th>
                        </tr>
                        <g:each in="${missingTitles}" var="missing">
                            <tr>
                                <td>${missing}</td>
                            </tr>
                        </g:each>
                        <tr>
                            <th>Duplicate titles without TIPPs; they may be subject of merge targets</th>
                        </tr>
                        <g:each in="${titlesWithoutTIPPs}" var="withoutTIPP">
                            <tr>
                                <td><g:link controller="title" action="show" id="${TitleInstance.findByGlobalUID(withoutTIPP).id}">${withoutTIPP}</g:link></td>
                            </tr>
                        </g:each>
                        <tr>
                            <th>Duplicate titles where UUIDs can simply be remapped</th>
                        </tr>
                        <g:each in="${remappingTitles}" var="remapping">
                            <tr>
                                <td>
                                    ${remapping}
                                </td>
                            </tr>
                        </g:each>
                        <tr>
                            <th>Duplicate titles that should be merged after name / UUID mismatch</th>
                        </tr>
                        <g:each in="${mergingTitles}" var="merging">
                            <tr>
                                <td>
                                    ${merging}
                                </td>
                            </tr>
                        </g:each>
                        <tr>
                            <th>Duplicate titles whose TIPPs should be put together</th>
                        </tr>
                        <g:each in="${tippMergers}" var="merging">
                            <tr>
                                <td>
                                    <p>From: <g:link controller="title" action="show" id="${TitleInstance.findByGlobalUID(merging.from).id}">${merging.from}</g:link></p>
                                    <p>To: ${merging.to}</p>
                                    <p>Other concerned:
                                        <g:each in="${merging.others}" var="other">
                                            <g:link controller="title" action="show" id="${TitleInstance.findByGlobalUID(other).id}">${other}</g:link>
                                        </g:each>
                                    </p>
                                </td>
                            </tr>
                        </g:each>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td>
                                <g:hiddenField name="id" value="clearUp" />
                                <div class="ui icon negative button js-open-confirm-modal"
                                     data-confirm-tokenMsg="${message(code: "confirm.dialogtriggerCleanup")}"
                                     data-confirm-term-how="clearUp"
                                     data-confirm-id="clearUp" >
                                    <i class="bath icon"></i>
                                    <g:message code="admin.cleanupTIPP.submit"/>
                                </div>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </g:form>
        </semui:form>

  </body>
</html>
