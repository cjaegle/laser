<%@ page import="de.laser.helper.RDStore; com.k_int.kbplus.Subscription; com.k_int.kbplus.ApiSource; com.k_int.kbplus.Platform; com.k_int.kbplus.BookInstance" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code: 'laser', default: 'LAS:eR')} : ${message(code: 'subscription.label', default: 'Subscription')}</title>
</head>

<body>
<semui:breadcrumbs>
    <semui:crumb controller="myInstitution" action="currentSubscriptions" text="${message(code: 'myinst.currentSubscriptions.label')}"/>
    <semui:crumb controller="subscription" action="index" id="${subscriptionInstance.id}" text="${subscriptionInstance.name}"/>
    <semui:crumb class="active" text="${message(code: 'subscription.details.renewEntitlements.label')}"/>
</semui:breadcrumbs>
<semui:controlButtons>
    <g:render template="actions"/>
</semui:controlButtons>
<h1 class="ui left aligned icon header"><semui:headerIcon/> <g:message code="subscription.details.renewEntitlements.label" /></h1>

<g:render template="nav"/>

<%--<g:set var="counter" value="${offset + 1}"/>
${message(code: 'subscription.details.availableTitles')} ( ${message(code: 'default.paginate.offset', args: [(offset + 1), (offset + (tipps?.size())), num_tipp_rows])} )--%>



<g:if test="${flash}">
    <semui:messages data="${flash}"/>
</g:if>

<g:form name="renewEntitlements" id="${newSub.id}" action="processRenewEntitlements" class="ui form">
    <g:hiddenField id="tippsToAdd" name="tippsToAdd"/>
    <g:hiddenField id="tippsToDelete" name="tippsToDelete"/>
    <g:hiddenField id="packageId" name="packageId" value="${params.packageId}" />
    <div class="ui grid">
        <div class="row">
            <g:render template="/templates/tipps/entitlementTable" model="${[subscriptions: [sourceId: subscription.id,targetId: newSub.id], ies: [sourceIEs: sourceIEs, targetIEs: targetIEs], side: "source"]}" />
            <g:render template="/templates/tipps/entitlementTable" model="${[subscriptions: [sourceId: subscription.id,targetId: newSub.id], ies: [sourceIEs: sourceIEs, targetIEs: targetIEs], side: "target"]}" />
        </div>
        <div class="row">
            <div class="sixteen wide column">
                <button type="submit" name="process" value="preliminary" class="ui green button"><g:message code="subscription.details.renewEntitlements.preliminary"/></button>
                <button type="submit" name="process" value="finalise" class="ui red button"><g:message code="subscription.details.renewEntitlements.submit"/></button>
            </div>
        </div>
    </div>
</g:form>

</body>
<r:script>
    $(document).ready(function() {
        var tippsToAdd = [], tippsToDelete = [];

        $(".select-all").click(function() {
            var id = $(this).parents("table").attr("id");
            if(this.checked) {
                $("#"+id).find('.bulkcheck').prop('checked', true);
                console.log($(this).parents('div.column').siblings('div'));
                $(this).parents('div.column').siblings('div').find('.select-all').prop('checked', false);
            }
            else {
                $("#"+id).find('.bulkcheck').prop('checked', false);
            }
            $("#"+id+" .bulkcheck").trigger("change");
        });

        $("#source .titleCell").each(function(k) {
            var v = $(this).height();
            $("#target .titleCell").eq(k).height(v);
        });

        $("#source .bulkcheck").change(function() {
            var index = $(this).parents("tr").attr("data-index");
            var corresp = $("#target tr[data-index='"+index+"']");
            if(this.checked) {
                if(corresp.attr("data-empty")) {
                    $("tr[data-index='"+index+"'").addClass("positive");
                    if(tippsToAdd.indexOf($(this).parents("tr").attr("data-gokbId")) < 0)
                        tippsToAdd.push($(this).parents("tr").attr("data-gokbId"));
                }
                else if(corresp.find(".bulkcheck:checked")) {
                    var delIdx = tippsToDelete.indexOf($(this).parents("tr").attr("data-gokbId"));
                    if (~delIdx) tippsToDelete.slice(delIdx,1);
                    $("tr[data-index='"+index+"'").removeClass("negative").addClass("positive");
                    corresp.find(".bulkcheck:checked").prop("checked", false);
                    tippsToAdd.push($(this).parents("tr").attr("data-gokbId"));
                }
            }
            else {
                $("tr[data-index='"+index+"'").removeClass("positive");
                var delIdx = tippsToAdd.indexOf($(this).parents("tr").attr("data-gokbId"));
                if (~delIdx) tippsToAdd.slice(delIdx,1);
            }
        });

        $("#target .bulkcheck").change(function() {
            var index = $(this).parents("tr").attr("data-index");
            var corresp = $("#source tr[data-index='"+index+"']");
            if(this.checked) {
                var delIdx = tippsToAdd.indexOf($(this).parents("tr").attr("data-gokbId"));
                if (~delIdx) tippsToAdd.slice(delIdx,1);
                $("tr[data-index='"+index+"'").removeClass("positive").addClass("negative");
                corresp.find(".bulkcheck:checked").prop("checked", false);
                tippsToDelete.push($(this).parents("tr").attr("data-gokbId"));
            }
            else {
                $("tr[data-index='"+index+"'").removeClass("negative");
                var delIdx = tippsToDelete.indexOf($(this).parents("tr").attr("data-gokbId"));
                if (~delIdx) tippsToDelete.slice(delIdx,1);
            }
        });

        $("#renewEntitlements").submit(function(){
            $("#tippsToAdd").val(tippsToAdd.join(','));
            $("#tippsToDelete").val(tippsToDelete.join(','));
        });

    });
</r:script>
</html>
