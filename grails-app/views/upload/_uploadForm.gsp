<div id="imageUploadrDiv">
  <h3>Upload image files</h3>
  <uploadr:add name="imageUploadr"
    path="${datasetDir + File.separator}img"
    direction="up"
    maxVisible="8"
    unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}"
    rating="false"
    voting="false"
    colorPicker="false"
    allowedExtensions="png"
    noSound="true"
    maxSize="${2**20 * 50}" />
</div>
<div id="segUploadrDiv">
  <h3>Upload segmented image files</h3>
  <uploadr:add name="segUploadr"
    path="${datasetDir + File.separator}bw"
    direction="up"
    maxVisible="8"
    unsupported="${createLink(plugin: 'uploadr', controller: 'upload', action: 'warning')}"
    rating="false"
    voting="false"
    colorPicker="false"
    allowedExtensions="png"
    noSound="true"
    maxSize="${2**20 * 50}" />
</div>
<div id="datasetFormDiv">
    <g:formRemote name="datasetForm"
                  url="[controller: 'upload', action: 'createDataset']"
                  update="uploadDiv"
                  before="if (\$('#datasetForm').valid()){"
                  after="}"
                  class="validatedForm">
      <label for="datasetName">Type a name for this data set:</label><g:textField name="datasetName"/><br />
      <g:hiddenField name="datasetDir" value="${datasetDir}"/>
      <g:submitButton name="datasetSubmit" value="Submit" class="button" />
    </g:formRemote>
</div>