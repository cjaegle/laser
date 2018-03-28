<%
    def result = []
    hits.each { hit ->

        if (hit.getSource().rectype == 'action') {
            result << [
                "title": "${hit.getSource().alias}",
                "url":   g.createLink(controller:"${hit.getSource().controller}", action:"${hit.getSource().action}"),
                "category": "${message(code: 'spotlight.action')}"
            ]
        }
        else if (hit.getSource().rectype == 'License') {
            result << [
                "title": "${hit.getSource().name}",
                "url":   g.createLink(controller:"licenseDetails", action:"show", id:"${hit.getSource().dbId}"),
                "category": "${message(code: 'spotlight.license')}"
            ]
        }
        else if (hit.getSource().rectype == 'Organisation') {
            result << [
                "title": "${hit.getSource().name}",
                "url":   g.createLink(controller:"organisations", action:"show", id="${hit.getSource().dbId}"),
                "category": "${message(code: 'spotlight.organisation')}"
            ]
        }
        else if (hit.getSource().rectype == 'Package') {
            result << [
                "title": "${hit.getSource().name}",
                "url":   g.createLink(controller:"packageDetails", action:"show", id:"${hit.getSource().dbId}"),
                "category": "${message(code: 'spotlight.package')}"
            ]
        }
        else if (hit.getSource().rectype == 'Platform') {
            result << [
                "title": "${hit.getSource().name}",
                "url":   g.createLink(controller:"platform", action:"show", id:"${hit.getSource().dbId}"),
                "category": "${message(code: 'spotlight.platform')}"
            ]
        }
        else if (hit.getSource().rectype == 'Subscription') {
            result << [
                "title": "${hit.getSource().name}",
                "url":   g.createLink(controller:"subscriptionDetails", action:"show", id:"${hit.getSource().dbId}"),
                "category": "${message(code: 'spotlight.subscription')}"
            ]
        }
        else if (hit.getSource().rectype == 'TitleInstance') {
            result << [
                "title": "${hit.getSource().title}",
                "url":   g.createLink(controller:"titleDetails", action:"show", id:"${hit.getSource().dbId}"),
                "category": "${message(code: 'spotlight.title')}"
            ]
        }
    }
%>
{
    "results": [
        <g:each in="${result}" var="hit" status="counter">
            <g:if test="${counter > 0}">, </g:if>
            {
                "title": "${hit.title}",
                "url":   "${hit.url}",
                "category": "${hit.category}"
            }
        </g:each>
    ]
}