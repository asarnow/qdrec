package edu.sfsu.ntd.phenometrainer

class Dataset {

  static hasMany = [images: Image, subsets: Subset]
  List<Image> images
  List<Subset> subsets
  String description
  Integer size = 0
  Subset lastSubset
  String token
  Boolean visible

  static constraints = {
    description unique: true
    lastSubset nullable: true
  }

  static mapping = {
    images indexColumn: [name: 'position', type: Integer]
  }

}
