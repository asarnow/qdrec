import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils

class LogoutController {
//  def springSecurityService
  def trainService
	/**
	 * Index action. Redirects to the Spring security logout uri.
	 */
	def index = {

    trainService.saveCurrentImageState(session["parasites"])

		redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl // '/j_spring_security_logout'
	}
}
