import edu.sfsu.ntd.phenometrainer.Dataset
import edu.sfsu.ntd.phenometrainer.Image
import edu.sfsu.ntd.phenometrainer.Users

class BootStrap {

    def bootStrapService

    def init = { servletContext ->

      bootStrapService.initRole("ROLE_USER")
      bootStrapService.initRole("ROLE_ADMIN")

//      bootStrapService.initCompound()

//      Dataset dataset = bootStrapService.initDataset("118 statin images (Brian)")
//      bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/imagedb_4conor",dataset)

//      dataset = bootStrapService.initDataset("438 statin images (Lili)")
//      bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/lili438",dataset)

//      dataset = bootStrapService.initDataset("210 statin images (Lili)")
//      bootStrapService.initImage("/home/da/Documents/Segmentation/Schisto/Data/imagedb/lili210",dataset)

//      bootStrapService.initUsers()
//      bootStrapService.initParasite()

//      bootStrapService.initImagePos()

//      Users.findById(1).lastImage = Image.findById(1)
    }

    def destroy = {
    }
}
