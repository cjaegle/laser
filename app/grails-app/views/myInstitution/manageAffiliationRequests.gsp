<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser')} : ${message(code:'myinstadmin.title', default:'Institutional Admin Dash')}</title>
</head>

<body>

<h1>THIS PAGE IS DEPRECATED</h1>


    <semui:breadcrumbs>
        <semui:crumb controller="myInstitution" action="dashboard" text="${institution?.getDesignation()}"/>
        <semui:crumb message="menu.institutions.affiliation_requests" class="active" />
    </semui:breadcrumbs>

    <h2 class="ui header">${message(code: "menu.institutions.affiliation_requests")}</h2>

    <table class="ui celled la-table table">
        <thead>
        <tr>
            <th>${message(code: "profile.user")}</th>
            <th>${message(code: "profile.display")}</th>
            <th>${message(code: "profile.email")}</th>
            <th>${message(code: "profile.membership.role")}</th>
            <th>${message(code: "default.status.label")}</th>
            <th>${message(code: "profile.membership.date2")}</th>
            <th class="la-action-info">${message(code:'default.actions.label')}</th>
        </tr>
        </thead>
        <tbody>
            <g:each in="${pendingRequestsOrg}" var="req">
                <tr>
                    <td>${req.user.username}</td>
                    <td>${req.user.displayName}</td>
                    <td>${req.user.email}</td>
                    <td><g:message code="cv.roles.${req.formalRole?.authority}"/></td>
                    <td><g:message code="cv.membership.status.${req.status}"/></td>
                    <td><g:formatDate format="dd MMMM yyyy" date="${req.dateRequested}"/></td>
                    <td class="x">
                        <g:if test="${editable}">
                            <g:link action="actionAffiliationRequestOrg" params="${[req: req.id, act: 'approve']}" class="ui icon positive button">
                                <i class="checkmark icon"></i>
                            </g:link>
                            <g:link action="actionAffiliationRequestOrg" params="${[req: req.id, act: 'deny']}" class="ui icon negative button">
                                <i class="times icon"></i>
                            </g:link>
                        </g:if>
                    </td>
                </tr>
            </g:each>
        </tbody>
    </table>
</body>
</html>
