<%@ page import="com.k_int.kbplus.Address;com.k_int.kbplus.RefdataValue;com.k_int.kbplus.RefdataCategory;de.laser.helper.RDConstants" %>

<semui:modal id="${modalId ?: 'addressFormModal'}"
             text="${message(code: 'default.add.label', args: [message(code: 'person.address.label')])}">

    <g:form id="create_address_${modalId}" class="ui form" url="[controller: 'address', action: 'create']" method="POST">
        <input type="hidden" name="redirect" value="true"/>

        <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'name', 'error')} ">
            <label for="name_${modalId}">
                <g:message code="address.name.label" />
            </label>
            <g:textField id="name_${modalId}" name="name" value="${addressInstance?.name}"/>
        </div>

        <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'additionFirst', 'error')} ">
            <label for="additionFirst_${modalId}">
                <g:message code="address.additionFirst.label" />
            </label>
            <g:textField id="additionFirst_${modalId}" name="additionFirst" value="${addressInstance?.additionFirst}"/>
        </div>

        <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'additionSecond', 'error')} ">
            <label for="additionSecond_${modalId}">
                <g:message code="address.additionSecond.label" />
            </label>
            <g:textField id="additionSecond_${modalId}" name="additionSecond" value="${addressInstance?.additionSecond}"/>
        </div>

        <div class="field">
            <div class="three fields">
                <div class="field required seven wide fieldcontain ${hasErrors(bean: addressInstance, field: 'street_1', 'error')}">
                    <label for="street_1_${modalId}">
                        <g:message code="address.street_1.label" />
                    </label>
                    <g:textField id="street_1_${modalId}" name="street_1" value="${addressInstance?.street_1}"/>
                </div>

                <div class="field two wide fieldcontain ${hasErrors(bean: addressInstance, field: 'street_2', 'error')} ">
                    <label for="street_2_${modalId}">
                        <g:message code="address.street_2.label" />
                    </label>
                    <g:textField id="street_2_${modalId}" name="street_2" value="${addressInstance?.street_2}"/>
                </div>

                <div class="field seven wide fieldcontain ${hasErrors(bean: addressInstance, field: 'state', 'error')}">
                    <label for="state_${modalId}">
                        <g:message code="address.state.label" />
                    </label>
                    <laser:select class="ui dropdown" id="state_${modalId}" name="state.id"
                                  from="${RefdataCategory.getAllRefdataValues(RDConstants.FEDERAL_STATE)}"
                                  optionKey="id"
                                  optionValue="value"
                                  noSelection="${['': message(code: 'default.select.choose.label')]}"/>
                </div>
            </div>
        </div>

        <div class="field">
            <div class="three fields">
                <div class="field required  three wide fieldcontain ${hasErrors(bean: addressInstance, field: 'zipcode', 'error')}">
                    <label for="zipcode_${modalId}">
                        <g:message code="address.zipcode.label" />
                    </label>
                    <g:textField id="zipcode_${modalId}" name="zipcode" value="${addressInstance?.zipcode}"/>
                </div>

                <div class="field required six wide fieldcontain ${hasErrors(bean: addressInstance, field: 'city', 'error')}">
                    <label for="city_${modalId}">
                        <g:message code="address.city.label" />
                    </label>
                    <g:textField id="city_${modalId}" name="city" value="${addressInstance?.city}"/>
                </div>

                <div class="field seven wide fieldcontain ${hasErrors(bean: addressInstance, field: 'country', 'error')}">
                    <label for="country_${modalId}">
                        <g:message code="address.country.label" />
                    </label>
                    <laser:select class="ui dropdown" id="country_${modalId}" name="country.id"
                                  from="${RefdataCategory.getAllRefdataValues(RDConstants.COUNTRY)}"
                                  optionKey="id"
                                  optionValue="value"
                                  value="${addressInstance?.country?.id}"
                                  noSelection="${['': message(code: 'default.select.choose.label')]}"/>
                </div>
            </div>
        </div>

        <h4 class="ui dividing header"><g:message code="address.pob.label" /></h4>

        <div class="field">
            <div class="three fields">
                <div class="field six wide fieldcontain ${hasErrors(bean: addressInstance, field: 'pob', 'error')} ">
                    <label for="pob_${modalId}">
                        <g:message code="address.pob.label" />
                    </label>
                    <g:textField id="pob_${modalId}" name="pob" value="${addressInstance?.pob}"/>
                </div>

                <div class="field three wide fieldcontain ${hasErrors(bean: addressInstance, field: 'pobZipcode', 'error')} ">
                    <label for="pobZipcode_${modalId}">
                        <g:message code="address.zipcode.label" />
                    </label>
                    <g:textField id="pobZipcode_${modalId}" name="pobZipcode" value="${addressInstance?.pobZipcode}"/>
                </div>

                <div class="field seven wide fieldcontain ${hasErrors(bean: addressInstance, field: 'pobCity', 'error')} ">
                    <label for="pobCity_${modalId}">
                        <g:message code="address.city.label" />

                    </label>
                    <g:textField id="pobCity_${modalId}" name="pobCity" value="${addressInstance?.pobCity}"/>
                </div>
            </div>
        </div>

        <h4 class="ui dividing header"><g:message code="address.additionals.label"/></h4>

        <g:if test="${modalId && hideType}">

            <g:if test="${modalId == 'addressFormModalPostalAddress'}">
                <input id="type_${modalId}" name="type.id" type="hidden" value="${com.k_int.kbplus.RefdataValue.getByValueAndCategory('Postal address', RDConstants.ADDRESS_TYPE)?.id}"/>
            </g:if>

            <g:if test="${modalId == 'addressFormModalBillingAddress'}">
                <input id="type_${modalId}" name="type.id" type="hidden" value="${com.k_int.kbplus.RefdataValue.getByValueAndCategory('Billing address', RDConstants.ADDRESS_TYPE)?.id}"/>
            </g:if>

            <g:if test="${modalId == 'addressFormModalLegalPatronAddress'}">
                <input id="type_${modalId}" name="type.id" type="hidden" value="${com.k_int.kbplus.RefdataValue.getByValueAndCategory('Legal patron address', RDConstants.ADDRESS_TYPE)?.id}"/>
            </g:if>

        </g:if>
        <g:else>
            <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'type', 'error')} ">
                <label for="type_${modalId}">
                    ${com.k_int.kbplus.RefdataCategory.getByDesc(RDConstants.ADDRESS_TYPE).getI10n('desc')}
                </label>
                <laser:select class="ui dropdown" id="type_${modalId}" name="type.id"
                              from="${com.k_int.kbplus.Address.getAllRefdataValues()}"
                              optionKey="id"
                              optionValue="value"
                              value="${addressInstance?.type?.id}"/>
            </div>
        </g:else>

        <g:if test="${!orgId}">
            <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'prs', 'error')} ">
                <label for="prs_${modalId}">
                    <g:message code="address.prs.label" />
                </label>
                <g:if test="${prsId}">
                    ${com.k_int.kbplus.Person.findById(prsId)}
                    <input id="prs_${modalId}" name="prs.id" type="hidden" value="${prsId}"/>
                </g:if>
                <g:else>
                    <g:select id="prs_${modalId}" name="prs.id" from="${com.k_int.kbplus.Person.list()}" optionKey="id"
                              value="${personInstance?.id}" class="many-to-one" noSelection="['null': '']"/>
                </g:else>
            </div>
        </g:if>


        <g:if test="${orgId}">
            <input id="org_${modalId}" name="org.id" type="hidden" value="${orgId}"/>
        </g:if>

        <g:if test="${!prsId && !orgId}">
            <div class="field fieldcontain ${hasErrors(bean: addressInstance, field: 'org', 'error')} ">
                <label for="org_${modalId}">
                    <g:message code="address.org.label" />
                </label>
                    <g:select id="org_${modalId}" name="org.id" from="${com.k_int.kbplus.Org.list()}" optionKey="id"
                              value="${org?.id}" class="many-to-one" noSelection="['null': '']"/>
            </div>
        </g:if>

    </g:form>
</semui:modal>
<r:script>
        function handleRequired() {
            $("form[id*='create_address']")
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