<semui:modal id="modalEditNote" text="${message(code:'template.readNote')}" hideSubmitButton="true">

    <g:form id="edit_note" class="ui form"  url="[controller:'doc', action:'show', id:noteInstance?.id]" method="post">

        <div class="field fieldcontain">
            <label for="title">${message(code:'template.addNote.title')}:</label>

            <input type="text" id="title" name="title" value="${noteInstance?.title}"/>
        </div>
        <div class="field fieldcontain">
            <label for="addNote">${message(code:'template.addNote.note')}:</label>

            <textarea id="addNote" name="content">${noteInstance?.content}</textarea>
        </div>

    </g:form>
</semui:modal>
