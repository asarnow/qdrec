package edu.sfsu.ntd.phenometrainer

import grails.test.mixin.TestFor
/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
@TestFor(BootStrapService)
class BootStrapServiceTests {

    def bootStrapService

    void testSomething() {
      bootStrapService.initImage()
    }
}
