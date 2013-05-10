package edu.sfsu.ntd.phenometrainer

class Image {

  static hasMany = [parasites: Parasite]

  Date date
  Integer cd_id
  double conc
  Integer day
  char series
  Image control

  static constraints = {
  }
}
