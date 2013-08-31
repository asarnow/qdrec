package edu.sfsu.ntd.phenometrainer
import grails.converters.JSON
import org.springframework.security.access.annotation.Secured

@Secured(['ROLE_USER'])
class TrainController {

    def springSecurityService
    def trainService
    def sessionFactory

    def index() {
      def user = (Users)springSecurityService.getCurrentUser()

//      def numTrained = user.trainedParasites.size()

      def image = user.lastImage

      def control = image.control

//      session["dataset"] = image.dataset
      def q = sessionFactory.currentSession.createSQLQuery("select images_idx from image where id = :code")
//      q.addEntity(Integer.class)
      q.setLong("code",image.id)
      def idx = q.list()[0]

//      def idx = Image.executeQuery("select i.images_idx from Image i where i.id = ?",[image.id])

      if (idx==-1) {
        // image not in dataset (unreachable)
        response.status = 500
        return
      }

      session["parasites"] = [:]
      image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it)}

      def parasites = []
      session["parasites"].each {k,v -> parasites.add(v) }

      render( view: 'index', model: [ datasets: Dataset.findAll(),
                                      datasetID: image.dataset.id,
                                      datasetSize: image.dataset.size,
                                      imageIdx: idx,
                                      imageID: image.id,
                                      imageName: image.name,
                                      controlID: control.id,
                                      controlName: control.name,
                                      parasites: parasites as JSON ] )
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

  def switchDataset() {
    trainService.saveCurrentImageState(session["parasites"])
    def user = (Users)springSecurityService.getCurrentUser()
    def dataset = Dataset.get(Integer.valueOf(params.datasetID))
    user.lastImage = trainService.determineLastImageForDataset(dataset)
    user.save(flush: true)
    redirect(action: 'index')
  }

  def nextImage() {
    trainService.saveCurrentImageState(session["parasites"])
    def image = Image.get(params.imageID)
    def idx = Integer.valueOf(params.imageIdx)
    idx = idx==image.dataset.size-1 ? 0 : idx+1
    forward(action: 'selectImage', params: [imageIdx: idx, imageID: image.id])
  }

  def prevImage() {
    trainService.saveCurrentImageState(session["parasites"])
    def image = Image.get(params.imageID)
    def idx = Integer.valueOf(params.imageIdx)
    idx = idx==0 ? image.dataset.size-1 : idx-1
    forward(action: 'selectImage', params: [imageIdx: idx, imageID: image.id])
  }

  def selectImage() {
    def idx = Integer.valueOf(params.imageIdx)
    Image image = Image.get(params.imageID)
//    Image image = Image.findByDatasetAndPosition(session["dataset"],idx)
    def user = (Users)springSecurityService.getCurrentUser()
    user.lastImage = image
    user.save(flush: true)
    session["parasites"] = null
    session["parasites"] = [:]
    image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it)}

    def parasites = []
    session["parasites"].each {k,v -> parasites.add(v) }

    render(template: 'trainUI', model: [datasetSize: image.dataset.size,
                                        imageIdx: idx,
                                        imageID: image.id,
                                        imageName: image.name,
                                        controlID: image.control.id,
                                        controlName: image.control.name,
                                        parasites: parasites])
  }

  def image() {
    def image = (Image.get(Integer.valueOf(params.imageID)).imageData as List)[0].stream
    response.contentLength = image.length
    response.contentType = 'image/png'
    response.outputStream << image
    response.outputStream.flush(image)
  }

  def userTrainStates() {
    List<String> csvLines = trainService.findAllUserTrainStates(params.userId)
    // Format is image.id, image.name, para.id, para.region, trainState
    render csvLines.join("\n")
  }
}
