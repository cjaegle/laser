<%@ page import="com.k_int.kbplus.Subscription" %>
<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser', default:'LAS:eR')} : ${message(code:'subscription.details.label', default:'Subscription Details')}</title>
  </head>
  <body>

    <semui:breadcrumbs>
        <semui:crumb message="subscription.details.label" class="active"/>
    </semui:breadcrumbs>

    <div>

    ${institution?.name} Subscription Taken
       <h1 class="ui left aligned icon header"><semui:headerIcon /><g:inPlaceEdit domain="Subscription" pk="${subscriptionInstance.id}" field="name" id="name" class="newipe">${subscriptionInstance?.name}</g:inPlaceEdit></h1>

      <ul class="nav nav-pills">
        <li class="active"><g:link controller="myInstitution"
                                   action="subscriptionDetails" 
                                   params="${[id:params.id]}">Current Entitlements</g:link></li>

        <li><g:link controller="myInstitution"
                    action="subscriptionAdd" 
                    params="${[id:params.id]}">Add Entitlements</g:link></li>
      </ul>


    <div class="tabbable"> <!-- Only required for left/right tabs -->
      <dl>
        <dt>License</dt>
        <dd><g:relation domain='Subscription' 
                        pk='${subscriptionInstance.id}' 
                        field='owner' 
                        class='reldataEdit'
                        id='ownerLicense'>${subscriptionInstance?.owner?.reference}</g:relation></dd>

        <g:if test="${entitlements}">
            <dt>Entitlements ( ${offset+1} to ${offset+(entitlements?.size())} of ${num_sub_rows} )
              <g:form action="subscriptionDetails" params="${params}" method="get">
                 <input type="hidden" name="sort" value="${params.sort}">
                 <input type="hidden" name="order" value="${params.order}">
                 Filter: <input name="filter" value="${params.filter}"/><input type="submit">
              </g:form>
            </dt>
            <dd>
              <g:form action="subscriptionBatchUpdate" params="${[id:subscriptionInstance?.id]}">
              <g:set var="counter" value="${offset+1}" />
              <table  class="table table-striped table-bordered table-condensed">
                <tr>
                  <th></th>
                  <th>${message(code:'sidewide.number')}</th>
                  <g:sortableColumn params="${params}" property="tipp.title.sortTitle" title="Title" />
                  <th>ISSN</th>
                  <th>iISSN</th>
                  <g:sortableColumn params="${params}" property="coreStatus" title="Core" />
                  <g:sortableColumn params="${params}" property="startDate" title="Start Date" />
                  <g:sortableColumn params="${params}" property="endDate" title="End Date" />
                  <th>Embargo</th>
                  <th>Content URL</th>
                  <th>Coverage Depth</th>
                  <th>Coverage Note</th>
                  <th>JUSP</th>
                </tr>  
                <tr>  
                  <th><input id="select-all" type="checkbox" name="chkall" onClick="javascript:selectAll();"/></th>
                  <th colspan="4"><input type="Submit" value="Apply Batch Changes" class="ui positive button"/></th>
                  <th><span id="entitlementBatchEdit" class="entitlementBatchEdit"></span><input type="hidden" name="bulk_core" id="bulk_core"/></th>
                  <th><span>${message('code':'default.button.edit.label')}</span> <input name="bulk_start_date" type="hidden" class="hdp" /></th>
                  <th><span>${message('code':'default.button.edit.label')}</span> <input name="bulk_end_date" type="hidden" class="hdp" /></th>
                  <th><span id="embargoBatchEdit" class="embargoBatchEdit"></span><input type="hidden" name="bulk_embargo" id="bulk_embargo"></th>
                  <th></th>
                  <th><span id="coverageBatchEdit" class="coverageBatchEdit"></span><input type="hidden" name="bulk_coverage" id="bulk_coverage"></th>
                  <th colspan="2"></th>
                </tr>
                <g:each in="${entitlements}" var="ie">
                  <tr>
                    <td><input type="checkbox" name="_bulkflag.${ie.id}" class="bulkcheck"/></td>
                    <td>${counter++}</td>
                    <td><g:link controller="title" action="show" id="${ie.tipp.title.id}">${ie.tipp.title.title}</g:link></td>
                    <td>${ie?.tipp?.title?.getIdentifierValue('ISSN')}</td>
                    <td>${ie?.tipp?.title?.getIdentifierValue('eISSN')}</td>
                    <td>${ie.coreStatus?.value}</td>
                    <td>
                        <span><g:formatDate format="${message(code:'default.date.format.notime', default:'yyyy-MM-dd')}" date="${ie.startDate}"/></span>
                        <input id="IssueEntitlement:${ie.id}:startDate" type="hidden" class="dp1" />
                    </td>
                    <td><span><g:formatDate format="${message(code:'default.date.format.notime', default:'yyyy-MM-dd')}" date="${ie.endDate}"/></span>
                        <input id="IssueEntitlement:${ie.id}:endDate" type="hidden" class="dp2" />
                    </td>
                    <td><g:inPlaceEdit domain="IssueEntitlement" pk="${ie.id}" field="embargo" id="embargo" class="newipe">${ie.embargo}</g:inPlaceEdit></td>
                    <td><g:if test="${ie.tipp?.getHostPlatform()}"><a href="${ie.tipp?.getHostPlatform()}">${ie.tipp?.getHostPlatform()}</a></g:if></td>
                    <td><g:inPlaceEdit domain="IssueEntitlement" pk="${ie.id}" field="coverageDepth" id="coverageDepth">${ie.coverageDepth}</g:inPlaceEdit></td>
                    <td>${ie.coverageNote}</td>  
                    <td>JUSP</td>
                  </tr>
                </g:each>
              </table>
              </g:form>
            </dd>
        </g:if>
        <dt>Org Links</dt>
        <dd>
          <ul>
            <g:each in="${subscriptionInstance.orgRelations}" var="or">
              <li>${or.org.name}:${or.roleType?.value}</li>
            </g:each>
          <ul>
        </dd>
      </dl>
    </div>

      <g:if test="${entitlements}" >
        <semui:paginate controller="myInstitution"
                          action="subscriptionDetails" 
                          params="${params}" next="Next" prev="Prev" 
                          max="15" 
                          total="${num_sub_rows}" />
      </g:if>

    </div>
    <r:script language="JavaScript">
      $(document).ready(function() {

        var datepicker_config = {
          buttonImage: '../../../images/calendar.gif',
          buttonImageOnly: true,
          changeMonth: true,
          changeYear: true,
          showOn: 'both',
          onSelect: function(dateText, inst) { 
            var elem_id = inst.input[0].id;
            $.ajax({url: '<g:createLink controller="ajax" action="genericSetValue" />?elementid='+
                             elem_id+'&value='+dateText+'&dt=date&idf=MM/dd/yyyy&odf=dd MMMM yyyy',
                   success: function(result){inst.input.parent().find('span').html(result)}
                   });
          }
        };


        $('span.newipe').editable('<g:createLink controller="ajax" action="genericSetValue" />', {
          type      : 'textarea',
          cancel    : 'Cancel',
          submit    : 'OK',
          id        : 'elementid',
          rows      : 3,
          tooltip   : 'Click to edit...'
        });

        $('span.entitlementBatchEdit').editable(function(value, settings) { 
          $("#bulk_core").val(value);
          return(value);          
        },{ data:{'true':'true','false':'false'}, type:'select',cancel:'Cancel',submit:'OK', rows:3, tooltop:'Click to edit...', width:'100px'});

        $('span.embargoBatchEdit').editable(function(value, settings) { 
          $("#bulk_embargo").val(value);
          return(value);
        },{type:'textarea',cancel:'Cancel',submit:'OK', rows:3, tooltop:'Click to edit...', width:'100px'});

        $('span.coverageBatchEdit').editable(function(value, settings) { 
          $("#bulk_coverage").val(value);
          return(value);
        },{type:'textarea',cancel:'Cancel',submit:'OK', rows:3, tooltop:'Click to edit...', width:'100px'});

        $('td span.coreedit').editable('<g:createLink controller="ajax" action="genericSetValue" />', {
           data   : {'true':'true', 'false':'false'},
           type   : 'select',
           cancel : 'Cancel',
           submit : 'OK',
           id     : 'elementid',
           tooltip: 'Click to edit...'
         });

         $('dd span.reldataEdit').editable('<g:createLink controller="ajax" params="${[resultProp:'reference']}" action="genericSetRel" />', {
           loadurl: '<g:createLink controller="myInstitution" action="availableLicenses" />',
           type   : 'select',
           cancel : 'Cancel',
           submit : 'OK',
           id     : 'elementid',
           tooltip: 'Click to edit...',
           callback : function(value, settings) {
           }
         });

         var checkEmptyEditable = function() {
           $('.ipe, .refdataedit, .fieldNote, .reldataEdit').each(function() {
             if($(this).text().length == 0) {
               $(this).addClass('editableEmpty');
             } else {
               $(this).removeClass('editableEmpty');
             }
           });
         }
      });

      function selectAll() {
        $('#select-all').is( ":checked")? $('.bulkcheck').prop('checked', true) : $('.bulkcheck').prop('checked', false);
      }

    </r:script>
  </body>
</html>
