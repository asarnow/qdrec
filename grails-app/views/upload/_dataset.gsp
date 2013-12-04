<%@ page import="edu.sfsu.ntd.phenometrainer.Dataset" %>
<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 11/30/13
  Time: 10:20 PM
  To change this template use File | Settings | File Templates.
--%>

<div id="manageDiv">
  %{--<h3>Define subsets for ${dataset.description}</h3>--}%
  <h3>Define subsets for:<g:select name="datasetID" from="${Dataset.findAll()}" optionValue="description" optionKey="id" value="${dataset.id}"
                        onchange="${remoteFunction(controller: "upload", action: "dataset",
                                params: '\'datasetID=\' + this.value', update: 'datasetDiv')}"/></h3>
  <g:formRemote name="subsetForm" url="[controller: 'upload', action: 'createSubset']" update="manageDiv" class="validatedForm" onSuccess="assocButtons()">
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
    </div>
    <g:hiddenField name="datasetID" value="${dataset.id}" />
  </g:formRemote>

</div>