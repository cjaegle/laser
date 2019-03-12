package com.k_int.kbplus

import de.laser.controller.AbstractDebugController
import grails.plugin.springsecurity.annotation.Secured
import com.k_int.kbplus.auth.*;
import grails.gorm.*

import java.security.MessageDigest

@Secured(['IS_AUTHENTICATED_FULLY'])
class UserController extends AbstractDebugController {

    def springSecurityService
    def genericOIDService
    def userService

    static allowedMethods = [create: ['GET', 'POST'], edit: ['GET', 'POST'], delete: 'POST']

    @Secured(['ROLE_ADMIN'])
    def index() {
        redirect action: 'list', params: params
    }

    @Secured(['ROLE_ADMIN'])
    def list() {

        def result = [:]
        result.user = User.get(springSecurityService.principal.id)
        result.editable = true // TODO; checked in gsp against ROLE_YODA


        params.max = params.max ?: result.user?.getDefaultPageSizeTMP()
        def results = null;
        def count = null;

      if(params.authority == "null") 
        params.authority=null;

      def criteria = new DetachedCriteria(User).build {
        if ( params.name && params.name != '' ) {
          or {
            ilike('username',"%${params.name}%")
            ilike('display',"%${params.name}%")
            ilike('instname',"%${params.name}%")
          }
        }
        if(params.authority){
          def filter_role = Role.get(params.authority.toLong())
          if(filter_role){
              roles{
                eq('role',filter_role)
              }
          }
        }
      }

      result.users = criteria.list(params)
      result.total = criteria.count()

      result
    }

    @Secured(['ROLE_ADMIN'])
    def edit() {
        def result = [:]
        result.user = User.get(springSecurityService.principal.id)
        result.editable = true // TODO; checked in gsp against ROLE_YODA

        def userInstance = User.get(params.id)
        if (! userInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'Org'), params.id])
            redirect action: 'list'
            return
        }
        else {
            // check if api key and secret are existing
            def readRole  = UserRole.findAllWhere(user: userInstance, role: Role.findByAuthority('ROLE_API_READER'))
            def writeRole = UserRole.findAllWhere(user: userInstance, role: Role.findByAuthority('ROLE_API_WRITER'))
            if((readRole || writeRole)){
                if(! userInstance.apikey){
                    def seed1 = Math.abs(new Random().nextFloat()).toString().getBytes()
                    userInstance.apikey = MessageDigest.getInstance("MD5").digest(seed1).encodeHex().toString().take(16)
                }
                if(! userInstance.apisecret){
                    def seed2 = Math.abs(new Random().nextFloat()).toString().getBytes()
                    userInstance.apisecret = MessageDigest.getInstance("MD5").digest(seed2).encodeHex().toString().take(16)
                }
            }
        }
        result.ui = userInstance
        result
    }

    @Secured(['ROLE_ADMIN'])
    def show() {
        def result = [:]
        result.user = User.get(springSecurityService.principal.id)
        def userInstance = User.get(params.id)
        result.ui = userInstance
        result
    }

    @Secured(['ROLE_ADMIN'])
    def newPassword() {
        def result = [:]
        result.user = User.get(springSecurityService.principal.id)
        result.editable = true // TODO; checked in gsp against ROLE_YODA

        def userInstance = User.get(params.id)
        if (userInstance) {
            String newPassword = User.generateRandomPassword()
            userInstance.password = newPassword
            if (userInstance.save(flush: true)) {
                flash.message = message(code: 'user.newPassword.success', args: [newPassword])

                userService.sendMail(userInstance, 'Passwortänderung',
                        '/mailTemplates/text/newPassword', [user: userInstance, newPass: newPassword])

                redirect controller: 'user', action: 'edit', id: params.id
                return
            }
        }

        flash.error = message(code: 'user.newPassword.fail')
        redirect controller: 'user', action: 'edit', id: params.id
    }

    @Secured(['ROLE_ADMIN'])
    def addAffiliation(){

        User user = User.get(params.id)
        Org org = Org.get(params.org)
        Role formalRole = Role.get(params.formalRole)

        if (user && org && formalRole) {
            userService.createAffiliation(user, org, formalRole, UserOrg.STATUS_APPROVED, flash)
        }

        redirect controller: 'user', action: 'edit', id: params.id
    }

    @Secured(['ROLE_ADMIN'])
  def create() {
    switch (request.method) {
      case 'GET':
        [orgInstance: new Org(params)]
        break
      case 'POST':
            def userInstance = new User(params)
            if (!userInstance.save(flush: true)) {
                render view: 'create', model: [userInstance: userInstance]
                return
            }

            def defaultRole = new UserRole(
                user: userInstance,
                role: Role.findByAuthority('ROLE_USER')
            )
            defaultRole.save(flush: true);

            flash.message = message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), userInstance.id])
            redirect action: 'edit', id: userInstance.id
        break
    }
  }
}