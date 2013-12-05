package edu.sfsu.ntd.phenometrainer

class ClassifyController {

  def springSecurityService
  def classifyService

  def index() {
    def datasetID = params.datasetID == null ? Dataset.first().id : params.datasetID
    def subsets = Dataset.get(datasetID).subsets
    render(view: 'classify', model: [datasetID:datasetID, subsets:subsets])
  }

  def classify(){
    if (params.trainSVM) {
      def user = (Users)springSecurityService.getCurrentUser()
      def result = classifyService.trainAndClassify(params.datasetID,user,params.testingID,params.trainingID,params.sigma,params.boxConstraint)
      render(template: 'result',
              model: [cm: result.cm as double[][],
                      Rtrain: result.Rtrain as double[][],
                      Rtest: result.Rtest as double[][],
                      trainImages: result.trainImages as List,
                      testImages:result.testImages as List])
    } else {
      def result = classifyService.classifyOnly(params.datasetID,params.testingID)
      render(template: 'result', model: [Rtest: result.Rtest as double[][], testImages: result.testImages as List])
    }
  }

  def downloadResults() {

  }

}
