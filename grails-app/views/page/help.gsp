<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 5/11/13
  Time: 11:33 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>QDREC Help</title>
  <meta name="layout" content="main" />
</head>
<body>
  <div class="content">
    <div class="help">
      <h1>QDREC Usage Instructions</h1>
      <p>
        Please carefully peruse the following instructions before using QDREC. Failure to follow these instructions
        precisely will lead to errors.
      </p>
      <h2>Create/Load Project</h2>
      <h3>Load Project</h3>
      <p>
        An existing project may be loaded by selecting its name from the drop-down menu and
        clicking <button class="button">Load Project</button>.
        A project can also be loaded directly by entering its 6-character identifier string into the "project identifier" field and
        clicking <button class="button">Load Project</button>.
      </p>
      <h3>Create Project</h3>
      <p>
        At least one set of files must be uploaded to create a project in QDREC.
        Archives containing example images which comply with the requirements
        enumerated below may be downloaded <a href="${createLink(action: 'download')}">here</a>.
        Image files should be uploaded individually; it is convenient to select a number of image files in the
        operating system file explorer and drag them all into the file upload area.
      </p>
      <p>
        Segmentation may be performed automatically with either the Asarnow-Singh method, using phase congruency edge detection
        for separating touching parasites, or the "Canny" method which uses Canny edge detection for that purpose.
        These options are both present in the "Segmentation" drop-down menu.
        Alternatively, previously computed segmentations (such as those provided with the example images) may be provided by selecting
        "Upload" from the "Segmentation" drop-down. In this case, an additional file upload dialog will appear.
      </p>
      <p>
        The project must also be given a unique, descriptive name of at least 4 characters in length.
      </p>
      <p>
        By default, "public project" is checked, indicating that the project will appear in the list of existing projects.
        To prevent this, uncheck the box. After project creation, a 6-character text identifier will be supplied. This identifier
        must be saved in order to re-load private projects in the future.
      </p>
      <p>
        Once images have been uploaded and the form fields filled, click <button class="button">Create Project</button>.
        Project creation may take several minutes depending on the size of the data and the segmentation method selected.
        New projects will be retained for one week (seven days).
      </p>
      <p>
        Images must conform strictly to the following requirements:
      </p>
      <h3>Parasite images</h3>
      <ul>
        <li>Must follow the file name convention defined below</li>
        <li>Must be <strong>non-indexed</strong> grayscale or RGB images</li>
        <li>Must have a bit-depth of 8</li>
        <li>Must be use the Portable Network Graphics (PNG) format</li>
        <li>Must have the ".png" file extension</li>
      </ul>
      <h3>Segmented images</h3>
      <ul>
        <li>Must have the same name as the corresponding parasite image</li>
        <li>Must have a bit-depth of 1</li>
        <li class="level2">Some images may not have a bit-depth of 1 even if they appear black-and-white</li>
        <li>Must use the Portable Network Graphics (PNG) format</li>
        <li>Must have the ".png" file extension</li>
      </ul>
      <h3>File name convention</h3>
      <p>
        QDREC requires that you use a specific file name convention.
        The convention permits QDREC to record each image uniquely in the database and, critically, to associate each
        experimental image with the appropriate control. This association is a key component of the QDREC parasite classification
        approach. See <a href="${createLink(action: 'about')}">here</a> for details.
      </p>
      <p>
        Files must be named as follows, not including ".png" extension:
        <br />
        DATE-COMPOUND-CONCENTRATION-EXPOSURE-SERIES
        <br />
      </p>
        <ul>
          <li>The date should be a 6-digit, American style (middle-endian) date such as "062113" (21 June, 2013)</li>
          <li>The compound may be any string containing alphabetic characters only</li>
          <li class="level2">It is recommended to use an abbreviation of the full compound name</li>
          <li class="level2">Control images must have the string "control" in the compound field</li>
          <li>The concentration is the decimal concentration in micromolars, with a leading zero but no decimal point</li>
          <li class="level2">For example, the string "001" indicates a concentration of 0.01 &micro;M</li>
          <li class="level2">Control images must have concentration of zero</li>
          <li>Exposure time must be an integer number of elapsed time units (e.g. days)</li>
          <li>The "series" field is used when replicate experiments have been performed, which would otherwise lead
              to identically named files</li>
          <li class="level2">The series must be a single, alphabetic character, such as "a" (or another letter)</li>
        </ul>
      <p>
        Here are several examples:
      </p>
      <table>
        <thead>
          <tr>
            <td>File name</td>
            <td>Meaning</td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>
              072913-NIC-01-4-a
            </td>
            <td>
              Date: 29 July, 2013
              <br />
              Compound: "NIC"
              <br />
              Concentration: 0.1 &micro;M
              <br />
              Exposure: 4 units (e.g. days)
              <br />
              Series: a
            </td>
          </tr>
          <tr>
            <td>
              062112-control-0-2-b
            </td>
            <td>
              Date: 21 June, 2012
              <br />
              Compound: N/A (control)
              <br />
              Concentration: 0 (control)
              <br />
              Exposure: 2 units (e.g. days)
              <br />
              Series: b
            </td>
          </tr>
          <tr>
            <td>
              062112-SIM-10-1-b
            </td>
            <td>
              Date: 21 June, 2012
              <br />
              Compound: "SIM"
              <br />
              Concentration: 10 &micro;M
              <br />
              Exposure: 1 unit (e.g. days)
              <br />
              Series: b
            </td>
          </tr>
        </tbody>
      </table>
      <h2>Define Subsets</h2>
      <p>
        Different sets of images should be used to train and test the classifier. Thus, it is necessary to divide a project
        into subsets which can be separately selected for training or testing. If only testing will be performed, it is acceptable to
        place all project images into a single subset.
      </p>
      <p>
        Subsets are defined by selecting multiple images from a project,
        providing a descriptive name of at least 5 characters in length and clicking <button class="button">Define</button>.
      </p>
      <p>
        The form also lists existing subsets. Clicking one will automatically select the images belonging to that subset.
        If the same name as an existing subset is provided before clicking <button class="button">Define</button>, then the
        existing subset will be updated to reflect the currently selected images.
      </p>
      <p>
        Clicking <button class="button">Invert</button> will invert the selection (selected images are unselected, and vice-versa).
        Clicking <button class="button">Clear</button> will clear the selection (unselect all images).
      </p>
      <p>
        Newly defined or updated subsets will be immediately reflected in the list of subsets.
        It is recommended to create at least two subsets, one for training and one for testing.
      </p>
      <p>
        Images must be associated to controls in order to be used in QDREC. If a control has been left out of a subset definition,
        it will be added automatically and you will be notified. If any images are missing controls, you will be asked to manually
        associate these images with the appropriate controls before continuing.
      </p>
      <p>
        If manual association is required, a new form area will appear containing a drop-down menu for the images which are missing associations.
        After selecting an image in the left drop-down menu, the right menu will be populated with possible controls. Select one, then click
        <button class="button">Add Control</button>. Once the association is complete, that image will be removed from the left of images which need
        manual association.
      </p>
      <h2>Create New Classifier</h2>
      <h3>Annotate Data</h3>
      <p>
        The first step in training is to select the appropriate subset from the menu at the top of the training
        interface. Once selected, the interface will switch to the chosen set of images.
      </p>
      <p>
        No training is required to use the existing classifier. Also note that if separate subsets for training and testing
        have been defined, it is not necessary to provide annotations for the test set.
      </p>
      <p>
        The QDREC Trainer will present you with a series of matched experiment and control images.
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
        The Trainer will remember your progress, so if at any time you would like a break from training, just exit the system.
        When you return and load the project, you will be able to pick up with training where you left off.
      </p>
      <h3>Train Classifier</h3>
      <p>
        If a new classifier should be trained, navigate to the "Train Classifier" tab. Three fields will appear. The first is a
        drop-down menu for selection of the subset for training.
        The other two fields (labeled "RBF Sigma" and "Soft-margin box constraint," respectively) are parameters used
        by the SVM classifier. For details, see <a href="${createLink(action: 'about')}">here</a>. It should
        be fine to leave the parameters set to their default values.
      </p>
      <p>
        Once the training set and parameter values have been selected, click <button class="button">Create Classifier</button>
        to train. Be aware that training may take several minutes depending on the size of the data.
        When training is complete, the cross-validated confusion matrix for classification of the training set, as well as the single-image
        response values, will be displayed in tabular form.
      </p>
      <h3>Review Segmentation</h3>
      <p>
        When a new project is created, you will be given the chance to review the segmented images, to ensure that they are
        sufficiently accurate. If previously segmented images were uploaded, or if an existing project is loaded, segmentation
        review will not launch immediately. Instead, it may be accessed by navigating to Review Segmentation.
      </p>
      <h2>Run Classifier</h2>
      <p>
        If no new classifier has been trained, simply select a subset from the first drop-down list, and click
        <button class="button">Classify</button>. If a new classifier is available, you may use the radio buttons to select
        either the new classifier, or the existing one. Be aware that classification may take several minutes depending on the size of the data.
      </p>

      <p>
        When classification is complete, the results will be available in two forms.
      </p>
      <h3>Plot Results</h3>
      <p>
        First, a simple plotting interface will appear under the "Plot Results" heading. Click this heading to hide and show the plotting interface.
      </p>
      <p>
        A particular drug compound can be chosen from the drop-down menu.
        Click <button class="button">Plot</button> in order to display interactive response plots for the selected compound.
      </p>
      <h3>Tabular Results</h3>
      <p>
        The tabular results include single-image response values for the test set. Click <button class="button">Display</button>
        under this heading in order to view the results table. Click <button class="button">Download</button> to download the results
        in comma-separated-values (CSV) format.
      </p>
    </div>
  </div>
</body>
</html>