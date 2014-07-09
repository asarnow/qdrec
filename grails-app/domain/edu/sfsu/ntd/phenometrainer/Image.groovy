/*
 * Copyright (C) 2014 Daniel Asarnow
 * San Francisco State University
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package edu.sfsu.ntd.phenometrainer

class Image {

  static hasMany = [parasites: Parasite, imageData: ImageData]
//  static hasOne = [imageData: ImageData]
  static belongsTo = [dataset: Dataset]

//  List imageData
//  List parasites

//  Dataset dataset

  String name
  Integer width
  Integer height
  double displayScale
  Date date
  Compound compound
  double conc
  Integer day
  char series
  Image control
  Integer position
  boolean segmented = false

  static constraints = {
    control nullable: true
    dataset unique: 'name'
    compound nullable: true
//    position nullable: true
//    imageData unique: true
//    cdId nullable: true
  }

  static mapping = {
    position updateable: false, insertable: false
    parasites cascade: "all-delete-orphan"
  }

}
