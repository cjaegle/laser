<%--
  Created by IntelliJ IDEA.
  User: rwincewicz
  Date: 10/07/2013
  Time: 09:11
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser', default:'LAS:eR')}</title>
</head>
<body>

<div class="container">
    <ul class="breadcrumb">
        <li> <g:link controller="home" action="index">Home</g:link> <span class="divider">/</span> </li>
        <li> <g:link controller="licenseDetails" action="index" id="${params.id}">ONIX-PL ${message(code:'license.details')}</g:link> </li>
        <g:if test="${editable}">
            <li class="pull-right"><span class="badge badge-warning">Editable</span>&nbsp;</li>
        </g:if>
</ul>
    </div>

<div class="container">
    <h1>ONIX-PL License : ${onixplLicense?.title}</h1>
</div>

<div class="container">
    <div class="row">
        <div class="span8">

            <h6>${message(code:'laser', default:'LAS:eR')} ${message(code:'license.information')}</h6>

            <g:if test="${!onixplLicense}">
            ${message(code:'onix.cannot.find.license')}
            </g:if>
            <g:else>
            <div class="inline-lists">
                <dl>
                    <dt><label class="control-label" for="license">Reference</label></dt>
                    <dd>
                        <g:each in="${onixplLicense.licenses}">
                            <g:link name="license" controller="licenseDetails" action="index" id="${it.id}">${it.reference}</g:link>
                        </g:each>
                    </dd>
                </dl>
                </div>

            <h6>ONIX-PL License Properties</h6>

            
            </g:else>
        </div>
    </div>
</div>

</body>
</html>