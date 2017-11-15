<%--
  Created by IntelliJ IDEA.
  User: ioannis
  Date: 03/07/2014
  Time: 10:46
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code:'laser', default:'LAS:eR')} Upload Jasper Reports</title>
    <meta name="layout" content="semanticUI"/>

</head>

<body>
<div>
    <div class="span12">

        <ul class="breadcrumb">
            <li><g:link controller="home" action="index">Home</g:link> <span class="divider">/</span></li>
            <li><g:link controller="jasperReports" action="index">Jasper Reports</g:link> <span
                    class="divider">/</span></li>
        </ul>

        <g:if test="${flash.message}">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
        </g:if>
        <g:if test="${flash.error}">
            <bootstrap:alert class="alert-error">${flash.error}</bootstrap:alert>
        </g:if>

        <p>The types of accepted files are .jasper and .jrxml. Any other files selected will be ignored.</p>
        <g:uploadForm action="uploadReport" controller="jasperReports">

            <b>Select Reports</b>:

            <input type="file" name="report_files" multiple="multiple"><br/>

            <b>Upload Selected</b>

            <input type="submit" class="btn-primary" value="Upload Files"/>

        </g:uploadForm>
    </div>
</div>

</body>

</html>