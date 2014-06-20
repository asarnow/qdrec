package edu.sfsu.ntd.phenometrainer
import ar.com.hjg.pngj.PngReader
import au.com.bytecode.opencsv.CSVReader
import com.mathworks.toolbox.javabuilder.MWException
import grails.util.Holders
import groovy.sql.Sql
import org.apache.commons.io.FileUtils
import org.apache.commons.lang.RandomStringUtils
import phenomj.PhenomJ

/**
 * Service class which provides administrative functions such as creating projects and subsets,
 * inclusive of segmenting images and populating the database with parasites and their locations.
 */
class AdminService {
  // Objects for dependency injection via Spring.
  def grailsApplication = Holders.getGrailsApplication()
  def sessionFactory
  def dataSource

  /**
   * Calls the PhenomJ MATLAB Builder JA library in order to segment project images
   * according the specified segmentation method, define the project / dataset
   * using the specified parameters (name, public / private flag), and
   * generate the imagedb.csv file listing the images and segmented parasites.
   * If project creation and initialization is successful, the project's working
   * directory is moved from the system temp location to the QDREC data directory.
   * @param name
   * @param datasetDir
   * @param visible
   * @param seg
   * @return
   */
  def initDataset(name, String datasetDir, visible, String seg) {
    def dataset = new Dataset()
    dataset.description = name
    dataset.visible = visible=='on'
    dataset.token = RandomStringUtils.random(6, ('a'..'z').join().toCharArray())

    def dest = new File(grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.token)
    while (dest.exists()) {
      dataset.token = RandomStringUtils.random(6, ('a'..'z').join().toCharArray())
      dest = new File(grailsApplication.config.PhenomeTrainer.dataDir + File.separator + dataset.token)
    }

    dataset = dataset.save()

    def segmentation = 0
    if (seg.startsWith('Asa')) segmentation = 1
    if (seg.startsWith('Can')) segmentation = 2
    if (seg.startsWith('Wat')) segmentation = 3

    if (segmentation > 0) {
      def dir = new File(datasetDir + File.separator + 'bw')
      if (!dir.exists()) dir.mkdir()
    }

    try {
      PhenomJ phenomJ = new PhenomJ()
      phenomJ.imageDatabase(datasetDir,segmentation)
    } catch (MWException e) {
      log.error(e)
      dataset.delete()
      return null
    }
    dataset = initImage(datasetDir, dataset)
    assocControls(dataset)
    initParasite(dataset)

    def src = new File(datasetDir)

    FileUtils.copyDirectory(src,dest)
    try {
      FileUtils.deleteDirectory(src)
    } catch (IOException e) {
      log.error(e)
    }

    return dataset.save(flush: true)
  }

  def validateDataset(String datasetName, String datasetDir, String visible, String seg) {
    def segmentation = 0
    if (seg.startsWith('Asa')) segmentation = 1
    if (seg.startsWith('Can')) segmentation = 2

    def imgDir = new File(datasetDir + File.separator + 'img')
    def segDir = new File(datasetDir + File.separator + 'bw')

    def imgFiles = imgDir.listFiles(new PngFilter())
    def segFiles = segDir.listFiles(new PngFilter())

    if (segmentation==0) {
      if (imgFiles?.length != segFiles?.length) return 'Number of uploaded files must match. Double check uploaded files.'
    }
    if (imgFiles?.length < 2) return 'At least two image files must be provided.'

    return null
  }

  class PngFilter implements FilenameFilter {
    public boolean accept(File f, String filename) {
      return filename.endsWith("png")
    }
  }

  /**
   * Service method to define a new subset using the supplied parameters
   * (name, dataset ID and selected image IDs).
   * Attempts to automatically identify controls if they were not included.
   * The user is informed if the controls were added automatically or if the
   * user will need to specify control images manually.
   * @param subsetName
   * @param datasetID
   * @param imageIDs
   * @return
   */
  def defineSubset(subsetName, datasetID, imageIDs) {
    def message = ''
    def images = []
    imageIDs.each {imageID -> images.add(Image.get(imageID))}

    def nocontrol = []
    def newims = []
    for (def im : images) {
      if (im.control==null) {
        nocontrol.add(im)
      } else if (!images.contains(im.control)) {
        newims.add(im.control)
        if (im.control.control == null) nocontrol.add(im)
      }
    }
    if (nocontrol.size() > 0) {
      return [nocontrol:nocontrol, message:message]
    }

    message = newims.size() > 0 ? 'Missing controls added to subset' : 'Subset defined successfully'
    images.addAll(newims)

    def dataset = Dataset.get(datasetID)
    def subset = Subset.findByDescriptionAndDataset(subsetName,dataset)
    if (subset==null) {
      subset = new Subset()
      dataset.addToSubsets(subset)
      subset.description = subsetName
    } else {
      subset.imageSubsets.clear()
    }

    images.each { image ->
      def imageSubset = new SubsetImage()
      subset.addToImageSubsets(imageSubset)
      imageSubset.image = image
    }
    subset.size = subset.imageSubsets.size()
    subset = subset.save(flush:true)
    dataset.save(flush: true)
    return [nocontrol:nocontrol, message:message]
  }

  /**
   * Populates the database using the project's imagedb.csv file, which lists all project images
   * as well as the parasites segmented in each image.
   * This requires parsing the file names according to QDREC's file name convention,
   * reading the images to determine their sizes and appropriate display scales,
   * and parsing the parasite definitions.
   * @param datadir
   * @param dataset
   * @return
   */
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

      def compound = null
      if (!(line[1].equals("control") || image.conc==0D)) {
        compound = Compound.findByAliasLike("%"+line[1]+"%")
        if (compound==null) {
          compound = new Compound()
          compound.name = line[1]
          compound.alias = line[1]
          compound = compound.save(flush: true)
        }
      }
      image.compound = compound
//      BufferedImage bi = ImageIO.read(new File(datadir + File.separator + line[0] + ".png"))
//      image.width = bi.getWidth()
//      image.height = bi.getHeight()
      def pngReader = new PngReader( new File(datadir + File.separator + 'img' + File.separator + line[0] + ".png") )
      def info = pngReader.getChunkseq().getImageInfo()
      image.width = info.cols
      image.height = info.rows
      image.displayScale = image.width*image.height > 768**2 ? 0.5 : 1.0;

      pngReader.close()

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

  /**
   * Identifies the each image's control image and updates the database accordingly.
   * @param dataset
   */
  def assocControls(Dataset dataset) {
    for (Image image : dataset.images) {
      def control = null
      try {
        def query = Image.where {
          (dataset==image.dataset && (compound==null||conc==0) && day==image.day && series==image.series && date==image.date)
        }
        control = query.find()

        if (control == null) {
          def query2 = Image.where {
                  (dataset==image.dataset && (compound==null||conc==0) && day==image.day && date==image.date)
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

  /**
   * Adds the project parasites' bounding boxes to the MySQL spatial index.
   * The only place in QDREC where a native database call is required (i.e. SQL vs. GORM).
   * @param dataset
   */
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

}
