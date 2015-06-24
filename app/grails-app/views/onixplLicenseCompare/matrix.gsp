<%@ page
	import="com.k_int.kbplus.OnixplLicenseCompareController; com.k_int.kbplus.OnixplLicense; com.k_int.kbplus.OnixplUsageTerm; com.k_int.kbplus.RefdataCategory"
	contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta name="layout" content="mmbootstrap" />
<title>KB+</title>
</head>
<body>
	<div class="container">
		<ul class="breadcrumb">
			<li><g:link controller="home" action="index">Home</g:link> <span
				class="divider">/</span></li>
			<li>ElCat Comparison Tool</li>
		</ul>
	</div>

	<div class="container">
		<h1>ElCat Comparison Tool</h1>
	</div>
	<div class="container">
		<g:if test="${flash.message}">
			<bootstrap:alert class="alert-info">
				${flash.message}
			</bootstrap:alert>
		</g:if>
		<g:render template="tables" model="${request.parameterMap}" />
	</div>
</body>
</html>
