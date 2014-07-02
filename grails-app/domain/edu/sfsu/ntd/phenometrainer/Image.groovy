package edu.sfsu.ntd.phenometrainer

class Image {

  static hasMany = [parasites: Parasite, imageData: ImageData]
//  static hasOne = [imageData: ImageData]
  static belongsTo = [dataset: Dataset]

//  List imageData
//  List parasites

//  Dataset dataset

  String name
  Integer width
  Integer height
  double displayScale
  Date date
  Compound compound
  double conc
  Integer day
  char series
  Image control
  Integer position
  boolean segmented = false

  static constraints = {
    control nullable: true
    dataset unique: 'name'
    compound nullable: true
//    position nullable: true
//    imageData unique: true
//    cdId nullable: true
  }

  static mapping = {
    position updateable: false, insertable: false
    parasites cascade: "all-delete-orphan"
  }

}
