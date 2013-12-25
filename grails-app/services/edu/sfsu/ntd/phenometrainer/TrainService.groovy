package edu.sfsu.ntd.phenometrainer

import groovy.sql.Sql

class TrainService {

    def dataSource

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

    /*def findAllUserSubsetTrainStates(userID, subsetID) {
      def user = Users.get(userID)
      def subset = Subset.get(subsetID)
      def lines = []
      subset.imageSubsets.image.sort{a,b -> a.id <=> b.id}.each { i ->
        i.parasites.sort{a,b -> a.id<=>b.id}.each { Parasite p ->
          def pts = ParasiteTrainState.findByParasiteAndTrainer(p,user)
          lines.add(i.id.toString() + "," + i.name.toUpperCase() + "," + i.control.id.toString() + "," +
                  p.id.toString() + "," + p.region.toString() + "," + p.getBBString() + "," + pts.trainState.toString())
        }
      }
      return lines
    }*/

    /*def findAllUserTrainStates(userId) {

      def images = Image.findAll()

      def user = Users.get(userId)

      def lines = []

      images.each { i ->
        i.parasites.each { Parasite p ->
          def pts = ParasiteTrainState.findByParasiteAndTrainer(p,user)
          lines.add(i.id.toString() + "," + i.name.toUpperCase() + "," + i.control.id.toString() + "," +
                  p.id.toString() + "," + p.region.toString() + "," + p.getBBString() + "," + pts.trainState.toString())
        }
      }
      return lines
    }*/

    def saveCurrentSubsetPosition(SubsetImage subsetImage) {
      def subset = subsetImage.subset
      def spd = SubsetPosition.findBySubset(subset)
      if (~spd) {
        spd = new SubsetPosition()
        spd.subset = subset
      }
      spd.subsetImage = subsetImage
      spd.save(flush: true)
    }

    def saveCurrentImageState(parasites) {
      parasites.each { k,v ->
        def parasite = Parasite.get(v.id)
        def parasiteTrainState = ParasiteTrainState.findByParasite(parasite) ?: new ParasiteTrainState()
        parasiteTrainState.parasite = parasite
        parasiteTrainState.trainState = v.trainState
        parasiteTrainState.save(flush: true)
      }
    }

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

    def resetParasites(sessionParasites) {
      def parasites = []
      sessionParasites.each { k,v ->
        sessionParasites[k].trainState = TrainState.NORMAL
        parasites.add(v)
      }
      return parasites

    }

}
