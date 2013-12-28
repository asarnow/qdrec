package edu.sfsu.ntd.phenometrainer

class Parasite {

  static hasMany = [trainStates: ParasiteTrainState]
  static belongsTo = [image: Image]

//  List trainStates

  Integer region
//  Polygon boundingBox
  Integer x,y,width,height
  byte[] boundingBox


    static constraints = {
      boundingBox nullable: true
      image unique: 'region'
    }

/*    static mapping = {
      columns {
        boundingBox type: GeometryUserType, sqlType: "Geometry"
      }
    }*/

  def getBBString() {
    return "$x,$y,$width,$height".toString()
  }
}
