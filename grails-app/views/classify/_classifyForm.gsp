<g:form name="classifyForm"
        class="validatedForm"
        before="if (\$('#classifyForm').valid()){"
        after="}">
  <label for="datasetID">Select dataset:</label>
  <g:select name="datasetID" from="${datasets}" optionValue="description" optionKey="id" value="${datasetID}"
                    onchange="${remoteFunction(controller: "train", action: "subsets",
                            params: '\'datasetID=\' + this.value', onSuccess: "updateSubset(data,'#training');updateSubset(data,'#testing')")}"/>
  <br />
  <label for="trainSVM">Train SVM</label>
  <g:checkBox name="trainSVM" checked="${false}" />
  <div id="trainingDiv">
    <label for="trainingID">Select training set:</label>
    <g:select name="trainingID" from="${subsets}" optionKey="id" optionValue="description"/>
    <br />
    <label for="sigma">RBF Sigma:</label>
    <g:textField name="sigma" value="6.9414" />
    <br />
    <label for="boxConstraint">Soft-margin box constraint:</label>
    <g:textField name="boxConstraint" value="3.2789"/>
  </div>
  <div id="testingDiv">
    <label for="testingID">Select testing set:</label>
    <g:select name="testingID" from="${subsets}" optionKey="id" optionValue="description"/>
    <g:submitToRemote name="classifySubmit" class="button" value="Classify"
      url="[controller: 'classify', action: 'classify']" update="resultsDiv"/>
  </div>
</g:form>