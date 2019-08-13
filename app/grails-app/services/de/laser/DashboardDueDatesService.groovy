package de.laser


import com.k_int.kbplus.EventLog
import com.k_int.kbplus.Org
import com.k_int.kbplus.Subscription
import com.k_int.kbplus.UserSettings
import com.k_int.kbplus.auth.User
import static de.laser.helper.RDStore.*
import de.laser.helper.SqlDateUtils
import static com.k_int.kbplus.UserSettings.DEFAULT_REMINDER_PERIOD
import grails.util.Holders

class DashboardDueDatesService {

    def queryService
    def mailService
    def executorService
    def grailsApplication
    def messageSource
    def locale
    String from
    String replyTo
    def update_running = false
    private static final String QRY_ALL_ORGS_OF_USER = "select distinct o from Org as o where exists ( select uo from UserOrg as uo where uo.org = o and uo.user = ? and ( uo.status=1 or uo.status=3)) order by o.name"

    @javax.annotation.PostConstruct
    void init() {
        from = grailsApplication.config.notifications.email.from
        replyTo = grailsApplication.config.notifications.email.replyTo
        messageSource = Holders.grailsApplication.mainContext.getBean('messageSource')
        locale = org.springframework.context.i18n.LocaleContextHolder.getLocale()
        log.debug("Initialised DashboardDueDatesService...")
    }

    boolean takeCareOfDueDates(boolean isUpdateDashboardTableInDatabase, boolean isSendEmailsForDueDatesOfAllUsers, def flash) {
        if (flash == null) flash = new HashMap<>()
        if (flash.message == null) flash.put('message', '')
        if (flash.error == null)   flash.put('error', '')

        if ( update_running ) {
                log.info("Existing DashboardDueDatesService takeCareOfDueDates - one already running");
                return false
        } else {
            try {
                update_running = true;
                log.debug("Start DashboardDueDatesService takeCareOfDueDates");

                // TODO: remove due SystemEvent
                new EventLog(event:'DashboardDueDatesService takeCareOfDueDates', message:'Start', tstp:new Date(System.currentTimeMillis())).save(flush:true)

                SystemEvent.createEvent('DBDD_SERVICE_START_1')

                if (isUpdateDashboardTableInDatabase) {
                    flash = updateDashboardTableInDatabase(flash)
                }
                if (isSendEmailsForDueDatesOfAllUsers) {
                    flash = sendEmailsForDueDatesOfAllUsers(flash)
                }
                log.debug("Finished DashboardDueDatesService takeCareOfDueDates");

                // TODO: remove due SystemEvent
                new EventLog(event:'DashboardDueDatesService takeCareOfDueDates', message:'Finished', tstp:new Date(System.currentTimeMillis())).save(flush:true)

                SystemEvent.createEvent('DBDD_SERVICE_COMPLETE_1')

            } catch (Throwable t) {
                String tMsg = t.message
                log.error("DashboardDueDatesService takeCareOfDueDates :: Unable to perform takeCareOfDueDates due to exception ${tMsg}")
                // TODO: remove due SystemEvent
                new EventLog(event:'DashboardDueDatesService takeCareOfDueDates', message:'Unable to takeCareOfDueDates email due to exception '+ tMsg, tstp:new Date(System.currentTimeMillis())).save(flush:true)

                SystemEvent.createEvent('DBDD_SERVICE_ERROR_1', ['error': tMsg])

                flash.error += messageSource.getMessage('menu.admin.error', null, locale)
                update_running = false
            } finally {
                update_running = false
            }
            return true
        }
    }
    private updateDashboardTableInDatabase(def flash){
        log.debug("Start DashboardDueDatesService updateDashboardTableInDatabase");

        // TODO: remove due SystemEvent
        new EventLog(event:'DashboardDueDatesService.updateDashboardTableInDatabase', message:'Start', tstp:new Date(System.currentTimeMillis())).save(flush:true)

        SystemEvent.createEvent('DBDD_SERVICE_START_2')

        List<DashboardDueDate> dashboarEntriesToInsert = []
        def users = User.findAllByEnabledAndAccountExpiredAndAccountLocked(true, false, false)
        users.each { user ->
            def orgs = Org.executeQuery(QRY_ALL_ORGS_OF_USER, user);
            orgs.each {org ->
                def dueObjects = queryService.getDueObjectsCorrespondingUserSettings(org, user)
                dueObjects.each { obj ->
                    if (obj instanceof Subscription) {
                        int reminderPeriodForManualCancellationDate = user.getSetting(UserSettings.KEYS.REMIND_PERIOD_FOR_SUBSCRIPTIONS_NOTICEPERIOD, DEFAULT_REMINDER_PERIOD).value
                        if (obj.manualCancellationDate && SqlDateUtils.isDateBetweenTodayAndReminderPeriod(obj.manualCancellationDate, reminderPeriodForManualCancellationDate)) {
                            dashboarEntriesToInsert.add(new DashboardDueDate(obj, true, user, org))
                        }
                        int reminderPeriodForSubsEnddate = user.getSetting(UserSettings.KEYS.REMIND_PERIOD_FOR_SUBSCRIPTIONS_ENDDATE, DEFAULT_REMINDER_PERIOD).value
                        if (obj.endDate && SqlDateUtils.isDateBetweenTodayAndReminderPeriod(obj.endDate, reminderPeriodForSubsEnddate)) {
                            dashboarEntriesToInsert.add(new DashboardDueDate(obj, false, user, org))
                        }
                    } else {
                        dashboarEntriesToInsert.add(new DashboardDueDate(obj, user, org))
                    }
                }
            }
        }
        DashboardDueDate.withTransaction { status ->
            try {
                DashboardDueDate.executeUpdate("DELETE from DashboardDueDate ")
                log.debug("DashboardDueDatesService DELETE from DashboardDueDate");
                dashboarEntriesToInsert.each {
                    it.save(flush: true)
                    log.debug("DashboardDueDatesService INSERT: " + it);
                }
                log.debug("DashboardDueDatesService INSERT Anzahl: " + dashboarEntriesToInsert.size);

                // TODO: remove due SystemEvent
                new EventLog(event:'DashboardDueDatesService INSERT Anzahl: ' + dashboarEntriesToInsert.size, message:'SQL Insert', tstp:new Date(System.currentTimeMillis())).save(flush:true)

                SystemEvent.createEvent('DBDD_SERVICE_PROCESSING_2', ['count': dashboarEntriesToInsert.size])

                flash.message += messageSource.getMessage('menu.admin.updateDashboardTable.successful', null, locale)
            } catch (Throwable t) {
                String tMsg = t.message
                SystemEvent.createEvent('DBDD_SERVICE_ERROR_2', ['error': tMsg])

                status.setRollbackOnly()
                log.error("DashboardDueDatesService - updateDashboardTableInDatabase() :: Rollback for reason: ${tMsg}")

                // TODO: remove due SystemEvent
                new EventLog(event:'DashboardDueDatesService.updateDashboardTableInDatabase', message:'Rollback for reason: ' + tMsg, tstp:new Date(System.currentTimeMillis())).save(flush:true)

                flash.error += messageSource.getMessage('menu.admin.updateDashboardTable.error', null, locale)
            }
        }
        log.debug("Finished DashboardDueDatesService updateDashboardTableInDatabase");

        // TODO: remove due SystemEvent
        new EventLog(event:'DashboardDueDatesService updateDashboardTableInDatabase', message:'Finished', tstp:new Date(System.currentTimeMillis())).save(flush:true)

        SystemEvent.createEvent('DBDD_SERVICE_COMPLETE_2')
        flash
    }

    private sendEmailsForDueDatesOfAllUsers(def flash) {
        try {
            // TODO: remove due SystemEvent
            new EventLog(event: 'DashboardDueDatesService.sendEmailsForDueDatesOfAllUsers', message: 'Start', tstp: new Date(System.currentTimeMillis())).save(flush: true)

            SystemEvent.createEvent('DBDD_SERVICE_START_3')

            def users = User.findAllByEnabledAndAccountExpiredAndAccountLocked(true, false, false)
            users.each { user ->
                boolean userWantsEmailReminder = YN_YES.equals(user.getSetting(UserSettings.KEYS.IS_REMIND_BY_EMAIL, YN_NO).rdValue)
                if (userWantsEmailReminder) {
                    def orgs = Org.executeQuery(QRY_ALL_ORGS_OF_USER, user);
                    orgs.each { org ->
                        def dashboardEntries = DashboardDueDate.findAllByResponsibleUserAndResponsibleOrg(user, org)
                        sendEmail(user, org, dashboardEntries)
                    }
                }
            }
            // TODO: remove due SystemEvent
            new EventLog(event: 'DashboardDueDatesService.sendEmailsForDueDatesOfAllUsers', message: 'Finished', tstp: new Date(System.currentTimeMillis())).save(flush: true)

            SystemEvent.createEvent('DBDD_SERVICE_COMPLETE_3')

            flash.message += messageSource.getMessage('menu.admin.sendEmailsForDueDates.successful', null, locale)
        } catch (Exception e) {
            flash.error += messageSource.getMessage('menu.admin.sendEmailsForDueDates.error', null, locale)
        }
        flash
    }

    private void sendEmail(User user, Org org, List<DashboardDueDate> dashboardEntries) {
        def emailReceiver = user.getEmail()
        def currentServer = grailsApplication.config.getCurrentServer()
        def subjectSystemPraefix = (currentServer == ContextService.SERVER_PROD)? "LAS:eR - " : (grailsApplication.config.laserSystemId + " - ")
        String mailSubject = subjectSystemPraefix + messageSource.getMessage('email.subject.dueDates', null, locale) + " (" + org.name + ")"
        try {
            if (emailReceiver == null || emailReceiver.isEmpty()) {
                log.debug("The following user does not have an email address and can not be informed about due dates: " + user.username);
            } else if (dashboardEntries == null || dashboardEntries.isEmpty()) {
                log.debug("The user has no due dates, so no email will be sent (" + user.username + "/"+ org.name + ")");
            } else {
                boolean isRemindCCbyEmail = user.getSetting(UserSettings.KEYS.IS_REMIND_CC_BY_EMAIL, YN_NO)?.rdValue == YN_YES
                String ccAddress = null
                if (isRemindCCbyEmail){
                    ccAddress = user.getSetting(UserSettings.KEYS.REMIND_CC_EMAILADDRESS, null)?.getValue()
                }
                if (isRemindCCbyEmail && ccAddress) {
                    mailService.sendMail {
                        to      emailReceiver
                        from    from
                        cc      ccAddress
                        replyTo replyTo
                        subject mailSubject
                        body    (view: "/mailTemplates/html/dashboardDueDates", model: [user: user, org: org, dueDates: dashboardEntries])
                    }
                } else {
                    mailService.sendMail {
                        to      emailReceiver
                        from    from
                        replyTo replyTo
                        subject mailSubject
                        body    (view: "/mailTemplates/html/dashboardDueDates", model: [user: user, org: org, dueDates: dashboardEntries])
                    }
                }

                log.debug("DashboardDueDatesService - finished sendEmail() to "+ user.displayName + " (" + user.email + ") " + org.name);
            }
        } catch (Exception e) {
            String eMsg = e.message

            log.error("DashboardDueDatesService - sendEmail() :: Unable to perform email due to exception ${eMsg}")
            // TODO: remove due SystemEvent
            new EventLog(event:'DashboardDueDatesService.sendEmail', message:'Unable to perform email due to exception ' + eMsg, tstp:new Date(System.currentTimeMillis())).save(flush:true)

            SystemEvent.createEvent('DBDD_SERVICE_ERROR_3', ['error': eMsg])
        }
    }
}

