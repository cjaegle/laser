  <table class="table table-bordered licence-properties">
    <thead>
      <tr>
        <td>Organisation Name</td>
        <td>Role</td>
        <td>actions</td>
      </tr>
    </thead>
    <g:each in="${roleLinks}" var="role">
      <tr>
        <g:if test="${role.org}">
          <td><g:link controller="Organisations" action="info" id="${role.org.id}">${role?.org?.name}</g:link></td>
          <td>${role?.roleType?.value}</td>
          <td>
            <g:if test="${editmode}">
              <g:link controller="ajax" action="delOrgRole" id="${role.id}" onclick="return confirm('Really delete this org link?')">Delete</g:link>
            </g:if>
          </td>
        </g:if>
        <g:else>
          <td colspan="3">Error - Role link without org ${role.id} Please report to support</td>
        </g:else>
      </tr>
    </g:each>
  </table>
  <g:if test="${editmode}">
    <a class="btn" data-toggle="modal" href="#osel_add_modal" >Add Org Link</a>
  </g:if>
