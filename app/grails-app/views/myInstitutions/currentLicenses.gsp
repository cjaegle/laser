<!doctype html>
<html>
  <head>
    <meta name="layout" content="mmbootstrap"/>
    <title>KB+ ${message(code:'licence.current', default:'Current Licences')}</title>
  </head>
  <body>

    <div class="container">
        <ul class="breadcrumb">
            <li> <g:link controller="home" action="index">Home</g:link> <span class="divider">/</span> </li>
           <li> <g:link controller="myInstitutions" action="currentLicenses" params="${[shortcode:params.shortcode]}">${institution.name} ${message(code:'licence.current')}</g:link> </li>
           <g:if test="${is_admin}">
              <li class="pull-right"><span class="badge badge-warning">${message(code:'default.editable', default:'Editable')}</span>&nbsp;</li>
          </g:if>
       <li class="dropdown pull-right">
          <a class="dropdown-toggle badge" id="export-menu" role="button" data-toggle="dropdown" data-target="#" href="">${message(code:'default.button.exports.label', default:'Exports')}<b class="caret"></b></a>&nbsp;
          <ul class="dropdown-menu filtering-dropdown-menu" role="menu" aria-labelledby="export-menu">
            <li>
              <g:link action="currentLicenses" params="${params+[format:'csv']}">${message(code:'default.button.exports.csv', default:'CSV Export')}</g:link>
            </li>
            <g:each in="${transforms}" var="transkey,transval">
                <li><g:link action="currentLicenses" params="${params+[format:'xml',transformId:transkey,format_content:'subie']}">${transval.name}</g:link></li>
              </g:each>
          </ul>
        </li>
        </ul>
    </div>

    <g:if test="${flash.message}">
      <div class="container">
        <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
      </div>
    </g:if>

    <g:if test="${flash.error}">
      <div class="container">
        <bootstrap:alert class="error-info">${flash.error}</bootstrap:alert>
      </div>
    </g:if>

    <div class="container">
      <h1>${institution?.name} - ${message(code:'licence.plural', default:'Licences')}</h1>

     <ul class="nav nav-pills">
       <li class="active"><g:link controller="myInstitutions" 
                            action="currentLicenses" 
                            params="${[shortcode:params.shortcode]}">${message(code:'licence.current')}
                          </g:link></li>

          <li><g:link controller="myInstitutions" 
                                  action="addLicense" 
                                  params="${[shortcode:params.shortcode]}">${message(code:'licence.copy', default:'Copy from Template')}</g:link></li>
        <g:if test="${is_admin}">
          <li><g:link controller="myInstitutions" 
                                     action="cleanLicense" 
                                     params="${[shortcode:params.shortcode]}">${message(code:'licence.add.blank')}</g:link></li>
        </g:if>

      </ul>
    </div>

    <div class="container licence-searches">
        <div class="row">
            <div class="span8">
              <div class="well">

                <form class="form-inline">
                  <div>
                    <label>${message(code:'licence.valid_on', default:'Valid On')}:</label>
                    <input size="10" type="text"  id="datepicker-validOn" name="validOn" value="${validOn}">
                    <label>${message(code:'licence.search.by_ref', default:'Search by Reference')}:</label>
                    <input type="text" name="keyword-search" placeholder="${message(code:'default.search.ph', default:'enter search term...')}" value="${params['keyword-search']?:''}" />
                  </div>
                  <div style="margin-top:10px;">
                    <label>${message(code:'licence.property.search')}:</label>
                    <g:select id="availablePropertyTypes" name="availablePropertyTypes" from="${custom_prop_types}" optionKey="value" optionValue="key" value="${params.propertyFilterType}"/>
                    <input id="selectVal" type="text" name="propertyFilter" placeholder="${message(code:'licence.search.property.ph', default:'property value...')}" value="${params.propertyFilter?:''}" />
                    <input type="hidden" id="propertyFilterType" name="propertyFilterType" value="${params.propertyFilterType}"/>
                    <input type="submit" class="btn btn-primary" value="${message(code:'default.button.search.label', default:'Search')}" />
                  </div>
                </form>
              </div>
            </div>
        </div>
    </div>

      <div class="container">
          <div class="well licence-options">
              <input type="submit" name="delete-licence" value="${message(code:'licence.delete_selected.label', default:'Delete Selected')}" class="btn btn-danger delete-licence" />
          </div>
      </div>



        <div class="container licence-results">
        <g:if test="${licenseCount && licenseCount>0}">
          <span>${message(code:'licence.current.showing', args:[licenseCount])}</span>
        </g:if>
          <table class="table table-bordered table-striped">
            <thead>
              <tr>
                <g:sortableColumn params="${params}" property="reference" title="${message(code:'licence.name')}" />
                <th>${message(code:'licence.licensor.label', default:'Licensor')}</th>
                <g:sortableColumn params="${params}" property="startDate" title="${message(code:'licence.start_date', default:'Start Date')}" />
                <g:sortableColumn params="${params}" property="endDate" title="${message(code:'licence.end_date', default:'End Date')}" />
                <th>${message(code:'default.actions.label', default:'Action')}</th>
              </tr>
            </thead>
            <tbody>
              <g:each in="${licenses}" var="l">
                <tr>
                  <td><g:link action="index"
                              controller="licenseDetails" 
                              id="${l.id}">${l.reference?:message(code:'missingLicenseReference', default:'** No Licence Reference Set **')}</g:link>
                   <g:if test="${l.subscriptions && ( l.subscriptions.size() > 0 )}">
                      <ul>
                        <g:each in="${l.subscriptions}" var="sub">
                          <g:if test="${sub.status?.value != 'Deleted'}">
                            <li><g:link controller="subscriptionDetails" action="index" id="${sub.id}">${sub.id} (${sub.name})</g:link><br/></li>
                          </g:if>
                        </g:each>
                      </ul>
                    </g:if>
                    <g:else>
                      <br/>No linked subscriptions.
                    </g:else>
                  </td>
                  <td>${l.licensor?.name}</td>
                  <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${l.startDate}"/></td>
                  <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${l.endDate}"/></td>
                  <td>
                    <g:link controller="myInstitutions" action="actionLicenses" params="${[shortcode:params.shortcode,baselicense:l.id,'copy-licence':'Y']}" class="btn btn-success">Copy</g:link>
                    <g:link controller="myInstitutions" action="actionLicenses" onclick="return confirm('${message(code:'licence.delete.confirm', default:'Are you sure you want to delete')} ${l.reference?:message(code:'missingLicenseReference', default:'** No Licence Reference Set **')}?')" params="${[shortcode:params.shortcode,baselicense:l.id,'delete-licence':'Y']}" class="btn btn-danger">${message(code:'default.button.delete.label', default:'Delete')}</g:link>
                  </td>
                </tr>
              </g:each>
            </tbody>
          </table>
        </div>
       
        <div class="pagination" style="text-align:center">
          <bootstrap:paginate action="currentLicenses" controller="myInstitutions" params="${params}" next="${message(code:'default.paginate.next', default:'Next')}" prev="${message(code:'default.paginate.prev', default:'Prev')}" max="${max}" total="${licenseCount}" />
        </div>

    <r:script type="text/javascript">

        $("#datepicker-validOn").datepicker({
            format:"${session.sessionPreferences?.globalDatepickerFormat}"
        });

        $('.licence-results input[type="radio"]').click(function () {
            $('.licence-options').slideDown('fast');
        });

        function availableTypesSelectUpdated(optionSelected){

          var selectedOption = $( "#availablePropertyTypes option:selected" )

          var selectedValue = selectedOption.val()

          //Set the value of the hidden input, to be passed on controller
          $('#propertyFilterType').val(selectedOption.text())
          
          updateInputType(selectedValue)  
        }

        function updateInputType(selectedValue){
          //If we are working with RefdataValue, grab the values and create select box
          if(selectedValue.indexOf("RefdataValue") != -1){
            var refdataType = selectedValue.split("&&")[1]
            $.ajax({ url:'<g:createLink controller="ajax" action="sel2RefdataSearch"/>'+'/'+refdataType+'?format=json',
                        success: function(data) {
                          var select = ' <select id="selectVal" name="propertyFilter" > '
                          //we need empty when we dont want to search by property
                          select += ' <option></option> '
                          for(var index=0; index < data.length; index++ ){
                            var option = data[index]
                            select += ' <option value="'+option.text+'">'+option.text+'</option> '
                          }
                          select += '</select>'
                          $('#selectVal').replaceWith(select)
                        },async:false
            });
          }else{
            //If we dont have RefdataValues,create a simple text input
            $('#selectVal').replaceWith('<input id="selectVal" type="text" name="propertyFilter" placeholder="${message(code:'licence.search.property.ph', default:'property value')}" />')
          }
        }

        function setTypeAndSearch(){
          var selectedType = $("#propertyFilterType").val()
          //Iterate the options, find the one with the text we want and select it
          var selectedOption = $("#availablePropertyTypes option").filter(function() {
                return $(this).text() == selectedType ;
          }).prop('selected', true); //This will trigger a change event as well.


          //Generate the correct select box
          availableTypesSelectUpdated(selectedOption)

          //Set selected value for the actual search
          var paramPropertyFilter = "${params.propertyFilter}";
          var propertyFilterElement = $("#selectVal");
          if(propertyFilterElement.is("input")){
            propertyFilterElement.val(paramPropertyFilter);
          }else{
              $("#selectVal option").filter(function() {
                return $(this).text() == paramPropertyFilter ;
              }).prop('selected', true);
          }
        }

        $('#availablePropertyTypes').change(function(e) {
          var optionSelected = $("option:selected", this);
          availableTypesSelectUpdated(optionSelected);
        });

        $('.licence-options .delete-licence').click(function () {
            $('.licence-results input:checked').each(function () {
                $(this).parent().parent().fadeOut('slow');
                $('.licence-options').slideUp('fast');
            })
        })
        window.onload = setTypeAndSearch()
    </r:script>


  </body>
</html>
