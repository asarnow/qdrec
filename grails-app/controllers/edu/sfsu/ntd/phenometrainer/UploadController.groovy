package edu.sfsu.ntd.phenometrainer
import grails.util.Holders

class UploadController {

  def adminService
  def grailsApplication = Holders.getGrailsApplication()
  def trainService

  def index() {
    trainService.saveCurrentImageState(session["parasites"])
    render(view: 'upload', model: [message: params.message])
  }

  def createDataset() {
    def dataset = adminService.initDataset(params.datasetName, params.datasetDir, params.visible, params.segmentation)
    session['datasetID'] = dataset.id
    redirect(action: 'define')
  }

  def load() {
    def dataset = Dataset.get(params.datasetID)
    session['datasetID'] = dataset?.id
    redirect(action: 'define')
  }

  def define() {
    trainService.saveCurrentImageState(session["parasites"])
    def dataset = Dataset.get(session['datasetID'])
    if (!dataset) {
      redirect(view: 'upload', params: [message: "Incorrect project or no project selected."])
      return
    } else if (dataset.subsets?.size() < 1) { // true if list is null OR size is 0
      redirect(view: 'define', params: [message: "At least one subset must be defined."])
      return
    }
    render(view: 'define', model: [dataset: dataset])
  }

  def project() {
    if (params.load=='true') {
      render(view: 'upload')
    } else {

      def datasetID = Dataset.last()?.id?: 0
      datasetID += 1
      def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + datasetID
      def dir = new File(datasetDir);
      if (dir.exists()) dir.deleteDir();

      render(view: 'upload', model: [datasetDir: datasetDir])
    }
  }

  def datasetInfo() {
    render(template: 'datasetInfo', model: [dataset: Dataset.findByToken(params.token)])
  }

  def dataset() {
    render(template: 'dataset', model: [dataset: Dataset.get(params.datasetID)])
  }

  def createSubset() {
    adminService.defineSubset(params.subsetName, params.datasetID, params.imageList)
//    render(template: 'subset', model: [subsets: Dataset.get(params.datasetID).subsets])
    render(template: 'dataset', model: [dataset: Dataset.get(params.datasetID)])
  }

  def imageList() {
    def subset = Subset.get(params.subsetID)
    render( template: 'imageList', model: [dataset:subset.dataset, imageIDs:subset.imageSubsets.image.id])
  }
}
