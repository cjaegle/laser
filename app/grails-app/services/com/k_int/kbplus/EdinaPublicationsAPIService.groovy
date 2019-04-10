package com.k_int.kbplus

import groovyx.net.http.*

class EdinaPublicationsAPIService {

  static transactional = false
  def endpoint
  def target_service

  @javax.annotation.PostConstruct
  def init() {
    log.debug("Initialising rest endpoint for edina publications service...");
    endpoint = grails.util.Holders.config.publicationService.baseurl ?: "http://knowplus.edina.ac.uk:2012/kbplus/api"
    target_service = new RESTClient(endpoint)
  }

  def lookup(title) {
    // http://knowplus.edina.ac.uk:2012/kbplus/api?title=ACS%20Applied%20Materials%20and%20Interfaces

    def result = null

    try {
      target_service.request(Method.GET, ContentType.XML) { request ->
        // uri.path='/'
        uri.query = [
          title:title
        ]

        response.success = { resp, data ->
          // data is the xml document
          // ukfam = data;
          result = data;
        }
        response.failure = { resp ->
          log.error("Error - ${resp}");
        }
      }
    }
    catch ( Exception e ) {
      e.printStackTrace();
    } 
    finally {
    }


    result
  }
}
