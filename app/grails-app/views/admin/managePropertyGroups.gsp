<%@ page import="com.k_int.properties.PropertyDefinition;com.k_int.kbplus.*"%>

<!doctype html>
<html>
    <head>
        <meta name="layout" content="semanticUI"/>
        <title>${message(code:'laser')} : ${message(code:'menu.institutions.manage_prop_groups')}</title>
    </head>
    <body>

        <semui:breadcrumbs>
            <semui:crumb message="menu.admin.dash" controller="admin" action="index" />
            <semui:crumb message="menu.institutions.manage_prop_groups" class="active"/>
        </semui:breadcrumbs>
        <br>
        <h1 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon /><g:message code="menu.institutions.manage_prop_groups"/></h1>

        <semui:messages data="${flash}" />

        <g:if test="${editable}">
            <div class="content ui form">
                <div class="fields">
                    <div class="field">
                        <g:link controller="admin" action="managePropertyGroups" params="${[cmd:'new']}" class="ui button trigger-modal">
                            ${message(code:'propertyDefinitionGroup.create_new.label')}
                        </g:link>
                    </div>
                </div>
            </div>
        </g:if>

    <table class="ui celled sortable table la-table la-table-small">
        <thead>
            <tr>
                <th>Name</th>
                <th>Beschreibung</th>
                <th>Merkmale</th>
                <th>Typ</th>
                <th>Anzeigen (Voreinstellung)</th>
                <th class="la-action-info">${message(code:'default.actions.label')}</th>
            </tr>
        </thead>
        <tbody>
            <g:each in="${propDefGroups}" var="pdGroup">
                <tr>
                    <td>
                        <semui:xEditable owner="${pdGroup}" field="name" />
                    </td>
                    <td>
                        <semui:xEditable owner="${pdGroup}" field="description" />
                    </td>
                    <td>
                        ${pdGroup.getPropertyDefinitions().size()}
                    </td>
                    <td>
                        <%-- TODO: REFACTORING: x.class.name with pd.desc --%>
                        <g:if test="${pdGroup.ownerType == License.class.name}">
                            <g:message code="propertyDefinition.License Property.label" default="${pdDescr}"/>
                        </g:if>
                        <g:elseif test="${pdGroup.ownerType == Org.class.name}">
                            <g:message code="propertyDefinition.Organisation Property.label" default="${pdDescr}"/>
                        </g:elseif>
                        <g:elseif test="${pdGroup.ownerType == Subscription.class.name}">
                            <g:message code="propertyDefinition.Subscription Property.label" default="${pdDescr}"/>
                        </g:elseif>
                        <%-- TODO: REFACTORING x.class.name with pd.desc --%>
                    </td>
                    <td>
                        <semui:xEditableBoolean owner="${pdGroup}" field="isVisible" />
                    </td>
                    <td class="x">
                        <g:if test="${editable}">
                            <g:set var="pdgOID" value="${pdGroup.class.name + ':' + pdGroup.id}" />
                            <g:link controller="admin" action="managePropertyGroups" params="${[cmd:'edit', oid:pdgOID]}" class="ui icon button trigger-modal">
                                <i class="write icon"></i>
                            </g:link>
                            <g:link controller="admin" action="managePropertyGroups" params="${[cmd:'delete', oid:pdgOID]}" class="ui icon negative button">
                                <i class="trash alternate icon"></i>
                            </g:link>
                        </g:if>
                    </td>
                </tr>
            </g:each>
        </tbody>
    </table>

    <script>
        $('.trigger-modal').on('click', function(e) {
            e.preventDefault();

            $.ajax({
                url: $(this).attr('href')
            }).done( function (data) {
                $('.ui.dimmer.modals > #propDefGroupModal').remove();
                $('#dynamicModalContainer').empty().html(data);

                $('#dynamicModalContainer .ui.modal').modal({
                    onVisible: function () {
                        r2d2.initDynamicSemuiStuff('#propDefGroupModal');
                        r2d2.initDynamicXEditableStuff('#propDefGroupModal');
                        $("html").css("cursor", "auto");
                        ajaxPostFunc()
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
