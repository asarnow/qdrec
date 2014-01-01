package edu.sfsu.ntd.phenometrainer
import grails.converters.JSON
import grails.util.Holders

import java.nio.file.Files

class ProjectController {

  def adminService
  def grailsApplication = Holders.getGrailsApplication()
  def trainService

  def index() {
    trainService.saveCurrentImageState(session["parasites"])
    if (params.load=='true') {
      def dataset = Dataset.get(session['datasetID'])
      render(view: 'upload', model: [message: params.message, dataset: dataset])
    } else {
      def datasetDir = Files.createTempDirectory('qdrec').toFile().path
      def imgDir = datasetDir + File.separator + 'img'
      def segDir = datasetDir + File.separator + 'bw'
      session['uploadr'] = null
      render(view: 'upload', model: [datasetDir: datasetDir, imgDir: imgDir, segDir: segDir, message: params.message])
    }
  }

  def createDataset() {
    def dataset = adminService.initDataset(params.datasetName, params.datasetDir, params.visible, params.segmentation)
    session['datasetID'] = dataset.id
    if (params.segmentation=='Upload') {
      redirect(controller: 'project', action: 'define')
    } else {
      redirect(controller: 'project', action: 'review')
    }
  }

  def load() {
    def dataset = Dataset.findByToken(params.token) ?: Dataset.get(params.datasetID)
    if (dataset==null) {
      redirect(action: 'index', params: [load: 'true', message: "Incorrect project or no project selected."])
    } else {
      session['datasetID'] = dataset?.id
      redirect(action: 'index', params: [load: 'true', dataset: dataset])
    }
  }

  def define() {
    trainService.saveCurrentImageState(session["parasites"])
    def dataset = Dataset.get(session['datasetID'])
    if (!dataset) {
      redirect(view: 'upload', params: [message: "Incorrect project or no project selected."])
    } else {
      render(view: 'define', model: [dataset: dataset])
    }
  }

/*  def project() {
    if (params.load=='true') {
      def dataset = Dataset.get(session['datasetID'])
      render(view: 'upload', model: [message: params.message, dataset: dataset])
    } else {
      def datasetDir = Files.createTempDirectory('qdrec').toAbsolutePath().toString()
      render(view: 'upload', model: [datasetDir: datasetDir, message: params.message])
    }
  }*/

  def datasetInfo() {
    render Dataset.get(params.datasetID)?.token
  }

  def dataset() {
    render(template: 'dataset', model: [dataset: Dataset.get(params.datasetID)])
  }

  def createSubset() {
    def output = adminService.defineSubset(params.subsetName, params.datasetID, params.imageList)
    def nocontrol = output.nocontrol as List<Image>
    def message = output.message
    render(template: 'dataset', model: [dataset: Dataset.get(params.datasetID), nocontrol: nocontrol, message: message])
  }

  def imageList() {
    def subset = Subset.get(params.subsetID)
    render( template: 'imageList', model: [dataset:subset.dataset, imageIDs:subset.imageSubsets.image.id])
  }

  def review() {
    def dataset = Dataset.get(session['datasetID'])
    if (!dataset) {
      if (params.load=='true') {
        redirect(action: 'index', params: [message: "Incorrect project or no project selected.", load:'true'])
      } else {
        redirect(action: 'index', params: [message: "Incorrect project or no project selected."])
      }
    } else {

      def image = dataset.images.first()
      session["parasites"] = [:]
      image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it,image.displayScale)}
      def parasites = []
      session["parasites"].each {k,v -> parasites.add(v) }

      render( view: 'review', model: [dataset: dataset,
                                      image: image,
                                      parasites: parasites as JSON] )
    }
  }

  def nextImage() {
    def image = Image.get(params.imageID)
    def idx = image.position
    idx = idx==image.dataset.size-1 ? 0 : idx+1
    def nextImage = Image.findByDatasetAndPosition(image.dataset, idx)
    forward(action: 'selectImage', params: [switchTo: nextImage.id])
  }

  def prevImage() {
    def image = Image.get(params.imageID)
    def idx = image.position
    idx = idx==0 ? image.dataset.size-1 : idx-1
    def prevImage = Image.findByDatasetAndPosition(image.dataset, idx)
    forward(action: 'selectImage', params: [switchTo: prevImage.id])
  }

  def selectImage() {
    def image = Image.get(params.switchTo)
    session["parasites"] = null
    session["parasites"] = [:]
    image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it,image.displayScale)}
    def parasites = []
    session["parasites"].each {k,v -> parasites.add(v) }

    render(template: 'reviewUI', model: [dataset: image.dataset,
                                         image: image,
                                         parasites: parasites as JSON])
  }

  def image() {
    def image = Image.get(params.imageID)
    def imagef
    if (params.segmented=='true') {
      imagef = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + image.dataset.token + File.separator + 'bw' + File.separator + image.name + '.png'
    } else {
      imagef = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + image.dataset.token + File.separator + 'img' + File.separator + image.name + '.png'
    }
    def stream = new BufferedInputStream(new FileInputStream(imagef)).getBytes()
    response.contentLength = stream.length
    response.contentType = 'image/png'
    response.outputStream << stream
    response.outputStream.flush()
  }

  def allimages() {
    def dataset = Dataset.get(session['datasetID'])
    render dataset.images as JSON
  }

  def addcontrol() {
    def image = Image.get(params.imageID)
    def control = Image.get(params.controlID)
    image.control = control
    image.save(flush:true)
    render ''
  }

}
