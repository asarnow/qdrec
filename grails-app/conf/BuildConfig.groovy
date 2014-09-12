/*
 * Copyright (C) 2014
 * Daniel Asarnow
 * Rahul Singh
 * San Francisco State University
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

grails.servlet.version = "2.5"
// Change depending on target container compliance (2.5 or 3.0)
//grails.project.class.dir = "target/classes"
//grails.project.test.class.dir = "target/test-classes"
//grails.project.test.reports.dir = "target/test-reports"
grails.project.work.dir = "target"
grails.project.target.level = 1.6
grails.project.source.level = 1.6
//grails.project.war.file = "target/${appName}-${appVersion}.war"

// uncomment (and adjust settings) to fork the JVM to isolate classpaths
//grails.project.fork = [
//   run: [maxMemory:1024, minMemory:64, debug:false, maxPerm:256]
//]

grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // specify dependency exclusions here; for example, uncomment this to disable ehcache:
        // excludes 'ehcache'
    }
    log "error" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    checksums true // Whether to verify checksums on resolve
    legacyResolve false // whether to do a secondary resolve on plugin installation, not advised and here for backwards compatibility

    repositories {
        inherits true // Whether to inherit repository definitions from plugins

        grailsPlugins()
        grailsHome()
        grailsCentral()

        mavenLocal()
        mavenCentral()

        // uncomment these (or add new ones) to enable remote dependency resolution from public Maven repositories
        //mavenRepo "http://snapshots.repository.codehaus.org"
        //mavenRepo "http://repository.codehaus.org"
        //mavenRepo "http://download.java.net/maven/2/"
        //mavenRepo "http://repository.jboss.com/maven2/"
        mavenRepo "http://repo1.maven.org"
//        mavenRepo "http://repo.desirableobjects.co.uk/"

//        flatDir name: 'localRepo', dirs: 'lib'

    }

    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes e.g.

        provided 'mysql:mysql-connector-java:5.1.22'
//        runtime ':hibernate-spatial:1.1.1'
//        runtime ':hibernate-spatial-mysql:1.1.1'

        compile 'net.sf:opencsv:2.3'
        compile 'ar.com.hjg:pngj:2.0.1'
//        runtime ('localRepo:phenomj:1.0') {changing: true}

    }

    plugins {
        runtime ":hibernate:$grailsVersion"
        runtime ":jquery:1.8.3"
        runtime ":resources:1.1.6"
        compile ":jquery-ui:1.8.24"
        compile: ":jquery-validation:1.9"
//        compile ":spring-security-core:1.2.7.3"
//        runtime ":ajax-uploader:1.1"
        compile ":uploadr:latest.integration"
        // Uncomment these (or add new ones) to enable additional resources capabilities
        //runtime ":zipped-resources:1.0"
        //runtime ":cached-resources:1.0"
        //runtime ":yui-minify-resources:0.1.5"
        build ":tomcat:$grailsVersion"
        runtime ":database-migration:1.3.2"
        compile ':cache:1.0.1'
        compile ":google-analytics:2.1.1"
    }
}
