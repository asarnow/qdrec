package edu.sfsu.ntd.phenometrainer

class Image {

  static hasMany = [parasites: Parasite, imageData: ImageData]
//  static hasOne = [imageData: ImageData]
  static belongsTo = [dataset: Dataset]

//  List imageData
//  List parasites

  String name
  Integer width
  Integer height
  double displayScale
  Date date
  Integer cdId
  double conc
  Integer day
  char series
  Image control
  Integer position

  static constraints = {
    control nullable: true
//    position nullable: true
//    imageData unique: true
//    cdId nullable: true
  }

  static mapping = {
    position updateable: false, insertable: false
  }

}
