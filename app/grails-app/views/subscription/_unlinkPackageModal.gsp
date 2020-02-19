<div id="unlinkPackageModal" class="ui modal ">

    <button type="ui button" class="close" data-dismiss="modal">×</button>

    <div class="header">
        <h6 class="ui header">${message(code: 'default.button.unlink.label')}: ${pkg}</h6>
    </div>

    <div class="content">
        %{--<p>${message(code: 'subscription.details.unlink.note', default: 'No user actions required for this process.')}</p>--}%
        <table class="ui celled la-table table">
            <thead>
            <th>${message(code: 'default.item.label')}</th>
            <th>${message(code: 'default.details.label')}</th>
            <th>${message(code: 'default.action.label')}</th>
            </thead>
            <tbody>
            <g:set var="actions_needed" value="false"/>

            <g:each in="${conflicts_list}" var="conflict_item">
                <tr>
                    <td>
                        ${conflict_item.name}
                    </td>
                    <td>
                        <ul>
                            <g:each in="${conflict_item.details}" var="detail_item">
                                <li>
                                    <g:if test="${detail_item.link}">
                                        <a href="${detail_item.link}">${detail_item.text}</a>
                                    </g:if>
                                    <g:else>
                                        ${detail_item.text}
                                    </g:else>
                                </li>
                            </g:each>
                        </ul>
                    </td>
                    <td>
                    %{-- Add some CSS based on actionRequired to show green/red status --}%
                        <g:if test="${conflict_item.action.actionRequired}">
                            <i style="color:red" class="fa fa-times-circle"></i>
                            <g:set var="actions_needed" value="true"/>

                        </g:if>
                        <g:else>
                            <i style="color:green" class="fa fa-check-circle"></i>
                        </g:else>
                        ${conflict_item.action.text}
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>

    <div class="actions">
        <g:form action="unlinkPackage"
                method="POST">
            <input type="hidden" name="package" value="${pkg.id}"/>
            <input type="hidden" name="subscription" value="${subscription.id}"/>
            <input type="hidden" name="confirmed" value="Y"/>
            <button type="submit"
                    class="ui negative button js-open-confirm-modal"
                data-confirm-tokenMsg="${message(code: "subscription.details.unlink.confirm")}"
                data-confirm-term-how="unlink">
                ${message(code: 'default.button.confirm_delete.label')}
            </button>
        </g:form>
    </div>
</div>  
