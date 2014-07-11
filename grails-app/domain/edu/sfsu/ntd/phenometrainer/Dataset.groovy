/*
 * Copyright (C) 2014 Daniel Asarnow
 * San Francisco State University
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package edu.sfsu.ntd.phenometrainer

class Dataset {

  static hasMany = [images: Image, subsets: Subset]
  List<Image> images
  List<Subset> subsets
  String description
  Integer size = 0
  Subset lastSubset
  String token
  Boolean visible

  static constraints = {
    description unique: true
    lastSubset nullable: true
  }

  static mapping = {
    images indexColumn: [name: 'position', type: Integer]
  }

}
