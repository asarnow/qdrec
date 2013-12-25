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

      <h4 style="display: inline;"><label for="segmentation">Segmentation</label></h4>
      %{--<g:checkBox name="uploadSegmented" checked="${false}" onchange="\$('#segUploadrDiv').toggle(this.checked)"/>--}%
      <g:select name="segmentation" from="['Upload','Proposed','Canny']" value="Proposed"
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
      <g:submitButton name="datasetSubmit" value="Create" class="button" />
    </g:form>
</div>


