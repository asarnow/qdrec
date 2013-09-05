import edu.sfsu.ntd.phenometrainer.Dataset

/*
 * Copyright (c) 2013 Daniel Asarnow
 */

/**
 *
 * @author Daniel Asarnow 
 */

def bootStrapService = ctx.bootStrapService

Dataset dataset = bootStrapService.initDataset("118 statin images (Brian)")

//  dataset = bootStrapService.initDataset("438 statin images (Lili)")
//  bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/lili438",dataset)

//dataset = bootStrapService.initDataset("210 statin images (Lili)")
