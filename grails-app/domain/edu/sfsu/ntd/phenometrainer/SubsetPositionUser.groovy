package edu.sfsu.ntd.phenometrainer

class SubsetPositionUser {

    static belongsTo = [user: Users, subset:Subset, subsetImage: SubsetImage]

    static constraints = {
    }
}
