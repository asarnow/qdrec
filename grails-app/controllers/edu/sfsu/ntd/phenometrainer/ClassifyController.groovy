package edu.sfsu.ntd.phenometrainer

class ClassifyController {

  def classifyService
  def trainService

  def index() {
    trainService.saveCurrentImageState(session["parasites"])
    def dataset = Dataset.get(session['datasetID'])

    if (!dataset) {
      redirect(controller: 'upload', action: 'index', params: [message: "Incorrect project or no project selected."])
      return
    } else if (dataset.subsets?.size() < 1) { // true if list is null OR size is 0
      redirect(controller: 'upload', action: 'define', params: [message: "At least one subset must be defined."])
      return
    }

    def subsets = dataset.subsets
    render(view: 'classify', model: [datasetID:dataset.id, subsets:subsets])
  }

  def classify(){
    if (params.trainSVM) {
      def result = classifyService.trainAndClassify(params.datasetID,params.testingID,params.trainingID,params.sigma,params.boxConstraint)
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

  def testClassify() {
    double[][] cm = [ [87.0, 3.0], [0.0, 76.0] ]

    double[][] Rtrain = [[0.04, 27.0],
                         [0.04, 25.0],
                         [0.13, 32.0],
                         [0.7,  30.0],
                         [1.0,  29.0],
                         [1.0,  23.0] ]

    double[][] Rtest = [[0.03, 31.0],
                        [0.0,	 23.0],
                        [0.13, 31.0],
                        [0.75, 24.0],
                        [0.97, 30.0],
                        [1.0,	 18.0] ]

    def trainImages = ["072913-CTRL-0-4-b",
                       "072913-NIC-0001-4-b",
                       "072913-NIC-001-4-b",
                       "072913-NIC-01-4-b",
                       "072913-NIC-1-4-b",
                       "072913-NIC-10-4-b"]

    def testImages = ["072913-CTRL-0-4-b",
                      "072913-NIC-0001-4-b",
                      "072913-NIC-001-4-b",
                      "072913-NIC-01-4-b",
                      "072913-NIC-1-4-b",
                      "072913-NIC-10-4-b"]

    render(view: 'testClassify',
                  model: [cm: cm as double[][],
                          Rtrain: Rtrain as double[][],
                          Rtest: Rtest as double[][],
                          trainImages: trainImages as List,
                          testImages: testImages as List,
                          datasetID: params.datasetID,
                          subsets: Dataset.get(params.datasetID).subsets])
  }

  def downloadResults() {

  }

}
