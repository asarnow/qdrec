package edu.sfsu.ntd.phenometrainer

import org.springframework.security.access.annotation.Secured

@Secured(['ROLE_USER'])
class UploadController {

  def adminService

  def index() {
    def datasetID = Dataset.last()?.id ?: 1
    def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + datasetID
    render(view: 'upload', model: [datasetDir: datasetDir])
  }

  def createDataset() {
    def dataset = adminService.initDataset(params.datasetName, params.datasetDir)
    redirect(action: 'define', params: [datasetID: dataset.id])
  }

  def define() {
    def dataset
    if (params.datasetID != null) {
      dataset = Dataset.get(params.datasetID)
    } else {
      dataset = Dataset.last()
    }
    render(view: 'define', model: [dataset: dataset])
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
