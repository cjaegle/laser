<%@ page
	import="com.k_int.kbplus.OnixplLicenseCompareController; com.k_int.kbplus.OnixplLicense; com.k_int.kbplus.RefdataCategory"
	contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head>
<meta name="layout" content="semanticUI" />
<title>${message(code:'laser', default:'LAS:eR')} ${message(code:'onixplLicense.compare.label', default:'ONIX-PL License Compare')} </title>
</head>
<body>

	<semui:breadcrumbs>
		<semui:crumb message="menu.institutions.comp_onix" class="active"/>
	</semui:breadcrumbs>

	<div>
		<h1>${message(code:'menu.institutions.comp_onix')}</h1>
	</div>
	<div>
		<g:if test="${flash.message}">
			<bootstrap:alert class="alert-info">
				${flash.message}
			</bootstrap:alert>
		</g:if>
		<g:render template="tables" model="${request.parameterMap}" />
	</div>
	  <r:script language="JavaScript">
	  	// //we replace cell-inner-undefined with call inner and our new icon
	  	    $(function(){
	  	    	$(".onix-pl-undefined").replaceWith("<span title='Not defined by the license' style='height:1em' class='onix-status fa-stack fa-4x'> <i class='fa fa-info-circle fa-stack-1x' style='color:#166fe7;' ></i> <i class='fa fa-ban fa-stack-1x' style='color:#FF0000'></i> </span>")
	  	    	  // Tooltips.
  $('.onix-code, .onix-status').tooltip(
      {placement: 'bottom', trigger:'hover', html: true, container: 'body'}
  );
  $('.onix-icons span i').popover(
    {placement: 'left', trigger:'hover', html: true, container: 'body'}
  );
	  	    });

	  </r:script>
</body>
</html>
