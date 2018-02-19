<!doctype html>
<html>
    <head>
        <meta name="layout" content="semanticUI"/>
        <title>${message(code:'laser', default:'LAS:eR')} ${institution.name} ${message(code:'myinst.todo.list', default:'ToDo List')}</title>
    </head>

    <body>

        <semui:breadcrumbs>
            <semui:crumb controller="myInstitution" action="dashboard" text="${institution?.getDesignation()}" />
            <semui:crumb text="(${num_todos} ${message(code:'myinst.todo.items', default:'Items')})" message="myinst.todo.list" class="active" />
        </semui:breadcrumbs>

    <div class="home-page">
      <h1 class="ui header">${message(code:'myinst.todo.pagination', args:[(params.offset?:1), (java.lang.Math.min(num_todos,(params.int('offset')?:0)+10)), num_todos])}</h1>
   

        <g:if test="${todos!=null}" >
          <semui:paginate  action="todo" controller="myInstitution" params="${params}" next="${message(code:'default.paginate.next', default:'Next')}" prev="${message(code:'default.paginate.prev', default:'Prev')}" max="${max}" total="${num_todos}" />
        </g:if>


            <table class="ui table">
              <g:each in="${todos}" var="todo">
                <tr>
                  <td>
                    <strong>
                      <g:if test="${todo.item_with_changes instanceof com.k_int.kbplus.Subscription}">
                        <g:link controller="subscriptionDetails" action="index" id="${todo.item_with_changes.id}">${message(code:'subscription')}: ${todo.item_with_changes.toString()}</g:link>
                      </g:if>
                      <g:else>
                        <g:link controller="licenseDetails" action="show" id="${todo.item_with_changes.id}">${message(code:'license')}: ${todo.item_with_changes.toString()}</g:link>
                      </g:else>
                    </strong><br/>
                    <span class="badge badge-warning">${todo.num_changes}</span> 
                    <span>${message(code:'myinst.change_from', default:'Change(s) between')} <g:formatDate date="${todo.earliest}" format="yyyy-MM-dd hh:mm a"/></span>
                    <span>${message(coe:'myinst.change_to', default:'and')} <g:formatDate date="${todo.latest}" format="yyyy-MM-dd hh:mm a"/></span><br/>
                  </td>
                </tr>
              </g:each>
            </table>

        <g:if test="${todos!=null}" >
          <semui:paginate  action="todo" controller="myInstitution" params="${params}" next="${message(code:'default.paginate.next', default:'Next')}" prev="${message(code:'default.paginate.prev', default:'Prev')}" max="${max}" total="${num_todos}" />
        </g:if>

    </div>


  </body>
</html>
