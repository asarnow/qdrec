import edu.sfsu.ntd.phenometrainer.Image
import edu.sfsu.ntd.phenometrainer.Users

class BootStrap {

    def bootStrapService

    def init = { servletContext ->
//      bootStrapService.initCompound()
//      bootStrapService.initImage()
//      bootStrapService.initUsers()
//      bootStrapService.initParasite()

      Users.findById(1).lastImage = Image.findById(1)
    }

    def destroy = {
    }
}
