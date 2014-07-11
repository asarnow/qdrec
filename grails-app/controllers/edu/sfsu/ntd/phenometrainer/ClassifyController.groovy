/*
 * Copyright (C) 2014 Daniel Asarnow
 * San Francisco State University
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package edu.sfsu.ntd.phenometrainer
import com.mathworks.toolbox.javabuilder.MWException
import grails.converters.JSON
import grails.util.Holders
/**
 * Handles all actions related to classification,
 * including classifier construction/training, running the classifier and display of results.
 * (Note annotation/training is handled by TrainController).
 */

class ClassifyController {
  // Objects for dependency injection via Spring.
  def classifyService
  def trainService
  def grailsApplication = Holders.getGrailsApplication()

  /**
   * Main action for Run Classifier - maps to /classify/ or /classify/index.
   * Redirects if classification is not possible (project not loaded / no subsets available),
   * and displays the classification view.
   *
   * Ensures in-progress annotation is saved.
   * @return
   */
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

    if (session['result'] != null) {
      def Rtest = session['result'].Rtest as double[][]
      def testImages = (session['result'].testImages as List<Image>)?.name
      def compounds = (session['dr'] as Map)?.keySet() as List
      render(view: 'classify', model: [dataset:dataset, subsets:subsets, svmsFileExists: svmsFileExists, classifierType: classifierType,
                                       hasResult: true,
                                       Rtest: Rtest,
                                       testImages: testImages,
                                       compounds: compounds,
                                       error: session['tr']==null||session['dr']==null ])
    } else {
      render(view: 'classify', model: [dataset:dataset, subsets:subsets, svmsFileExists: svmsFileExists, classifierType: classifierType, hasResult: false])
    }
  }

  /**
   * RESTful API call for classification.
   * Validates the classification form input, passes parameters to ClassifyService instance,
   * stores the results in the session and renders the results template.
   *
   * @return
   */
  def classify(){
      def subset = Subset.get(params.testingID)
      def r = classifyService.classifyOnly(params.datasetID,params.testingID,params.useSVM)
      session['result'] = r.result
      session['dr'] = classifyService.doseResponse(SubsetImage.findAllBySubset(subset).image, r.result.Rtest)
      session['tr'] = classifyService.timeResponse(SubsetImage.findAllBySubset(subset).image, r.result.Rtest)
      def compounds = (session['dr'] as Map)?.keySet() as List
      render(template: 'combinedResult', model: [Rtest: r.result.Rtest as double[][],
                                                 testImages: (r.result.testImages as List<Image>)?.name,
                                                 compounds: compounds,
                                                 error:session['tr']==null||session['dr']==null])
  }

  /**
   * Action for Create New Classifier / Train Classifier - maps to /classify/trainClassifier.
   * Checks type of existing classifier, if any, and displays the trainClassifier view.
   * @return
   */
  def trainClassifier() {
    def dataset = Dataset.get(session['datasetID'])
    def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.token
    def svmsFileExists = new File(datasetDir + File.separator + 'svms.mat').exists()
    def classifierType = svmsFileExists ? classifyService.classifierType(datasetDir + File.separator + 'svms.mat') : ""
    render(view: 'trainClassifier', model: [dataset: dataset, subsets: dataset?.subsets, svmsFileExists: svmsFileExists, classifierType: classifierType])
  }

  /**
   * RESTful API call for creating a new classifier.
   * Validates the subset and classifier parameters, then pass them to ClassifyService instance
   * for classifier training. Renders the cross-validated training results.
   * @return
   */
  def trainSVM() {
    def subset = Subset.get(params.trainingID)
    def result = null
    def message
    if (!trainService.doneTraining(subset)) {
      message = 'Subset is not completely annotated.'
    } else if (params.classifier == 'Naive Bayes' && classifyService.distinctControls(subset).size() < 2) {
      message = 'Naive Bayes classifier requires training set using at least 2 controls.'
    } else {

        def clas = params.classifier
        def classifier = 0
          if (clas == 'SVM (RBF)') classifier = 0
          if (clas == 'SVM (linear)') classifier = 1
          if (clas == 'Naive Bayes')  classifier = 2
          if (clas == 'Random Forest') classifier = 3

        def parameters = [
                classifierName: clas as String,
                classifier: classifier as int,
                twoStage: params.twoStage as boolean,
                sigma: params.sigma as double,
                rbfKktLevel: params.rbfKktLevel as double,
                rbfTolKkt: params.rbfTolKkt as double,
                rbfBoxConstraint: params.rbfBoxConstraint as double,
                kktLevel: params.kktLevel as double,
                tolKKt: params.tolKkt as double,
                boxConstraint: params.boxConstraint as double,
                nTrees: params.nTrees as int
        ]

        def r = classifyService.trainOnly(params.datasetID,params.trainingID,parameters)
        result = r.result
        message = r.message
    }
    render(template: 'result',
           model: [cm: result?.cm as double[][],
                   Rtrain: result?.Rtrain as double[][],
                   trainImages: (result?.trainImages as List<Image>)?.name,
                   message: message])
  }

  /**
   * RESTful API call used to update the curves listed in the plot legends.
   * @return
   */
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

  def options() {
    render(template: 'options', model: [xdim:params.xdim])
  }

  /**
   * RESTful API call formats and retrieves stored results for QDREC internal use (plotting).
   * The data format, labels, etc. set below are specific to the Dygraphs JavaScript library.
   * @return
   */

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

  /**
   * Forms a CSV file from the classification results stored in the session,
   * and dumps the CSV to the output stream for client download.
   * @return
   */
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

  /**
   * RESTful API call to retrieve boolean training vector for a given subset.
   * Result is rendered as JSON (for e.g. AJAX calls).
   * @return
   */
  def trainingVec() {
    def training = Subset.get(params.subsetID)
    boolean[] G = classifyService.findTrainingVector(training)
    render G as JSON
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
                        [0.06, 31.0],
                        [0.0,	 23.0],
                        [0.04, 23.0],
                        [0.13, 31.0],
                        [0.2,  31.0],
                        [0.75, 24.0],
                        [0.65, 24.0],
                        [0.97, 30.0],
                        [0.89, 30.0],
                        [1.0,	 18.0],
                        [0.95, 18.0]]

    def testImages = ["072913-control-0-4-b",
                       "072913-niclosamide-0001-4-b",
                       "072913-niclosamide-001-4-b",
                       "072913-niclosamide-01-4-b",
                       "072913-niclosamide-1-4-b",
                       "072913-niclosamide-10-4-b",
                       "072913-control-0-4-a",
                       "072913-niclosamide-0001-4-a",
                       "072913-niclosamide-001-4-a",
                       "072913-niclosamide-01-4-a",
                       "072913-niclosamide-1-4-a",
                       "072913-niclosamide-10-4-a"]

    testImages = testImages.sort()

    session['result'] = [:]
    session['result'].testImages = Image.where({name in testImages && dataset==dataset1}).list()
//    session['result'].trainImages = Image.where({name in trainImages && dataset==dataset1}).list()
    session['result'].Rtest = Rtest
//    session['result'].Rtrain = Rtrain
//    session['result'].cm = cm

    session['dr'] = classifyService.doseResponse(Image.where({name in testImages && dataset==dataset1}).list(), Rtest)
    session['tr'] = classifyService.timeResponse(Image.where({name in testImages && dataset==dataset1}).list(), Rtest)

    def compounds = (session['dr'] as Map).keySet() as List

    render(view: 'testClassify',
                  model: [cm: null,
                          Rtrain: null,
                          Rtest: Rtest as double[][],
                          trainImages: null,
                          testImages: testImages as List,
                          dataset: dataset1,
                          subsets: dataset1.subsets,
                          compounds:compounds,
                          error:session['tr']==null||session['dr']==null])
  }

}
