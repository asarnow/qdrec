package edu.sfsu.ntd.phenometrainer
import grails.converters.JSON
import grails.util.Holders

class TrainController {

    def grailsApplication = Holders.getGrailsApplication()
    def springSecurityService
    def trainService

    def index() {
      def dataset = Dataset.get(session['datasetID'])

      if (!dataset) {
        redirect(controller: 'upload', action: 'index', params: [message: "Incorrect project or no project selected."])
        return
      } else if (dataset.subsets?.size() < 1) { // true if list is null OR size is 0
        redirect(controller: 'upload', action: 'define', params: [message: "At least one subset must be defined."])
        return
      }

      def subset = dataset.lastSubset ?: dataset.subsets.first()
      def subsetImage = SubsetPosition.findBySubset(subset)?.subsetImage ?: subset.imageSubsets.first()

      def image = subsetImage.image

      session["parasites"] = [:]
      image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it,image.displayScale)}

      def parasites = []
      session["parasites"].each {k,v -> parasites.add(v) }

      boolean done = trainService.doneTraining(subsetImage.subset)

      render( view: 'index', model: [ dataset: image.dataset,
                                      subsets: dataset.subsets,
                                      imageSubset: subsetImage,
                                      subset: subsetImage.subset,
                                      image: image,
                                      control: image.control,
                                      done: done,
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

  def switchSubset() {
    trainService.saveCurrentImageState(session["parasites"])

    def dataset = Dataset.get(params.datasetID) // current dataset
    def subsetImage = SubsetImage.get(params.imageSubsetID) // current subsetImage

    trainService.saveCurrentSubsetPosition(subsetImage)

    def subset = Subset.get(params.subsetID) // new subset
    dataset.lastSubset = subset
    dataset.save(flush: true)

    def sp = SubsetPosition.findBySubset(subset)
    if (!sp) {
      sp = new SubsetPosition()
      sp.subset = subset
      sp.subsetImage = subset.imageSubsets.first()
      sp.save(flush: true)
    }
    boolean done = trainService.doneTraining(sp.subset)
    forward(action: 'selectImage', params: [switchTo: sp.subsetImage.id, done:done])
  }

  def nextImage() {
    trainService.saveCurrentImageState(session["parasites"])
    def imageSubset = SubsetImage.get(params.imageSubsetID)
    def idx = imageSubset.position
    idx = idx==imageSubset.subset.size-1 ? 0 : idx+1
    def nextImageSubset = SubsetImage.findBySubsetAndPosition(imageSubset.subset, idx)
    forward(action: 'selectImage', params: [switchTo: nextImageSubset.id, done:params.done])
  }

  def prevImage() {
    trainService.saveCurrentImageState(session["parasites"])
    def imageSubset = SubsetImage.get(params.imageSubsetID)
    def idx = imageSubset.position
    idx = idx==0 ? imageSubset.subset.size-1 : idx-1
    def prevImageSubset = SubsetImage.findBySubsetAndPosition(imageSubset.subset, idx)
    forward(action: 'selectImage', params: [switchTo: prevImageSubset.id, done:params.done])
  }

  def selectImage() {
    def imageSubset = SubsetImage.get(params.switchTo)
    def image = imageSubset.image

    trainService.saveCurrentSubsetPosition(imageSubset)

    session["parasites"] = null
    session["parasites"] = [:]
    image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it,image.displayScale)}

    def parasites = []
    session["parasites"].each {k,v -> parasites.add(v) }

    boolean done = params.done
    if (imageSubset.position == imageSubset.subset.size || imageSubset.position == 0) {
      done = trainService.doneTraining(imageSubset.subset)
    }

    render(template: 'trainUI', model: [dataset: imageSubset.subset.dataset,
                                        subsets: imageSubset.subset.dataset.subsets,
                                        subset: imageSubset.subset,
                                        imageSubset: imageSubset,
                                        image: image,
                                        control: image.control,
                                        done: done,
                                        parasites: parasites as JSON])
  }

  def image() {
//    def stream = (Image.get(params.imageID).imageData as List)[0].stream
    def image = Image.get(params.imageID)
    def imagef = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + image.dataset.token + File.separator + 'img' + File.separator + image.name + '.png'
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
