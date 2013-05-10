package edu.sfsu.ntdphenometrainer
import com.vividsolutions.jts.geom.Coordinate
import com.vividsolutions.jts.geom.GeometryFactory
import com.vividsolutions.jts.geom.Point
import edu.sfsu.ntd.phenometrainer.Image
import edu.sfsu.ntd.phenometrainer.Parasite

class TrainService {

    def findParasiteByLocation(String imageID, String parasiteX, String parasiteY) {

      Image image = Image.get(Integer.valueOf(imageID))

      double x = Double.valueOf(parasiteX)
      double y = Double.valueOf(parasiteY)

      Coordinate coordinate = new Coordinate(x,y)
      Point point = new GeometryFactory().createPoint(coordinate)

      def results = Parasite.executeQuery(
              "select p from Parasite p where p.image = :image and mbrcontains(:loc, boundingBox) = true",
              [image: image, loc: point])

      assert results.size() == 1 || results.size() == 0

      if (results.size() == 1) {
        return results.get(0)
      } else {
        return null
      }

    }
}
