<div class="control-group">
	<label class="control-label" for="orgType">${message(code:'org.orgType.label')}</label>
	<div class="controls">
		 <g:set value="${com.k_int.kbplus.RefdataCategory.getByDesc(de.laser.helper.RDConstants.ORG_TYPE)}" var="orgroletypecat"/>
		 <g:set value="${com.k_int.kbplus.RefdataCategory.getAllRefdataValues(de.laser.helper.RDConstants.ORG_TYPE)}" var="refvalues"/>
	   	 <g:select from="${refvalues}" name="orgType" optionKey="id" optionValue="${{it.getI10n('value')}}" value="${orgInstance?.orgType?.id}" noSelection="['null': '']"/>
	</div>
</div>
