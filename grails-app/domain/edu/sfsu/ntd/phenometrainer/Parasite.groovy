package edu.sfsu.ntd.phenometrainer

class Parasite {

  static hasMany = [trainStates: ParasiteTrainState]
  static belongsTo = [image: Image]
//  Image image
  Integer region
//  Polygon boundingBox
  Integer x,y,width,height
  byte[] boundingBox


    static constraints = {
      boundingBox nullable: true
    }

/*    static mapping = {
      columns {
        boundingBox type: GeometryUserType, sqlType: "Geometry"
      }
    }*/
}
