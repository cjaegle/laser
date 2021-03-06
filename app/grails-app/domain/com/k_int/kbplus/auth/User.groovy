package com.k_int.kbplus.auth

import com.k_int.kbplus.Org
import com.k_int.kbplus.UserSettings
import grails.plugin.springsecurity.SpringSecurityUtils

import javax.persistence.Transient

class User {

    transient springSecurityService
    def contextService
    def yodaService
    def userService
    def instAdmService
    def grailsApplication

  String username
  String display
  String password
  String email
  String shibbScope
  Date dateCreated
  Date lastUpdated

  boolean enabled = false
  boolean accountExpired = false
  boolean accountLocked = false
  boolean passwordExpired = false

  SortedSet affiliations
  SortedSet roles

  static hasMany = [ affiliations: com.k_int.kbplus.auth.UserOrg, roles: com.k_int.kbplus.auth.UserRole ]
  static mappedBy = [ affiliations: 'user', roles: 'user' ]

  static constraints = {
    username blank: false, unique: true
    password blank: false
    display blank: true, nullable: true
    email blank: true, nullable: true
    shibbScope blank: true, nullable: true
  }

  static mapping = {
      cache   true
      table (name: '`user`')
      password column: '`password`'

      affiliations  batchSize: 10
      roles         batchSize: 10
  }

  Set<Role> getAuthorities() {
    UserRole.findAllByUser(this).collect { it.role } as Set
  }

    void beforeInsert() {
        encodePassword()
    }

    void beforeUpdate() {
        if (isDirty('password')) {
            encodePassword()
        }
    }

    /*
        gets UserSettings
        creating new one (with value) if not existing
     */
    def getSetting(UserSettings.KEYS key, def defaultValue) {
        def us = UserSettings.get(this, key)
        (us == UserSettings.SETTING_NOT_FOUND) ? UserSettings.add(this, key, defaultValue) : us
    }

    /*
        gets VALUE of UserSettings
        creating new UserSettings (with value) if not existing
     */
    def getSettingsValue(UserSettings.KEYS key, def defaultValue) {
        def setting = getSetting(key, defaultValue)
        setting.getValue()
    }

    /*
        gets VALUE of UserSettings
        creating new UserSettings if not existing
     */
    def getSettingsValue(UserSettings.KEYS key) {
        getSettingsValue(key, null)
    }

    // refactoring -- tmp changes

    def getDefaultPageSizeTMP() {
        // create if no setting found
        def setting = getSetting(UserSettings.KEYS.PAGE_SIZE, 10)
        // if setting exists, but null value
        setting.getValue() ?: 10
    }

    // refactoring -- tmp changes

  @Transient
  String getDisplayName() {
    String result
    if ( display ) {
      result = display
    }
    else {
      result = username
    }
    result
  }

  protected void encodePassword() {
    password = springSecurityService.encodePassword(password)
  }

  @Transient def getAuthorizedAffiliations() {
    affiliations.findAll { it.status == UserOrg.STATUS_APPROVED }
  }

    @Transient List<Org> getAuthorizedOrgs() {
        String qry = "select distinct(o) from Org as o where exists ( select uo from UserOrg as uo where uo.org = o and uo.user = ? and ( uo.status=1 or uo.status=3)) order by o.name"
        Org.executeQuery(qry, [this]);
    }
    @Transient def getAuthorizedOrgsIds() {
        getAuthorizedOrgs().collect{ it.id }
    }

    boolean hasRole(String roleName) {
        SpringSecurityUtils.ifAnyGranted(roleName)
    }
    boolean hasRole(List<String> roleNames) {
        SpringSecurityUtils.ifAnyGranted(roleNames?.join(','))
    }

    boolean isAdmin() {
        SpringSecurityUtils.ifAnyGranted("ROLE_ADMIN")
    }
    boolean isYoda() {
        SpringSecurityUtils.ifAnyGranted("ROLE_YODA")
    }

    boolean hasAffiliation(userRoleName) {
        hasAffiliationAND(userRoleName, 'ROLE_USER')
    }

    boolean hasAffiliationAND(userRoleName, globalRoleName) {
        affiliationCheck(userRoleName, globalRoleName, 'AND', contextService.getOrg())
    }
    boolean hasAffiliationOR(userRoleName, globalRoleName) {
        affiliationCheck(userRoleName, globalRoleName, 'OR', contextService.getOrg())
    }

    boolean hasAffiliationForForeignOrg(userRoleName, orgToCheck) {
        affiliationCheck(userRoleName, 'ROLE_USER', 'AND', orgToCheck)
    }

    private boolean affiliationCheck(String userRoleName, String globalRoleName, mode, orgToCheck) {
        boolean result = false
        List<String> rolesToCheck = [userRoleName]

        //log.debug("USER.hasAffiliation(): ${userRoleName}, ${globalRoleName}, ${mode} @ ${orgToCheck}")

        // TODO:

        if (SpringSecurityUtils.ifAnyGranted("ROLE_YODA")) {
            return true // may the force be with you
        }
        if (SpringSecurityUtils.ifAnyGranted("ROLE_ADMIN")) {
            return true // may the force be with you
        }

        if (mode == 'AND') {
            if (! SpringSecurityUtils.ifAnyGranted(globalRoleName)) {
                return false // min restriction fail
            }
        }
        else if (mode == 'OR') {
            if (SpringSecurityUtils.ifAnyGranted(globalRoleName)) {
                return true // min level granted
            }
        }

        // TODO:

        // sym. role hierarchy
        if (userRoleName == "INST_USER") {
            rolesToCheck << "INST_EDITOR"
            rolesToCheck << "INST_ADM"
        }
        else if (userRoleName == "INST_EDITOR") {
            rolesToCheck << "INST_ADM"
        }

        rolesToCheck.each{ rot ->
            Role role = Role.findByAuthority(rot)
            if (role) {
                UserOrg uo = UserOrg.findByUserAndOrgAndFormalRole(this, orgToCheck, role)
                result = result || (uo && getAuthorizedAffiliations()?.contains(uo))
            }
        }
        result
    }

    boolean isLastInstAdmin() {
        boolean lia = false

        affiliations.each { aff ->
            if (instAdmService.isUserLastInstAdminForOrg(this, aff.org)) {
                lia = true
            }
        }
        lia
    }

    static String generateRandomPassword() {
        org.apache.commons.lang.RandomStringUtils.randomAlphanumeric(24)
    }

    @Override
    String toString() {
        yodaService.showDebugInfo() ? display + ' (' + id + ')' : display
        //display
    }
}
