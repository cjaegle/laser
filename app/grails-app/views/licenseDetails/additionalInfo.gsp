<!doctype html>
<html>
    <head>
        <meta name="layout" content="mmbootstrap"/>
        <title>${message(code:'laser', default:'LAS:eR')} Licence</title>
</head>

<body>

    <div class="container">
      <g:render template="breadcrumb" model="${[ license:license, params:params ]}"/>
    </div>

    <div class="container">
        <h1>${license.licensee?.name} ${license.type?.value} Licence : ${license.reference}</h1>

        <g:render template="nav" />
    </div>



    <div class="container">
      <h2>Permissions for user</h2>
      <table  class="table table-striped table-bordered">
      </table>

      <h2>The following organisations are granted the listed permissions from this licence</h2>
      <table  class="table table-striped table-bordered">
        <tr>
          <th>Organisation</th><th>Roles and Permissions</th>
        </tr>
        <g:each in="${license.orgLinks}" var="ol">
          <tr>
            <td>${ol.org.name}</td>
            <td>
              Connected to this licence through link ${ol.id} link role : ${ol.roleType?.value}.<br/>
              This role grants the following permissions to members of that org whose membership role also includes the permission<br/>
              <ul>
                <g:each in="${ol.roleType?.sharedPermissions}" var="sp">
                  <li>${sp.perm.code} 
                      <g:if test="${license.checkPermissions(sp.perm.code,user)}">
                        [Granted]
                      </g:if>
                      <g:else>
                        [Not granted]
                      </g:else>
 
                  </li>
                </g:each>
              </ul>
            </td>
          </tr>
        </g:each>
      </table>

      <h2>Logged in user permissions</h2>
      <table  class="table table-striped table-bordered">
        <tr>
          <th>Affiliated via Role</th><th>Permissions</th>
        </tr>
        <g:each in="${user.affiliations}" var="ol">
          <g:if test="${((ol.status==1) || (ol.status==3))}">
            <tr>
              <td>Affiliated to ${ol.org?.name} with role <g:message code="cv.roles.${ol.formalRole?.authority}"/></td>
              <td>
                <ul>
                  <g:each in="${ol.formalRole.grantedPermissions}" var="gp">
                    <li>${gp.perm.code}</li>
                  </g:each>
                </ul>
              </td>
            </tr>
            <g:each in="${ol.org.outgoingCombos}" var="oc">
              <tr>
                <td> --&gt; This org is related to ${oc.toOrg.name} ( ${oc.type.value} )</td>
                <td>
                  <ul>
                    <g:each in="${oc.type.sharedPermissions}" var="gp">
                      <li>${gp.perm.code}</li>
                    </g:each>
                  </ul>
                </td>
              </tr>     
            </g:each>
          </g:if>
        </g:each>
      </table>
   
    </div>


</body>
</html>
