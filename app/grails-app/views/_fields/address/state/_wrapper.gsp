<div class="control-group">
	<label class="control-label" for="state">${message(code:'address.state.label', default:'State')}</label>
	<div class="controls">
		 <g:set value="${com.k_int.kbplus.RefdataCategory.getByDesc(de.laser.helper.RDConstants.FEDERAL_STATE)}" var="statecat"/>
		 <g:set value="${com.k_int.kbplus.RefdataValue.findAllByOwner(statecat)}" var="refvalues"/>
	   	 <g:select from="${refvalues}" optionKey="id" name="state" />
	</div>
</div>
