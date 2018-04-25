<%@ page import="com.k_int.kbplus.Address" %>

<div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'street_1', 'error')} required">
	<label for="street_1">
		<g:message code="address.street_1.label" default="Street1" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="street_1" required="" value="${addressInstance?.street_1}"/>

</div>

<div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'street_2', 'error')} ">
	<label for="street_2">
		<g:message code="address.street_2.label" default="Street2" />
		
	</label>
	<g:textField name="street_2" value="${addressInstance?.street_2}"/>

</div>

<div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'pob', 'error')} ">
	<label for="pob">
		<g:message code="address.pob.label" default="Pob" />
		
	</label>
	<g:textField name="pob" value="${addressInstance?.pob}"/>

</div>

<div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'zipcode', 'error')} required">
	<label for="zipcode">
		<g:message code="address.zipcode.label" default="Zipcode" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="zipcode" required="" value="${addressInstance?.zipcode}"/>

</div>

<div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'city', 'error')} required">
	<label for="city">
		<g:message code="address.city.label" default="City" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="city" required="" value="${addressInstance?.city}"/>

</div>

<div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'state', 'error')}">
	<label for="state">
		<g:message code="address.state.label" default="State" />
	</label>
	<laser:select class="ui dropdown" id="state" name="state.id"
				  from="${com.k_int.kbplus.RefdataValue.findAllByOwner(com.k_int.kbplus.RefdataCategory.findByDesc('Federal State'))}"
				  optionKey="id"
				  optionValue="value"
				  value="${addressInstance?.state?.id}"
                  noSelection="['null': '']" />
</div>

<div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'country', 'error')}">
	<label for="country">
		<g:message code="address.country.label" default="Country" />
	</label>
	<laser:select class="ui dropdown" id="country" name="country.id"
				  from="${com.k_int.kbplus.RefdataValue.findAllByOwner(com.k_int.kbplus.RefdataCategory.findByDesc('Country'))}"
				  optionKey="id"
				  optionValue="value"
				  value="${addressInstance?.country?.id}"
                  noSelection="['null': '']" />
</div>

<div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'type', 'error')} ">
	<label for="type">
		${com.k_int.kbplus.RefdataCategory.findByDesc('AddressType').getI10n('desc')}
		
	</label>
	<laser:select class="ui dropdown" id="type" name="type.id"
		from="${com.k_int.kbplus.Address.getAllRefdataValues()}"
    	optionKey="id"
    	optionValue="value"
    	value="${addressInstance?.type?.id}"
        required=""/>
</div>

<div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'prs', 'error')} ">
	<label for="prs">
		<g:message code="address.prs.label" default="Prs" />
		
	</label>
	<g:select id="prs" name="prs.id" from="${com.k_int.kbplus.Person.list()}" optionKey="id" value="${addressInstance?.prs?.id}" class="many-to-one" noSelection="['null': '']"/>

</div>

<div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'org', 'error')} ">
	<label for="org">
		<g:message code="address.org.label" default="Org" />
		
	</label>
	<g:select id="org" name="org.id" from="${com.k_int.kbplus.Org.list()}" optionKey="id" value="${addressInstance?.org?.id}" class="many-to-one" noSelection="['null': '']"/>

</div>

