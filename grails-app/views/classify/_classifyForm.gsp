<g:form name="classifyForm"
        class="validatedForm"
        before="if (\$('#classifyForm').valid()){"
        after="}">
  <h3><label for="datasetID">Classify in project: ${dataset.description}</label></h3>
  <g:hiddenField name="datasetID" value="${dataset.id}"/>
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