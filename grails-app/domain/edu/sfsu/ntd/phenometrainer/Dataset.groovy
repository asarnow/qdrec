package edu.sfsu.ntd.phenometrainer

class Dataset {

  static hasMany = [images: Image]

  List images

  String description
  Integer size = 0

  static constraints = {
  }
}
