import edu.sfsu.ntd.phenometrainer.Role
import edu.sfsu.ntd.phenometrainer.UserRole
import edu.sfsu.ntd.phenometrainer.Users

class BootStrap {

    def init = { servletContext ->
      def userRole = new Role(authority: 'ROLE_USER').save(flush: true)

      def user = new Users(username:'schisto', enabled: true, password: 'schisto', dateCreated: new Date())
      user.save(failOnError: true)
      UserRole.create user, userRole, true
    }
    def destroy = {
    }
}
