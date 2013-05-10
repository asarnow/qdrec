package edu.sfsu.ntd.phenometrainer

import grails.converters.JSON
import grails.plugins.springsecurity.Secured

@Secured(['ROLE_USER'])
class TrainController {

    def springSecurityService
    def trainService

    def index() {
      def user = springSecurityService.getPrincipal()

      def image = user.lastImage
      def control = image.control

      render(view: 'index', model: [image: image.id, control: control.id])
    }

  def imageParasites() {
    def id = Integer.valueOf(params.imageId)
    def image = Image.get(id)
    def parasites = image.parasites

    render parasites as JSON
  }

  def parasite() {
    def imageID = params.imageID
    def parasiteX = params.parasiteX
    def parasiteY = params.parasiteY
    def parasite = trainService.findParasiteByLocation(imageID, parasiteX, parasiteY)

    if (session["parasites"] == null) { // Null -> init and add
      session["parasites"] = [:]
      session["parasites"][parasite.id] = parasite
    } else if (session["parasites"].containsKey(parasite.id)) {
      session["parasites"][parasite.id].remove(parasite.id)  // Toggle a previously selected parasite
    } else {
      session["parasites"][parasite.id] = parasite
    }


    def parasites = []
    session["parasites"].each {k,v -> parasites.add(v) }

    render parasites as JSON
  }
}
