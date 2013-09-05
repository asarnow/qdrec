package edu.sfsu.ntd.phenometrainer

class Subset {

  static belongsTo = [dataset: Dataset]
  static hasMany = [imageSubsets: SubsetImage]
  List<SubsetImage> imageSubsets
  Integer size
  String description

  static constraints = {
  }

  static mapping = {
    imageSubsets indexColumn: [name: 'position', type: Integer]
  }

}
