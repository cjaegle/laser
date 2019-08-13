package com.k_int.kbplus

import com.k_int.kbplus.auth.User
import com.k_int.properties.PropertyDefinition
import de.laser.controller.AbstractDebugController
import de.laser.helper.DebugAnnotation
import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.annotation.Secured
import org.springframework.dao.DataIntegrityViolationException

@Secured(['IS_AUTHENTICATED_FULLY'])
class PropertyDefinitionController extends AbstractDebugController {

    static allowedMethods = [create: ['GET', 'POST'], edit: ['GET', 'POST'], delete: 'POST']

    def springSecurityService
    def accessService
    def contextService

    @Secured(['ROLE_USER'])
    def list() {
        redirect controller: 'home', action: 'index'
        return // ----- deprecated

        params.max = params.max ?: ((User) springSecurityService.getCurrentUser())?.getDefaultPageSizeTMP()
        [propDefInstanceList: PropertyDefinition.list(params), propertyDefinitionTotal: PropertyDefinition.count(), editable:false]
    }

    @DebugAnnotation(test='hasAffiliation("INST_EDITOR")')
    @Secured(closure = { ctx.springSecurityService.getCurrentUser()?.hasAffiliation("INST_EDITOR") })
    def edit() {
        redirect controller: 'home', action: 'index'
        return // ----- deprecated

        log.debug("edit:: ${params} - ${request.method}")

        switch (request.method) {
            case 'GET':
                def propDefInstance = PropertyDefinition.get(params.id)
                if (!propDefInstance) {
                    flash.message = message(code: 'default.not.found.message', args: [message(code: 'propertyDefinition.label', default: 'PropertyDefinition'), params.id])
                    redirect action: 'list'
                    return
                }
                [propDefInstance: propDefInstance,editable:false]
                break ;
            case 'POST':
                def propDefInstance = PropertyDefinition.get(params.id)
                if (!propDefInstance) {
                    flash.message = message(code: 'default.not.found.message', args: [message(code: 'propertyDefinition.label', default: 'PropertyDefinition'), params.id])
                    redirect action: 'list'
                    return
                }

                if (params.version) {
                    def version = params.version.toLong()
                    if (propDefInstance.version > version) {
                        propDefInstance.errors.rejectValue('version', 'default.optimistic.locking.failure',
                                [message(code: 'propertyDefinition.label', default: 'PropertyDefinition')] as Object[],
                                "Another user has updated this PropertyDefinition while you were editing")
                        render view: 'edit', model: [propDefInstance: propDefInstance, editable:false]
                        return
                    }
                }

                propDefInstance.properties = params
                if (params.refdataCategory) {
                    def categoryString = RefdataCategory.get(params.refdataCategory).desc
                    propDefInstance.refdataCategory = categoryString;
                }

                if (!propDefInstance.save(flush: true)) {
                    render view: 'edit', model: [propDefInstance: propDefInstance]
                    return
                }

                flash.message = message(code: 'default.updated.message', args: [message(code: 'propertyDefinition.label', default: 'PropertyDefinition'), propDefInstance.id])
                redirect action: 'edit', id: propDefInstance.id
                break
        }
    }

    @DebugAnnotation(test='hasAffiliation("INST_EDITOR")')
    @Secured(closure = { ctx.springSecurityService.getCurrentUser()?.hasAffiliation("INST_EDITOR") })
    def create() {
        redirect controller: 'home', action: 'index'
        return // ----- deprecated

        if(SpringSecurityUtils.ifNotGranted('ROLE_ADMIN')){
          flash.error =  message(code:"default.access.error")
          response.sendError(401)
          return;
        }
        switch (request.method) {
                case 'GET':
                default:
                    [propertyDefinitionInstance: new PropertyDefinition(params)]
                    break
                case 'POST':
                    def propertyDefinitionInstance = new PropertyDefinition(params)
                    if (!propertyDefinitionInstance.save(flush: true)) {
                        render view: 'create', model: [propertyDefinitionInstance: propertyDefinitionInstance]
                        return
                    }

                    flash.message = message(code: 'default.created.message', args: [message(code: 'propertyDefinition.label', default: 'PropertyDefinition'), propertyDefinitionInstance.id])
                    redirect action: 'edit', id: propertyDefinitionInstance.id
                    break
            }
    }

    @DebugAnnotation(test='hasAffiliation("INST_EDITOR")')
    @Secured(closure = { ctx.springSecurityService.getCurrentUser()?.hasAffiliation("INST_EDITOR") })
    def delete() {
        redirect controller: 'home', action: 'index'
        return // ----- deprecated

        if(SpringSecurityUtils.ifNotGranted('ROLE_ADMIN')){
          flash.error =  message(code:"default.access.error")
          response.sendError(401)
          return;
        }
        log.debug(" delete :: ${params}")
        def propDefInstance = PropertyDefinition.get(params.id)
        if (!propDefInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'propertyDefinition.label', default: 'PropertyDefinition'), params.id])
            redirect action: 'list'
            return
        }

        try {
            propDefInstance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'propertyDefinition.label', default: 'PropertyDefinition'), params.id])
            redirect action: 'list'
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'propertyDefinition.label', default: 'PropertyDefinition'), params.id])
            redirect action: 'edit', id: params.id
        }
    }
}
