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
import com.mathworks.toolbox.javabuilder.MWArray
import com.mathworks.toolbox.javabuilder.MWCellArray
import com.mathworks.toolbox.javabuilder.MWCharArray
import com.mathworks.toolbox.javabuilder.MWException
import com.mathworks.toolbox.javabuilder.MWJavaObjectRef
import grails.util.Holders
import phenomj.PhenomJ

/**
 * Service class which provides service methods relating to classification.
 * This includes running the existing or user-defined classifier instances,
 * training new user-defined classifier instances, and calculating quantal
 * phenotypic response values based on classification results.
 */
class ClassifyService {
  // Objects for dependency injection via Spring.
  def grailsApplication = Holders.getGrailsApplication()

  /**
   * Uses the PhenomJ library to classify parasites from the specified subset
   * using the specified classifier, returning the classification results.
   * @param datasetID
   * @param testingID
   * @param useSVM
   * @return
   */
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

    def result = [:]
    def verdict
    try {
      PhenomJ phenomJ = new PhenomJ()

      Object[] R = phenomJ.classifyOnly(1,vids_cell,svmsFile,datasetDir)

      MWArray.disposeArray(vids_cell)

      result.Rtest = (double[][])((MWArray)(R[0])).toArray()
      result.testImages = vids

      R.each {MWArray.disposeArray(it)}
      verdict = "Classification completed successfully"
    } catch (MWException e) {
      log.error(e)
      verdict = "Error during classification"
    }

    return [result: result, message: verdict]
  }

  /**
   * Recovers the boolean training vector for parasites from a specified subset.
   * @param subset
   * @return
   */
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

  /**
   * Converts a Groovy or Java List object to a MATLAB cell array.
   * @param l
   * @return
   */
  def list2cell(List l) {
    MWCellArray cell = new MWCellArray(l.size(),1)
    for (int i=0;i<l.size();i++) {
      cell.set(i+1,new MWCharArray(l[i]))
    }
    return cell
  }

  /**
   * Groups the response values for images with the same compound, concentration and exposure time (in that order).
   * Averaging the grouped response values would create a dose-response curve.
   * @param vids List of N videos
   * @param R N x 2 matrix of response values (first column) and parasite counts (second column).
   * @return
   */
  def doseResponse(List<Image> vids, double[][] R) {
    def v = []
    vids.eachWithIndex { Image it, int i ->
      v.add([name:it.name, compound:it.compound?.name?:'control', conc:it.conc, day:it.day, r:R[i][0]])
    }
    def groups = v.groupBy([{it.compound}, {it.conc}, {it.day}])
    return groups
  }

  /**
   * Groups the response values for images with the same compound, exposure time and concentration (in that order).
   * Averaging the grouped response values would create a time-response curve.
   * @param vids List of N videos
   * @param R N x 2 matrix of response values (first column) and parasite counts (second column).
   * @return
   */
  def timeResponse(List<Image> vids, double[][] R) {
    def v = []
    vids.eachWithIndex { Image it, int i ->
      v.add([name:it.name, compound:it.compound?.name?:'control', conc:it.conc, day:it.day, r:R[i][0]])
    }
    def groups = v.groupBy([{it.compound}, {it.day}, {it.conc}])
    return groups
  }

  /**
   * Compute the mean of values in a Collection.
   * @param list
   * @return
   */
  def mean(list) {
    def mu = 0
    list.each(){mu+=it}
    mu /= list.size()
    return mu
  }

  /**
   * Compute the standard deviation of values in a Collection.
   * @param list
   * @return
   */
  def std(list) {
    def mu = mean(list)
    def sigma = 0
    list.each(){sigma+=(mu-it)**2}
    sigma /= list.size()
    sigma = Math.sqrt(sigma)
    return sigma
  }

  /**
   * Use the PhenomJ library to create a new classifier according to the specified parameters.
   * The classifier is saved to a MAT file 'svms.mat' in the project working directory.
   * Returns the cross-validated results produced during classifier training.
   * @param datasetID
   * @param trainingID
   * @param sigmaS
   * @param boxConstraint
   * @param classifierType
   * @return
   */
  def trainOnly(datasetID,trainingID, Map parameters) {
    def dataset = Dataset.get(datasetID)
    def training = Subset.get(trainingID)

    boolean[] G = findTrainingVector(training)

    def vids_train = training.imageSubsets.image
    def vids_train_cell = list2cell( vids_train.name )

    def datasetDir = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.token
    String svmsFile = datasetDir + File.separator + 'svms.mat'

    def verdict
    def result = [:]
    try {
      PhenomJ phenomJ = new PhenomJ();
      MWJavaObjectRef parametersRef = new MWJavaObjectRef(parameters)

      Object[] R = phenomJ.trainOnly(2,vids_train_cell,datasetDir,svmsFile,G,parametersRef)

      MWArray.disposeArray(parametersRef)
      MWArray.disposeArray(vids_train_cell)

      result.cm = (double[][])((MWArray)(R[0])).toArray()
          result.Rtrain = (double[][])((MWArray)(R[1])).toArray()
          result.trainImages = vids_train

      R.each {MWArray.disposeArray(it)}

      def classifier = classifierType(svmsFile)
      verdict = "Training of " + classifier + " completed successfully"
    } catch (MWException e) {
      log.error(e)
      verdict = "Error during training"
    }

    return [result: result, message: verdict]
  }

  /**
   * Returns the type of classifier stored in the specified QDREC classifier file.
   * @param svmsFile
   * @return
   */
  def classifierType(String svmsFile) {
    PhenomJ phenomJ = new PhenomJ()
    return phenomJ.classifierType(1,svmsFile)[0]
  }

  /**
   * Returns all of the unique control images within a subset.
   * @param subset
   * @return
   */
  def distinctControls(Subset subset) {
    return subset.imageSubsets.image.control as Set
  }

}
