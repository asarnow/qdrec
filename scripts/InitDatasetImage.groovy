/*
 * Copyright (c) 2013 Daniel Asarnow
 */

import edu.sfsu.ntd.phenometrainer.Dataset

/**
 *
 * @author Daniel Asarnow 
 */
def bootStrapService = ctx.bootStrapService

// Dataset dataset = bootStrapService.initDataset("118 statin images (Brian)")
// bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/imagedb_4conor",dataset)

//  dataset = bootStrapService.initDataset("438 statin images (Lili)")
//  bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/lili438",dataset)

dataset = bootStrapService.initDataset("Lili's images")
bootStrapService.initImage("/home/dev/imagedb/lili",dataset)
