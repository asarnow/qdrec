import edu.sfsu.ntd.phenometrainer.Dataset

/**
 *
 * @author Daniel Asarnow 
 */

def bootStrapService = ctx.bootStrapService
def sessionFactory = ctx.sessionFactory

bootStrapService.initCompound()

Dataset dataset = bootStrapService.initDataset("118 statin images (Brian)")
bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/imagedb_4conor",dataset)

//  dataset = bootStrapService.initDataset("438 statin images (Lili)")
//  bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/lili438",dataset)

dataset = bootStrapService.initDataset("210 statin images (Lili)")
bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/lili210",dataset)

bootStrapService.assocControls()
sessionFactory.getCurrentSession().flush()

bootStrapService.initUsers()
bootStrapService.initParasite()

//Users.findById(1).lastImage = Image.findById(1)
