package edu.sfsu.ntd.phenometrainer

class ParasiteTrainState {

  static hasOne = [parasite: Parasite, trainState: TrainState, trainer: Users]

  static constraints = {
  }
}
