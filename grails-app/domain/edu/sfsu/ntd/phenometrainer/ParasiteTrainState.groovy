package edu.sfsu.ntd.phenometrainer

class ParasiteTrainState {

//  static hasOne = [trainState: TrainState]
  static belongsTo = [parasite: Parasite, trainer: Users]

  TrainState trainState
  Date lastUpdated

  static constraints = {
  }
}
