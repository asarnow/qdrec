import edu.sfsu.ntd.phenometrainer.Image
import edu.sfsu.ntd.phenometrainer.Role
import edu.sfsu.ntd.phenometrainer.SubsetImage
import edu.sfsu.ntd.phenometrainer.UserRole
import edu.sfsu.ntd.phenometrainer.Users

/**
 *
 * @author Daniel Asarnow 
 */
def bootStrapService = ctx.bootStrapService

  def initUsers() {
    def userRole = new Role(authority: 'ROLE_USER').save(flush: true)

    def lili = new Users(username:'lili', enabled: true, password: 'liliucsf', dateCreated: new Date(), lastImage: Image.get(1))
	lili.save(failOnError: true)
	UserRole.create lili, userRole, true

//    user = new Users(username:'train', enabled: true, password: 'train', dateCreated: new Date(), lastImage: Image.get(1))
//    user.save(failOnError: true)
//    UserRole.create user, userRole, true

    def schisto = new Users(username:'schisto', enabled: true, password: 'schisto', dateCreated: new Date(), lastImageSubset: SubsetImage.first())
    schisto.save(failOnError: true)
    UserRole.create schisto, userRole, true
  }