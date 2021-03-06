<semui:filter>
    <g:form action="linkAccessPoint" controller="platform" method="get" class="ui small form">
        <input type="hidden" name="platform_id" value="${platformInstance.id}">
        <div class="fields">
            <div class="field">
                <g:select class="ui dropdown" name="institutions"
                          from="${institution}"
                          optionKey="id"
                          optionValue="name"
                          value="${selectedInstitution} "
                          onchange="${remoteFunction (
                                  action: 'dynamicApLink',
                                  params: '{platform_id:'+platformInstance.id+', institution_id:this.value}',
                                  update: [success: 'dynamicUpdate', failure: 'failure'],
                          )}"/>
            </div>
            <div class="field">
                <g:select class="ui dropdown" name="AccessPoints"
                          from="${accessPointList}"
                          optionKey="id"
                          optionValue="name"
                          value="${params.status}"
                          noSelection="${['' : message(code:'default.select.choose.label')]}"/>
            </div>
            <div class="field">
                <g:submitButton name="submit" class="ui button trash alternate" value="${message(code:'platform.link.accessPoint.button.label', default:'Zugangsverfahren verknüpfen')}" onClick="return confirmSubmit()"/>
            </div>
        </div>
    </g:form>
</semui:filter>
<table class="ui sortable celled la-table table la-ignore-fixed la-bulk-header">
    <thead>
    <tr>
        <th>${message(code:'platform.link.accessPoint.grid.activeConfiguration', default:'Active Access configuration')}</th>
        <th>${message(code:'platform.link.accessPoint.grid.action', default:'Action')}</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${accessPointLinks}" var="oapl">
        <tr>
            <td>${oapl.oap.name}</td>
            <td>
                <g:if test="${oapl.oap.hasActiveLink()}">
                    <g:link controller="platform" action="removeAccessPoint" id="${platformInstance.id}" params="[oapl_id: oapl.id]" onclick="return confirm('Zugangspunkt entfernen?')">
                        <i class="trash icon red"></i>
                    </g:link>
                </g:if>
                <g:else>
                    <g:link controller="platform" action="linkAccessPoint" id="${platformInstance.id}" params="[oapl_id: oapl.id]" onclick="return confirm('Zugangspunkt hinzufügen?')">
                        <i class="linkify icon"></i>
                    </g:link>
                </g:else>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>