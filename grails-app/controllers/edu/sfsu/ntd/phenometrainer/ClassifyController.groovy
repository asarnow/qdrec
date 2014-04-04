package edu.sfsu.ntd.phenometrainer

import com.mathworks.toolbox.javabuilder.MWNumericArray
import grails.converters.JSON
import grails.util.Holders
import phenomj.PhenomJ

class ClassifyController {

  def classifyService
  def trainService
  def grailsApplication = Holders.getGrailsApplication()

  def index() {
    trainService.saveCurrentImageState(session["parasites"])
    def dataset = Dataset.get(session['datasetID'])

    if (!dataset) {
      redirect(controller: 'project', action: 'index', params: [message: "Incorrect project or no project selected."])
      return
    } else if (dataset.subsets?.size() < 1) { // true if list is null OR size is 0
      redirect(controller: 'project', action: 'define', params: [message: "At least one subset must be defined."])
      return
    }

    def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.token
    def svmsFileExists = new File(datasetDir + File.separator + 'svms.mat').exists()
    def classifierType = svmsFileExists ? classifyService.classifierType(datasetDir + File.separator + 'svms.mat') : ""

    def subsets = dataset.subsets
    render(view: 'classify', model: [dataset:dataset, subsets:subsets, svmsFileExists: svmsFileExists, classifierType: classifierType])
  }

  def classify(){
      def subset = Subset.get(params.testingID)
      def result = classifyService.classifyOnly(params.datasetID,params.testingID,params.useSVM)
      session['result'] = result
      session['dr'] = classifyService.doseResponse(SubsetImage.findAllBySubset(subset).image, result.Rtest)
      session['tr'] = classifyService.timeResponse(SubsetImage.findAllBySubset(subset).image, result.Rtest)
      def compounds = (session['dr'] as Map).keySet() as List
      render(template: 'combinedResult', model: [Rtest: result.Rtest as double[][],
                                                 testImages: (result.testImages as List<Image>)?.name,
                                                 compounds: compounds,
                                                 error:session['tr']==null||session['dr']==null])
  }

  def trainClassifier() {
    def dataset = Dataset.get(session['datasetID'])
    def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.token
    def svmsFileExists = new File(datasetDir + File.separator + 'svms.mat').exists()
    def classifierType = svmsFileExists ? classifyService.classifierType(datasetDir + File.separator + 'svms.mat') : ""
    render(view: 'trainClassifier', model: [dataset: dataset, subsets: dataset?.subsets, svmsFileExists: svmsFileExists, classifierType: classifierType])
  }

  def trainSVM() {
    def subset = Subset.get(params.trainingID)
    def result = null
    def message
    if (trainService.doneTraining(subset)) {
      result = classifyService.trainOnly(params.datasetID,params.trainingID,params.sigma,params.boxConstraint,params.classifier)
      message = 'Training completed successfully.'
    } else {
      message = 'Subset is not completely annotated.'
    }
    render(template: 'result',
           model: [cm: result?.cm as double[][],
                   Rtrain: result?.Rtrain as double[][],
                   trainImages: (result?.trainImages as List<Image>)?.name,
                   message: message])
  }

  def testClassify() {
    trainService.saveCurrentImageState(session["parasites"])
    session['datasetID'] = Dataset.first().id
    def dataset1 = Dataset.get(session['datasetID'])

    if (!dataset1) {
      redirect(controller: 'project', action: 'index', params: [message: "Incorrect project or no project selected."])
      return
    } else if (dataset1.subsets?.size() < 1) { // true if list is null OR size is 0
      redirect(controller: 'project', action: 'define', params: [message: "At least one subset must be defined."])
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

    session['result'] = [:]
    session['result'].testImages = Image.where({name in testImages && dataset==dataset1}).list()
    session['result'].trainImages = Image.where({name in trainImages && dataset==dataset1}).list()
    session['result'].Rtest = Rtest
    session['result'].Rtrain = Rtrain
    session['result'].cm = cm

    session['dr'] = classifyService.doseResponse(Image.where({name in testImages && dataset==dataset1}).list(), Rtest)
    session['tr'] = classifyService.timeResponse(Image.where({name in testImages && dataset==dataset1}).list(), Rtest)

    def compounds = (session['dr'] as Map).keySet() as List

    render(view: 'testClassify',
                  model: [cm: cm as double[][],
                          Rtrain: Rtrain as double[][],
                          Rtest: Rtest as double[][],
                          trainImages: trainImages as List,
                          testImages: testImages as List,
                          dataset: dataset1,
                          subsets: dataset1.subsets,
                          compounds:compounds,
                          error:session['tr']==null||session['dr']==null])
  }

  def curves() {
    def curves = [] as Set
    if (params.xdim=='time') {
      def dr = session['dr'][params.compound] as Map<Double,Map<Integer,Map>>;
      dr.keySet().each {curves.add(it + ' &micro;M')}
    } else if (params.xdim=='conc') {
      def tr = session['tr'][params.compound] as Map<Integer,Map<Double,Map>>;
      tr.keySet().each {curves.add(it + ' time units')}
    }
    render(template: 'curves', model: [curves:(curves as List).sort(), xdim:params.xdim])
  }

  def plotsrc() {
    render(createLink(action: 'genplot', params: params))
  }

  def genplot() {
    def stream = null
    def curves = params.curves as List
    def curve_cell = classifyService.list2cell(curves as List<String>)
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
      stream = (phenomj.plotResponse(1,x,rmat,smat,'time',curve_cell,compound)[0] as MWNumericArray).byteData
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
      stream = (phenomj.plotResponse(1,x,rmat,smat,'conc',curve_cell,compound)[0] as MWNumericArray).byteData
    }
    response.contentLength = stream.length
    response.contentType = 'image/png'
    response.outputStream << stream
    response.outputStream.flush()
  }

  def csvdata() {
    def compound = params.compound
    double[][] rmat
    def labels = []
    def grp = session['tr'][compound] as Map<Integer,Map<Double,Map>>;
    def curves = ((session['dr'][compound] as Map<Double,Map<Integer,Map>>).keySet() as List).sort()
    labels.add('Exposure')
    curves.each {labels.add(it + ' &micro;M')}
    def x = (grp.keySet() as List).sort().toArray() as int[]
    rmat = new double[x.size()][1 + 2*curves.size()];
    x.eachWithIndex { double entry, int i -> rmat[i][0] = entry }
    for (int i=0; i<x.size(); i++) {
      for (int j=1; j<rmat[0].length; j+=2) {
        def c = grp[x[i] as Integer]
        def t = curves[(j-1)/2 as int] as Double
        if (c[t]==null) {
          rmat[i][j] = Double.NaN
          rmat[i][j+1] = Double.NaN
        } else {
          def r = c[t].r
          rmat[i][j] = classifyService.mean(r)
          rmat[i][j+1] = classifyService.std(r)
        }
      }
    }

    def csv = new StringBuilder()
    csv.append(labels.join(',') + '\n')
    def extrapt = (rmat[0][0]-0.5) + (',NaN' * (rmat[0].length-1)) + '\n'
    csv.append(extrapt)
    for (int i=0; i<rmat.length; i++) {
      csv.append((rmat[i] as List).join(',') + '\n')
    }
    extrapt = (rmat[rmat.length-1][0]+0.5) + (',NaN' * (rmat[0].length-1)) + '\n'
    csv.append(extrapt)

    double[][] rmat2
    def labels2 = []
    def grp2 = session['dr'][compound] as Map<Double,Map<Integer,Map>>;
    def curves2 = ((session['tr'][compound] as Map<Integer,Map<Double,Map>>).keySet() as List).sort()
    labels2.add('Log Concentration')
    curves2.each {labels2.add(it + ' time units')}
    def x2 = (grp2.keySet() as List).sort().toArray() as double[]
    rmat2 = new double[x2.size()][1 + 2*curves2.size()]
    x2.eachWithIndex { double entry, int i -> rmat2[i][0] = Math.log10(entry) }
    for (int i=0; i<x2.size(); i++) {
      for (int j=1; j<rmat2[0].length; j+=2) {
        def c = grp2[x2[i]]
        def t = curves2[(j-1)/2 as int] as Integer
        if (c[t]==null) {
          rmat2[i][j] = Double.NaN
          rmat2[i][j+1] = Double.NaN
        } else {
          def r = c[t].r
          rmat2[i][j] = classifyService.mean(r)
          rmat2[i][j+1] = classifyService.std(r)
        }
      }
    }

    def csv2 = new StringBuilder()
    csv2.append(labels2.join(',') + '\n')
    extrapt = (rmat2[0][0]-0.5) + (',NaN' * (rmat2[0].length-1)) + '\n'
    csv2.append(extrapt)
    for (int i=0; i<rmat2.length; i++) {
      csv2.append((rmat2[i] as List).join(',') + '\n')
    }
    extrapt = (rmat2[rmat2.length-1][0]+0.5) + (',NaN' * (rmat2[0].length-1)) + '\n'
    csv2.append(extrapt)

    def result = [csv1: csv, csv2: csv2]

    render result as JSON
  }

  def downloadResults() {
    def testImages = session['result'].testImages as List<Image>
    def trainImages = session['result'].trainImages as List<Image>
    def Rtest = session['result'].Rtest as double[][]
    def Rtrain = session['result'].Rtrain as double[][]
    def cm = session['result'].cm as double[][]
    def csv = new StringBuilder()
    if (cm!=null) {
      csv.append("Cross-validated Confusion Matrix\n")
      csv.append("Normal,Degenerate\n")
      for (int i=0; i<cm.length; i++) {
        def a = i==0 ? "Normal" : "Degenerate"
        csv.append( a + ',' + (cm[i] as List).join(',') + '\n' )
      }
    }
    if (trainImages!=null && Rtrain!=null) {
      csv.append("Cross-validated Training Results\n")
      csv.append("Quantal Response,Number of Parasites\n")
      trainImages.eachWithIndex { Image entry, int i ->
        def line = entry.name + ',' + Rtrain[i][0] + ',' + Rtrain[i][1] + '\n'
        csv.append(line)
      }
    }
    if (testImages!=null && Rtest!=null) {
      csv.append("Test Results\n")
      csv.append("Quantal Response,Number of Parasites\n")
      testImages.eachWithIndex { Image entry, int i ->
        def line = entry.name + ',' + Rtest[i][0] + ',' + Rtest[i][1] + '\n'
        csv.append(line)
      }
    }
    def fname = 'QDREC_Results.csv'
    response.setContentType('text/csv')
    response.setHeader("Content-disposition", "filename=${fname}")
    response.outputStream << csv.toString().bytes
  }

  def trainingVec() {
    def training = Subset.get(params.subsetID)
    boolean[] G = classifyService.findTrainingVector(training)
    render G as JSON
  }

}
