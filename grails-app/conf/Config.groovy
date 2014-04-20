// locations to search for config files that get merged into the main config;
// config files can be ConfigSlurper scripts, Java properties files, or classes
// in the classpath in ConfigSlurper format

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if (System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

grails.project.groupId = 'edu.sfsu.ntd' + appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [
    all:           '*/*',
    atom:          'application/atom+xml',
    css:           'text/css',
    csv:           'text/csv',
    form:          'application/x-www-form-urlencoded',
    html:          ['text/html','application/xhtml+xml'],
    js:            'text/javascript',
    json:          ['application/json', 'text/json'],
    multipartForm: 'multipart/form-data',
    rss:           'application/rss+xml',
    text:          'text/plain',
    xml:           ['text/xml', 'application/xml']
]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// What URL patterns should be processed by the resources plugin
grails.resources.adhoc.patterns = ['/images/*', '/css/*', '/js/*', '/plugins/*']

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// whether to disable processing of multi part requests
grails.web.disable.multipart=false

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// configure auto-caching of queries by default (if false you can cache individual queries with 'cache: true')
grails.hibernate.cache.queries = false

google.analytics.webPropertyID = 'UA-21010059-4'

environments {
    development {
        grails.logging.jul.usebridge = true
        grails.app.context = "/qdrec"
        PhenomeTrainer {
          dataDir = "/home/da/Documents/IDEAProjects/PhenomeTrainer/app-data"
          svmsFile = "/home/da/Documents/IDEAProjects/PhenomeTrainer/app-data/svms.mat"
        }

      // log4j configuration
      log4j = {
          // Example of changing the log pattern for the default console appender:
          //
          appenders {
          //    console name:'stdout', layout:pattern(conversionPattern: '%c{2} %m%n')
            rollingFile name: 'file', file:'/tmp/qdrec.log', maxFileSize: 50 * 2**20
          }
          root {
            info 'stout', 'file'
            additivity = true
          }

          error  'org.codehaus.groovy.grails.web.servlet',        // controllers
                 'org.codehaus.groovy.grails.web.pages',          // GSP
                 'org.codehaus.groovy.grails.web.sitemesh',       // layouts
                 'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
                 'org.codehaus.groovy.grails.web.mapping',        // URL mapping
                 'org.codehaus.groovy.grails.commons',            // core / classloading
                 'org.codehaus.groovy.grails.plugins',            // plugins
                 'org.codehaus.groovy.grails.orm.hibernate',      // hibernate integration
                 'org.springframework',
                 'org.hibernate',
                 'net.sf.ehcache.hibernate'

          info   'grails.app'
      }
    }
    production {
        grails.logging.jul.usebridge = false
//        grails.app.context = "/qdrec"
//        grails.serverURL = "http://haddock4.sfsu.edu"
//        grails.plugins.springsecurity.successHandler.defaultTargetUrl = "/qdrec"
//        grails.plugins.springsecurity.logout.afterLogoutUrl = "/qdrec"
        PhenomeTrainer {
          dataDir = "/home/dev/qdrec2-data"
          svmsFile = "/home/dev/qdrec2-data/svms.mat"
        }

        // log4j configuration
        log4j = {
            // Example of changing the log pattern for the default console appender:
            //
            appenders {
            //    console name:'stdout', layout:pattern(conversionPattern: '%c{2} %m%n')
              file name: 'file', file:'/home/dev/tomcat6/logs/qdrec2.log'
            }
            root {
              error 'file'
              additivity = true
            }

            error  'org.codehaus.groovy.grails.web.servlet',        // controllers
                   'org.codehaus.groovy.grails.web.pages',          // GSP
                   'org.codehaus.groovy.grails.web.sitemesh',       // layouts
                   'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
                   'org.codehaus.groovy.grails.web.mapping',        // URL mapping
                   'org.codehaus.groovy.grails.commons',            // core / classloading
                   'org.codehaus.groovy.grails.plugins',            // plugins
                   'org.codehaus.groovy.grails.orm.hibernate',      // hibernate integration
                   'org.springframework',
                   'org.hibernate',
                   'net.sf.ehcache.hibernate'

            info   'grails.app'
        }

    }
}

// Added by the Spring Security Core plugin:
//grails.plugins.springsecurity.userLookup.userDomainClassName = 'edu.sfsu.ntd.phenometrainer.Users'
//grails.plugins.springsecurity.userLookup.authorityJoinClassName = 'edu.sfsu.ntd.phenometrainer.UserRole'
//grails.plugins.springsecurity.authority.className = 'edu.sfsu.ntd.phenometrainer.Role'
/* Added by the Hibernate Spatial Plugin. */
/*grails.gorm.default.mapping = {
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.Geometry)
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.GeometryCollection)
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.LineString)
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.Point)
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.Polygon)
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.MultiLineString)
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.MultiPoint)
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.MultiPolygon)
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.LinearRing)
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.Puntal)
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.Lineal)
   'user-type'(type:org.hibernatespatial.GeometryUserType, class:com.vividsolutions.jts.geom.Polygonal)
}*/
