<!doctype html>
<html>
<head>
    <meta name="layout" content="pubbootstrap"/>
    <title>${message(code: 'public.nav.contact.label', default: 'Contact Us')} | ${message(code: 'laser', default: 'LAS:eR')}</title>
</head>

<body class="public">
    <g:render template="public_navbar" contextPath="/templates" model="['active': 'contact']"/>

    <div class="ui container">
        <h1 class="ui header">${message(code: 'public.nav.contact.label', default: 'Contact Us')}</h1>

        <div class="row">
            <div class="span8">
                <markdown:renderHtml><g:dbContent key="kbplus.contact.text"/></markdown:renderHtml>
            </div>

            <div class="span4">
                <g:render template="/templates/loginDiv"/>
            </div>
        </div>
    </div>
</body>
</html>