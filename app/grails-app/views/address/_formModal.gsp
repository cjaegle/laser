<%@ page import="com.k_int.kbplus.Address;com.k_int.kbplus.RefdataValue;com.k_int.kbplus.RefdataCategory;de.laser.helper.RDConstants" %>

<semui:modal id="${modalId ?: 'addressFormModal'}"
             text="${message(code: 'default.add.label', args: [message(code: 'person.address.label')])}">

    <g:form id="create_address" class="ui form" url="[controller: 'address', action: 'create']" method="POST">
        <input type="hidden" name="redirect" value="true"/>

        <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'name', 'error')} ">
            <label for="name">
                <g:message code="address.name.label" />
            </label>
            <g:textField id="name" name="name" value="${addressInstance?.name}"/>
        </div>

        <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'additionFirst', 'error')} ">
            <label for="additionFirst">
                <g:message code="address.additionFirst.label" />
            </label>
            <g:textField id="additionFirst" name="additionFirst" value="${addressInstance?.additionFirst}"/>
        </div>

        <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'additionSecond', 'error')} ">
            <label for="additionSecond">
                <g:message code="address.additionSecond.label" />
            </label>
            <g:textField id="additionSecond" name="additionSecond" value="${addressInstance?.additionSecond}"/>
        </div>

        <div class="field">
            <div class="three fields">
                <div class="field seven wide fieldcontain ${hasErrors(bean: addressInstance, field: 'street_1', 'error')}">
                    <label for="street_1">
                        <g:message code="address.street_1.label" />
                    </label>
                    <g:textField id="street_1" name="street_1" value="${addressInstance?.street_1}"/>
                </div>

                <div class="field two wide fieldcontain ${hasErrors(bean: addressInstance, field: 'street_2', 'error')} ">
                    <label for="street_2">
                        <g:message code="address.street_2.label" />
                    </label>
                    <g:textField id="street_2" name="street_2" value="${addressInstance?.street_2}"/>
                </div>

                <div class="field seven wide fieldcontain ${hasErrors(bean: addressInstance, field: 'state', 'error')}">
                    <label for="state">
                        <g:message code="address.state.label" />
                    </label>
                    <laser:select class="ui dropdown" id="state" name="state.id"
                                  from="${RefdataCategory.getAllRefdataValues(RDConstants.FEDERAL_STATE)}"
                                  optionKey="id"
                                  optionValue="value"
                                  value="${addressInstance?.state?.id}"
                                  noSelection="['null': '']"/>
                </div>
            </div>
        </div>

        <div class="field">
            <div class="three fields">
                <div class="field three wide fieldcontain ${hasErrors(bean: addressInstance, field: 'zipcode', 'error')}">
                    <label for="zipcode">
                        <g:message code="address.zipcode.label" />
                    </label>
                    <g:textField id="zipcode" name="zipcode" value="${addressInstance?.zipcode}"/>
                </div>

                <div class="field six wide fieldcontain ${hasErrors(bean: addressInstance, field: 'city', 'error')}">
                    <label for="city">
                        <g:message code="address.city.label" />
                    </label>
                    <g:textField id="city" name="city" value="${addressInstance?.city}"/>
                </div>

                <div class="field seven wide fieldcontain ${hasErrors(bean: addressInstance, field: 'country', 'error')}">
                    <label for="country">
                        <g:message code="address.country.label" />
                    </label>
                    <laser:select class="ui dropdown" id="country" name="country.id"
                                  from="${RefdataCategory.getAllRefdataValues(RDConstants.COUNTRY)}"
                                  optionKey="id"
                                  optionValue="value"
                                  value="${addressInstance?.country?.id}"
                                  noSelection="['null': '']"/>
                </div>
            </div>
        </div>

        <h4 class="ui dividing header"><g:message code="address.pob.label" /></h4>

        <div class="field">
            <div class="three fields">
                <div class="field six wide fieldcontain ${hasErrors(bean: addressInstance, field: 'pob', 'error')} ">
                    <label for="pob">
                        <g:message code="address.pob.label" />
                    </label>
                    <g:textField id="pob" name="pob" value="${addressInstance?.pob}"/>
                </div>

                <div class="field three wide fieldcontain ${hasErrors(bean: addressInstance, field: 'pobZipcode', 'error')} ">
                    <label for="pobZipcode">
                        <g:message code="address.zipcode.label" />
                    </label>
                    <g:textField id="pobZipcode" name="pobZipcode" value="${addressInstance?.pobZipcode}"/>
                </div>

                <div class="field seven wide fieldcontain ${hasErrors(bean: addressInstance, field: 'pobCity', 'error')} ">
                    <label for="pobCity">
                        <g:message code="address.city.label" />

                    </label>
                    <g:textField id="pobCity" name="pobCity" value="${addressInstance?.pobCity}"/>
                </div>
            </div>
        </div>

        <h4 class="ui dividing header"><g:message code="address.additionals.label"/></h4>

        <g:if test="${modalId && hideType}">

            <g:if test="${modalId == 'addressFormModalPostalAddress'}">
                <input id="type" name="type.id" type="hidden" value="${com.k_int.kbplus.RefdataValue.getByValueAndCategory('Postal address', RDConstants.ADDRESS_TYPE)?.id}"/>
            </g:if>

            <g:if test="${modalId == 'addressFormModalBillingAddress'}">
                <input id="type" name="type.id" type="hidden" value="${com.k_int.kbplus.RefdataValue.getByValueAndCategory('Billing address', RDConstants.ADDRESS_TYPE)?.id}"/>
            </g:if>

            <g:if test="${modalId == 'addressFormModalLegalPatronAddress'}">
                <input id="type" name="type.id" type="hidden" value="${com.k_int.kbplus.RefdataValue.getByValueAndCategory('Legal patron address', RDConstants.ADDRESS_TYPE)?.id}"/>
            </g:if>

        </g:if>
        <g:else>
            <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'type', 'error')} ">
                <label for="type">
                    ${com.k_int.kbplus.RefdataCategory.getByDesc(RDConstants.ADDRESS_TYPE).getI10n('desc')}
                </label>
                <laser:select class="ui dropdown" id="type" name="type.id"
                              from="${com.k_int.kbplus.Address.getAllRefdataValues()}"
                              optionKey="id"
                              optionValue="value"
                              value="${addressInstance?.type?.id}"/>
            </div>
        </g:else>

        <g:if test="${!orgId}">
            <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'prs', 'error')} ">
                <label for="prs">
                    <g:message code="address.prs.label" />
                </label>
                <g:if test="${prsId}">
                    ${com.k_int.kbplus.Person.findById(prsId)}
                    <input id="prs" name="prs.id" type="hidden" value="${prsId}"/>
                </g:if>
                <g:else>
                    <g:select id="prs" name="prs.id" from="${com.k_int.kbplus.Person.list()}" optionKey="id"
                              value="${personInstance?.id}" class="many-to-one" noSelection="['null': '']"/>
                </g:else>
            </div>
        </g:if>


        <g:if test="${orgId}">
            <input id="org" name="org.id" type="hidden" value="${orgId}"/>
        </g:if>

        <g:if test="${!prsId && !orgId}">
            <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'org', 'error')} ">
                <label for="org">
                    <g:message code="address.org.label" />
                </label>
                    <g:select id="org" name="org.id" from="${com.k_int.kbplus.Org.list()}" optionKey="id"
                              value="${org?.id}" class="many-to-one" noSelection="['null': '']"/>
            </div>
        </g:if>

    </g:form>
</semui:modal>
<r:script>
        function handleRequired() {
            $('#create_address')
                    .form({

                inline: true,
                fields: {
                    street_1: {
                        identifier  : 'street_1',
                        rules: [
                            {
                                type   : 'empty',
                                prompt : '{name} <g:message code="validation.needsToBeFilledOut"
                                                            default=" muss ausgefüllt werden"/>'
                            }
                        ]
                    },

                    zipcode: {
                        identifier  : 'zipcode',
                        rules: [
                            {
                                type   : 'empty',
                                prompt : '{name} <g:message code="validation.needsToBeFilledOut"
                                                            default=" muss ausgefüllt werden"/>'
                            }
                        ]
                    },
                    city: {
                        identifier  : 'city',
                        rules: [
                            {
                                type   : 'empty',
                                prompt : '{name} <g:message code="validation.needsToBeFilledOut"
                                                            default=" muss ausgefüllt werden"/>'
                            }
                        ]
                    },
                 }
            });
        }
        handleRequired()
</r:script>