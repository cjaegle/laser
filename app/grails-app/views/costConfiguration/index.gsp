<%@ page import="com.k_int.kbplus.OrgRole;com.k_int.kbplus.RefdataCategory;com.k_int.kbplus.RefdataValue" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="semanticUI">
        <title>${message(code: 'menu.institutions.costConfiguration')}</title>
    </head>
    <body>
        <semui:breadcrumbs>
            <semui:crumb message="menu.institutions.myInst" controller="myInstitution" action="dashboard"/>
            <semui:crumb message="menu.institutions.costConfiguration" class="active" />
        </semui:breadcrumbs>
        <h1 class="ui left aligned icon header"><semui:headerIcon/><g:message code="menu.institutions.costConfiguration"/></h1>
        <semui:messages data="${flash}"/>
        <div class="content ui form">
            <div class="two fields wide">
                <div class="field">
                    <g:message code="costConfiguration.preset"/>
                </div>
                <div class="field">
                    <g:if test="${editable}">
                        <semui:xEditableRefData owner="${institution}" field="costConfigurationPreset" emptytext="${message(code:'financials.costItemConfiguration.notSet')}" config="Cost configuration"/>
                    </g:if>
                    <g:else>
                        ${institution.costConfigurationPreset ? institution.costConfigurationPreset : message(code:'financials.costItemConfiguration.notSet')}
                    </g:else>
                </div>
            </div>
        </div>
        <semui:messages data="${flash}" />
        <g:if test="${editable}">
            <div class="content ui form">
                <div class="fields">
                    <div class="field">
                        <g:link controller="costConfiguration" action="createNewConfiguration" class="ui button trigger-modal">
                            ${message(code:'costItemElementConfiguration.create_new.label')}
                        </g:link>
                    </div>
                </div>
            </div>
        </g:if>
        <div class="ui styled fluid">
            <table class="ui celled la-table la-table-small table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>${message(code:'financials.costItemElement')}</th>
                        <th>${message(code:'financials.costItemConfiguration')}</th>
                        <th>${message(code:'financials.setAll')}</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${costItemElementConfigurations}" var="ciec">
                        <tr>
                            <td>${ciec.id}</td>
                            <td>${ciec.costItemElement.getI10n('value')}</td>
                            <td>
                                <semui:xEditableRefData owner="${ciec}" field="elementSign" emptytext="${message(code:'financials.costItemConfiguration.notSet')}" config="Cost configuration"/>
                            </td>
                            <td>

                            </td>
                        </tr>
                    </g:each>
                </tbody>
            </table>
        </div>
        <script>
            $('.trigger-modal').on('click', function(e) {
                e.preventDefault();

                $.ajax({
                    url: $(this).attr('href')
                }).done( function (data) {
                    $('.ui.dimmer.modals > #ciecModal').remove();
                    $('#dynamicModalContainer').empty().html(data);

                    $('#dynamicModalContainer .ui.modal').modal({
                        onVisible: function () {
                            r2d2.initDynamicSemuiStuff('#ciecModal');
                            r2d2.initDynamicXEditableStuff('#ciecModal');
                        },
                        detachable: true,
                        autofocus: false,
                        closable: false,
                        transition: 'scale',
                        onApprove : function() {
                            $(this).find('.ui.form').submit();
                            return false;
                        }
                    }).modal('show');
                })
            })
        </script>
    </body>
</html>