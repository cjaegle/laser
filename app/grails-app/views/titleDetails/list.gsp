<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser', default:'LAS:eR')} ${message(code: 'title.plural')} - ${message(code: 'default.button.search.label')}</title>
  </head>
  <body>

    <semui:breadcrumbs>
      <semui:crumb message="menu.institutions.all_titles" class="active" />
    </semui:breadcrumbs>

    <semui:filter>
      <g:form action="index" role="form" class="ui form" method="get" params="${params}">
        <input type="hidden" name="offset" value="${params.offset}"/>
        <div class="fields">
          <div class="field">
            <label for="q" class="control-label">${message(code: 'title.search')}</label>
            <input id="q" type="text" name="q" placeholder="${message(code: 'title.search.ph')}" value="${params.q}"/>
          </div>
          <div class="field">
            <label for="filter" class="control-label">${message(code: 'title.search_in')}</label>
            <g:select id="filter" name="filter" from="${[[key:'title',value:"${message(code: 'title.title.label')}"],[key:'publisher',value:"${message(code:'title.publisher.label')}"],[key:'',value:"${message(code: 'title.all.label')}"]]}" optionKey="key" optionValue="value" value="${params.filter}"/>
          </div>
          <div class="field">
              <label>&nbsp;</label>
              <button class="ui secondary button" type="submit" name="search" value="yes">${message(code: 'default.button.search.label')}</button>
          </div>
        </div>
      </g:form>
    </semui:filter>

    <div class="ui grid">
        <div class="sixteen wide column">

             <g:if test="${hits}" >
                <div class="paginateButtons" style="text-align:center">
                  <g:if test="${params.int('offset')}">
                    <g:set var="curOffset" value="${params.int('offset') + 1}" />
                    <g:set var="pageMax" value="${resultsTotal < (params.int('max') + params.int('offset')) ? resultsTotal : (params.int('max') + params.int('offset'))}" />
                    ${message(code: 'title.search.offset.text', args: [curOffset,pageMax,resultsTotal])}
                  </g:if>
                  <g:elseif test="${resultsTotal && resultsTotal > 0}">
                    <g:set var="pageMax" value="${resultsTotal < params.int('max') ? resultsTotal : params.int('max')}" />
                    ${message(code: 'title.search.no_offset.text', args: [pageMax,resultsTotal])}
                  </g:elseif>
                  <g:else>
                    ${message(code: 'title.search.no_pagination.text', args: [resultsTotal])}
                  </g:else>
                </div><!-- .paginateButtons -->

                <div id="resultsarea">
                  <table class="ui sortable celled la-table table">
                    <thead>
                      <tr>
                      <g:sortableColumn property="sortTitle" title="${message(code: 'title.title.label', default: 'Title')}" params="${params}" />
                      <g:sortableColumn property="publisher" style="white-space:nowrap" title="${message(code: 'title.publisher.label', default: 'Publisher')}" params="${params}" />
                      <th style="white-space:nowrap"><g:message code="title.identifiers.label" /></th>
                      </tr>
                    </thead>
                    <tbody>
                      <g:each in="${hits}" var="hit">
                        <tr>
                          <td>
                            <g:link controller="titleDetails" action="show" id="${hit.getSource().dbId}">${hit.getSource().title}</g:link>
                          </td>
                          <td>
                            ${hit.getSource().publisher?:''}
                          </td>
                          <td>
                            <g:each in="${hit.getSource().identifiers}" var="id">
                              <g:if test="${id.type != 'originediturl'}">
                                <div style="white-space:nowrap"><span>${id.type}:</span><span>${id.value}</span></div>
                              </g:if>
                            </g:each>
                          </td>
                        </tr>
                      </g:each>
                    </tbody>
                  </table>
                </div><!-- #resultsarea -->
             </g:if>

              <g:if test="${hits}" >
                <semui:paginate controller="titleDetails" action="index" params="${params}" next="${message(code: 'default.paginate.next')}" prev="${message(code: 'default.paginate.prev')}" maxsteps="10" total="${resultsTotal}" />
              </g:if>

        </div><!-- .sixteen -->
      </div><!-- .grid -->
  </body>
</html>
