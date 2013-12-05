<g:form class="validatedForm">
  <label for="datasetID">Select dataset:</label>
  <g:select name="datasetID" from="${datasets}" optionValue="description" optionKey="id" value="${datasetID}"
                    onchange="${remoteFunction(controller: "train", action: "subsets",
                            params: '\'datasetID=\' + this.value', onSuccess: "updateSubset(data,'#training');updateSubset(data,'#testing')")}"/>
  <label for="trainSVM">Train SVM</label>
  <g:checkBox name="trainSVM" checked="${false}" />
  <div id="trainingDiv">
    <label for="trainingID">Select training set:</label>
    <g:select name="trainingID" from="${subsets}" optionKey="id" optionValue="description"/>
    <label for="sigma">RBF Sigma:</label>
    <g:textField name="sigma" value="6.9414" />
    <label for="boxConstraint">Soft-margin box constraint:</label>
    <g:textField name="boxConstraint" value="3.2789"/>
  </div>
  <br />
  <label for="testingID">Select testing set:</label>
  <g:select name="testingID" from="${subsets}" optionKey="id" optionValue="description"/>
  <g:submitToRemote name="classifySubmit" class="button" value="Go!"
    url="[controller: 'classify', action: 'classify']" update="resultsDiv"/>
</g:form>