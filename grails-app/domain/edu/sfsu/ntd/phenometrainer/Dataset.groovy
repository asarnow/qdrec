package edu.sfsu.ntd.phenometrainer

class Dataset {

  static hasMany = [images: Image, subsets: Subset]
  List<Image> images
  List<Subset> subsets
  String description
  Integer size = 0

  static constraints = {
  }

  static mapping = {
    images indexColumn: [name: 'position', type: Integer]
  }

}
