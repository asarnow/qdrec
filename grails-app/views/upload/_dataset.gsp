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
  <g:formRemote name="subsetForm" url="[controller: 'upload', action: 'createSubset']"
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
              onchange="${remoteFunction(controller: 'upload', action: 'allimages', onSuccess: "updateSelect(data,'#controls')")}"
              noSelection="['':'Select Image']"/>
    <g:select name="controls" from="[]" optionValue="name" optionKey="id" noSelection="['':'Select Control']"/>
    <button class="button" type="button" onclick="${remoteFunction(action: 'addcontrol',
          params: '\'imageID=\'+\$(\'#nocontrol\').val()+\'&controlID=\'+$(\'#controls\').val()',
            onSuccess: 'rem = $(\'#nocontrol\').val();\$(\'#nocontrol option[value=\'+rem+\']\').remove()')}">Add Control</button>
  </g:if>
</div>