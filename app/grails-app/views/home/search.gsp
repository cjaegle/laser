<!doctype html>
<%
  def addFacet = { params, facet, val ->
    def newparams = [:]
    newparams.putAll(params)
    def current = newparams[facet]
    if ( current == null ) {
      newparams[facet] = val
    }
    else if ( current instanceof String[] ) {
      newparams.remove(current)
      newparams[facet] = current as List
      newparams[facet].add(val);
    }
    else {
      newparams[facet] = [ current, val ]
    }
    newparams
  }

  def removeFacet = { params, facet, val ->
    def newparams = [:]
    newparams.putAll(params)
    def current = newparams[facet]
    if ( current == null ) {
    }
    else if ( current instanceof String[] ) {
      newparams.remove(current)
      newparams[facet] = current as List
      newparams[facet].remove(val);
    }
    else if ( current?.equals(val.toString()) ) {
      newparams.remove(facet)
    }
    newparams
  }

%>

<html>
  <head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser', default:'LAS:eR')} Data import explorer</title>
  </head>

  <body>
    <div class="content"><div class="row-fluid">
      <div class="row well text-center">
        <g:form role="form" action="search" controller="home" method="get" class="form-inline">
          <fieldset>

            <g:each in="${['type','endYear','startYear','consortiaName','cpname']}" var="facet">
              <g:each in="${params.list(facet)}" var="selected_facet_value"><input type="hidden" name="${facet}" value="${selected_facet_value}"/></g:each>
            </g:each>

            <label>Search Text : </label>
            <input id="intext" type="text" class="form-control" placeholder="Search Text" name="q" value="${params.q}"/>
            <!--
            <label>Keywords : </label>
            <input id="kwin" type="text" class="form-control" placeholder="Keyword" name="q" value="${params.q}"/>
            -->
            <button name="search" type="submit" value="true" class="ui button">Search</button>
          </fieldset>
        </g:form>
        <p>
          <g:each in="${['type','endYear','startYear','consortiaName','cpname']}" var="facet">
            <g:each in="${params.list(facet)}" var="fv">
              <span class="badge alert-info">${facet}:${fv} &nbsp; <g:link controller="home" action="search" params="${removeFacet(params,facet,fv)}"><i class="icon-remove icon-white"></i></g:link></span>
            </g:each>
          </g:each>
        </p>
        <g:if test="${hits!=null}">
          <p>
            Your search found ${hits?.totalHits} records
          </p>
        </g:if>
      </div></div>


      <div class="container-fluid">
        <div class="facetFilter span3">
          <g:each in="${facets}" var="facet">
            <div class="panel panel-default">
              <div class="panel-heading">
                <h5><g:message code="facet.so.${facet.key}" default="${facet.key}" /></h5>
              </div>
              <div class="panel-body">
                <ul>
                  <g:each in="${facet.value.sort{it.display}}" var="v">
                    <li>
                      <g:set var="fname" value="facet:${facet.key+':'+v.term}"/>
 
                      <g:if test="${params.list(facet.key).contains(v.term.toString())}">
                        ${v.display} (${v.count})
                      </g:if>
                      <g:else>
                        <g:link controller="home" action="search" params="${addFacet(params,facet.key,v.term)}">${v.display}</g:link> (${v.count})
                      </g:else>
                    </li>
                  </g:each>
                </ul>
              </div>
            </div>
          </g:each>
        </div>
        <div class="span9">


              <g:if test="${hits}" >
                <div class="paginateButtons" style="text-align:center">
                  <g:if test="${params.int('offset')}">
                   Showing Results ${params.int('offset') + 1} - ${resultsTotal < (params.int('max') + params.int('offset')) ? resultsTotal : (params.int('max') + params.int('offset'))} of ${resultsTotal}
                  </g:if>
                  <g:elseif test="${resultsTotal && resultsTotal > 0}">
                    Showing Results 1 - ${resultsTotal < params.int('max') ? resultsTotal : params.int('max')} of ${resultsTotal}
                  </g:elseif>
                  <g:else>
                    Showing ${resultsTotal} Results
                  </g:else>
                </div>


                <div id="resultsarea">
                  <table cellpadding="5" cellspacing="5">
                    <tr><th>Type</th><th>Title/Name</th><th>Additional Info</th></tr>
                    <g:each in="${hits}" var="hit">
                      <tr>
                        <td>
                          <g:if test="${hit.type=='com.k_int.kbplus.Org'}"><span class="label label-info">Organisation</span></g:if>
                          <g:if test="${hit.type=='com.k_int.kbplus.TitleInstance'}"><span class="label label-info">Title Instance</span></g:if>
                          <g:if test="${hit.type=='com.k_int.kbplus.Package'}"><span class="label label-info">Package</span></g:if>
                          <g:if test="${hit.type=='com.k_int.kbplus.Platform'}"><span class="label label-info">Platform</span></g:if>
                          <g:if test="${hit.type=='com.k_int.kbplus.Subscription'}"><span class="label label-info">Subscription</span></g:if>
                          <g:if test="${hit.type=='com.k_int.kbplus.License'}"><span class="label label-info">License</span></g:if>
                        </td>
                        <g:if test="${hit.type=='com.k_int.kbplus.Org'}">
                            <td><g:link controller="org" action="show" id="${hit.getSource().dbId}">${hit.getSource().name}</g:link></td>
                        </g:if>
                        <g:if test="${hit.type=='com.k_int.kbplus.TitleInstance'}">
                          <td><g:link controller="titleInstance" action="show" id="${hit.getSource().dbId}">${hit.getSource().title}</g:link></td>
                          <td>
                            <g:each in="${hit.getSource().identifiers}" var="id">
                              ${id.type}:${id.value} &nbsp;
                            </g:each>
                          </td>
                        </g:if>
                        <g:if test="${hit.type=='com.k_int.kbplus.Package'}">
                          <td><g:link controller="package" action="show" id="${hit.getSource().dbId}">${hit.getSource().name}</g:link></td>
                        </g:if>
                        <g:if test="${hit.type=='com.k_int.kbplus.Platform'}">
                          <td><g:link controller="platform" action="show" id="${hit.getSource().dbId}">${hit.getSource().name}</g:link></td>
                        </g:if>
                        <g:if test="${hit.type=='com.k_int.kbplus.Subscription'}">
                          <td><g:link controller="subscription" action="show" id="${hit.getSource().dbId}">${hit.getSource().name} (${hit.getSource().type})</g:link></td>
                          <td>${hit.getSource().identifier}</td>
                        </g:if>
                        <g:if test="${hit.type=='com.k_int.kbplus.License'}">
                          <td><g:link controller="license" action="show" id="${hit.getSource().dbId}">${hit.getSource().name}</g:link></td>
                        </g:if>
                      </tr>
                    </g:each>
                  </table>
                </div>
                <div class="paginateButtons" style="text-align:center">
                  <span><g:paginate controller="home" action="search" params="${params}" next="Next" prev="Prev" total="${resultsTotal}" /></span>
              </div>
              </g:if>

        </div>
      </div>
    </div>
  </body>
</html>
