%{--
  - Copyright (C) 2014
  - Daniel Asarnow
  - Rahul Singh
  - San Francisco State University
  -
  - This program is free software: you can redistribute it and/or modify
  - it under the terms of the GNU Affero General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - This program is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU Affero General Public License
  - along with this program.  If not, see <http://www.gnu.org/licenses/>.
  --}%

<%@ page import="edu.sfsu.ntd.phenometrainer.Dataset" %>
<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 11/30/13
  Time: 10:20 PM
  To change this template use File | Settings | File Templates.
--%>

<div id="manageDiv">
  <h3 class="project">Project: ${dataset.description}</h3>
  <g:if test="${dataset.visible}">
    The token <i>${dataset.token}</i> may be used to load this project directly.
  </g:if>
  <g:else>
    <span class="privateAlert">This is a private project. The token <i>${dataset.token}</i> is required to load this project.</span>
  </g:else>
  <div class="clearDiv"></div>
  <g:formRemote name="subsetForm" url="[controller: 'project', action: 'createSubset']"
                update="manageDiv"
                class="validatedForm"
                onSuccess="assocButtons()"
                before="if (\$('#subsetForm').valid()){"
                after="}">
    <div id="imageListDiv">
      <g:render template="imageList" model="[dataset: dataset, imageIDs: []]"/>
    </div>
    <div id="subsetDiv">
      <g:render template="subset" model="[subsets: dataset.subsets]"/>
      <br/>
      <label for="subsetName">New subset:</label>
      <br/>
      <g:textField name="subsetName" id="subsetName" />
    <g:submitButton name="subsetSubmit" value="Define" class="button"/>
      <br />
      ${message}
    </div>
    <g:hiddenField name="datasetID" value="${dataset.id}" />
  </g:formRemote>
  <g:if test="${nocontrol?.size()>0}">
    <p>Some images are missing a control. Please manually add controls for these images and try again.</p>
    <g:select name="nocontrol" from="${nocontrol}" optionKey="id" optionValue="name" value="${nocontrol.first()}"
              onchange="${remoteFunction(controller: 'project', action: 'allimages', onSuccess: "updateSelect(data,'#controls')")}"
              noSelection="['':'Select Image']"/>
    <g:select name="controls" from="[]" optionValue="name" optionKey="id" noSelection="['':'Select Control']"/>
    <button class="button" type="button" onclick="${remoteFunction(action: 'addcontrol',
          params: '\'imageID=\'+\$(\'#nocontrol\').val()+\'&controlID=\'+$(\'#controls\').val()',
            onSuccess: 'rem = $(\'#nocontrol\').val();\$(\'#nocontrol option[value=\'+rem+\']\').remove()')}">Add Control</button>
  </g:if>
</div>