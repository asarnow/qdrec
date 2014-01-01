<h2>Create Project</h2>
<p>
  A project containing parasite images and the corresponding segmentations must be created or loaded.
</p>
<div id="datasetFormDiv">
    <g:form name="datasetForm"
                  url="[controller: 'upload', action: 'createDataset']"
                  before="if (\$('#datasetForm').valid()){"
                  after="}"
                  class="validatedForm">
      <label for="datasetName">Project name:</label><g:textField name="datasetName"/><br />
      <g:hiddenField name="datasetDir" value="${datasetDir}"/>

      <br />
      <label for="visible">Public project</label>
      <g:checkBox name="visible" checked="${true}"/>

      <div id="imageUploadrDiv">
        <h4>Upload image files</h4>
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

      <h4 class="inline"><label for="segmentation">Segmentation</label></h4>
      <g:select name="segmentation" from="['Upload','Asarnow-Singh','Canny']" value="Asarnow-Singh"
                onchange="\$('#segUploadrDiv').toggle(this.value=='Upload');"/>

      <div id="segUploadrDiv" hidden>
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
      <br />
      <g:submitButton name="datasetSubmit" value="Create Project" class="button" onclick="
                  if (\$('#datasetForm').valid()){ \$('#uploadDiv').hide(); \$('#spinner').show(); }"/>
    </g:form>
</div>


