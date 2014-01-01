package edu.sfsu.ntd.phenometrainer
import com.mathworks.toolbox.javabuilder.MWArray
import com.mathworks.toolbox.javabuilder.MWCellArray
import com.mathworks.toolbox.javabuilder.MWCharArray
import grails.util.Holders
import phenomj.PhenomJ

class ClassifyService {
  def grailsApplication = Holders.getGrailsApplication()

  def trainAndClassify(datasetID,testingID,trainingID,String sigmaS,String boxConstraint) {

    def dataset = Dataset.get(datasetID)
    def testing = Subset.get(testingID)
    def training = Subset.get(trainingID)
    double sigma = Double.valueOf(sigmaS)
    double C = Double.valueOf(boxConstraint)

    boolean[] G = findTrainingVector(training)

    def vids_test = testing.imageSubsets.image
    def vids_train = training.imageSubsets.image

    def vids_test_cell = list2cell( vids_test.name )
    def vids_train_cell = list2cell( vids_train.name )

    def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.token

    PhenomJ phenomJ = new PhenomJ();
    Object[] R = phenomJ.trainAndClassify(3,vids_train_cell,vids_test_cell,G,datasetDir,C,sigma)

    MWArray.disposeArray(vids_test_cell)
    MWArray.disposeArray(vids_train_cell)

    def result = [:]
    result.cm = (double[][])((MWArray)(R[0])).toArray()
    result.Rtest = (double[][])((MWArray)(R[1])).toArray()
    result.Rtrain = (double[][])((MWArray)(R[2])).toArray()
    result.testImages = vids_test
    result.trainImages = vids_train

    R.each {MWArray.disposeArray(it)}

    return result
  }

  def classifyOnly(datasetID,testingID,useSVM) {
    def dataset = Dataset.get(datasetID)
    def testing = Subset.get(testingID)
    def vids = testing.imageSubsets.image
    def vids_cell = list2cell( vids.name )
    def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.token
    def svmsFile

    if (useSVM=='new') {
      svmsFile = datasetDir + File.separator + 'svms.mat'
    } else {
      svmsFile = grailsApplication.config.PhenomeTrainer.svmsFile
    }

    PhenomJ phenomJ = new PhenomJ()

    Object[] R = phenomJ.classifyOnly(1,vids_cell,svmsFile,datasetDir)

    MWArray.disposeArray(vids_cell)

    def result = [:]
    result.Rtest = (double[][])((MWArray)(R[0])).toArray()
    result.testImages = vids

    R.each {MWArray.disposeArray(it)}

    return result
  }

  def findTrainingVector(Subset subset) {
    List<Boolean> trv = []
    subset.imageSubsets.image.sort{a,b->a.id<=>b.id}.each { i ->
      i.parasites.sort{a,b->a.id<=>b.id}.each { Parasite p ->
        def pts = ParasiteTrainState.findByParasite(p)
        trv.add(pts.trainState == TrainState.DEGENERATE)
      }
    }
    boolean[] trva = new boolean[trv.size()]
    trv.eachWithIndex { boolean entry, int i -> trva[i] = entry}
    return trva
  }

  def list2cell(List l) {
    MWCellArray cell = new MWCellArray(l.size(),1)
    for (int i=0;i<l.size();i++) {
      cell.set(i+1,new MWCharArray(l[i]))
    }
    return cell
  }

  def doseResponse(List<Image> vids, double[][] R) {
    def v = []
    vids.eachWithIndex { Image it, int i ->
      v.add([name:it.name, compound:it.compound?.name?:'control', conc:it.conc, day:it.day, r:R[i][0]])
    }
    def groups = v.groupBy([{it.compound}, {it.conc}, {it.day}])
    return groups
  }

  def timeResponse(List<Image> vids, double[][] R) {
    def v = []
    vids.eachWithIndex { Image it, int i ->
      v.add([name:it.name, compound:it.compound?.name?:'control', conc:it.conc, day:it.day, r:R[i][0]])
    }
    def groups = v.groupBy([{it.compound}, {it.day}, {it.conc}])
    return groups
  }

  def mean(list) {
    def mu = 0
    list.each(){mu+=it}
    mu /= list.size()
    return mu
  }

  def std(list) {
    def mu = mean(list)
    def sigma = 0
    list.each(){sigma+=(mu-it)**2}
    sigma /= list.size()
    sigma = Math.sqrt(sigma)
    return sigma
  }

  def trainOnly(datasetID,trainingID,String sigmaS,String boxConstraint) {
    def dataset = Dataset.get(datasetID)
    def training = Subset.get(trainingID)
    double sigma = Double.valueOf(sigmaS)
    double C = Double.valueOf(boxConstraint)

    boolean[] G = findTrainingVector(training)

    def vids_train = training.imageSubsets.image
    def vids_train_cell = list2cell( vids_train.name )

    def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.token
    String svmsFile = datasetDir + File.separator + 'svms.mat'

    PhenomJ phenomJ = new PhenomJ();
    Object[] R = phenomJ.trainOnly(2,vids_train_cell,G,datasetDir,C,sigma,svmsFile)

    MWArray.disposeArray(vids_train_cell)

    def result = [:]
    result.cm = (double[][])((MWArray)(R[0])).toArray()
    result.Rtrain = (double[][])((MWArray)(R[1])).toArray()
    result.trainImages = vids_train

    R.each {MWArray.disposeArray(it)}

    return result
  }
}
