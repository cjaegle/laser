<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI">
    <title>${message(code:'laser', default:'LAS:eR')} : ${message(code:'menu.yoda.quartzInfo')}</title>
</head>
<body>

<semui:breadcrumbs>
    <semui:crumb message="menu.yoda.dash" controller="yoda" action="index"/>
    <semui:crumb message="menu.yoda.quartzInfo" class="active"/>
</semui:breadcrumbs>
<br>
<h1 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon />${message(code:'menu.yoda.quartzInfo')}</h1>

<br />

<g:each in="${quartz}" var="groupKey, group">
    <%--<h3 class="ui header">${groupKey}</h3>--%>

    <table class="ui celled la-table la-table-small table">
        <thead>
            <tr>
                <th>Job</th>
                <th>Config</th>
                <th>s  m  h  DoM  M  DoW  Y</th>
                <th>Status</th>
                <th>Nächste Ausführung</th>
            </tr>
        </thead>
        <tbody>
            <g:each in="${group}" var="job">
                <tr>
                    <td>
                        ${job.name}
                    </td>
                    <td>
                        <g:each in="${job.configFlags.split(',')}" var="flag">
                            <g:if test="${currentConfig.get(flag) && currentConfig.get(flag) != false}">
                                ${flag}
                            </g:if>
                            <g:else>
                                <span style="color:lightgrey;font-style:italic">${flag}</span>
                            </g:else>
                        </g:each>
                    </td>
                    <td>
                        <code>${job.cronEx}</code>
                    </td>
                    <td style="text-align:center">
                        <g:if test="${job.running}">
                            <i class="ui icon circle green"></i>
                        </g:if>
                        <g:elseif test="${job.available}">
                            <i class="ui icon circle yellow"></i>
                        </g:elseif>
                        <g:else>
                           <%-- <i class="ui icon circle outline lightgrey"></i> --%>
                        </g:else>
                    </td>
                    <td>
                        <%
                            boolean isActive = true

                            if (job.configFlags) {
                                job.configFlags.split(',').each { flag ->
                                    isActive = isActive && (currentConfig.get(flag) && ! (currentConfig.get(flag) in [null, false]))
                                }
                            }
                        %>
                        <g:if test="${isActive}">
                            ${job.nextFireTime}
                        </g:if>
                        <g:else>
                            <span style="color:lightgrey">${job.nextFireTime}</span>
                        </g:else>
                        <%--<g:formatDate format="${message(code:'default.date.format.noZ')}" date="${job.nextFireTime}" />--%>
                    </td>
                </tr>
            </g:each>
        </tbody>
    </table>
</g:each>

<br />
<br />

    <%-- TODO: implement ajax calls --%>
    <script>
        setTimeout(function() {
            window.document.location.reload();
        }, (30 * 1000)); // refresh ~ 30 Seconds
    </script>

</body>
</html>