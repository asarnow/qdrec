package edu.sfsu.ntd.phenometrainer
import groovy.sql.Sql

class TrainService {

    def dataSource
    def springSecurityService

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

//      Coordinate coordinate = new Coordinate(x,y)
//      Point point = new GeometryFactory().createPoint(coordinate)

//      def results = Parasite.executeQuery(
//              "select p from Parasite p where p.image = :image and mbrcontains(:loc, boundingBox) = true",
//              [image: image, loc: point])

//      def queryString = "SELECT id FROM parasite WHERE parasite.image_id = ${image.id} AND " +
//                    "MBRContains(bounding_box, GeomFromText('Point(" + "${x} ${y}" + ")'))=1"

      def db = new Sql(dataSource)
/*      Connection conn = db.getConnection()
      PreparedStatement preparedStatement = conn.prepareStatement("SELECT id FROM parasite WHERE parasite.image_id = ? AND " +
                                "MBRContains(bounding_box, GeomFromText('Point(? ?)'))=1")
      preparedStatement.setLong(1,image.id)
      preparedStatement.setDouble(2,x)
      preparedStatement.setDouble(2,y)
      def rs = preparedStatement.getResultSet()
      def id = rs.getInt(1)*/

      def result = db.firstRow("SELECT id FROM parasite WHERE MBRContains(bounding_box, GeomFromText('Point(" + x +" " + y + ")')) AND parasite.image_id = :imageID",
                      [imageID: image.id])

//      def result = db.firstRow(queryString)
      def id = result.id

      def p = Parasite.get(id)

      return dom2web(p, scale)

    }

    def dom2web(Parasite p, double scale) {

//      def db = new Sql(dataSource)
//      def result = db.firstRow("SELECT asText(bounding_box) FROM parasite WHERE parasite.id = ${p.id}")
//      String bb = result.boundingBox

//      List<String[]> points = [];
//       for (String pt : bb.substring(9,bb.length()-2).split(",")) {
//         points.add( pt.split(" ") )
//       }

//       def upperLeftX = Double.valueOf(points[0][0]) - 1 // 1-based MATLAB index
//       def upperLeftY = Double.valueOf(points[0][1]) - 1
//       def width = Double.valueOf(points[1][0]) - Double.valueOf(points[0][0])
//       def height = Double.valueOf(points[2][1]) - Double.valueOf(points[0][1])



      def parasite = [:]
      parasite.id = p.id
      parasite.imageID = p.imageId
//      def coords = p.boundingBox.getCoordinates()
//      assert coords.size() == 4
//      coords.sort()
      parasite.upperLeftX = Math.max(Math.floor((p.x-0.5) * scale), 0)
      parasite.upperLeftY = Math.max(Math.floor((p.y-0.5) * scale), 0)
      parasite.width = Math.round(p.width * scale)
      parasite.height = Math.round(p.height * scale)

      def user = (Users)springSecurityService.getCurrentUser()
      def pts = ParasiteTrainState.findByParasiteAndTrainer(p,user)
      parasite.trainState = pts!=null ? pts.trainState : TrainState.NORMAL
      return parasite
    }

    def findAllUserSubsetTrainStates(userID, subsetID) {
      def user = Users.get(userID)
      def subset = Subset.get(subsetID)
      def lines = []
      subset.imageSubsets.image.each { i ->
        i.parasites.each { Parasite p ->
          def pts = ParasiteTrainState.findByParasiteAndTrainer(p,user)
          lines.add(i.id.toString() + "," + i.name.toUpperCase() + "," + i.control.id.toString() + "," +
                  p.id.toString() + "," + p.region.toString() + "," + pts.trainState.toString())
        }
      }
      return lines
    }

    def findAllUserTrainStates(userId) {

      def images = Image.findAll()

      def user = Users.get(userId)

      def lines = []

      images.each { i ->
        i.parasites.each { Parasite p ->
          def pts = ParasiteTrainState.findByParasiteAndTrainer(p,user)
          lines.add(i.id.toString() + "," + i.name.toUpperCase() + "," + i.control.id.toString() + "," +
                  p.id.toString() + "," + p.region.toString() + "," + pts.trainState.toString())
        }
      }
      return lines
    }

    def determineLastImageForSubset(Subset subset) {
      def user = (Users)springSecurityService.getCurrentUser()
      def trainStates = ParasiteTrainState.findAll(max: 1, sort: "lastUpdated", order: "desc") {
        trainer == user && subset.imageSubsets.image.contains(parasite.image)
      }
      def latestImage = trainStates[0].parasite.image ?: subset.imageSubsets[0].image
      return SubsetImage.findBySubsetAndImage(subset,latestImage)
    }

    def saveCurrentImageState(parasites) {
      def user = (Users)springSecurityService.getCurrentUser()
      parasites.each { k,v ->
        def parasite = Parasite.get(v.id)
        def parasiteTrainState = ParasiteTrainState.findByTrainerAndParasite(user,parasite) ?: new ParasiteTrainState()
        parasiteTrainState.parasite = parasite
        parasiteTrainState.trainState = v.trainState
        parasiteTrainState.trainer = user
        parasiteTrainState.save(flush: true)
      }
    }

}
