package edu.sfsu.ntd.phenometrainer

class Image {

  static hasMany = [parasites: Parasite]
  static hasOne = [imageData: ImageData]
  static belongsTo = [dataset: Dataset]

  String name
  Date date
  Integer cdId
  double conc
  Integer day
  char series
  Image control
  Integer position

  static constraints = {
    control nullable: true
    position nullable: true
//    cdId nullable: true
  }
}
