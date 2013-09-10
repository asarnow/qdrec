/*
 * Copyright (c) 2013 Daniel Asarnow
 */

import edu.sfsu.ntd.phenometrainer.Dataset

/**
 *
 * @author Daniel Asarnow 
 */
def bootStrapService = ctx.bootStrapService

//Dataset dataset = Dataset.get(1)
//bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/imagedb_4conor",dataset)

//  dataset = bootStrapService.initDataset("438 statin images (Lili)")
//  bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/lili438",dataset)

//dataset = bootStrapService.initDataset("210 statin images (Lili)")
def dataset = Dataset.get(2)
bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/lili210",dataset)