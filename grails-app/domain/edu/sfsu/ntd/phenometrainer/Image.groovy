package edu.sfsu.ntd.phenometrainer

class Image {

  static hasMany = [parasites: Parasite]
  static hasOne = [imageData: ImageData]

  String name
  Date date
  Integer cdId
  double conc
  Integer day
  char series
  Image control

  static constraints = {
    control nullable: true
//    cdId nullable: true
  }
}
