<g:form id="delete_doc_form" url="[controller:"${controllerName}",action:'deleteDocuments']" method="post">
    <g:if test="${editable}">
        <div class="well hide licence-documents-options">

            <input type="hidden" name="redirectAction" value="${redirect}"/>
            <input type="hidden" name="instanceId" value="${instance.id}"/>
            <input type="submit" class="btn btn-danger delete-document" value="${message(code:'license.notes.button.delete')}"/>
          <!--  <input type="submit" class="btn btn-danger delete-document" value="Delete Selected Notes"/> -->
        </div>

    </g:if>
    <table class="table table-striped table-bordered table-condensed licence-documents">
        <thead>
        <tr>
            <g:if test="${editable}"><th>${message(code:'license.notes.table.select')}</th></g:if>
            <th>${message(code:'license.notes.table.title')}</th>
            <th>${message(code:'license.notes.table.note')}</th>
            <th>${message(code:'license.notes.table.creator')}</th>
            <th>${message(code:'license.notes.table.type')}</th>
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
        <input type="button" class="btn btn-primary" value="${message(code:'template.addNote')}" data-toggle="modal"
               href="#modalCreateNote"/>
   </g:if>
</g:form>

<!-- JS for show/hide of delete button -->
<r:script type="text/javascript">
    var showEditButtons =function () {
        if ($('.licence-documents input:checked').length > 0) {
            $('.licence-documents-options').slideDown('fast');
        } else {
            $('.licence-documents-options').slideUp('fast');
        }
    }

    $(document).ready(showEditButtons);

    $('.licence-documents input[type="checkbox"]').click(showEditButtons);

    $('.licence-documents-options .delete-document').click(function () {
        if (!confirm('${message(code:'license.note.delete.warning')}')) {
   <%-- if (!confirm('Are you sure you wish to delete these notes?')) { --%>
            $('.licence-documents input:checked').attr('checked', false);
            return false;
        }
        $('.licence-documents input:checked').each(function () {
            $(this).parent().parent().fadeOut('slow');
            $('.licence-documents-options').slideUp('fast');
        });
    })
</r:script>
