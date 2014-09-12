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

import groovy.sql.Sql

/**
 * Service class providing service methods for annotating parasites via
 * the QDREC data annotation interface.
 */
class TrainService {
    // Objects for dependency injection via Spring.
    def dataSource

  /**
   * Searches the specified image for a parasite at the given X,Y coordinates
   * using the MySQL spatial index.
   * If the specified location lies within the bounding rectangles of multiple parasites,
   * the smallest parasite is selected. This ensures the user can always select every parasite
   * in an image, even if they are significantly overlapping.
   * @param imageID
   * @param parasiteX
   * @param parasiteY
   * @return
   */
    def findParasiteByLocation(String imageID, String parasiteX, String parasiteY) {
      Image image = Image.get(imageID)

      double x = Double.valueOf(parasiteX)
      double y = Double.valueOf(parasiteY)

      def scale = image.displayScale;
      def nativeWidth = image.width;
      def nativeHeight = image.height;
      // This formula includes the +1 for MATLAB indexing, and selects the
      // upper left pixel of the four possible pixels from the original scale.
      x = Math.min( Math.floor((x+0.5)/scale + 0.5), nativeWidth)
      y = Math.min( Math.floor((y+0.5)/scale + 0.5), nativeHeight)

      def db = new Sql(dataSource)

      def result = db.rows("SELECT id FROM parasite WHERE MBRContains(bounding_box, GeomFromText('Point(" + x +" " + y + ")')) AND parasite.image_id = :imageID",
                      [imageID: image.id])

      def parasites = Parasite.getAll(result*.id)
      def p = parasites.min { it.height * it.width }

      return dom2web(p, scale)

    }

  /**
   * Converts parasite domain objects to a simpler structure containing only
   * the fields needed at the web layer. Also adjusts the parasite coordinates
   * for display scale of the image.
   * @param p
   * @param scale
   * @return
   */
    def dom2web(Parasite p, double scale) {
      def parasite = [:]
      parasite.id = p.id
      parasite.imageID = p.imageId
      parasite.upperLeftX = Math.max(Math.floor((p.x-0.5) * scale), 0)
      parasite.upperLeftY = Math.max(Math.floor((p.y-0.5) * scale), 0)
      parasite.width = Math.round(p.width * scale)
      parasite.height = Math.round(p.height * scale)

      def pts = ParasiteTrainState.findByParasite(p)
      parasite.trainState = pts!=null ? pts.trainState : TrainState.NORMAL
      return parasite
    }

  /**
   * Saves the user's position within the specified subset, so that annotation / training
   * may be resumed conveniently.
   * @param subsetImage
   * @return
   */
    def saveCurrentSubsetPosition(SubsetImage subsetImage) {
      def subset = subsetImage.subset
      def spd = SubsetPosition.findBySubset(subset)
      if (spd==null) {
        spd = new SubsetPosition()
        spd.subset = subset
      }
      spd.subsetImage = subsetImage
      spd.save(flush: true)
    }

  /**
   * Saves annotation state for a collection of parasites.
   * @param parasites
   * @return
   */
    def saveCurrentImageState(parasites) {
      parasites.each { k,v ->
        def parasite = Parasite.get(v.id)
        def parasiteTrainState = ParasiteTrainState.findByParasite(parasite) ?: new ParasiteTrainState()
        parasiteTrainState.parasite = parasite
        parasiteTrainState.trainState = v.trainState
        parasiteTrainState.save(flush: true)
      }
    }

  /**
   * Toggles the annotation state of parasites in the 'web' format (see dom2web).
   * @param sessionParasites
   * @return
   */
    def toggleParasites(sessionParasites) {
      def parasites = []
      sessionParasites.each { k,v ->
        if ( sessionParasites[k].trainState == TrainState.NORMAL ) {
          sessionParasites[k].trainState = TrainState.DEGENERATE
        } else {
          sessionParasites[k].trainState = TrainState.NORMAL
        }
        parasites.add(v)
      }
      return parasites
    }

  /**
   * Resets the annotation state (to 'NORMAL') of parasites in the 'web' format (see dom2web).
   * @param sessionParasites
   * @return
   */
    def resetParasites(sessionParasites) {
      def parasites = []
      sessionParasites.each { k,v ->
        sessionParasites[k].trainState = TrainState.NORMAL
        parasites.add(v)
      }
      return parasites

    }

  /**
   * Determine if the specified subset has been completely annotated.
   * @param subset
   * @return
   */
    def doneTraining(Subset subset) {
      def trv = 0
      def np = 0
      subset.imageSubsets.image.each { i ->
        i.parasites.each { Parasite p ->
          np += 1
          def pts = ParasiteTrainState.findByParasite(p)
          if (pts!=null) trv+=1
        }
      }
      return trv == np
    }

}
