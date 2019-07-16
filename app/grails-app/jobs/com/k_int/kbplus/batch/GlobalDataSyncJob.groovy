package com.k_int.kbplus.batch

import de.laser.SystemEvent
import de.laser.quartz.AbstractJob

class GlobalDataSyncJob extends AbstractJob {

    def globalSourceSyncService
    def grailsApplication

    static triggers = {
    // Delay 20 seconds, run every 10 mins.
    // Cron:: Min Hour DayOfMonth Month DayOfWeek Year
    // Example - every 10 mins 0 0/10 * * * ? 
    // At 5 past 4am every day
    cron name:'globalDataSyncTrigger', startDelay:180000, cronExpression: "0 1 0 * * ?"
    // cronExpression: "s m h D M W Y"
    //                  | | | | | | `- Year [optional]
    //                  | | | | | `- Day of Week, 1-7 or SUN-SAT, ?
    //                  | | | | `- Month, 1-12 or JAN-DEC
    //                  | | | `- Day of Month, 1-31, ?
    //                  | | `- Hour, 0-23
    //                  | `- Minute, 0-59
    //                  `- Second, 0-59
    }

    static configFlags = ['hbzMaster', 'globalDataSyncJobActiv']

    boolean isAvailable() {
        !jobIsRunning && !globalSourceSyncService.running
    }
    boolean isRunning() {
        jobIsRunning
    }

    def execute() {
        if (! isAvailable()) {
            return false
        }

        jobIsRunning = true

    log.debug("GlobalDataSyncJob");

    if ( grailsApplication.config.hbzMaster == true && grailsApplication.config.globalDataSyncJobActiv == true ) {
      log.debug("This server is marked as hbzMaster. Running GlobalDataSyncJob batch job");
      SystemEvent.createEvent('GD_SYNC_JOB_START')

      globalSourceSyncService.runAllActiveSyncTasks()
      SystemEvent.createEvent('GD_SYNC_JOB_COMPLETE')
    }
    else {
      log.debug("This server is NOT marked as hbzMaster. NOT Running GlobalDataSyncJob SYNC batch job");
    }

        jobIsRunning = false
  }

}

