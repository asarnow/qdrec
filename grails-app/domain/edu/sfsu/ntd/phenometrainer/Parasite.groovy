package edu.sfsu.ntd.phenometrainer

import com.vividsolutions.jts.geom.Polygon
import org.hibernatespatial.GeometryUserType

class Parasite {

  static hasMany = [trainStates: ParasiteTrainState]

  Image image
  Integer region
  Polygon boundingBox



    static constraints = {
    }

    static mapping = {
      columns {
        boundingBox type: GeometryUserType, sqlType: "Geometry"
      }
    }
}
