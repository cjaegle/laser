<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI">
    <title>${message(code:'laser')} : ${message(code:'menu.yoda.quartzInfo')}</title>
</head>
<body>

<semui:breadcrumbs>
    <semui:crumb message="menu.yoda.dash" controller="yoda" action="index"/>
    <semui:crumb message="menu.yoda.quartzInfo" class="active"/>
</semui:breadcrumbs>
<br>
<h2 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon />${message(code:'menu.yoda.quartzInfo')}</h2>

<br />

<g:each in="${quartz}" var="groupKey, group">
    <%--<h3 class="ui header">${groupKey}</h3>--%>

    <table class="ui celled la-table la-table-small table">
        <thead>
            <tr>
                <th>Job</th>
                <th>Services</th>
                <th>Config</th>
                <th>Status</th>
                <th>s  m  h  DoM  M  DoW  Y</th>
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
                        <g:each in="${job.services}" var="srv">
                            ${srv} <br />
                        </g:each>
                    </td>
                    <td>
                        <g:each in="${job.configFlags.split(',')}" var="flag">
                            <g:if test="${currentConfig.get(flag.trim())}">
                                ${flag} = ${currentConfig.get(flag.trim())} <br />
                            </g:if>
                            <g:else>
                                <span style="color:lightgrey;font-style:italic">${flag}</span> <br />
                            </g:else>
                        </g:each>
                    </td>

                    <%
                        boolean isActive = true

                        if (job.configFlags) {
                            job.configFlags.split(',').each { flag ->
                                isActive = isActive && (currentConfig.get(flag.trim()) && ! (currentConfig.get(flag.trim()) in [null, false]))
                            }
                        }
                    %>

                    <td style="text-align:center">
                        <g:if test="${job.running}">
                            <i class="ui big icon play circle green"></i>
                        </g:if>
                        <g:else>
                            <g:if test="${! job.nextFireTime}">
                                <i class="ui icon exclamation circle red"></i>
                            </g:if>
                            <g:elseif test="${isActive}">
                                <i class="ui icon play green"></i>
                            </g:elseif>
                            <g:elseif test="${job.available}">
                                <i class="ui icon question circle yellow"></i>
                            </g:elseif>
                        </g:else>
                    </td>
                    <td>
                        <code>${job.cronEx}</code>
                    </td>
                    <td>
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