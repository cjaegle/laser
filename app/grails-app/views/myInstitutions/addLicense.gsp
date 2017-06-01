<!doctype html>
<html>
  <head>
    <meta name="layout" content="mmbootstrap"/>
    <title>${message(code:'laser', default:'LAS:eR')} ${message(code:'myinst.addLicence.label', default:'Data import explorer')}</title>
  </head>
  <body>

    <div class="container">
        <ul class="breadcrumb">
            <li> <g:link controller="home" action="index">${message(code:'default.home.label', default:'Home')}</g:link> <span class="divider">/</span> </li>
           <li> <g:link controller="myInstitutions" action="addLicense" params="${[shortcode:params.shortcode]}">${institution.name} - ${message(code:'licence.copy', default:'Copy from Template')}</g:link> </li>
        </ul>
    </div>

    <div class="container">
      <h1>${institution?.name} - ${message(code:'licence.plural', default:'Licences')}</h1>
      <ul class="nav nav-pills">
       <li><g:link controller="myInstitutions" 
                   action="currentLicenses" 
                   params="${[shortcode:params.shortcode]}">${message(code:'licence.current')}</g:link></li>

       <li class="active"><g:link controller="myInstitutions" 
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
            <div class="span6">&nbsp;
                <!--
                <input type="text" name="keyword-search" placeholder="enter search term..." />
                <input type="submit" class="btn btn-primary" value="Search" />
                -->
            </div>
            <div class="span6">
            </div>
        </div>
    </div>

      <div class="container">
        <g:form action="addLicense" params="${params}" method="get" class="form-inline">
          <input type="hidden" name="sort" value="${params.sort}">
          <input type="hidden" name="order" value="${params.order}">
          <label>${message(code:'default.filter.plural', default:'Filters')} - ${message(code:'licence.name')}:</label> <input name="filter" value="${params.filter}"/> &nbsp;
          <input type="submit" class="btn btn-primary" value="${message(code:'default.button.submit.label')}" />
        </g:form>
      </div>

      <div class="container">
          <div class="well licence-options">
            <g:if test="${is_admin}">
              <input type="submit" name="copy-licence" value="${message(code:'default.button.copySelected.label', default:'Copy Selected')}" class="btn btn-warning" />
            </g:if>
            <g:else>${message(code:'myinst.addLicence.no_permission', default:'Sorry, you must have editor role to be able to add licences')}</g:else>
          </div>
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


      <g:if test="${licenses?.size() > 0}">
        <div class="container licence-results">
          <table class="table table-bordered table-striped">
            <thead>
              <tr>
                <g:sortableColumn params="${params}" property="reference" title="${message(code:'licence.name')}" />
                <th>${message(code:'licence.licensor.label', default:'Licensor')}</th>
                <g:sortableColumn params="${params}" property="startDate" title="${message(code:'default.startDate.label', default:'Start Date')}" />
                <g:sortableColumn params="${params}" property="endDate" title="${message(code:'default.endDate.label', default:'End Date')}" />
                <th>${message(code:'default.actions.label', default:'Action')}</th>
              </tr>
            </thead>
            <tbody>
              <g:each in="${licenses}" var="l">
                <tr>
                  <td>
                    <g:link action="index"
                              controller="licenseDetails" 
                              id="${l.id}">
                              <g:if test="${l.reference}">${l.reference}</g:if>
                              <g:else>${message(code:'myinst.addLicence.no_ref', args:[l.id])}</g:else>
                    </g:link>
                    <g:if test="${l.pkgs && ( l.pkgs.size() > 0 )}">
                      <ul>
                        <g:each in="${l.pkgs}" var="pkg">
                          <li><g:link controller="packageDetails" action="show" id="${pkg.id}">${pkg.id} (${pkg.name})</g:link><br/></li>
                        </g:each>
                      </ul>
                    </g:if>
                    <g:else>
                      <br/>${message(code:'myinst.addLicence.no_results', default:'No linked packages.')}
                    </g:else>
                  </td>
                  <td>${l.licensor?.name}</td>
                  <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${l.startDate}"/></td>
                  <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${l.endDate}"/></td>
                  <td><g:link controller="myInstitutions" action="actionLicenses" params="${[shortcode:params.shortcode,baselicense:l.id,'copy-licence':'Y']}" class="btn btn-success">${message(code:'default.button.copy.label', default:'Copy')}</g:link></td>
                </tr>
              </g:each>
            </tbody>
          </table>

          <div class="pagination" style="text-align:center">
            <g:if test="${licenses}" >
              <bootstrap:paginate  action="addLicense" controller="myInstitutions" params="${params}" next="${message(code:'default.paginate.next', default:'Next')}" prev="${message(code:'default.paginate.prev', default:'Prev')}" max="${max}" total="${numLicenses}" />
            </g:if>
          </div>
        </div>

      </g:if>

    <r:script type="text/javascript">
        $('.licence-results input[type="radio"]').click(function () {
            $('.licence-options').slideDown('fast');
        });

        $('.licence-options .delete-licence').click(function () {
            $('.licence-results input:checked').each(function () {
                $(this).parent().parent().fadeOut('slow');
                $('.licence-options').slideUp('fast');
            })
        })
    </r:script>

  </body>
</html>
