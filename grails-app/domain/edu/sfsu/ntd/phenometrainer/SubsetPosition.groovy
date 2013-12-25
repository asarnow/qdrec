package edu.sfsu.ntd.phenometrainer

class SubsetPosition {

    static belongsTo = [subset:Subset, subsetImage: SubsetImage]

    static constraints = {
      subset unique: true
    }
}
