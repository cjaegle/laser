<%--
  Created by IntelliJ IDEA.
  User: ioannis
  Date: 15/05/2014
  Time: 15:00
--%>

<%@ page import="com.k_int.kbplus.TitleInstance" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mmbootstrap">
    <g:set var="entityName" value="${message(code: 'titleInstance.label', default: 'Title Instance')}"/>
    <title><g:message code="default.edit.label" args="[entityName]"/></title>
</head>

<body>

<div class="container">
  <ul class="breadcrumb">
    <li> <g:link controller="home" action="index">${message(code:'default.home.label', default:'Home')}</g:link> <span class="divider">/</span> </li>
    <li> <g:link controller="titleDetails" action="show" id="${titleInstance.id}">${message(code: 'title', default: 'Title')} ${titleInstance.title}</g:link> </li>

    <li class="dropdown pull-right">

    <g:if test="${editable}">
      <li class="pull-right"><span class="badge badge-warning">${message(code: 'default.editable', default: 'Editable')}</span>&nbsp;</li>
    </g:if>
  </ul>
</div>

<div class="container">
    <div class="span12">


  <div class="page-header">   <h1>${titleInstance.title}</h1> </div>         

    <g:render template="nav" />
    
    <g:if test="${flash.message}">
        <div class="container"><bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert></div>
    </g:if>

    <g:if test="${flash.error}">
        <div class="container"><bootstrap:alert class="alert-error">${flash.error}</bootstrap:alert></div>
    </g:if>

    <g:if test="${formattedHistoryLines?.size() > 0}">

      <div class="container alert-warn">
        <table class="table table-bordered">
          <thead>
            <tr>
              <td>${message(code:'event.component', default:'Name')}</td>
              <td>${message(code:'event.actor', default:'Actor')}</td>
              <td>${message(code:'event.name', default:'Event name')}</td>
              <td>${message(code:'event.property', default:'Property')}</td>
              <td>${message(code:'event.old', default:'Old')}</td>
              <td>${message(code:'event.new', default:'New')}</td>
              <td>${message(code:'default.date.label', default:'Date')}</td>
            </tr>
          </thead>
          <tbody>
            <g:each in="${formattedHistoryLines}" var="hl">
              <tr>
                <td><a href="${hl.link}">${hl.name}</a></td>
                <td>
                  <g:link controller="userDetails" action="edit" id="${hl.actor?.id}">${hl.actor?.displayName}</g:link>
                </td>
                <td>${hl.eventName}</td>
                <td>${hl.propertyName}</td>
                <td>${hl.oldValue}</td>
                <td>${hl.newValue}</td>
                <td><g:formatDate format="${message(code:'default.date.format.notime', default:'yyyy-MM-dd')}" date="${hl.lastUpdated}"/></td>
              </tr>
            </g:each>
          </tbody>
        </table>
      </div>


      <div class="pagination" style="text-align:center">
        <g:if test="${historyLines != null}" >
          <bootstrap:paginate  action="history" controller="titleDetails" params="${params}" next="${message(code:'default.paginate.next', default:'Next')}" prev="${message(code:'default.paginate.prev', default:'Prev')}" maxsteps="${max}" total="${num_hl}" />
        </g:if>
      </div>
    </g:if>
    <g:else>
      <div class="container alert-warn"> </div>
    </g:else>
  </div>
  </div>
  </div>

</body>
</html>
