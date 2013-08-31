package edu.sfsu.ntd.phenometrainer

class ImageData {

  def ImageData(byte[] stream) {
    this.stream = stream
  }

  static belongsTo = [image: Image]

  byte[] stream

  static mapping = {
    stream sqlType: "longblob"
  }

  static constraints = {
    stream(maxSize: 3145728)
  }
}
