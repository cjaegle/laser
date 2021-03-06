<!doctype html>
<html>
<head>
    <meta name="layout" content="public"/>
    <title>${message(code: 'public.nav.signUp.label')} | ${message(code: 'laser')}</title>
</head>

<body class="public">
    <g:render template="public_navbar" contextPath="/templates" model="['active': 'signup']"/>

    <div class="ui container">
        <h1 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon />${message(code: 'public.signUp.label')}</h1>

        <div class="ui grid">
            <div class="twelve wide column">
                <markdown:renderHtml><g:dbContent key="kbplus.signup.text"/></markdown:renderHtml>
            </div>

            <aside class="four wide column">
                <g:render template="/templates/loginDiv"/>
            </aside>
        </div>
    </div>
</body>
</html>
