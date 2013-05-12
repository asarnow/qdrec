package edu.sfsu.ntd.phenometrainer

import grails.converters.JSON
import org.springframework.security.access.annotation.Secured

@Secured(['ROLE_USER'])
class TrainController {

    def springSecurityService
    def trainService

    def index() {
      def user = (Users)springSecurityService.getCurrentUser()

      def numTrained = user.trainedParasites.size()

      def image = user.lastImage

      def control = image.control

      session["parasites"] = [:]
      image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it)}

      def parasites = []
      session["parasites"].each {k,v -> parasites.add(v) }

      render( view: 'index', model: [ imageID: image.id,
                                      imageName: image.name,
                                      controlID: control.id,
                                      controlName: control.name,
                                      parasites: parasites as JSON,
                                      numTrained: numTrained ] )
    }

  def imageParasites() {
    def image = Image.get( Integer.valueOf(params.imageId) )
    def parasites = []
    image.parasites.each {it -> parasites.add(trainService.dom2web(it))}
    render parasites as JSON
  }

  def parasite() {
    def imageID = params.imageID
    def parasiteX = params.parasiteX
    def parasiteY = params.parasiteY
    def parasite = trainService.findParasiteByLocation(imageID, parasiteX, parasiteY)

    if ( session["parasites"][parasite.id].trainState == TrainState.NORMAL ) {
      session["parasites"][parasite.id].trainState = TrainState.DEGENERATE
    } else {
      session["parasites"][parasite.id].trainState = TrainState.NORMAL
    }


    def parasites = []
    session["parasites"].each {k,v -> parasites.add(v) }

    render parasites as JSON
  }

  def nextImage() {
    def user = (Users)springSecurityService.getCurrentUser()

    session["parasites"].each { k,v ->
      def parasite = Parasite.findById(v.id)
      def parasiteTrainState = ParasiteTrainState.findByTrainerAndParasite(user,parasite)
      if (parasiteTrainState==null) parasiteTrainState = new ParasiteTrainState()
      parasiteTrainState.parasite = parasite
      parasiteTrainState.trainState = v.trainState
      parasiteTrainState.trainer = user
      parasiteTrainState.save(flush: true)
    }


    user.lastImage = Image.findById( (user.lastImage.id+1)>118 ? 1 : user.lastImage.id+1 )
    user.save(flush: true)

    session["parasites"] = null

    redirect( action: 'index' )
  }

  def prevImage() {
    def user = (Users)springSecurityService.getCurrentUser()
    session["parasites"].each { k,v ->
      def parasite = Parasite.findById(v.id)
      def parasiteTrainState = ParasiteTrainState.findByTrainerAndParasite(user,parasite)
      if (parasiteTrainState==null) parasiteTrainState = new ParasiteTrainState()
      parasiteTrainState.parasite = parasite
      parasiteTrainState.trainState = v.trainState
      parasiteTrainState.trainer = user
      parasiteTrainState.save(flush: true)
    }

    user.lastImage = Image.findById(Math.max(user.lastImage.id-1,1))
    user.save(flush:true)

    session["parasites"] = null

    redirect( action: 'index' )
  }

  def image() {
    def image = Image.get(Integer.valueOf(params.imageID)).imageData.stream
    response.contentLength = image.length
    response.contentType = 'image/png'
    response.outputStream << image
    response.outputStream.flush(image)
  }
}
