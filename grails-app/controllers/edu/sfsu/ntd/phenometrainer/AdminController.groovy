package edu.sfsu.ntd.phenometrainer

import org.springframework.security.access.annotation.Secured

class AdminController {

  def trainService

  @Secured(['ROLE_ADMIN'])
  def index() {

  }

  def userTrainStates() {
    List<String> csvLines = trainService.findAllUserTrainStates(params.userId)
    // Format is image.id, image.name, para.id, para.region, trainState
    render csvLines.join("\n")
  }
}
