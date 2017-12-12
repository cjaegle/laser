%{--Two rows of data per CostItem--}%

<g:each in="${cost_items}" var="ci">
    <tr id="bulkdelete-a${ci.id}">
        <td rowspan="2">${ci.id}</td>
        <td>
                <g:simpleReferenceTypedown disabled="${!editable}" modified="${true}" class="refData" data-shortcode="${params.shortcode}"
                       data-owner="${ci.class.name}" baseClass="com.k_int.kbplus.Invoice"
                       data-relationID="${ci?.invoice!=null? ci.invoice.id:'create'}"
                       data-placeholder="${ci?.invoice==null? 'Enter invoice number':''}"
                       data-defaultValue="${ci?.invoice?.invoiceNumber?.encodeAsHTML()}" data-ownerid="${ci.id}"
                       data-ownerfield="invoice" name="invoiceField" data-relationField="invoiceNumber"/>
        </td>
        <td>
                <g:simpleReferenceTypedown disabled="${!editable}" modified="${true}" class="refData" data-shortcode="${params.shortcode}"
                       data-owner="${ci.class.name}" baseClass="com.k_int.kbplus.Order"
                       data-relationID="${ci?.order!=null? ci.order.id:'create'}"
                       data-placeholder="${ci?.order==null? 'Enter order number':''}"
                       data-defaultValue="${ci?.order?.orderNumber}" data-ownerid="${ci.id}"
                       data-ownerfield="order" name="orderField" data-relationField="orderNumber"/>
        </td>
        <td>
            <g:simpleReferenceTypedown disabled="${!editable}" id="${ci.id}_sub" modified="${true}" class="refObj" data-mode="sub" data-isSubPkg="${false}"
                        style="max-width:300px;" name="name" data-shortcode="${params.shortcode}"
                        data-placeholder="${ci?.sub==null? 'Enter sub name':''}" data-ownerfield="sub"
                        data-defaultValue="${ci.sub?.name}" data-ownerid="${ci.id}"
                        data-owner="${ci.class.name}" baseClass="com.k_int.kbplus.Subscription"/>

        <td>
            <g:simpleReferenceTypedown disabled="${!editable}" id="${ci.id}_subPkg" modified="${true}" class="refObj" data-isSubPkg="${true}"
                        style="max-width:300px;" name="name" data-shortcode="${params.shortcode}"
                        data-placeholder="${ci?.subPkg==null? 'Enter sub pkg name':''}" data-mode="pkg" data-ownerfield="subPkg"
                        data-defaultValue="${ci?.subPkg?.pkg?.name}" data-ownerid="${ci.id}" data-subfilter="${ci?.sub?.id}"
                        data-owner="${ci.class.name}" baseClass="com.k_int.kbplus.SubscriptionPackage"/>
        </td>
        <td colspan="2">
            <g:simpleReferenceTypedown disabled="${!editable}" id="${ci.id}_ie" modified="${true}" class="refObj" data-mode="ie"
                        style="max-width:300px;" name="title" data-shortcode="${params.shortcode}" data-subfilter="${ci?.sub?.id}"
                        data-placeholder="${ci?.issueEntitlement==null? 'Enter IE name':''}" data-ownerfield="issueEntitlement"
                        data-defaultValue="${ci?.issueEntitlement?.tipp?.title?.title}" data-ownerid="${ci.id}"
                        data-owner="${ci.class.name}" baseClass="com.k_int.kbplus.IssueEntitlement"/>
        </td>
        <g:if test="${editable}">
            <td rowspan="2"> <input type="checkbox" value="${ci.id}" class="bulkcheck"/> </td>
        </g:if>
    </tr>
    <tr id="bulkdelete-b${ci.id}">
        <td>
            <g:if test="${editable}">
                <semui:xEditable emptytext="Edit Paid-Date" owner="${ci}" type="date" field="datePaid" /> </br></br>
                <g:xEditableRefData config="CostItemStatus" emptytext="Edit Status" owner="${ci}" field="costItemStatus" /> </br>
                <g:xEditableRefData config="CostItemCategory" emptytext="Edit Category" owner="${ci}" field="costItemCategory" /> </br>
                <g:xEditableRefData config="CostItemElement" emptytext="Edit Element" owner="${ci}" field="costItemElement" /> </br>
                <g:xEditableRefData config="TaxType" emptytext="Edit Tax Code" owner="${ci}" field="taxCode" />
            </g:if>
            <g:else>
                <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ci?.datePaid}"/>
            </g:else>
        </td>
        <td>
            <g:if test="${editable}">
                <semui:xEditable emptytext="Edit Cost" owner="${ci}" field="costInBillingCurrency" /> </br>
                <g:xEditableRefData config="Currency" emptytext="Edit billed" owner="${ci}" field="billingCurrency" /> </br>
                <semui:xEditable emptytext="Edit local" owner="${ci}" field="costInLocalCurrency" />
            </g:if>
            <g:else>
                ${ci?.costInBillingCurrency} </br> 
                ${ci?.billingCurrency} </br>
                ${ci?.costInLocalCurrency}
            </g:else>
        </td>
        <td>
            <g:if test="${editable}">
                <semui:xEditable emptytext="Edit Ref" owner="${ci}" field="reference" /> </br></br>
                <div style="display: inline-block" class="budgetCodeWrapper">
                    <div id="budgetcodes_${ci.id}">
                        <g:each in="${ci.budgetcodes}" var="bc">
                            <span class="budgetCode">${bc.value.encodeAsHTML()} </span>
                            <a style="display: inline-block" id="bcci_${bc.id}_${ci.id}" class="badge budgetCode">x</a>
                        </g:each>
                        <a class="editable-empty budgetCode" style="cursor: pointer;" data-owner="${ci.id}">Add Codes...</a>
                    </div>
                </div> </br></br>
                <semui:xEditable emptytext="Edit Start-Date" owner="${ci}" type="date" field="startDate" /> &nbsp;<i>to</i>&nbsp;
                <semui:xEditable emptytext="Edit End-Date" owner="${ci}" type="date" field="endDate" />
            </g:if>
            <g:else>
                ${ci?.reference} &nbsp;/&nbsp;
                <g:each in="${ci.budgetcodes}" var="bc" status="${i}">${(i+1)}. ${bc.value.encodeAsHTML()}&nbsp;</g:each> </br>
                <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ci?.startDate}"/> </br>
                <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ci?.endDate}"/>
            </g:else>
        </td>
        <td colspan="3">
            <g:if test="${editable}">
                <semui:xEditable emptytext="Edit Description" owner="${ci}" field="costDescription" />
            </g:if>
            <g:else>
                ${ci?.costDescription}
            </g:else>
        </td>
    </tr>
</g:each>
