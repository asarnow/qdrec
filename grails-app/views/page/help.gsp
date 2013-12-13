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
  <div class="help">
    <h2>QDREC Usage Instructions</h2>
    <p>
      Please carefully peruse the following instructions before using QDREC. Failure to follow these instructions
      precisely will lead to errors. Some example data for use with QDREC is provided below.
    </p>
    <h2>Upload Data</h2>
    <p>
      Two sets of files must be uploaded to create a distinct data set in QDREC, namely
      parasite images and segmented parasite images. An archive containing example images with comply with the requirements
      enumerated below may be downloaded <a href="${resource(dir: 'download', file: 'QDREC_Example_Data.zip')}">here</a>.
    </p>
    <p>
      The data set must also be given a unique, descriptive name of at least 4 characters in length.
    </p>
    Both sets of images must conform strictly to the following requirements:
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
      approach described in the <a href="${createLink(action: 'about')}">publication</a>.
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
      Subsets are defined by selected multiple images from a data set,
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
    <h2>Manual Annotation</h2>
    <p>
      The first step in training is to select the appropriate data set and subset from the menus at the top of the training
      interface. Once selected, click <button class="button">Switch</button> to switch to chosen set of images.
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
      The Trainer will remember your progress, so if at any time you would like a break from training, just log out.
      When you log in again, you will be able to pick up with the image where you left off.
    </p>
    <h2>Classification</h2>
    <p>
      First, select the appropriate data set from the drop-down list of available data sets.
    </p>
    <p>
      If the existing classifier is to be used, simply select a subset from the second drop-down list, and click
      <button class="button">Classify</button>.
    </p>
    <p>
      If a new classifier should be trained, check the "Train SVM" box. Three new fields will appear. The first is an
      additional drop-down menu for selection of the subset for training. This should be a different set than that used for
      testing. The other two fields (labeled "RBF Sigma" and "Soft-margin box constraint," respectively) are parameters within
      by the SVM classifier. For details, refer to the <a href="${createLink(action: 'about')}">publication</a>. It should
      be fine to leave the parameters set to their default values.
    </p>
  </div>
</body>
</html>