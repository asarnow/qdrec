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
  <r:require modules="jquery" />
  <g:javascript>
    $(document).ready( function() {
        $('#nicbutton').click(function() {
          $('niclosamideSubsets').toggle();
          $('#mevastatinSubsets').hide();
          $('#niclosamideSubsets').toggle();

        });
/*        $('#mevbutton').click(function() {
          $('#niclosamideSubsets').hide();
        $('#mevastatinSubsets').toggle();
      });*/
    });
  </g:javascript>
</head>
<body>
  <div class="help">
    <h2>Example Project Data</h2>
    <p>
      Sample screening data can be used to create new projects (as long as a unique project name is used).
    </p>
    <ul class="downloads">
      <li>
        <a href="${resource(dir: 'download', file: 'Niclosamide.zip')}">Niclosamide example data</a>
        <p>
          Contains two replicate dose-response series for 4 days of exposure to Niclosamide (5 images and 1 control image each, 12 images total).
          Intended to demonstrate separate training and testing sets used to create and test a new classifier.
          Segmented images are included.
        </p>
      </li>
      <li>
        <a href="${resource(dir: 'download', file: 'Mevastatin.zip')}">Mevastatin example data</a>
        <p>
          Contains dose- and time-response series for Mevastatin, including controls, with two time-points replicated across concentrations (30 images total).
          Intended to demonstrate QDREC with combined time- and dose-response data.
          Segmented images are included.
        </p>
      </li>
      <li>
        <a href="${resource(dir: 'download', file: 'Phenotyping Schistosomula.pptx')}">Introduction to Phenotyping Schistosomula</a>
        <p>
          A brief slideshow companion to the sample data sets, which introduces manual phenotypic screening for schistosomula
          and presents several examples which will aid with the Tutorial for Sample Data.
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
      Make sure the new window is wide enough to display the entire navigation bar, with 5 entries. We recommend you make
      the QDREC browser window as wide as possible (maximized).
    </p>
    <p>
      Once the page has loaded, enter a unique name for your project. You can see what project names have already been used,
      by switching to the "Load Project" tab, and look through the drop-down menu of available projects.
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
      Finally, click <button type="button" class="button">Create Project</button>. A loading animation will be shown while the server registers each image and performs
      segmentation using the selected method (if applicable). When segmentation and registration are complete, the loading
      animation will be replaced with some information about your new project. If this is a private project, then you must save the six-character
      project identifier token in order to access the project again later.
    </p>
    <p>
      Once project creation is finished, switch to the "Review Segmentation" tab and inspect the segmented images directly.
      Now that your project has been created and is loaded by the server, navigate to the "Define Subsets" page.
    </p>
    <h3>Define subsets</h3>
    <p>
      For the Mevastatin sample data, please enter all of the images into a single subset called 'complete' and then
      proceed directly to the "Run Classifier" section of the tutorial.
    </p>
    <p>
      When training a new classifier, project images must be divided into at least two subsets for use in training and testing.
      The Niclosamide sample data should be divided into the following 'training' and 'testing' sets.
    </p>
    <p>
      <button type="button" class="button" id="nicbutton">Show Defintions</button>
    </p>
      <div id="niclosamideSubsets" hidden>
        <h5>Subsets for Niclosamide Sample Data</h5>
        <table>
          <thead>
            <tr>
              <td>Training</td>
              <td>Testing</td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>072913-CTRL-0-4-a</td>
              <td>072913-CTRL-0-4-b</td>
            </tr>
            <tr>
              <td>072913-NIC-0001-4-a</td>
              <td>072913-NIC-0001-4-b</td>
            </tr>
            <tr>
              <td>072913-NIC-001-4-a</td>
              <td>072913-NIC-001-4-b</td>
            </tr>
            <tr>
              <td>072913-NIC-01-4-a</td>
              <td>072913-NIC-01-4-b</td>
            </tr>
            <tr>
              <td>072913-NIC-1-4-a</td>
              <td>072913-NIC-1-4-b</td>
            </tr>
            <tr>
              <td>072913-NIC-10-4-a</td>
              <td>072913-NIC-10-4-b</td>
            </tr>
          </tbody>
        </table>
      </div>
    <br />
    <p>
      Subsets are defined by selecting images from the list on the right side of the page. When the desired images are chosen, the subset name
      is entered into the "New subset" field. Click the <button type="button" class="button">Define</button> button to create the subset, which will appear in the list of subsets.
    </p>
    <p>
      The <button type="button" class="button">Invert</button> and <button type="button" class="button">Clear</button> buttons control
      selection of images by inverting and clearing the selection, respectively. The <button type="button"
                                                                                             class="button">Invert</button>
      is especially convenient for defining a test set which is the complement of an already defined training set.
    </p>
    <p>
      Once acceptable training and testing sets have been defined, navigate to "Create New Classifier."
    </p>
    <h3>Create classifier</h3>
    <h4>Annotate Data</h4>
    <p>
      The first step in creating a new classifier is manually annotating the training set, conducted on the "Annotate Data" tab.
      The annotation interface holds two high-resolution images side-by-side, so you may need to maximize your browser window.
    </p>
    <p>
      To train, select the desired training subset from the menu at the top of the training
      interface. Once selected, the interface will switch to the chosen set of images.
    </p>
    <p>
      QDREC will present you with a series of matched experiment and control images.
      The experimental images are decorated with bounding rectangles which indicate the parasites which were found by the
      computer vision algorithm. These rectangles are <span style="color:#0000ff">blue</span>, which indicates the "normal" classification.
    </p>
    <p>
      Click inside a bounding box to mark a parasite as "degenerate." The bounding box will turn <span style="color:#ff0000">red</span>, reflecting the
      recorded state of that parasite. You can switch a "degenerate" parasite back to "normal" by clicking in the box again.
      This will also toggle the box color back to <span style="color:#0000ff">blue</span>.
    </p>
    <p>
      Clicking <button class="button">Toggle all</button> will cause all parasites in the image to swtich state
    (e.g. from <span style="color:#0000ff">normal</span> to <span style="color:#ff0000">degenerate</span> or vice versa).
      Clicking <button class="button">Reset all</button> will reset all of the parasites to the <span style="color:#0000ff">normal</span> state.
    </p>
    <p>
      When you have finished classifying the parasites in an image, click <button class="button">Next</button> to advance to the next image.
      As you advance through the images, your progress will be noted.
      You may also return to previously visited images by clicking <button class="button">Prev</button>.
    </p>
    <p>
      QDREC will remember your progress, so if at any time you would like a break from training, just exit the system.
      When you return and load the project, you will be able to pick up with training where you left off. You may also
      explicitly save annotations for the current image by clicking <button class="button">Save</button>, for example
      if you plan on immediately closing the browser window completely.
    </p>
    <p>
      The sample data sets are small enough to enable rapid training. If differences from control parasites are difficult
      to recognize, we recommend that you review the brief slideshow (10 slides) on manual screening for schistosomula,
      which is provided with the sample data.
    </p>
    <p>
      QDREC will notify you when annotation of the selected subset is complete. At this point you should switch to the
      "Train Classifier" tab.
    </p>
    <h4>Train Classifier</h4>
    <p>
      Use the drop-down menu for selection of the training subset, then use the radio buttons to select the desired
      classification algorithm. For the sample data sets, please select either SVM (RBF) or SVM (linear).
    </p>
    <p>
      Fields for any required method parameters will appear.
      For details, see <a href="${createLink(action: 'about')}">here</a>. It should
      be fine to leave the parameters set to their default values.
    </p>
    <p>
      Once the training set and parameter values have been selected, click <button class="button">Create Classifier</button>
      to train. Be aware that training may take several minutes depending on the size of the data.
      When training is complete, the cross-validated confusion matrix for classification of the training set, as well as the single-image
      response values, will be displayed in tabular form.
    </p>
    <p>
      At this point, proceed to "Run Classifier."
    </p>
    <h3>Run classifier</h3>
    <p>
      Select the subset for classification from the drop-down menu. In the case of the sample data sets, this should be
      the 'Testing' subset.
    </p>
    <p>
      Then, select either the existing or newly trained classifier and click <button type="button"
                                                                                     class="button">Classify</button>
    </p>
    <p>
      Classification may take several minutes. When classification is complete, the results will be available in two forms.
    </p>
    <h4>Plot Results</h4>
    <p>
      First, a simple plotting interface will appear under the "Plot Results" heading. Click this heading to hide and show the plotting interface.
    </p>
    <p>
      A particular drug compound can be chosen from the drop-down menu. For the sample data, only one drug ('nic' or 'meva') and an entry
      for 'control' will be available. Due to the small size of the sample sets, the 'control' entry is not informative and
      should be ignored.
    </p>
    <p>
      Click <button class="button">Plot</button> in order to display interactive response plots for the selected compound.
    </p>
    <h4>Tabular Results</h4>
    <p>
      The tabular results include single-image response values for the test set. Click <button class="button">Display</button>
      under this heading in order to view the results table. Click <button class="button">Download</button> to download the results
      in comma-separated-values (CSV) format.
    </p>
    <p>
      Thank you for taking the time to peruse this tutorial.
    </p>
  </div>
</body>
</html>