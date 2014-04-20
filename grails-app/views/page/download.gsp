%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%

<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 12/30/13
  Time: 11:42 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>QDREC: Downloads</title>
  <meta name="layout" content="main" />
</head>
<body>
  <div class="content">
    <h2>Example Project Data</h2>
    <p>
      Sample screening data can be used to create new projects (as long as a unique project name is used).
    </p>
    <ul class="downloads">
      <li>
        <a href="${resource(dir: 'download', file: 'Niclosamide.zip')}">Niclosamide example data</a>
        <p>
          Contains two replicate dose-response series for 4 days of exposure to Niclosamide (5 images and 1 control image each, 12 images total).
          Segmented images are included.
        </p>
      </li>
      <li>
        <a href="${resource(dir: 'download', file: 'Mevastatin.zip')}">Mevastatin example data</a>
        <p>
          Contains dose- and time-response series for Mevastatin, including controls, with two time-points replicated across concentrations (30 images total).
          Segmented images are included.
        </p>
      </li>
    </ul>
    <h2>Tutorial for Sample Data</h2>
    <h3>Download and extract</h3>
    <p>
      First, download one of the sample archives above. After the download is complete, extract the archive.
    </p>
    <p>
      You should now have a directory containing subdirectories called 'img' and 'bw,' which contain the
      original and segmented images, respectively.
    </p>
    <h3>Create project</h3>
    <p>
      Next, open QDREC in a new browser tab or window, and select "Create Project" from the navigation bar.
      Once the page has loaded, enter a unique name for your project. You can see what project names have already been used,
      select "Load Project" from the secondary navigation bar, and look through the drop-down menu of available projects.
    </p>
    <p>
      Next, you may choose to deselect the "Public project" checkbox. If this box is checked,
      you (or anyone else) will be able to load the project using the "Load Project" page. If the box is unchecked,
      then a secret six-character project identifier will be assigned, which can be used to load the project.
    </p>
    <p>
      Now, choose a segmentation method from the "Segmentation" drop-down menu. The default "Asarnow-Singh" method has the best performance.
      To save time, select "Upload." This will allow you to use the segmented images provided in the data archive, rather than waiting for the
      server to completely segment the original images.
    </p>
    <p>
      To upload images files for your new project, open the 'img' directory from the data archive and drag the images into the file upload area
      labeled "Upload images." Parallel data upload will begin immediately, and may take up to 10-20 minutes depending on the speed of your connection.
    </p>
    <p>
      If the Segmentation method has been set to "Upload," you must also open the 'bw' directory from the archive and drag the segmented
      images onto the second file upload area (labelled "Upload segmented images").
    </p>
    <p>
      Please wait for all uploads to complete before proceeding (or else some images may be dropped by the server).
    </p>
    <p>
      Finally, click the "Create Project" button. A loading animation will be shown while the server registers each image and performs
      segmentation using the selected method (if applicable). When segmentation and registration are complete, the loading
      animation will be replaced with some information about your new project. If this is a private project, then you must save the six-character
      project identifier token in order to access the project again later.
    </p>
    <p>
      Once project creation is finished, you may navigate to "Review Segmentation" and inspect the segmented images directly.
    </p>
    <h3>Define subsets</h3>
    <p>
      Now that your project has been created and is loaded by the server, the project images must be divided into at least two subsets for use
      in training and testing. Navigate to the "Define Subsets" page.
    </p>
    <p>
      Subsets are defined by selecting images from the list on the right side of the page. When the desired images are chosen, the subset name
      is entered into the "New subset" field. Click the "Define" button to create the subset, which will appear in the list of subsets.
    </p>
    <h3>Create classifier</h3>
    <h3>Run classifier</h3>
  </div>
</body>
</html>