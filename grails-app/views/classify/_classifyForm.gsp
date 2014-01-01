<g:form name="classifyForm"
        class="validatedForm"
        before="if (\$('#classifyForm').valid()){"
        after="}">
  <h3 class="project"><label for="datasetID">Project: ${dataset.description}</label></h3>
  <g:if test="${!dataset.visible}">
    <span class="privateAlert">This is a private project. The token <i>${dataset.token}</i> is required to load this project.</span>
  </g:if>
  <g:hiddenField name="datasetID" value="${dataset.id}"/>
  <div id="testingDiv">
    <label for="testingID">Select testing set:</label>
    <g:select name="testingID" from="${subsets}" optionKey="id" optionValue="description"/>
    <br />
    <g:if test="${svmsFileExists}">
      <label for="useSVM">Choose classifer:</label>
      <br />
      <g:radioGroup name="useSVM"
                values="['existing','new']"
                value="new"
                labels="['Existing','Trained']">
        <p style="float: left;">${it.label} ${it.radio}</p>
      </g:radioGroup>
      <div class="clearDiv"></div>
    </g:if>
    <g:else>
      <g:hiddenField name="useSVM" value="existing"/>
      <p>
        No new classifier trained. Will use existing classifier.
      </p>
    </g:else>
    <g:submitToRemote name="classifySubmit" class="button" value="Classify"
      url="[controller: 'classify', action: 'classify']" update="resultsDiv"
      onLoading="\$('#resultsDiv').hide();\$('#spinner').show()" onComplete="\$('#spinner').hide();\$('#resultsDiv').show()"/>
  </div>
</g:form>