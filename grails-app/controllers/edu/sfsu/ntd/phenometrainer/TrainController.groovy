package edu.sfsu.ntd.phenometrainer
import grails.converters.JSON
import org.springframework.security.access.annotation.Secured

@Secured(['ROLE_USER'])
class TrainController {

    def springSecurityService
    def trainService

    def index() {
      def user = (Users)springSecurityService.getCurrentUser()

//      def numTrained = user.trainedParasites.size()

      def imageSubset = user.lastImageSubset ?: Subset.last().imageSubsets.first()

      user.lastImageSubset = imageSubset
      user = user.save(flush: true)

      def image = imageSubset.image
      def dataset = image.dataset

      session["parasites"] = [:]
      image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it,image.displayScale)}

      def parasites = []
      session["parasites"].each {k,v -> parasites.add(v) }

      render( view: 'index', model: [ datasets: Dataset.findAll(),
                                      dataset: image.dataset,
                                      subsets: dataset.subsets,
                                      imageSubset: imageSubset,
                                      subset: imageSubset.subset,
                                      image: image,
                                      control: image.control,
                                      parasites: parasites as JSON] )
    }

  def imageParasites() {
    def image = Image.get(params.imageID)
    def parasites = []
    image.parasites.each {it -> parasites.add(trainService.dom2web(it, image.displayScale))}
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
    def subset = Subset.get(params.subsetID)
    trainService.saveCurrentUserSubsetPosition(subset)
    redirect(action: 'index')
  }

  def nextImage() {
    trainService.saveCurrentImageState(session["parasites"])
    def imageSubset = SubsetImage.get(params.imageSubsetID)
    def idx = imageSubset.position
    idx = idx==imageSubset.subset.size-1 ? 0 : idx+1
    def nextImageSubset = SubsetImage.findBySubsetAndPosition(imageSubset.subset, idx)
    forward(action: 'selectImage', params: [switchTo: nextImageSubset.id])
  }

  def prevImage() {
    trainService.saveCurrentImageState(session["parasites"])
    def imageSubset = SubsetImage.get(params.imageSubsetID)
    def idx = imageSubset.position
    idx = idx==0 ? imageSubset.subset.size-1 : idx-1
    def prevImageSubset = SubsetImage.findBySubsetAndPosition(imageSubset.subset, idx)
    forward(action: 'selectImage', params: [switchTo: prevImageSubset.id])
  }

  def selectImage() {
    def imageSubset = SubsetImage.get(params.switchTo)
    def image = imageSubset.image
//    Subset subset = imageSubset.subset
    def user = (Users)springSecurityService.getCurrentUser()
    user.lastImageSubset = imageSubset
    user.save(flush: true)
    session["parasites"] = null
    session["parasites"] = [:]
    image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it,image.displayScale)}

    def parasites = []
    session["parasites"].each {k,v -> parasites.add(v) }

    render(template: 'trainUI', model: [imageSubset: imageSubset,
                                        subset: imageSubset.subset,
                                        image: image,
                                        control: image.control,
                                        parasites: parasites as JSON])
  }

  def image() {
//    def stream = (Image.get(params.imageID).imageData as List)[0].stream
    def image = Image.get(params.imageID)
    def imagef = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + image.dataset.id + File.separator + 'img' + File.separator + image.name + '.png'
    def stream = new BufferedInputStream(new FileInputStream(imagef)).getBytes()
    response.contentLength = stream.length
    response.contentType = 'image/png'
    response.outputStream << stream
    response.outputStream.flush()
  }

  def subsets() {
    def dataset = Dataset.get(params.datasetID)
    render dataset?.subsets as JSON
  }

  def toggleParasites() {
    def parasites = trainService.toggleParasites(session["parasites"])
    render parasites as JSON
  }

  def resetParasites() {
    def parasites = trainService.resetParasites(session["parasites"])
    render parasites as JSON
  }

}
