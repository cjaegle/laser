package de.laser.batch

import com.k_int.kbplus.Org
import de.laser.quartz.AbstractJob

class TestJob extends AbstractJob {

    def grailsApplication
    def contextService

    static triggers = {

    //cron name:'TestJob', startDelay:0, cronExpression: "0/10 * * * * ?"
    // cronExpression: "s m h D M W Y"
    //                  | | | | | | `- Year [optional]
    //                  | | | | | `- Day of Week, 1-7 or SUN-SAT, ?
    //                  | | | | `- Month, 1-12 or JAN-DEC
    //                  | | | `- Day of Month, 1-31, ?
    //                  | | `- Hour, 0-23
    //                  | `- Minute, 0-59
    //                  `- Second, 0-59
    }

    static List<String> configFlags = ['activateTestJob']

    boolean isAvailable() {
        !jobIsRunning // no service needed
    }
    boolean isRunning() {
        jobIsRunning
    }

    def execute() {
        if (grailsApplication.config.activateTestJob) {
            if (! isAvailable()) {
                return false
            }
            jobIsRunning = true

            log.debug("Ping")

            // provocate error @  WebUtils.retrieveGrailsWebRequest().getSession()

            Org ctx = contextService.getOrg()

            jobIsRunning = false
        }
    }
}
