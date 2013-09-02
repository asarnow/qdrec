package edu.sfsu.ntd.phenometrainer

class SubsetImage {

  static belongsTo = [subset: Subset]
  Image image
  Integer position

  static constraints = {
  }

  static mapping = {
    position updateable: false, insertable: false
  }
}
