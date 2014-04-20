package edu.sfsu.ntd.phenometrainer

class ParasiteTrainState {

//  static hasOne = [trainState: TrainState]
  static belongsTo = [parasite: Parasite]

  TrainState trainState
  Date lastUpdated

  static constraints = {
    parasite unique: true
  }
}
