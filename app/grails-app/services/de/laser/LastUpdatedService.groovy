package de.laser

import com.k_int.kbplus.Creator
import com.k_int.kbplus.Identifier
import com.k_int.kbplus.IdentifierNamespace
import com.k_int.kbplus.License
import com.k_int.kbplus.Org
import com.k_int.kbplus.Package
import com.k_int.kbplus.Subscription
import com.k_int.kbplus.TitleInstance
import com.k_int.kbplus.TitleInstancePackagePlatform
import grails.transaction.Transactional

@Transactional
class LastUpdatedService {

    def grailsApplication

    def setCalculatedLastUpdateWithoutSave(Object obj) {
        log.debug ('setCalculatedLastUpdateWithoutSave() for ' + obj)
        log.debug ('dirtyPropertyNames: ' + obj.dirtyPropertyNames)

        log.debug('lastUpdated: ' + obj.lastUpdated)
        log.debug('calculatedLastUpdated: ' + obj.calculatedLastUpdated)

        if (!obj.calculatedLastUpdated || obj.lastUpdated > obj.calculatedLastUpdated) {
            log.debug('--> updated')
            obj.calculatedLastUpdated = obj.lastUpdated
        }
    }

    def cascadingUpdate(Identifier obj) {
        log.debug ('cascadingUpdate() for ' + obj)

        obj.sub.each { ref ->
            log.debug('setting ' + ref.calculatedLastUpdated + ' to ' + obj.lastUpdated + ' for ' + ref)
            //ref.calculatedLastUpdated = obj.lastUpdated
            //ref.save()
        }
//        lic:    License,
//        org:    Org,
//        pkg:    Package,
//        sub:    Subscription,
//        ti:     TitleInstance,
//        tipp:   TitleInstancePackagePlatform,
//        cre:    Creator
    }

    def cascadingUpdate(IdentifierNamespace obj) {
        log.debug ('cascadingUpdate() for ' + obj)
        List<Identifier> list = Identifier.findAllByNs(obj)

        Identifier.executeUpdate("update Identifier i set i.calculatedLastUpdated = :lu where i.ns = :ns", [
                lu: obj.lastUpdated,
                ns: obj
        ])

        //List<Identifier> list = Identifier.findAllByNs(obj)
        list.each{ ref ->
            def x = Identifier.get(ref.id)
            log.debug('setting ' + x.calculatedLastUpdated + ' to ' + obj.lastUpdated + ' for ' + x)
            x.note = 'test'
            x.save()
        }
        print list
    }

    def cascadingUpdate(Subscription obj) {
        log.debug (obj)

    }
}
