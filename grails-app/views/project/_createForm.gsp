%{--
  - Copyright (C) 2014 Daniel Asarnow
  - San Francisco State University
  -
  - This program is free software: you can redistribute it and/or modify
  - it under the terms of the GNU General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - This program is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU General Public License
  - along with this program.  If not, see <http://www.gnu.org/licenses/>.
  --}%

<%@ page import="org.h2.util.MathUtils" %>
<h2>Create Project</h2>
<p>
  A project containing parasite images and the corresponding segmentations must be created or loaded.
</p>
<div id="datasetFormDiv">
    <g:formRemote name="datasetForm"
                  url="[controller: 'project', action: 'createDataset']"
                  before="if (\$('#datasetForm').valid()){"
                  after="}"
                  class="validatedForm"
                  onLoading="\$('#uploadDiv').hide(); \$('#spinner').show();"
                  onSuccess="
                  var t = data;
                  if (t.substring(0,1)==='/') {
                    document.location.href = t;
                  } else {
                    \$('#verdict').text(t);
                  }"
                  onFailure="\$('#spinner').hide();
                  \$('#uploadDiv').show();
                  \$('#verdict').text('Project creation failed. Please review project specifications.');">
      <label for="datasetName">Project name:</label><g:textField name="datasetName"/>
      <span id="verdict">${message}</span>
      <g:hiddenField name="datasetDir" value="${datasetDir}"/>
      <br />
      <label for="visible">Public project</label>
      <g:checkBox name="visible" checked="${true}"/>
      <br />
      <h4 class="inline"><label for="segmentation">Segmentation</label></h4>
      <g:select name="segmentation" from="['Upload','Asarnow-Singh','Canny','Watershed']" value="Asarnow-Singh"
                onchange="\$('#segUploadrDiv').toggle(this.value=='Upload');"/>


      <br />
      %{--<g:submitButton style="display: none" name="datasetSubmit" value="Create Project" class="button" onclick="
                  if (\$('#datasetForm').valid()){ \$('#uploadDiv').hide(); \$('#spinner').show(); }"/>--}%
      <g:submitButton style="display: none" name="datasetSubmit" value="Create Project" class="button"/>
    </g:formRemote>
</div>


