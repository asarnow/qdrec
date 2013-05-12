package edu.sfsu.ntd.phenometrainer
import groovy.sql.Sql

class TrainService {

    def dataSource
    def springSecurityService

    def findParasiteByLocation(String imageID, String parasiteX, String parasiteY) {

      Image image = Image.get(Integer.valueOf(imageID))

      double x = Double.valueOf(parasiteX)
      double y = Double.valueOf(parasiteY)

      def scale = 2.0;
      def nativeWidth = 1388;
      def nativeHeight = 1040;
      // This formula includes the +1 for MATLAB indexing, and selects the
      // upper left pixel of the four possible pixels from the original scale.
      x = Math.min( Math.floor((x+0.5)*scale + 0.5), nativeWidth)
      y = Math.min( Math.floor((y+0.5)*scale + 0.5), nativeHeight)

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

      return dom2web(p)

    }

    def dom2web(Parasite p) {

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
      parasite.upperLeftX = Math.max(Math.floor((p.x-0.5) / 2), 0)
      parasite.upperLeftY = Math.max(Math.floor((p.y-0.5) / 2), 0)
      parasite.width = Math.round(p.width / 2)
      parasite.height = Math.round(p.height / 2)

      def user = (Users)springSecurityService.getCurrentUser()
      def pts = ParasiteTrainState.findByParasiteAndTrainer(p,user)
      parasite.trainState = pts!=null ? pts.trainState : TrainState.NORMAL
      return parasite
    }

}
