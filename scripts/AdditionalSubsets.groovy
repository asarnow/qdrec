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

import edu.sfsu.ntd.phenometrainer.Dataset
import edu.sfsu.ntd.phenometrainer.Image
import edu.sfsu.ntd.phenometrainer.Subset
import edu.sfsu.ntd.phenometrainer.SubsetImage

/**
 *
 * @author Daniel Asarnow
 */

def ds = Dataset.get(5)
def subset = new Subset()
ds.addToSubsets(subset)

subset.description = "Day 2-3, 0.01-10 \u00B5M, Series A"

Image.where {
  dataset == ds && (day == 2 || day == 3) && conc > 0.001 && (series == '1' || series == 'a')
}.findAll().each {
  def subsetImage = new SubsetImage()
  subset.addToImageSubsets(subsetImage)
  subsetImage.image = it
}

subset.size = subset.imageSubsets.size()

ds.save()