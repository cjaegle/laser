<%@ page import="com.k_int.kbplus.ReaderNumber" %>



<div class="fieldcontain ${hasErrors(bean: numbersInstance, field: 'type', 'error')} required">
	<label for="type">
		<g:message code="readerNumber.referenceGroup.label" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="type" name="type.id" from="${com.k_int.kbplus.RefdataValue.list()}" optionKey="id" required="" value="${numbersInstance?.type?.id}" class="many-to-one"/>

</div>

<div class="fieldcontain ${hasErrors(bean: numbersInstance, field: 'number', 'error')} ">
	<label for="number">
		<g:message code="readerNumber.number.label" />
		
	</label>
	<g:field id="number" name="number" type="number" value="${numbersInstance.number}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: numbersInstance, field: 'startDate', 'error')} required">
	<label for="startDate">
		<g:message code="readerNumber.startDate.label" default="Start Date" />
		<span class="required-indicator">*</span>
	</label>
	<g:datePicker id="startDate" name="startDate" precision="day"  value="${numbersInstance?.startDate}"  />

</div>

<div class="fieldcontain ${hasErrors(bean: numbersInstance, field: 'endDate', 'error')} ">
	<label for="endDate">
		<g:message code="readerNumber.endDate.label" default="End Date" />
		
	</label>
	<g:datePicker id="endDate" name="endDate" precision="day"  value="${numbersInstance?.endDate}" default="none" noSelection="['': '']" />

</div>

<div class="fieldcontain ${hasErrors(bean: numbersInstance, field: 'org', 'error')} required">
	<label for="org">
		<g:message code="numbers.org.label" default="Org" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="org" name="org.id" from="${com.k_int.kbplus.Org.list()}" optionKey="id" required="" value="${numbersInstance?.org?.id}" class="many-to-one"/>

</div>

