package edu.sfsu.ntd.phenometrainer

class ImageData {

  static belongsTo = [image: Image]

  byte[] stream

  static mapping = {
    stream sqlType: "longblob"
  }

  static constraints = {
    stream(maxSize: 3145728)
  }
}
