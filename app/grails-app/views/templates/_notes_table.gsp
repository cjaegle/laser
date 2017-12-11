<g:form id="delete_doc_form" url="[controller:"${controllerName}",action:'deleteDocuments']" method="post">
    <g:if test="${editable}">
        <div class="well hide license-documents-options">

            <input type="hidden" name="redirectAction" value="${redirect}"/>
            <input type="hidden" name="instanceId" value="${instance.id}"/>
            <input type="submit" class="btn btn-danger delete-document" value="${message(code:'template.notes.delete', default:'Delete Selected Notes')}"/>
        </div>

    </g:if>
    <table class="ui celled table license-documents">
        <thead>
        <tr>
            <g:if test="${editable}"><th>${message(code:'default.select.label', default:'Select')}</th></g:if>
            <th>${message(code:'title.label', default:'Title')}</th>
            <th>${message(code:'default.note.label', default:'Note')}</th>
            <th>${message(code:'default.creator.label', default:'Creator')}</th>
            <th>${message(code:'default.type.label', default:'Type')}</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${instance.documents}" var="docctx">
            <g:if test="${docctx.owner.contentType == 0 && (docctx.status == null || docctx.status?.value != 'Deleted')}">
                <tr>
                    <g:if test="${editable}"><td><input type="checkbox" name="_deleteflag.${docctx.id}" value="true"/>
                    </td></g:if>
                    <td>
                        <g:xEditable owner="${docctx.owner}" field="title" id="title"/>
                    </td>
                    <td>
                        <g:xEditable owner="${docctx.owner}" field="content" id="content"/>
                    </td>
                    <td>
                        <g:xEditable owner="${docctx.owner}" field="creator" id="creator"/>
                    </td>
                    <td>${docctx.owner?.type?.value}</td>
                </tr>
            </g:if>
        </g:each>
        </tbody>
    </table>
    <g:if test="${editable}">
        <input type="button" class="ui primary button" value="${message(code:'template.addNote', default:'Add new Note')}" data-semui="modal"
                   href="#modalCreateNote"/>
   </g:if>
</g:form>

<!-- JS for show/hide of delete button -->
<r:script type="text/javascript">
    var showEditButtons =function () {
        if ($('.license-documents input:checked').length > 0) {
            $('.license-documents-options').slideDown('fast');
        } else {
            $('.license-documents-options').slideUp('fast');
        }
    }

    $(document).ready(showEditButtons);

    $('.license-documents input[type="checkbox"]').click(showEditButtons);

    $('.license-documents-options .delete-document').click(function () {
        if (!confirm('${message(code:'template.notes.delete.confirm', default:'Are you sure you wish to delete these notes?')}')) {
            $('.license-documents input:checked').attr('checked', false);
            return false;
        }
        $('.license-documents input:checked').each(function () {
            $(this).parent().parent().fadeOut('slow');
            $('.license-documents-options').slideUp('fast');
        });
    })
</r:script>
