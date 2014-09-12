/*
 * Copyright (C) 2014
 * Daniel Asarnow
 * Rahul Singh
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
import grails.converters.JSON
import grails.util.Holders

import java.nio.file.Files

/**
 * Handles actions related to project creation and subset definition.
 */
class ProjectController {
  // Objects for dependency injection via Spring.
  def adminService
  def grailsApplication = Holders.getGrailsApplication()
  def trainService

  /**
   * Main action for Create Project - maps to /project or /project/index.
   * If no project loaded, prepares a new project working directory in the system temp directory,
   * otherwise displays project selection form and information on loaded project.
   * Create Project / Create Project and Create Project / Load Project force the creation and
   * loading forms to be displayed, respectively.
   * Also nulls out the uploadr plugin to avoid file conflicts.
   * @return
   */
  def index() {
    trainService.saveCurrentImageState(session["parasites"])
    if (params.load=='true') {
      def dataset = Dataset.get(session['datasetID'])
      render(view: 'upload', model: [message: params.message, dataset: dataset])
    } else {
      def datasetDir = Files.createTempDirectory('qdrec').toFile().path
      def imgDir = datasetDir + File.separator + 'img'
      def segDir = datasetDir + File.separator + 'bw'
      session['uploadr'] = null
      render(view: 'upload', model: [datasetDir: datasetDir, imgDir: imgDir, segDir: segDir, message: params.message])
    }
  }

  /**
   * RESTful API call to create a new project.
   * Uses AdminService instance to validate the dataset and then initialize it
   * by segmenting images and registering parasites in the database.
   * Returns a failure message if project creation is unsuccessful.
   * @return
   */
  def createDataset() {
    def verdict = adminService.validateDataset(params.datasetName, params.datasetDir, params.visible, params.segmentation)
    if (verdict==null) {
      def dataset = adminService.initDataset(params.datasetName, params.datasetDir, params.visible, params.segmentation)
      session['datasetID'] = dataset.id
      session['result'] = null // Clear any classification results still in session
      /*if (params.segmentation=='Upload') {
        redirect(controller: 'project', action: 'define')
      } else {
        redirect(controller: 'project', action: 'review')
      }*/
      render createLink(action: 'index', params: [load:true])
    } else {
      render verdict
    }
  }

  /**
   * RESTful API call to load a project (selected from the drop-down menu or by identifier token).
   * The selected project's ID is stored in the session.
   * @return
   */
  def load() {
    def dataset = Dataset.findByToken(params.token) ?: Dataset.get(params.datasetID)
    if (dataset==null) {
      redirect(action: 'index', params: [load: 'true', message: "Incorrect project or no project selected."])
    } else {
      session['datasetID'] = dataset?.id
      session['result'] = null // Clear any classification results still in session
      redirect(action: 'index', params: [load: 'true', dataset: dataset])
    }
  }

  /**
   * Action for Define Subsets - maps to /project/define.
   * Redirects if no project is loaded and ensures in-progress annotation is saved.
   * @return
   */
  def define() {
    trainService.saveCurrentImageState(session["parasites"])
    def dataset = Dataset.get(session['datasetID'])
    if (!dataset) {
      redirect(view: 'upload', params: [message: "Incorrect project or no project selected."])
    } else {
      render(view: 'define', model: [dataset: dataset])
    }
  }

/*  def project() {
    if (params.load=='true') {
      def dataset = Dataset.get(session['datasetID'])
      render(view: 'upload', model: [message: params.message, dataset: dataset])
    } else {
      def datasetDir = Files.createTempDirectory('qdrec').toAbsolutePath().toString()
      render(view: 'upload', model: [datasetDir: datasetDir, message: params.message])
    }
  }*/

  /**
   * RESTful API call determines the identifier token for a project.
   * @return
   */
  def datasetInfo() {
    render Dataset.get(params.datasetID)?.token
  }

  /**
   * Renders the dataset template (part of subset definition interface).
   * @return
   */
  def dataset() {
    render(template: 'dataset', model: [dataset: Dataset.get(params.datasetID)])
  }

  /**
   * RESTful API call to define a new subset based on selections in subset definition interface.
   * If all needed controls are not selected, they will be added automatically, and the user notified.
   * If controls cannot be identified automatically, the user will be asked to specify them manually.
   * @return
   */
  def createSubset() {
    def output = adminService.defineSubset(params.subsetName, params.datasetID, params.imageList)
    def nocontrol = output.nocontrol as List<Image>
    def message = output.message
    render(template: 'dataset', model: [dataset: Dataset.get(params.datasetID), nocontrol: nocontrol, message: message])
  }

  /**
   * RESTful API call to list the images in a subset.
   * @return
   */
  def imageList() {
    def subset = Subset.get(params.subsetID)
    render( template: 'imageList', model: [dataset:subset.dataset, imageIDs:subset.imageSubsets.image.id])
  }

  /**
   * Action for Create Project / Review Segmentation.
   * Redirects if no project loaded.
   * Renders the view for reviewing image segmentation conducted during project creation.
   * @return
   */
  def review() {
    def dataset = Dataset.get(session['datasetID'])
    if (!dataset) {
      if (params.load=='true') {
        redirect(action: 'index', params: [message: "Incorrect project or no project selected.", load:'true'])
      } else {
        redirect(action: 'index', params: [message: "Incorrect project or no project selected."])
      }
    } else {

      def image = dataset.images.first()
      session["parasites"] = [:]
      image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it,image.displayScale)}
      def parasites = []
      session["parasites"].each {k,v -> parasites.add(v) }

      render( view: 'review', model: [dataset: dataset,
                                      image: image,
                                      parasites: parasites as JSON] )
    }
  }

  /**
   * RESTful API call to advance to next image during segmentation review.
   * @return
   */
  def nextImage() {
    def image = Image.get(params.imageID)
    def idx = image.position
    idx = idx==image.dataset.size-1 ? 0 : idx+1
    def nextImage = Image.findByDatasetAndPosition(image.dataset, idx)
    forward(action: 'selectImage', params: [switchTo: nextImage.id])
  }

  /**
   * RESTful API call to return to previous image during segmentation review.
   * @return
   */
  def prevImage() {
    def image = Image.get(params.imageID)
    def idx = image.position
    idx = idx==0 ? image.dataset.size-1 : idx-1
    def prevImage = Image.findByDatasetAndPosition(image.dataset, idx)
    forward(action: 'selectImage', params: [switchTo: prevImage.id])
  }

  /**
   * RESTful API call used internally to switch the image displayed during segmentation review.
   * Renders the view corresponding to the segmentation review interface.
   * @return
   */
  def selectImage() {
    def image = Image.get(params.switchTo)
    session["parasites"] = null
    session["parasites"] = [:]
    image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it,image.displayScale)}
    def parasites = []
    session["parasites"].each {k,v -> parasites.add(v) }

    render(template: 'reviewUI', model: [dataset: image.dataset,
                                         image: image,
                                         parasites: parasites as JSON])
  }

  /**
   * RESTful API call returning byte stream for a specified image.
   */
  def image() {
    def image = Image.get(params.imageID)
    def imagef
    if (params.segmented=='true') {
      imagef = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + image.dataset.token + File.separator + 'bw' + File.separator + image.name + '.png'
    } else {
      imagef = grailsApplication.config.PhenomeTrainer.dataDir + File.separator + image.dataset.token + File.separator + 'img' + File.separator + image.name + '.png'
    }
    def stream = new BufferedInputStream(new FileInputStream(imagef)).getBytes()
    response.contentLength = stream.length
    response.contentType = 'image/png'
    response.outputStream << stream
    response.outputStream.flush()
  }

  /**
   * RESTful API call returning list of all images associated with a project.
   * @return
   */
  def allimages() {
    def dataset = Dataset.get(session['datasetID'])
    render dataset.images as JSON
  }

  /**
   * RESTful API call used to manually specify control images during subset definition.
   * Only used if user attempts to define a subset without identifiable controls.
   * @return
   */
  def addcontrol() {
    def image = Image.get(params.imageID)
    def control = Image.get(params.controlID)
    image.control = control
    image.save(flush:true)
    render ''
  }

  /**
   * RESTful API call for re-segmentation of project images.
   * @return
   */
  def resegment() {
    def dataset = Dataset.get(session['datasetID'])
        if (!dataset) {
          if (params.load=='true') {
            redirect(action: 'index', params: [message: "Incorrect project or no project selected.", load:'true'])
          } else {
            redirect(action: 'index', params: [message: "Incorrect project or no project selected."])
          }
        } else {

          def seg = params.segmentation
              def segmentation = 1
              if (seg.startsWith('Asa')) segmentation = 1
              if (seg.startsWith('Can')) segmentation = 2
              if (seg.startsWith('Wat')) segmentation = 3

              def segmentationParams = [
                      segmentation: segmentation as Integer,
                      nscale: params.nscale as Integer,
                      minwl: params.minwl as Integer,
                      mult: params.mult as Double,
                      sigma: params.sigma as Double,
                      noise: params.noise as Double,
                      sigmaCanny: params.sigmaCanny as Double,
                      lowCanny: params.lowCanny as Double,
                      highCanny: params.highCanny as Double,
                      hmin: params.hmin as Integer,
                      lighting: params.lighting as Integer,
                      minSize: params.minSize as Integer,
                      maxBorder: params.maxBorder as Integer
              ]

          def verdict = adminService.resegmentProject(dataset,segmentationParams)

          def image = dataset.images.first()
          session["parasites"] = [:]
          image.parasites.each {it -> session["parasites"][it.id] = trainService.dom2web(it,image.displayScale)}
          def parasites = []
          session["parasites"].each {k,v -> parasites.add(v) }

          render( template: 'reviewUI', model: [dataset: dataset,
                                          image: image,
                                          message: verdict,
                                          parasites: parasites as JSON] )
        }
  }

}
