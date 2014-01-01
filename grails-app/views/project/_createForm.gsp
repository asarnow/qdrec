<%@ page import="org.h2.util.MathUtils" %>
<h2>Create Project</h2>
<p>
  A project containing parasite images and the corresponding segmentations must be created or loaded.
</p>
<div id="datasetFormDiv">
    <g:form name="datasetForm"
                  url="[controller: 'project', action: 'createDataset']"
                  before="if (\$('#datasetForm').valid()){"
                  after="}"
                  class="validatedForm">
      <label for="datasetName">Project name:</label><g:textField name="datasetName"/><br />
      <g:hiddenField name="datasetDir" value="${datasetDir}"/>

      <br />
      <label for="visible">Public project</label>
      <g:checkBox name="visible" checked="${true}"/>
      <br />
      <h4 class="inline"><label for="segmentation">Segmentation</label></h4>
      <g:select name="segmentation" from="['Upload','Asarnow-Singh','Canny']" value="Asarnow-Singh"
                onchange="\$('#segUploadrDiv').toggle(this.value=='Upload');"/>


      <br />
      <g:submitButton style="display: none" name="datasetSubmit" value="Create Project" class="button" onclick="
                  if (\$('#datasetForm').valid()){ \$('#uploadDiv').hide(); \$('#spinner').show(); }"/>
    </g:form>
</div>


