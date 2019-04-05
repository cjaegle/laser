<%@ page import="com.k_int.kbplus.IssueEntitlement; com.k_int.kbplus.SubscriptionController; de.laser.helper.RDStore; com.k_int.kbplus.Person; com.k_int.kbplus.Subscription; com.k_int.kbplus.GenericOIDService "%>
<%@ page import="com.k_int.kbplus.SubscriptionController" %>
<%@ page import="static com.k_int.kbplus.SubscriptionController.COPY" %>
<%@ page import="static com.k_int.kbplus.SubscriptionController.REPLACE" %>
<%@ page import="static com.k_int.kbplus.SubscriptionController.DO_NOTHING" %>
<laser:serviceInjection />

<semui:form>
    <g:render template="selectSourceAndTargetSubscription" model="[
            sourceSubscription: sourceSubscription,
            targetSubscription: targetSubscription,
            allSubscriptions_readRights: allSubscriptions_readRights,
            allSubscriptions_writeRights: allSubscriptions_writeRights]"/>

    <g:form action="copyElementsIntoSubscription" controller="subscription" id="${params.id}"
            params="[workFlowPart: workFlowPart, sourceSubscriptionId: sourceSubscriptionId, targetSubscriptionId: targetSubscription?.id]" method="post" class="ui form newLicence">
        <table class="ui celled table table-tworow la-table">
            <thead>
                <tr>
                    <th class="center aligned">${message(code: 'default.copy.label')}</th>
                    <th class="center aligned">${message(code: 'default.replace.label')}</th>
                    <th class="center aligned">${message(code: 'default.doNothing.label')}</th>
                    <th class="six wide">
                        <g:if test="${sourceSubscription}"><g:link controller="subscription" action="show" id="${sourceSubscription?.id}">${sourceSubscription?.name}</g:link></g:if>
                    </th>
                    <th class="six wide">
                        <g:if test="${targetSubscription}"><g:link controller="subscription" action="show" id="${targetSubscription?.id}">${targetSubscription?.name}</g:link></g:if>
                    </th>
                </tr>
            </thead>
            <tbody>
            <tr>
                <td class="center aligned" style="vertical-align: top">

                </td>
                <td class="center aligned" style="vertical-align: top">
                    <div class="ui checkbox la-toggle-radio la-replace">
                        <input type="radio" name="subscription.takeDates" value="${REPLACE}" />
                    </div>
                </td>
                <td class="center aligned" style="vertical-align: top">
                    <div class="ui checkbox la-toggle-radio la-noChange">
                        <input type="radio" name="subscription.takeDates" value="${DO_NOTHING}" checked />
                    </div>
                </td>
                <td style="vertical-align: top" name="subscription.takeDates.source">
                    <div>
                        <b><i class="calendar alternate outline icon"></i>${message(code: 'subscription.periodOfValidity.label')}:</b>&nbsp
                        <g:formatDate date="${sourceSubscription?.startDate}" format="${message(code: 'default.date.format.notime')}"/>
                        ${sourceSubscription?.endDate ? (' - ' + formatDate(date: sourceSubscription?.endDate, format: message(code: 'default.date.format.notime'))) : ''}
                    </div>
                </td>
                <td style="vertical-align: top" name="subscription.takeDates.target">
                    <div>
                        <b><i class="calendar alternate outline icon"></i>${message(code: 'subscription.periodOfValidity.label')}:</b>&nbsp
                        <g:formatDate date="${targetSubscription?.startDate}" format="${message(code: 'default.date.format.notime')}"/>
                        ${targetSubscription?.endDate ? (' - ' + formatDate(date: targetSubscription?.endDate, format: message(code: 'default.date.format.notime'))) : ''}
                    </div>
                </td>
            </tr>
            <tr>
                <td class="center aligned" style="vertical-align: top"></td>
                <td class="center aligned" style="vertical-align: top"><div class="ui checkbox la-toggle-radio la-replace"><input type="radio" name="subscription.takeOwner" value="${REPLACE}" /></div></td>
                <td class="center aligned" style="vertical-align: top"><div class="ui checkbox la-toggle-radio la-noChange"><input type="radio" name="subscription.takeOwner" value="${DO_NOTHING}" checked /></div></td>
                <td style="vertical-align: top" name="subscription.takeOwner.source">
                    <div>
                        <b><i class="balance scale icon"></i>${message(code: 'license')}:</b>
                        <g:if test="${sourceSubscription?.owner}">
                            <g:link controller="license" action="show" target="_blank" id="${sourceSubscription.owner.id}">
                                ${sourceSubscription.owner}
                            </g:link>
                        </g:if>
                    </div>
                </td>
                <td style="vertical-align: top" name="subscription.takeOwner.target">
                    <div>
                        <b><i class="balance scale icon"></i>${message(code: 'license')}:</b>
                        <g:if test="${targetSubscription?.owner}">
                            <g:link controller="license" action="show" target="_blank" id="${targetSubscription?.owner?.id}">
                                ${targetSubscription?.owner}
                            </g:link>
                        </g:if>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="center aligned" style="vertical-align: top"><div class="ui checkbox la-toggle-radio la-append"><input type="radio" name="subscription.takeOrgRelations" value="${COPY}" /></div></td>
                <td class="center aligned" style="vertical-align: top"><div class="ui checkbox la-toggle-radio la-replace"><input type="radio" name="subscription.takeOrgRelations" value="${REPLACE}" /></div></td>
                <td class="center aligned" style="vertical-align: top"><div class="ui checkbox la-toggle-radio la-noChange"><input type="radio" name="subscription.takeOrgRelations" value="${DO_NOTHING}" checked /></div></td>
                <td style="vertical-align: top" name="subscription.takeOrgRelations.source">
                    <div>
                        <g:if test="${ ! source_visibleOrgRelations}">
                            <b><i class="university icon"></i>&nbsp${message(code: 'subscription.organisations.label')}:</b>
                        </g:if>
                        <g:each in="${source_visibleOrgRelations}" var="source_role">
                            <g:if test="${source_role.org}">
                                <b><i class="university icon"></i>&nbsp${source_role?.roleType?.getI10n("value")}:</b>
                                <g:link controller="organisation" action="show" target="_blank" id="${source_role.org.id}">
                                    ${source_role?.org?.name}
                                </g:link><br>
                            </g:if>
                        </g:each>
                    </div>
                </td>
                <td style="vertical-align: top" name="subscription.takeOrgRelations.target">
                    <div>
                        <g:if test="${ ! target_visibleOrgRelations}">
                            <b><i class="university icon"></i>&nbsp${message(code: 'subscription.organisations.label')}:</b>
                        </g:if>
                        <g:each in="${target_visibleOrgRelations}" var="target_role">
                            <g:if test="${target_role.org}">
                                <b><i class="university icon"></i>&nbsp${target_role?.roleType?.getI10n("value")}:</b>
                                <g:link controller="organisation" action="show" target="_blank" id="${target_role.org.id}">
                                    ${target_role?.org?.name}
                                </g:link>
                                <br>
                            </g:if>
                        </g:each>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
        <div class="sixteen wide field" style="text-align: right;">
            <input type="submit" class="ui button js-click-control" value="Ausgewählte Elemente kopieren/überschreiben" onclick="return jsConfirmation()"/>
        </div>
    </g:form>
</semui:form>

<r:script>
    $('input:radio[name="subscription.takeDates"]').change( function(event) {
        if (this.checked && this.value=='REPLACE') {
            $('.table tr td[name="subscription.takeDates.source"] div').addClass('willStay');
            $('.table tr td[name="subscription.takeDates.target"] div').addClass('willBeReplaced');
        } else {
            $('.table tr td[name="subscription.takeDates.source"] div').removeClass('willStay');
            $('.table tr td[name="subscription.takeDates.target"] div').removeClass('willStay');
            $('.table tr td[name="subscription.takeDates.target"] div').removeClass('willBeReplaced');
        }
    })
    $('input:radio[name="subscription.takeOwner"]').change( function(event) {
        if (this.checked && this.value=='REPLACE') {
            $('.table tr td[name="subscription.takeOwner.source"] div').addClass('willStay');
            $('.table tr td[name="subscription.takeOwner.target"] div').addClass('willBeReplaced');
        } else {
            $('.table tr td[name="subscription.takeOwner.source"] div').removeClass('willStay');
            $('.table tr td[name="subscription.takeOwner.target"] div').removeClass('willStay')
            $('.table tr td[name="subscription.takeOwner.target"] div').removeClass('willBeReplaced');
        }
    })
    $('input:radio[name="subscription.takeOwner"]').change( function(event) {
        if (this.checked && this.value=='COPY') {
            $('.table tr td[name="subscription.takeOwner.source"] div').addClass('willStay');
            $('.table tr td[name="subscription.takeOwner.target"] div').removeClass('willBeReplaced');
        }
        if (this.checked && this.value=='DO_NOTHING') {
            $('.table tr td[name="subscription.takeOwner.source"] div').removeClass('willStay');
            $('.table tr td[name="subscription.takeOwner.target"] div').removeClass('willStay');
            $('.table tr td[name="subscription.takeOwner.target"] div').removeClass('willBeReplaced');
        }
    })
    $('input:radio[name="subscription.takeOrgRelations"]').change( function(event) {
        if (this.checked && this.value=='COPY') {
            $('.table tr td[name="subscription.takeOrgRelations.source"] div').addClass('willStay');
            $('.table tr td[name="subscription.takeOrgRelations.target"] div').addClass('willStay');
            $('.table tr td[name="subscription.takeOrgRelations.target"] div').removeClass('willBeReplaced');
        }
        if (this.checked && this.value=='REPLACE') {
            $('.table tr td[name="subscription.takeOrgRelations.source"] div').addClass('willStay');
            $('.table tr td[name="subscription.takeOrgRelations.target"] div').addClass('willBeReplaced');
        }
        if (this.checked && this.value=='DO_NOTHING') {
            $('.table tr td[name="subscription.takeOrgRelations.source"] div').removeClass('willStay');
            $('.table tr td[name="subscription.takeOrgRelations.target"] div').removeClass('willStay');
            $('.table tr td[name="subscription.takeOrgRelations.target"] div').removeClass('willBeReplaced');
        }
    })
</r:script>

