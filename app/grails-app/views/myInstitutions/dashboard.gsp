<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser', default:'LAS:eR')} ${message(code:'myinst.title', default:'Institutional Dash')} :: ${org?.name}</title>
  </head>

  <body>



    <div class="home-page">
      <div>
        <div class="span4">
          <div class="well">
            <h6 class="ui header">${message(code:'license.plural', default:'Licenses')}</h6>
            <dl>
              <g:each in="${user.authorizedOrgs}" var="org">
                <dd><g:link controller="myInstitutions" 
                                     action="currentLicenses" 
                                     params="${[shortcode:org?.shortcode]}">${org?.name}</g:link></dd>
              </g:each>
            </dl>
          </div>
        </div>
        <div class="span4">
          <div class="well">
            <h6 class="ui header">${message(code:'subscription.plural', default:'Subscriptions')}</h6>
            <dl>
              <g:each in="${user.authorizedOrgs}" var="org">
                <dd><g:link controller="myInstitutions" 
                                     action="currentSubscriptions" 
                                     params="${[shortcode:org?.shortcode]}">${org?.name}</g:link></dd>
              </g:each>
            </dl>
          </div>
        </div>
        <div class="span4">
          <div class="well">
            <h6 class="ui header">${message(code:'title.plural', default:'Titles')}</h6>
            <dl>
              <g:each in="${user.authorizedOrgs}" var="org">
                <dd><g:link controller="myInstitutions" 
                            action="currentTitles" 
                            params="${[shortcode:org?.shortcode]}">${org?.name}
                </g:link></dd>
              </g:each>
            </dl>
          </div>
        </div>
      </div>
    </div>

  <semui:messages data="${flash}" />

    <g:if test="${staticAlerts.size() > 0}">
      <div>
        <table class="ui celled table">
          <tr><th>${message(code:'sysAlert.label', default:'System Alert')}</th></tr>
          <g:each in="${staticAlerts}" var="sa">
            <tr>
              <td>
                <g:if test="${sa.controller}">
                  <g:link controller="${sa.controller}" action="${sa.action}">${message(code:sa.message)}</g:link>
                </g:if>
                <g:else>
                  ${message(sa.message)}
                </g:else>
              </td>
            </tr>
          </g:each>
        </table>
      </div>
    </g:if>

    <div>
      <table class="ui celled table">
          <thead>
              <tr>
                  <th colspan="6">${message(code:'sysAlert.item.label', default:'Alerted item')}</th>
              </tr>
          </thead>
        <tr class="no-background">
          <th>${message(code:'sysAlert.note', default:'Note')}</th>
          <th>${message(code:'sysAlert.comments', default:'Comments')}</th>
        </tr>
        <g:each in="${userAlerts}" var="ua">
          <tr>
            <td colspan="2">
              <g:if test="${ua.rootObj.class.name=='com.k_int.kbplus.License'}">
                <span class="label label-info">${message(code:'license.label', default:'License')}</span>
                <em><g:link action="index"
                        controller="licenseDetails" 
                        id="${ua.rootObj.id}">${ua.rootObj.reference}</g:link></em>
              </g:if>
              <g:elseif test="${ua.rootObj.class.name=='com.k_int.kbplus.Subscription'}">
                <span class="label label-info">${message(code:'subscription.label', default:'Subscription')}</span>
                <em><g:link action="index"
                        controller="subscriptionDetails" 
                        id="${ua.rootObj.id}">${ua.rootObj.name}</g:link></em>
              </g:elseif>
              <g:elseif test="${ua.rootObj.class.name=='com.k_int.kbplus.Package'}">
                <span class="label label-info">$message(code:'package.label', default:'Package')}</span>
                <em><g:link action="show"
                        controller="packageDetails" 
                        id="${ua.rootObj.id}">${ua.rootObj.name}</g:link></em>
              </g:elseif>
              <g:else>
                Unhandled object type attached to alert: ${ua.rootObj.class.name}:${ua.rootObj.id}
              </g:else>
            </td>
          </tr>
          <g:each in="${ua.notes}" var="n">
            <tr>
              <td>
                  ${n.owner.content}<br/>
                  <div class="pull-right"><i>${n.owner.type?.value} (
                    <g:if test="${n.alert.sharingLevel==2}">Shared with KB+ Community</g:if>
                    <g:elseif test="${n.alert.sharingLevel==1}">JC Only</g:elseif>
                    <g:else>Private</g:else>
) By ${n.owner.user?.displayName} on <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${n.alert.createTime}" /></i></div>
              </td>
              <td>
                <input type="submit" 
                       class="ui button announce"
                       value="${n.alert?.comments != null ? n.alert?.comments?.size() : 0} Comment(s)" 
                       data-id="${n.alert.id}" 
                       />
              </td>
            </tr>
          </g:each>
        </g:each>
      </table>
    </div>

    <!-- Lightbox modal for creating a note taken from licenseNotes.html -->
    <div class="modal hide fade" id="modalComments">
    </div>

    <r:script type="text/javascript">
      // http://stackoverflow.com/questions/10626885/passing-data-to-a-bootstrap-modal
      $(document).ready(function() {
         $(".announce").click(function(){ 
           var id = $(this).data('id');
           $('#modalComments').load('<g:createLink controller="alert" action="commentsFragment" />/'+id);
           $('#modalComments').modal('show');
         });
      });
    </r:script>
  </body>
</html>
