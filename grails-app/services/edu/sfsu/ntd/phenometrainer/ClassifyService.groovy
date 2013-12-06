package edu.sfsu.ntd.phenometrainer
import com.mathworks.toolbox.javabuilder.MWArray
import com.mathworks.toolbox.javabuilder.MWCellArray
import com.mathworks.toolbox.javabuilder.MWCharArray
import phenomj.PhenomJ

class ClassifyService {
  def grailsApplication

  def trainAndClassify(datasetID,user,testingID,trainingID,String sigmaS,String boxConstraint) {

    def dataset = Dataset.get(datasetID)
    def testing = Subset.get(testingID)
    def training = Subset.get(trainingID)
    double sigma = Double.valueOf(sigmaS)
    double C = Double.valueOf(boxConstraint)

    boolean[] G = findTrainingVector(user,training)

    def vids_test = testing.imageSubsets.image.name
    def vids_train = training.imageSubsets.image.name

    def vids_test_cell = list2cell( vids_test )
    def vids_train_cell = list2cell( vids_train )

    def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.id

    PhenomJ phenomJ = new PhenomJ();
    Object[] R = phenomJ.trainAndClassify(3,vids_train_cell,vids_test_cell,G,datasetDir,C,sigma)

    MWArray.disposeArray(vids_test_cell)
    MWArray.disposeArray(vids_train_cell)

    def results = [:]
    results.cm = (double[][])((MWArray)(R[0])).toArray()
    results.Rtest = (double[][])((MWArray)(R[1])).toArray()
    results.Rtrain = (double[][])((MWArray)(R[2])).toArray()
    results.testImages = vids_test
    results.trainImages = vids_train

    R.each {MWArray.disposeArray(it)}

    return results
  }

  def classifyOnly(datasetID,testingID) {
    def dataset = Dataset.get(datasetID)
    def testing = Subset.get(testingID)
    def vids = testing.imageSubsets.image.name
    def vids_cell = list2cell( vids )
    def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.id
    def svmsFile = grailsApplication.config.PhenomeTrainer.svmsFile

    PhenomJ phenomJ = new PhenomJ()

    Object[] R = phenomJ.classifyOnly(1,vids_cell,svmsFile,datasetDir)

    MWArray.disposeArray(vids_cell)

    def result = [:]
    result.Rtest = (double[][])((MWArray)(R[0])).toArray()
    result.testImages = vids

    R.each {MWArray.disposeArray(it)}

    return result
  }

  def findTrainingVector(Users user,Subset subset) {
    List<Boolean> trv = []
    subset.imageSubsets.image.sort{a,b->a.id<=>b.id}.each { i ->
      i.parasites.sort{a,b->a.id<=>b.id}.each { Parasite p ->
        def pts = ParasiteTrainState.findByParasiteAndTrainer(p,user)
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

}
