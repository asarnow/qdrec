package edu.sfsu.ntd.phenometrainer

class Dataset {

  static hasMany = [images: Image]

  String description
  Integer size = 0

  static constraints = {
  }
}
