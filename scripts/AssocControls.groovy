
/**
 *
 * @author Daniel Asarnow 
 */
def bootStrapService = ctx.bootStrapService
def sessionFactory = ctx.sessionFactory
bootStrapService.assocControls()
def hibSession = sessionFactory.getCurrentSession()
assert hibSession != null
hibSession.flush()