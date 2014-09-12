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

package edu.sfsu.ntd.phenometrainer
import ar.com.hjg.pngj.PngReader
import au.com.bytecode.opencsv.CSVReader
import groovy.sql.Sql
import org.codehaus.groovy.grails.plugins.DomainClassGrailsPlugin

/**
 * The BootStrapService is suitable for calling initialization functions from Bootstrap.groovy.
 * QDREC does not currently use this class. Initial projects are added directly through the
 * project creation page instead of during initialization.
 */
class BootStrapService {

  def dataSource
  def sessionFactory

  /*def initRole(name) {
    new Role(authority: name).save(flush: true)
  }*/

  /*def initUser(name, password, auth) {
    def role = Role.findByAuthority(auth)
    def user = new Users(username:name, enabled: true, password: password, dateCreated: new Date(), lastImageSubset: SubsetImage.first())
    user.save(failOnError: true)
    UserRole.create user, role, true
  }*/

  /*def addUserRole(name, auth) {
    def user = Users.findByUsername(name)
    def role = Role.findByAuthority(auth)
    UserRole.create user, role, true
  }*/

  def initDataset(String description) {
    Dataset dataset = new Dataset()
    dataset.description = description
    dataset.save(flush: true)
    return dataset
  }

  def initImage(String datadir, Dataset dataset) {
    CSVReader reader = new CSVReader(new FileReader(datadir + File.separator + "imagedb.csv"))
    List<String[]> lines = reader.readAll()
//    def position = dataset.size
    def datasetID = dataset.id
    for (int i=0; i<lines.size(); i++) {
      String[] line = lines[i]
//      dataset.size++
//      image.position = position++
      def compound
      if (line[1].equals("control")) {
        compound = null
      } else {
        compound = Compound.findByAliasLike("%"+line[1]+"%")
      }
      Image image = new Image()
      image.dataset = dataset
      image.compound = compound
      image.conc = Double.valueOf(line[2])
      image.day = Integer.valueOf(line[3])
      image.series = line[4].charAt(0)
      image.date = Date.parse("MMddyy",line[5])

      image.name = line[0]
//      BufferedImage bi = ImageIO.read(new File(datadir + File.separator + line[0] + ".png"))
//      image.width = bi.getWidth()
//      image.height = bi.getHeight()
      def pngReader = new PngReader( new File(datadir + File.separator + line[0] + ".png") )
      def info = pngReader.getChunkseq().getImageInfo()
      image.width = info.cols
      image.height = info.rows
      image.displayScale = image.width*image.height > 768**2 ? 0.5 : 1.0;

      dataset.addToImages(image)
      image.save()

//      image.addToImageData( new ImageData(new BufferedInputStream(new FileInputStream(datadir + File.separator + line[0] + ".png")).getBytes()) )
      ImageData imageData = new ImageData()
      imageData.stream = new BufferedInputStream(new FileInputStream(datadir + File.separator + line[0] + ".png")).getBytes()
      imageData.image = image
//      image.addToImageData(imageData)
      imageData.save(flush: true)

      String[] P = line[6].split(';')
//      Set<Parasite> parasites = new HashSet<Parasite>()
      for (String p : P) {
        Parasite parasite = new Parasite()
        String[] q = p.split(',')
        parasite.image = image
        parasite.region = Integer.valueOf(q[0])

        Integer upperLeftX = Double.valueOf(q[1])
        Integer upperLeftY = Double.valueOf(q[2])
        Integer width = Double.valueOf(q[3])
        Integer height = Double.valueOf(q[4])

        parasite.x = upperLeftX
        parasite.y = upperLeftY
        parasite.width = width
        parasite.height = height

        parasite.save()
//        parasites.add(parasite)
//        image.addToParasites(parasite)
      }
//      image.parasites = parasites
//      image.save()
//      dataset.addToImages(image)
      // Memory leak workaround
      if (i%10 == 0 && i!=lines.size()-1) {
        dataset.save()
        def hibSession = sessionFactory.getCurrentSession()
        assert hibSession != null
        hibSession.flush()
        hibSession.clear()
        DomainClassGrailsPlugin.PROPERTY_INSTANCE_MAP.get().clear()
        dataset = Dataset.get(datasetID)
      }
      log.info "Inserted " + datadir + File.separator + line[0] + ".png"
    }
    reader.close()

    dataset.size = dataset.images.size()
    dataset.save(flush: true)

    log.info "Finished inserting images"
//    assocControls()
    def hibSession = sessionFactory.getCurrentSession()
    assert hibSession != null
    hibSession.flush()
//    log.info "Associated images with controls"
  }

  def assocControls() {
    for (Image image : Image.findAll()) {
      def control = null
      try {
        def query = Image.where {
          (dataset==image.dataset && compound==null && day==image.day && series==image.series && date==image.date)
        }
        control = query.find()

        if (control == null) {
          def query2 = Image.where {
                  (dataset==image.dataset && compound==null && day==image.day && date==image.date)
                }
          control = query2.findAll()[0];
        }
      } catch (Exception e) {
        log.error("Couldn't associate control for " + image.name,e)
      }

      image.control = control
      image.save()
    }
  }

  def initImageData() {

  }

  def initParasite() {

    for (Parasite p : Parasite.findAll()) {

      int X = p.x;
      int Y = p.y;
      int X1 = p.x + p.width
      int Y1 = p.y + p.height

      String param = "GeomFromText( 'POLYGON((" + X + " " + Y + "," + X1 + " " + Y + "," + X1 + " " + Y1 + "," + X + " " + Y1 + "," + X + " " + Y + "))' )";
      def db = new Sql(dataSource)

      db.executeUpdate("UPDATE parasite set bounding_box "
                              + "=" + param + " WHERE id = ${p.id}")
    }
  }

  def initCompound() {
    new Compound(name:"chlorophenothiazine", alias: "2cpt").save(flush: true)
    new Compound(name:"acepromazine", alias: "ace#acetopromazine#aceto").save(flush: true)
    new Compound(name:"atorvastatin", alias: "ato#ator#atoravastin").save(flush: true)
    new Compound(name:"chlorpromazine", alias: "chl#chloropromazine#chlorprimazine#chloro#chlor").save(flush: true)
    new Compound(name:"clozapine", alias: "cloz#clos#closapine").save(flush: true)
    new Compound(name:"fluvastatin", alias: "flu#fluv#fluva").save(flush: true)
    new Compound(name:"K11777", alias: "k77#k777").save(flush: true)
    new Compound(name:"lovastatin", alias: "lov#lova").save(flush: true)
    new Compound(name:"mevastatin", alias: "mev#meva").save(flush: true)
    new Compound(name:"pravastatin", alias: "pra#prav#prava").save(flush: true)
    new Compound(name:"promethazine", alias: "pro#prom").save(flush: true)
    new Compound(name:"praziquantel", alias: "pzq#praz").save(flush: true)
    new Compound(name:"quinacrine", alias: "qui#quin").save(flush: true)
    new Compound(name:"simvastatin", alias: "sim#simv#simva").save(flush: true)
    new Compound(name:"imipramine", alias: "imi#imip#c8").save(flush: true)
    new Compound(name:"desipramine", alias: "a10").save(flush: true)
    new Compound(name:"clomipramine", alias: "a11").save(flush: true)
    new Compound(name:"trimipramine", alias: "e2").save(flush: true)
    new Compound(name:"doxepin", alias: "b5").save(flush: true)
    new Compound(name:"nortriptyline", alias: "b11").save(flush: true)
    new Compound(name:"hycanthone", alias: "d8").save(flush: true)
    new Compound(name:"chlorprothixene", alias: "e3").save(flush: true)
    new Compound(name:"amitriptyline", alias: "a2").save(flush: true)
    new Compound(name:"cyclobenzaprine", alias: "d7").save(flush: true)
    new Compound(name:"metrifonate", alias: "metrif").save(flush: true)
    new Compound(name:"alimemazine", alias: "trimeprazine#c4").save(flush: true)
    new Compound(name:"rosuvastatin", alias: "rosu#rosuv#rosuva").save(flush: true)
    new Compound(name:"bs-181", alias: "").save(flush: true)
    new Compound(name:"metitepine", alias: "methiopin#e4").save(flush: true)
    new Compound(name:"promazine", alias: "a5").save(flush: true)
    new Compound(name:"triflupromazine", alias: "b8").save(flush: true)
    new Compound(name:"ibandronate", alias: "iban").save(flush: true)
    new Compound(name:"niclosamide", alias: "nic").save(flush: true)
    new Compound(name:"sorafenib", alias: "sor").save(flush: true)

  }

  def initImagePos() {
    def datasets = Dataset.findAll()
    datasets.each { ds ->
      def images = Image.findAllByDataset(ds)
      images.each {
        it.dataset = ds
        it.save(flush: true)
      }
//      DomainClassGrailsPlugin.PROPERTY_INSTANCE_MAP.get().clear()
      ds.size = ds.images.size()
      ds.save(flush: true)
    }
  }

  def initSubsets() {
    Dataset.findAll().each { dataset ->
      def day4images = Image.findAllByDatasetAndDay(dataset,4)
      def subset = new Subset()
//      subset.dataset = dataset
      dataset.addToSubsets(subset)
      subset.description = "Complete set"
      dataset.images.each { image ->
        def imageSubset = new SubsetImage()
//        imageSubset.subset = subset
        subset.addToImageSubsets(imageSubset)
        imageSubset.image = image
//        imageSubset.save()
      }
      subset.size = subset.imageSubsets.size()
//      subset.save()

      subset = new Subset()
      dataset.addToSubsets(subset)
      subset.description = "Day 4 images"
      day4images.each { image ->
        def imageSubset = new SubsetImage()
//        imageSubset.subset = subset
        subset.addToImageSubsets(imageSubset)
        imageSubset.image = image
//        imageSubset.save()
      }
      subset.size = subset.imageSubsets.size()
//      subset.save()

      dataset.save()
    }
  }

}
