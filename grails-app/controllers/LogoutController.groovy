import edu.sfsu.ntd.phenometrainer.Parasite
import edu.sfsu.ntd.phenometrainer.ParasiteTrainState
import edu.sfsu.ntd.phenometrainer.Users
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils

class LogoutController {
  def springSecurityService
	/**
	 * Index action. Redirects to the Spring security logout uri.
	 */
	def index = {

    def user = (Users)springSecurityService.getCurrentUser()

    session["parasites"].each { k,v ->
      def parasite = Parasite.findById(v.id)
      def parasiteTrainState = ParasiteTrainState.findByTrainerAndParasite(user,parasite)
      if (parasiteTrainState==null) parasiteTrainState = new ParasiteTrainState()
      parasiteTrainState.parasite = parasite
      parasiteTrainState.trainState = v.trainState
      parasiteTrainState.trainer = user
      parasiteTrainState.save(flush: true)
    }

		redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl // '/j_spring_security_logout'
	}
}
