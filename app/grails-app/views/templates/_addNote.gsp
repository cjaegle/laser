
<!-- Lightbox modal for creating a note taken from licenceNotes.html -->
<div class="modal hide" id="modalCreateNote">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>
        <h3>${message(code:'template.addNote', default: 'Create New Note')}</h3>
    </div>
    <g:form id="create_note" url="[controller:'docWidget',action:'createNote']" method="post">
        <input type="hidden" name="ownerid" value="${ownobj.id}"/>
        <input type="hidden" name="ownerclass" value="${ownobj.class.name}"/>
        <input type="hidden" name="ownertp" value="${owntp}"/>
        <div class="modal-body">
            <dl>
                <dt>
                    <label>${message(code:'template.addNote.note', default: 'Note')}:</label>
                </dt>
                <dd>
                    <textarea name="licenceNote"></textarea>
                </dd>
            </dl>
            <input type="hidden" name="licenceNoteShared" value="0"/>
        </div>
        <div class="modal-footer">
            <a href="#" class="btn" data-dismiss="modal">${message(code: 'default.button.close.label', default:'Close')}</a>
            <input type="submit" class="btn btn-primary" name ="SaveNote" value="${message(code: 'default.button.save_changes', default: 'Save Changes')}">
        </div>
    </g:form>
</div>
