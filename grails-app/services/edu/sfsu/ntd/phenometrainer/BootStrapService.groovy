package edu.sfsu.ntd.phenometrainer
import au.com.bytecode.opencsv.CSVReader
import groovy.sql.Sql
import org.codehaus.groovy.grails.plugins.DomainClassGrailsPlugin

class BootStrapService {

  def dataSource
  def sessionFactory

  def initUsers() {
    def userRole = new Role(authority: 'ROLE_USER').save(flush: true)
    def user = new Users(username:'schisto', enabled: true, password: 'schisto', dateCreated: new Date(), lastImage: Image.get(1))
    user.save(failOnError: true)
    UserRole.create user, userRole, true
  }

  def initDataset(String description) {
    Dataset dataset = new Dataset()
    dataset.description = description
    dataset.save(flush: true)
    return dataset
  }

  def initImage(String datadir, Dataset dataset) {
    CSVReader reader = new CSVReader(new FileReader(datadir + File.separator + "imagedb.csv"))
    List<String[]> lines = reader.readAll()
    for (int i=0; i<lines.size(); i++) {
      String[] line = lines[i]
      Image image = new Image()

      image.dataset = dataset

      if (line[1].equals("control")) {
        image.cdId = 0
      } else {
        image.cdId = Compound.findByAliasLike("%"+line[1]+"%").id
      }

      image.conc = Double.valueOf(line[2])
      image.day = Integer.valueOf(line[3])
      image.series = line[4].charAt(0)
      image.date = Date.parse("MMddyy",line[5])

      image.name = line[0]

      image.imageData = new ImageData()
      image.imageData.stream = new FileInputStream(datadir + File.separator + line[0] + ".png").getBytes()
//      image.imageData.save(flush: true)

      String[] P = line[6].split(';')
      Set<Parasite> parasites = new HashSet<Parasite>()
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

//        parasite.save(flush: true)
        parasites.add(parasite)
      }
      image.parasites = parasites
      image.save(flush: true)

      // Memory leak workaround
      if (i!=lines.size()-1) {
//        def hibSession = sessionFactory.getCurrentSession()
//        assert hibSession != null
//        hibSession.flush()
        DomainClassGrailsPlugin.PROPERTY_INSTANCE_MAP.get().clear()
      }
      log.info "Inserted " + datadir + File.separator + line[0] + ".png"
    }
    reader.close()
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
          (dataset==image.dataset && cdId==0 && day==image.day && series==image.series && date==image.date)
        }
        control = query.find()

        if (control == null) {
          def query2 = Image.where {
                  (dataset==image.dataset && cdId==0 && day==image.day && date==image.date)
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
    new Compound(name:"clozapine", alias: "cloz").save(flush: true)
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

}
