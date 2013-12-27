package edu.sfsu.ntd.phenometrainer

import com.mathworks.toolbox.javabuilder.MWNumericArray
import phenomj.PhenomJ

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
    render(view: 'classify', model: [dataset:dataset, subsets:subsets])
  }

  def classify(){
    if (params.trainSVM) {
      def result = classifyService.trainAndClassify(params.datasetID,params.testingID,params.trainingID,params.sigma,params.boxConstraint)
      session['dr'] = classifyService.doseResponse(Image.where({name in result.testImages}).list(), result.Rtest)
      session['tr'] = classifyService.timeResponse(Image.where({name in result.testImages}).list(), result.Rtest)
      def compounds = (session['dr'] as Map).keySet() as List
      render(template: 'resultPlot',
              model: [cm: result.cm as double[][],
                      Rtrain: result.Rtrain as double[][],
                      Rtest: result.Rtest as double[][],
                      trainImages: result.trainImages as List,
                      testImages:result.testImages as List],
                      compounds:compounds)
    } else {
      def result = classifyService.classifyOnly(params.datasetID,params.testingID)
      session['dr'] = classifyService.doseResponse(Image.where({name in result.testImages}).list(), result.Rtest)
      session['tr'] = classifyService.timeResponse(Image.where({name in result.testImages}).list(), result.Rtest)
      def compounds = (session['dr'] as Map).keySet() as List
      render(template: 'resultPlot', model: [Rtest: result.Rtest as double[][], testImages: result.testImages as List, compounds: compounds])
    }
  }

  def testClassify() {
    trainService.saveCurrentImageState(session["parasites"])
    session['datasetID'] = Dataset.first().id
    def dataset = Dataset.get(session['datasetID'])

    if (!dataset) {
      redirect(controller: 'upload', action: 'index', params: [message: "Incorrect project or no project selected."])
      return
    } else if (dataset.subsets?.size() < 1) { // true if list is null OR size is 0
      redirect(controller: 'upload', action: 'define', params: [message: "At least one subset must be defined."])
      return
    }

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

    session['dr'] = classifyService.doseResponse(Image.where({name in testImages}).list(), Rtest)
    session['tr'] = classifyService.timeResponse(Image.where({name in testImages}).list(), Rtest)

    def compounds = (session['dr'] as Map).keySet() as List

    render(view: 'testClassify',
                  model: [cm: cm as double[][],
                          Rtrain: Rtrain as double[][],
                          Rtest: Rtest as double[][],
                          trainImages: trainImages as List,
                          testImages: testImages as List,
                          dataset: dataset,
                          subsets: dataset.subsets,
                          compounds:compounds])
  }

  def downloadResults() {

  }

  def curves() {
    def curves = [] as Set
    if (params.xdim=='time') {
      def dr = session['dr'][params.compound] as Map<Double,Map<Integer,Map>>;
      dr.keySet().each {curves.add(it)}
    } else if (params.xdim=='conc') {
      def tr = session['tr'][params.compound] as Map<Integer,Map<Double,Map>>;
      tr.keySet().each {curves.add(it)}
    }
    render(template: 'curves', model: [curves:curves as List])
  }

  def plotsrc() {
    render(createLink(action: 'genplot', params: params))
  }

  def genplot() {
    def stream = null
    def curves = params.curves as List
    def compound = params.compound
    def tr = session['tr'][compound] as Map<Integer,Map<Double,Map>>;
    def dr = session['dr'][compound] as Map<Double,Map<Integer,Map>>;
    def phenomj = new PhenomJ()
    if (params.xdim=='time') {
      def x = (tr.keySet() as List).toArray() as int[]
      double[][] rmat = new double[x.size()][curves.size()];
      double[][] smat = new double[x.size()][curves.size()]
      for (int i=0; i<x.size(); i++) {
        for (int j=0; j<curves.size(); j++) {
          def c = tr[x[i] as Integer]
          def t = curves[j] as Double
          def r = c[t].r
          rmat[i][j] = classifyService.mean(r)
          smat[i][j] = classifyService.std(r)
        }
      }
      stream = (phenomj.plotResponse(1,x,rmat,smat)[0] as MWNumericArray).byteData
    } else {
      def x = (dr.keySet() as List).toArray() as double[]
      double[][] rmat = new double[x.size()][curves.size()]
      double[][] smat = new double[x.size()][curves.size()]
      for (int i=0; i<x.size(); i++) {
        for (int j=0; j<curves.size(); j++) {
          def c = dr[x[i]]
          def t = curves[j] as Integer
          def r = c[t].r
          rmat[i][j] = classifyService.mean(r)
          smat[i][j] = classifyService.std(r)
        }
      }
      stream = (phenomj.plotResponse(1,x,rmat,smat)[0] as MWNumericArray).byteData
    }
    response.contentLength = stream.length
    response.contentType = 'image/png'
    response.outputStream << stream
    response.outputStream.flush()
  }

}
