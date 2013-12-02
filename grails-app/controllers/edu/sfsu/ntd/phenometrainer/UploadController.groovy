package edu.sfsu.ntd.phenometrainer

import org.springframework.security.access.annotation.Secured

@Secured(['ROLE_USER'])
class UploadController {

  def adminService

  def index() {
    def skipUpload = params.skipUpload
    skipUpload = skipUpload != null ? skipUpload : 0L
    def dataset = Dataset.last()
    def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + (dataset.id+1)
    render(view: 'upload', model: [datasetDir: datasetDir, skipUpload: skipUpload])
  }

  def createDataset() {
    def dataset = adminService.initDataset(params.datasetName, params.datasetDir)
    render(template: 'dataset', model: [dataset: dataset])
  }

  def createSubset() {
    def dataset = adminService.defineSubset(params.subsetName, params.datasetID, params.imageList)
    render(template: 'subset', model: [subsets: dataset.subsets])
  }

  def imageList() {
    def subset = Subset.get(params.subsetID)
    render( template: 'imageList', model: [dataset:subset.dataset, imageIDs:subset.imageSubsets.image.id])
  }
}
