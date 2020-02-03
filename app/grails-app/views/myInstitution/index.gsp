<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser', default:'LAS:eR')} : ${message(code:'myinstadmin.title', default:'Institutional Admin Dash')}</title>
</head>

<body>
    <semui:breadcrumbs>
        <semui:crumb controller="myInstitution" action="dashboard" text="${institution?.getDesignation()}"/>
        <semui:crumb text="${message(code:'myinstadmin.title', default:'Institutional Admin Dash')}" class="active" />
    </semui:breadcrumbs>

    <table class="ui celled la-table table">
        <tr>
            <th colspan="3">Note attached to</th>
        </tr>
        <tr>
            <th>Note</th>
        </tr>
        <g:each in="${userAlerts}" var="ua">
            <tr>
                <td colspan="3">
                    <g:if test="${ua.rootObj.class.name == 'com.k_int.kbplus.License'}">
                        <span class="label label-info">${message(code: 'license')}</span>
                        <em><g:link action="show"
                                    controller="license"
                                    id="${ua.rootObj.id}">${ua.rootObj.reference}</g:link></em>
                    </g:if>
                    <g:elseif test="${ua.rootObj.class.name == 'com.k_int.kbplus.Subscription'}">
                        <span class="label label-info">${message(code: 'subscription')}</span>
                        <em><g:link action="index"
                                    controller="subscription"
                                    id="${ua.rootObj.id}">${ua.rootObj.name}</g:link></em>
                    </g:elseif>
                    <g:elseif test="${ua.rootObj.class.name == 'com.k_int.kbplus.Package'}">
                        <span class="label label-info">${message(code: 'package.label')}</span>
                        <em><g:link action="show"
                                    controller="package"
                                    id="${ua.rootObj.id}">${ua.rootObj.name}</g:link></em>
                    </g:elseif>
                    <g:else>
                        Unhandled object type attached to alert: ${ua.rootObj.class.name}:${ua.rootObj.id}
                    </g:else>
                </td>
            </tr>
            <g:each in="${ua.notes}" var="n">
                <tr>
                    <td>
                        ${n.owner.content}<br/>

                        <div class="la-float-right"><i>${n.owner.type?.value} (
                        Private
                        ) By ${n.owner.user?.displayName} on <g:formatDate formatName="default.date.format.notime"
                                                                           date="${n.alert.createTime}"/></i></div>
                    </td>
                </tr>
            </g:each>
        </g:each>
    </table>
</div>
</body>
</html>
