package edu.sfsu.ntd.phenometrainer
import ar.com.hjg.pngj.PngReader
import au.com.bytecode.opencsv.CSVReader
import groovy.sql.Sql
import phenomj.PhenomJ

class AdminService {

  def grailsApplication
  def sessionFactory
  def dataSource

  def initUser(name, password, auth) {
    def role = Role.findByAuthority(auth)
    def user = new Users(username:name, enabled: true, password: password, dateCreated: new Date(), lastImageSubset: null)
    user = user.save(failOnError: false)
    if (user != null) {
      UserRole.create user, role, true
      return user
    } else {
      return null
    }
  }

  def initDataset(name, String datasetDir) {
    def dataset = new Dataset()
    dataset.description = name
    dataset = dataset.save()

    def dir = new File(datasetDir)
    if (!dir.exists()) {
      dir.mkdir()
    }

    PhenomJ phenomJ = new PhenomJ()
    phenomJ.imageDatabase(datasetDir)

    dataset = initImage(datasetDir, dataset)
    assocControls(dataset)
    initParasite(dataset)

    return dataset.save(flush: true)
  }

  def defineSubset(subsetName, datasetID, images) {
    def dataset = Dataset.get(datasetID)
    def subset = Subset.findByDescriptionAndDataset(subsetName,dataset)

    if (subset!=null) {
      subset.delete() // should cascade to all subsetImage
    }

    subset = new Subset()
    dataset.addToSubsets(subset)
    subset.description = subsetName
    images.each { imageID ->
      def image = Image.get(imageID)
      def imageSubset = new SubsetImage()
      subset.addToImageSubsets(imageSubset)
      imageSubset.image = image
    }
    subset.size = subset.imageSubsets.size()
    return dataset.save()
  }

  def initImage(String datadir, Dataset dataset) {
    CSVReader reader = new CSVReader(new FileReader(datadir + File.separator + "imagedb.csv"))
    List<String[]> lines = reader.readAll()
//    def datasetID = dataset.id
    for (int i=0; i<lines.size(); i++) {
      String[] line = lines[i]

      Image image = new Image()
      image.dataset = dataset

      image.conc = Double.valueOf(line[2])
      image.day = Integer.valueOf(line[3])
      image.series = line[4].charAt(0)
      image.date = Date.parse("MMddyy",line[5])

      image.name = line[0]

      def cdId
      if (line[1].equals("control") || image.conc==0D) {
        cdId = 0
      } else {
        def compound = Compound.findByAliasLike("%"+line[1]+"%")
        if (compound==null) {
          compound = new Compound()
          compound.name = line[1]
          compound.alias = line[1]
          compound = compound.save(flush: true)
        }
        cdId = compound.id
      }

      image.cdId = cdId
//      BufferedImage bi = ImageIO.read(new File(datadir + File.separator + line[0] + ".png"))
//      image.width = bi.getWidth()
//      image.height = bi.getHeight()
      def pngReader = new PngReader( new File(datadir + File.separator + 'img' + File.separator + line[0] + ".png") )
      def info = pngReader.getChunkseq().getImageInfo()
      image.width = info.cols
      image.height = info.rows
      image.displayScale = image.width*image.height > 768**2 ? 0.5 : 1.0;

      dataset.addToImages(image)
      image.save(flush: true)

//      image.addToImageData( new ImageData(new BufferedInputStream(new FileInputStream(datadir + File.separator + line[0] + ".png")).getBytes()) )
//      ImageData imageData = new ImageData()
//      imageData.stream = new BufferedInputStream(new FileInputStream(datadir + File.separator + line[0] + ".png")).getBytes()
//      imageData.image = image
////      image.addToImageData(imageData)
//      imageData.save(flush: true)

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

        parasite = parasite.save(flush: true)
//        parasites.add(parasite)
        image.addToParasites(parasite)
        parasite.save(flush: true)
      }
//      image.parasites = parasites
      image.save(flush: true)
//      dataset.addToImages(image)
      // Memory leak workaround
      /*if (i%10 == 0 && i!=lines.size()-1) {
        dataset.save()
        def hibSession = sessionFactory.getCurrentSession()
        assert hibSession != null
        hibSession.flush()
        hibSession.clear()
        DomainClassGrailsPlugin.PROPERTY_INSTANCE_MAP.get().clear()
        dataset = Dataset.get(datasetID)
      }*/
      log.info "Inserted " + datadir + File.separator + 'img' + File.separator + line[0] + ".png"
    }
    reader.close()

    dataset.size = dataset.images.size()
    dataset = dataset.save(flush: true)

    log.info "Finished inserting images"
//    assocControls()
//    def hibSession = sessionFactory.getCurrentSession()
//    assert hibSession != null
//    hibSession.flush()
//    log.info "Associated images with controls"
    return dataset
  }

  def assocControls(Dataset dataset) {
    for (Image image : dataset.images) {
      def control = null
      try {
        def query = Image.where {
          (dataset==image.dataset && (cdId==0||conc==0) && day==image.day && series==image.series && date==image.date)
        }
        control = query.find()

        if (control == null) {
          def query2 = Image.where {
                  (dataset==image.dataset && (cdId==0||conc==0) && day==image.day && date==image.date)
                }
          control = query2.findAll()[0];
        }
      } catch (Exception e) {
        log.error("Couldn't associate control for " + image.name,e)
      }

      image.control = control
      image.merge(flush: true)
    }
  }

  def initParasite(Dataset dataset) {
    def parasites = dataset.images.parasites.flatten()
      for (Parasite p : parasites) {
        if (p!=null) {
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
    }

  def findDatasetDir(dataset) {
    return grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.id
  }

}
