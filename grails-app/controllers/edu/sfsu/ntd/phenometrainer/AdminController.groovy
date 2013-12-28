package edu.sfsu.ntd.phenometrainer

import org.springframework.security.access.annotation.Secured

class AdminController {

  def trainService
  def adminService

  @Secured(['ROLE_ADMIN'])
  def index() {

  }

  def userTrainStates() {
    List<String> csvLines = trainService.findAllUserTrainStates(params.userID)
    // Format is image.id, image.name, para.id, para.region, trainState
    render csvLines.join("\n")
  }

  def userSubsetTrainStates() {
    List<String> csvLines = trainService.findAllUserSubsetTrainStates(params.userID, params.subsetID)
    render csvLines.join("\n")
  }

  def createUser() {


  }

  def initUser() {
    def user = adminService.initUser(params.username, params.password, 'ROLE_USER')
    render(template: 'createUserResponse', model: [user: user])
  }

}
