<%@ page import="com.k_int.kbplus.Package" %>
<!doctype html>
<html>
  <head>
    <meta name="layout" content="mmbootstrap">
    <title>${ti.title}</title>
  </head>
  <body>
      <div class="container">
        <div class="row">
          <div class="span12">

            <div class="page-header">
              <h1><g:if test="${editable}"><span id="titleEdit" 
                        class="xEditableValue"
                        data-type="textarea" 
                        data-pk="${ti.class.name}:${ti.id}"
                        data-name="title" 
                        data-url='<g:createLink controller="ajax" action="editableSetValue"/>'
                        data-original-title="${ti.title}">${ti.title}</span></g:if><g:else>${ti.title}</g:else></h1>
            </div>

            <g:if test="${flash.message}">
            <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
            </g:if>



             <g:hasErrors bean="${flash.domainError}">
                    <bootstrap:alert class="alert-error">
                    <ul>
                        <g:eachError bean="${flash.domainError}" var="error">
                            <li> <g:message error="${error}"/></li>
                        </g:eachError>
                    </ul>
                    </bootstrap:alert>
              </g:hasErrors>



            <g:if test="${flash.error}">
            <bootstrap:alert class="alert-info">${flash.error}</bootstrap:alert>
            </g:if>

            <h3>${message(code:'identifier.plural', default:'Identifiers')}</h3>

              <g:each in="${duplicates}" var="entry">

                 <bootstrap:alert class="alert-info">
                 ${message(code:'title.edit.duplicate.warn', args:[entry.key])}:
                 <ul>
                 <g:each in ="${entry.value}" var="dup_title">
                 <li><g:link controller='titleDetails' action='show' id="${dup_title.id}">${dup_title.title}</g:link></li>
                 </g:each>
                 </ul>
                 </bootstrap:alert>
              </g:each>
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th>${message(code:'title.edit.component_id.label')}</td>
                  <th>${message(code:'title.edit.namespace.label')}</th>
                  <th>${message(code:'identifier.label')}</th>
                  <th>${message(code:'default.actions.label')}</th>
                </tr>
              </thead>
              <tbody>
                <g:each in="${ti.ids}" var="io">
                  <tr>
                    <td>${io.id}</td>
                    <td>${io.identifier.ns.ns}</td>
                    <td>${io.identifier.value}</td>
                    <td><g:if test="${editable}"><g:link controller="ajax" action="deleteThrough" params='${[contextOid:"${ti.class.name}:${ti.id}",contextProperty:"ids",targetOid:"${io.class.name}:${io.id}"]}'>${message(code:'title.edit.identifier.delete')}</g:link></g:if></td>
                  </tr>
                </g:each>
              </tbody>
            </table>

           
            <g:if test="${editable}">
              <g:form controller="ajax" action="addToCollection" class="form-inline" name="add_ident_submit">
                ${message(code:'identifier.select.text', args:['eISSN:2190-9180'])}<br/>
                <input type="hidden" name="__context" value="${ti.class.name}:${ti.id}"/>
                <input type="hidden" name="__newObjectClass" value="com.k_int.kbplus.IdentifierOccurrence"/>
                <input type="hidden" name="__recip" value="ti"/>
                <input type="hidden" name="identifier" id="addIdentifierSelect"/>
                <input type="submit" value="${message(code:'title.edit.identifier.select.add')}" class="btn btn-primary btn-small"/><br/>
              </g:form>
            </g:if>
            <h3>${message(code:'title.edit.orglink')}</h3>

          <g:render template="orgLinks" contextPath="../templates" model="${[roleLinks:ti?.orgs,editmode:editable]}" />

          </div>
        </div>

        <div class="row">
          <div class="span12">


            <h3>${message(code:'title.edit.tipp')}</h3>
            <table class="table table-bordered table-striped">
                    <tr>
                        <th>${message(code:'tipp.from_date')}</th><th>${message(code:'tipp.from_volume')}</th><th>${message(code:'tipp.from_issue')}</th>
                        <th>${message(code:'tipp.to_date')}</th><th>${message(code:'tipp.to_volume')}</th><th>${message(code:'tipp.to_issue')}</th><th>${message(code:'tipp.coverage_depth')}</th>
                        <th>${message(code:'tipp.platform')}</th><th>${message(code:'tipp.package')}</th><th>${message(code:'title.edit.actions.label')}</th>
                    </tr>
                    <g:each in="${ti.tipps}" var="t">
                        <tr>
                            <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.startDate}"/></td>
                        <td>${t.startVolume}</td>
                        <td>${t.startIssue}</td>
                        <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${t.endDate}"/></td>
                        <td>${t.endVolume}</td>
                        <td>${t.endIssue}</td>
                        <td>${t.coverageDepth}</td>
                        <td><g:link controller="platform" action="show" id="${t.platform.id}">${t.platform.name}</g:link></td>
                        <td><g:link controller="packageDetails" action="show" id="${t.pkg.id}">${t.pkg.name}</g:link></td>
                        <td><g:link controller="tipp" action="show" id="${t.id}">${message(code:'title.edit.tipp.show', default:'Full TIPP record')}</g:link></td>
                        </tr>
                    </g:each>
            </table>

          </div>
        </div>



      </div>

    <g:render template="orgLinksModal" 
              contextPath="../templates" 
              model="${[linkType:ti?.class?.name,roleLinks:ti?.orgs,parent:ti.class.name+':'+ti.id,property:'orgLinks',recip_prop:'title']}" />

  <r:script language="JavaScript">

    $(function(){


      $("[name='add_ident_submit']").submit(function( event ) {
        event.preventDefault();
        $.ajax({
          url: "<g:createLink controller='ajax' action='validateIdentifierUniqueness'/>?identifier="+$("input[name='identifier']").val()+"&owner="+"${ti.class.name}:${ti.id}",
          success: function(data) {
            if(data.unique){
              $("[name='add_ident_submit']").unbind( "submit" )
              $("[name='add_ident_submit']").submit();
            }else if(data.duplicates){
              var warning = "${message(code:'title.edit.duplicate.warn.list', default:'The following Titles are also associated with this identifier')}:\n";
              for(var ti of data.duplicates){
                  warning+= ti.id +":"+ ti.title+"\n";
              }
              var accept = confirm(warning);
              if(accept){
                $("[name='add_ident_submit']").unbind( "submit" )
                $("[name='add_ident_submit']").submit();
              }
            }
          },
        });
      });

      <g:if test="${editable}">
      $("#addIdentifierSelect").select2({
        placeholder: "${message(code:'identifier.select.ph')}",
        minimumInputLength: 1,
        formatInputTooShort: function () {
            return "${message(code:'select2.minChars.note', default:'Pleaser enter 1 or more character')}";
        },
        ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
          url: "<g:createLink controller='ajax' action='lookup'/>",
          dataType: 'json',
          data: function (term, page) {
              return {
                  q: term, // search term
                  page_limit: 10,
                  baseClass:'com.k_int.kbplus.Identifier'
              };
          },
          results: function (data, page) {
            return {results: data.values};
          }
        },
        createSearchChoice:function(term, data) {
          return {id:'com.k_int.kbplus.Identifier:__new__:'+term,text:"New - "+term};
        }
      });

      $("#addOrgSelect").select2({
        placeholder: "Search for an org...",
        minimumInputLength: 1,
        formatInputTooShort: function () {
            return "${message(code:'select2.minChars.note', default:'Pleaser enter 1 or more character')}";
        },
        ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
          url: "<g:createLink controller='ajax' action='lookup'/>",
          dataType: 'json',
          data: function (term, page) {
              return {
                  q: term, // search term
                  page_limit: 10,
                  baseClass:'com.k_int.kbplus.Org'
              };
          },
          results: function (data, page) {
            return {results: data.values};
          }
        }
      });

      $("#orgRoleSelect").select2({
        placeholder: "Search for an role...",
        minimumInputLength: 1,
        formatInputTooShort: function () {
            return "${message(code:'select2.minChars.note', default:'Pleaser enter 1 or more character')}";
        },
        ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
          url: "<g:createLink controller='ajax' action='lookup'/>",
          dataType: 'json',
          data: function (term, page) {
              return {
                  q: term, // search term
                  page_limit: 10,
                  baseClass:'com.k_int.kbplus.RefdataValue'
              };
          },
          results: function (data, page) {
            return {results: data.values};
          }
        }
      });
      </g:if>



    });

    function validateAddOrgForm() {
      var org_name=$("#addOrgSelect").val();
      var role=$("#orgRoleSelect").val();

      if( !org_name || !role ){
        return false;
      }
      return true;
    }
  </r:script>

  </body>
</html>
