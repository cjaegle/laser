<!doctype html>

<html>
<head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code: 'laser')} : ${message(code: 'package.show.all')}</title>
</head>

<body>

<semui:breadcrumbs>
    <semui:crumb message="package.show.all" class="active"/>
</semui:breadcrumbs>
<br>
<h1 class="ui left floated aligned icon header la-clear-before"><semui:headerIcon/>${message(code: 'package.show.all')}
<semui:totalNumber total="${resultsTotal2}"/>
</h1>

<semui:messages data="${flash}"/>

<g:render template="/templates/filter/javascript" />
<semui:filter showFilterButton="true">
    <g:form action="index" method="get" params="${params}" class="ui form">
        <input type="hidden" name="offset" value="${params.offset}"/>

        <div class="field">
            <label>${message(code: 'home.search.text')}: ${message(code: 'package.show.pkg_name')}, ${message(code: 'package.content_provider')}</label>
            <input name="q" placeholder="${message(code:'default.search.ph')}" value="${params.q}"/>
        </div>

        <div class="field la-field-right-aligned">
            <a href="${request.forwardURI}"
               class="ui reset primary button">${message(code: 'default.button.filterreset.label')}</a>
            <button type="submit" name="search" value="yes"
                    class="ui secondary button">${message(code: 'default.button.filter.label')}</button>
        </div>
    </g:form>
</semui:filter>
<div class="ui icon info message">
    <i class="exclamation triangle icon"></i>
    <i class="close icon"></i>
    <div class="content">
        <div class="header">
            ${message(code: 'message.attention')}
        </div>

        <p>${message(code: 'message.attention.needTime')}</p>
    </div>
</div>

%{--  <div class="twelve wide column">
      <div>
             <g:if test="${hits}" >
                <div class="paginateButtons" style="text-align:center">

                  <g:if test="${offset && params.int('offset') > 0 }">
                    ${message(code:'default.search.offset.text', args: [(params.int('offset') + 1),(resultsTotal < (params.int('max') + params.int('offset')) ? resultsTotal : (params.int('max') + params.int('offset'))),resultsTotal])}
                  </g:if>
                  <g:elseif test="${resultsTotal && resultsTotal > params.int('max')}">
                    ${message(code:'default.search.no_offset.text', args: [(resultsTotal < params.int('max') ? resultsTotal : params.int('max')),resultsTotal])}
                  </g:elseif>
                  <g:elseif test="${resultsTotal && resultsTotal == 1}">
                    ${message(code:'default.search.single.text')}
                  </g:elseif>
                  <g:else>
                    ${message(code:'default.search.no_pagiantion.text', args:[resultsTotal])}
                  </g:else>
                </div><!-- .paginateButtons -->

                <div id="resultsarea">
                  <table class="ui sortable celled la-table table">
                    <thead>
                      <tr>
                          <th>${message(code:'sidewide.number')}</th>
                          <g:sortableColumn property="name" title="${message(code:'package.show.pkg_name', default:'Package Name')}" params="${params}" />
                          <th>${message(code:'default.status.label')}</th>
                          <th>${message(code:'package.compare.overview.tipps')}</th>
                          <th>${message(code:'package.content_provider')}</th>
                          <th>${message(code:'package.nominalPlatform')}</th>
                          <th>${message(code:'package.scope')}</th>
                      </tr>
                    </thead>
                    <tbody>
                      <g:each in="${hits}" var="hit" status="jj">
                        <tr>
                            <td>${ (params.int('offset') ?: 0)  + jj + 1 }</td>
                          <td>
                            <g:if test="${com.k_int.kbplus.Package.findByImpId(hit?.id)}">
                                <g:link controller="package" action="show" id="${com.k_int.kbplus.Package.findByImpId(hit?.id).id}">${hit?.getSource().name}</g:link>
                            </g:if>
                              <g:else>
                                  ${hit?.getSource().name} <a target="_blank" href="${es_host_url ? es_host_url+'/gokb/resource/show/'+hit?.id : '#'}" ><i title="GOKB Link" class="external alternate icon"></i></a>
                              </g:else>
                          </td>
                            <td>${message(code: 'refdata.'+hit?.getSource().status)}</td>
                          <td>
                              <g:if test="${hit?.getSource().tippsCountCurrent}">
                                <g:if test="${hit?.getSource().tippsCountCurrent == 1}">
                                    <g:if test="${com.k_int.kbplus.Package.findByImpId(hit?.id)}">
                                        <g:link controller="package" action="current" id="${com.k_int.kbplus.Package.findByImpId(hit?.id).id}">${message(code:'package.index.result.titles.single')}</g:link>
                                    </g:if>
                                    <g:else>
                                        ${message(code:'package.index.result.titles.single')}
                                    </g:else>
                                </g:if>
                                <g:else>
                                    <g:if test="${com.k_int.kbplus.Package.findByImpId(hit?.id)}">
                                        <g:link controller="package" action="current" id="${com.k_int.kbplus.Package.findByImpId(hit?.id).id}">${message(code:'package.index.result.titles', args: [hit?.getSource().tippsCountCurrent])}</g:link>
                                    </g:if>
                                    <g:else>
                                        ${message(code:'package.index.result.titles', args: [hit?.getSource().tippsCountCurrent])}
                                    </g:else>

                                </g:else>
                              </g:if>
                              <g:else>
                                  ${message(code:'package.index.result.titles.unknown', default:'Unknown number of TIPPs')}
                              </g:else>
                          </td>
                            <td><g:if test="${com.k_int.kbplus.Org.findByName(hit?.getSource().providerName)}"><g:link controller="organisation" action="show" id="${com.k_int.kbplus.Org.findByName(hit?.getSource().providerName).id}">${hit?.getSource().providerName}</g:link></g:if>
                                <g:else>${hit?.getSource().providerName}</g:else>
                            </td>
                            <td><g:if test="${com.k_int.kbplus.Platform.findByName(hit?.getSource().platformName)}"><g:link controller="platform" action="show" id="${com.k_int.kbplus.Platform.findByName(hit?.getSource().platformName).id}">${hit?.getSource().platformName}</g:link></g:if>
                                <g:else>${hit?.getSource().platformName}</g:else></td>
                            <td>${hit?.getSource().scope}</td>
                        </tr>
                      </g:each>
                    </tbody>
                  </table>
                </div><!-- #resultsarea -->

                 <semui:paginate action="index" controller="package" params="${params}"
                                 next="${message(code: 'default.paginate.next')}"
                                 prev="${message(code: 'default.paginate.prev')}" max="${max}"
                                 total="${resultsTotal}"/>

             </g:if>
            <g:else>
              <p><g:message code="default.search.empty" default="No results found"/></p>
            </g:else>
          </div>
    </div>
  </div>--}%

<div class="twelve wide column la-clear-before">
    <div>
        <g:if test="${records}">

            <div id="resultsarea">
                <table class="ui sortable celled la-table table">
                    <thead>
                    <tr>
                        <th>${message(code: 'sidewide.number')}</th>
                        <g:sortableColumn property="name"
                                          title="${message(code: 'package.show.pkg_name')}"
                                          params="${params}"/>
                        <th>${message(code: 'package.compare.overview.tipps')}</th>
                        <g:sortableColumn property="providerName" title="${message(code: 'package.content_provider')}"
                                          params="${params}"/>
                        <g:sortableColumn property="platformName" title="${message(code: 'package.nominalPlatform')}"
                                          params="${params}"/>
                        <th>${message(code: 'package.curatoryGroup.label')}</th>
                        <th>${message(code: 'package.listVerifiedDate.label')}</th>
                        <th>${message(code: 'package.scope')}</th>
                        <th>${message(code: 'package.contentType.label')}</th>
                        <th>${message(code: 'package.packageListStatus')}</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${records}" var="record" status="jj">
                        <tr>
                            <td>${(params.int('offset') ?: 0) + jj + 1}</td>
                            <td>
                                <!--${record} -->
                                <!--UUID: ${record?.uuid} -->
                                <!--Package: ${com.k_int.kbplus.Package.findByGokbId(record?.uuid)} -->
                                <g:if test="${com.k_int.kbplus.Package.findByGokbId(record?.uuid)}">
                                    <g:link controller="package" action="show"
                                            id="${com.k_int.kbplus.Package.findByGokbId(record?.uuid).id}">${record?.name}</g:link>
                                </g:if>
                                <g:else>
                                    ${record?.name} <a target="_blank"
                                                      href="${record?.editUrl ? record?.editUrl + '/gokb/public/packageContent/' + record?.uuid : '#'}"><i
                                            title="GOKB Link" class="external alternate icon"></i></a>
                                </g:else>
                            </td>
                            <td>
                                <g:if test="${record?.titleCount}">
                                    <g:if test="${record?.titleCount == 1}">
                                        <g:if test="${com.k_int.kbplus.Package.findByGokbId(record?.uuid)}">
                                            <g:link controller="package" action="current"
                                                    id="${com.k_int.kbplus.Package.findByGokbId(record?.uuid).id}">${message(code: 'package.index.result.titles.single')}</g:link>
                                        </g:if>
                                        <g:else>
                                            ${message(code: 'package.index.result.titles.single')}
                                        </g:else>
                                    </g:if>
                                    <g:else>
                                        <g:if test="${com.k_int.kbplus.Package.findByGokbId(record?.uuid)}">
                                            <g:link controller="package" action="current"
                                                    id="${com.k_int.kbplus.Package.findByGokbId(record?.uuid).id}">${message(code: 'package.index.result.titles', args: [record?.titleCount])}</g:link>
                                        </g:if>
                                        <g:else>
                                            ${message(code: 'package.index.result.titles', args: [record?.titleCount])}
                                        </g:else>

                                    </g:else>
                                </g:if>
                                <g:else>
                                    ${message(code: 'package.index.result.titles.unknown')}
                                </g:else>
                            </td>
                            <td><g:if test="${com.k_int.kbplus.Org.findByGokbId(record.providerUuid)}"><g:link
                                    controller="organisation" action="show"
                                    id="${com.k_int.kbplus.Org.findByGokbId(record.providerUuid).id}">${record.providerName}</g:link></g:if>
                            <g:else>${record.providerName}</g:else>
                            </td>
                            <td><g:if test="${com.k_int.kbplus.Platform.findByGokbId(record?.platformUuid)}"><g:link
                                    controller="platform" action="show"
                                    id="${com.k_int.kbplus.Platform.findByGokbId(record?.platformUuid).id}">${record.platformName}</g:link></g:if>
                                <g:else>${record.platformName}</g:else></td>
                            <td>
                                <div class="ui bulleted list">
                                <g:each in="${record.curatoryGroups}" var="curatoryGroup">
                                    <div class="item">${curatoryGroup}</div>
                                </g:each>
                                </div>
                            </td>
                            <td>${record.listVerifiedDate}</td>
                            <td>${record.scope}</td>
                            <td>${record.contentType}</td>
                            <td class="center aligned">
                                <g:if test="${record.listStatus == 'In Progress'}">
                                    <span class="la-popup-tooltip la-delay" data-position="right center" data-content="${message(code:'package.show.record.listStatus.inProgress')}">
                                        <i class="exclamation triangle yellow icon"></i>
                                    </span>
                                </g:if>
                                <g:elseif test="${record.listStatus == 'Checked'}">
                                    <span class="la-popup-tooltip la-delay" data-position="right center" data-content="${message(code:'package.show.record.listStatus.Checked')}">
                                        <i class="check green circle icon"></i>
                                    </span>
                                </g:elseif>
                                <g:else></g:else>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div><!-- #resultsarea -->

            <semui:paginate action="index" controller="package" params="${params}"
                            next="${message(code: 'default.paginate.next')}"
                            prev="${message(code: 'default.paginate.prev')}" max="${max}"
                            total="${resultsTotal2}"/>

        </g:if>
        <g:else>
            <p><g:message code="default.search.empty" /></p>
        </g:else>
    </div>
</div>

</body>
</html>
