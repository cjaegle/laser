<div class="control-group">
  <label class="control-label" for="outgoingCombos">${message(code:'org.outgoingCombos.label', default:'Outgoing Combos')}</label>
  <div class="controls">
    <g:if test="${orgInstance.outgoingCombos && orgInstance.outgoingCombos.size() > 0}">
      <ul>
        <g:each in="${orgInstance.outgoingCombos}" var="oc">
          <li><g:link controller="organisation" actions="show" id="${oc.toOrg.id}">${oc.toOrg.name}</g:link></li>
        </g:each>
      </ul>
    </g:if>
  </div>
</div>
