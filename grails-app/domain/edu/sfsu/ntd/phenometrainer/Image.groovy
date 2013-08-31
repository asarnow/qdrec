package edu.sfsu.ntd.phenometrainer

class Image {

  static hasMany = [parasites: Parasite, imageData: ImageData]
//  static hasOne = [imageData: ImageData]
  static belongsTo = [dataset: Dataset]

//  List imageData
//  List parasites

  String name
  Date date
  Integer cdId
  double conc
  Integer day
  char series
  Image control
//  Integer position // list idx instead

  static constraints = {
    control nullable: true
//    position nullable: true
//    imageData unique: true
//    cdId nullable: true
  }
}
