package de.laser.batch

import de.laser.SystemEvent
import de.laser.quartz.AbstractJob

class StatsSyncJob extends AbstractJob {

    def statsSyncService
    def grailsApplication

    static triggers = {
        // Delay 20 seconds, run every 10 mins.
        // Cron:: Min Hour DayOfMonth Month DayOfWeek Year
        // Example - every 10 mins 0 0/10 * * * ?
        // At 5 past 2am on the first of every month - Sync stats
        //cron name:'statsSyncTrigger', startDelay:10, cronExpression: "* 10 * * * ?"
        // cronExpression: "s m h D M W Y"
        //                  | | | | | | `- Year [optional]
        //                  | | | | | `- Day of Week, 1-7 or SUN-SAT, ?
        //                  | | | | `- Month, 1-12 or JAN-DEC
        //                  | | | `- Day of Month, 1-31, ?
        //                  | | `- Hour, 0-23
        //                  | `- Minute, 0-59
        //                  `- Second, 0-59
    }

    static configFlags = ['hbzMaster', 'StatsSyncJobActiv']

    boolean isAvailable() {
        !jobIsRunning
    }
    boolean isRunning() {
        jobIsRunning
    }

    def execute() {
        if (! isAvailable()) {
            return false
        }

        jobIsRunning = true

        log.debug("Execute::statsSyncJob");
        if ( grailsApplication.config.hbzMaster == true && grailsApplication.config.StatsSyncJobActiv == true ) {
            log.debug("This server is marked as hbzMaster. Running Stats SYNC batch job");
            SystemEvent.createEvent('STATS_SYNC_JOB_START')

            statsSyncService.doSync()
            SystemEvent.createEvent('STATS_SYNC_JOB_COMPLETE')
        }
        else {
            log.debug("This server is NOT marked as hbzMaster. NOT Running Stats SYNC batch job");
        }

        jobIsRunning = false
    }
}
