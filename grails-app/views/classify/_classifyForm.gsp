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
                labels="['Existing','Trained']"
                onchange="svmSelection('${classifierType}');">
        <p style="float: left;">${it.label} ${it.radio}</p>
      </g:radioGroup>
      <div class="clearDiv"></div>
      <p id="svmMessage">Will use new <b>${classifierType}</b> classifier.</p>
    </g:if>
    <g:else>
      <g:hiddenField name="useSVM" value="existing"/>
      <p>
        No new classifier trained. Will use existing <b>SVM (RBF)</b> classifier.
      </p>
    </g:else>
    <g:submitToRemote name="classifySubmit" class="button" value="Classify"
      url="[controller: 'classify', action: 'classify']" update="resultsDiv"
      onLoading="\$('#resultsDiv').hide();\$('#spinner').show()" onComplete="\$('#spinner').hide();\$('#resultsDiv').show()"/>
  </div>
</g:form>