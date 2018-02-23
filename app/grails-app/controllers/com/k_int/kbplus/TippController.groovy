package com.k_int.kbplus

import grails.converters.*
import grails.plugin.springsecurity.annotation.Secured // 2.0
import grails.converters.*
import groovy.xml.MarkupBuilder
import com.k_int.kbplus.auth.*;
import grails.plugin.springsecurity.SpringSecurityUtils // 2.0

class TippController {

 def springSecurityService

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def show() { 
    def result = [:]

    result.user = User.get(springSecurityService.principal.id)
    result.editable = SpringSecurityUtils.ifAllGranted('ROLE_ADMIN')

    result.tipp = TitleInstancePackagePlatform.get(params.id)
    result.titleInstanceInstance = result.tipp.title

    if (!result.titleInstanceInstance) {
      flash.message = message(code: 'default.not.found.message', args: [message(code: 'titleInstance.label', default: 'TitleInstance'), params.id])
      redirect action: 'list'
      return
    }

    params.max = Math.min(params.max ? params.int('max') : 10, 100)
    def paginate_after = params.paginate_after ?: 19;
    result.max = params.max
    result.offset = params.offset ? Integer.parseInt(params.offset) : 0;

    def base_qry = "from TitleInstancePackagePlatform as tipp where tipp.title = ? and tipp.status.value != 'Deleted' "
    def qry_params = [result.titleInstanceInstance]

    if ( params.filter ) {
      base_qry += " and lower(tipp.pkg.name) like ? "
      qry_params.add("%${params.filter.trim().toLowerCase()}%")
    }

    if ( params.endsAfter && params.endsAfter.length() > 0 ) {
      def sdf = new java.text.SimpleDateFormat(message(code:'default.date.format.notime', default:'yyyy-MM-dd'));
      def d = sdf.parse(params.endsAfter)
      base_qry += " and tipp.endDate >= ?"
      qry_params.add(d)
    }

    if ( params.startsBefore && params.startsBefore.length() > 0 ) {
      def sdf = new java.text.SimpleDateFormat(message(code:'default.date.format.notime', default:'yyyy-MM-dd'));
      def d = sdf.parse(params.startsBefore)
      base_qry += " and tipp.startDate <= ?"
      qry_params.add(d)
    }

    if ( ( params.sort != null ) && ( params.sort.length() > 0 ) ) {
      base_qry += " order by lower(${params.sort}) ${params.order}"
    }
    else {
      base_qry += " order by lower(tipp.title.title) asc"
    }

    log.debug("Base qry: ${base_qry}, params: ${qry_params}, result:${result}");
    // result.tippList = TitleInstancePackagePlatform.executeQuery("select tipp "+base_qry, qry_params, [max:result.max, offset:result.offset]);
    result.tippList = TitleInstancePackagePlatform.executeQuery("select tipp "+base_qry, qry_params, [max:300, offset:0]);
    result.num_tipp_rows = TitleInstancePackagePlatform.executeQuery("select count(tipp) "+base_qry, qry_params )[0]

    result

  }
}
