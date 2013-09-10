import edu.sfsu.ntd.phenometrainer.Dataset
import edu.sfsu.ntd.phenometrainer.Image
import edu.sfsu.ntd.phenometrainer.Subset
import edu.sfsu.ntd.phenometrainer.SubsetImage

/*
 * Copyright (c) 2013 Daniel Asarnow
 */

/**
 *
 * @author Daniel Asarnow 
 */

def ds = Dataset.get(5)
def subset = new Subset()
ds.addToSubsets(subset)

subset.description = "Day 2-3, 0.01-10 \u03BCM, Series A"

Image.where {
  dataset == ds && (day == 2 || day == 3) && conc > 0.001 && (series == '1' || series == 'a')
}.findAll().each {
  def subsetImage = new SubsetImage()
  subset.addToImageSubsets(subsetImage)
  subsetImage.image = it
}

subset.size = subset.imageSubsets.size()

ds.save()