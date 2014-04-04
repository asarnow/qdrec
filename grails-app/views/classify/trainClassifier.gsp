%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%

<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 12/31/13
  Time: 4:11 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>QDREC: Train Classifier</title>
  <meta name="layout" content="main"/>
  <r:require modules="jquery-validate"/>
  <g:javascript>
    $(document).ready(function(){
        $('.validatedForm').validate({
            rules: {
              sigma: {
                number: true,
                required: true
              },
              boxConstraint: {
                number: true,
                required: true
              }
            }
          });

    $('input[name="classifier"]').change(function(){
        var classifier = $('input[name="classifier"]:checked').val();
            if (classifier == 0) {
              $('input[name="sigma"]').val("6.9414");
              $('label[for="sigma"]').text("Sigma")
              $('input[name="boxConstraint"]').val("3.2789");
              $('#parameterDiv').show();
            } else if (classifier == 1) {
              $('input[name="sigma"]').val("0.0498");
              $('label[for="sigma"]').text("KKT violation level")
              $('input[name="boxConstraint"]').val("0.0183");
              $('#parameterDiv').show();
            } else if (classifier == 2) {
              $('#parameterDiv').hide();
            }
      });

    });
  </g:javascript>
</head>
<body>
<div id="subnav" class="nav">
  <ul class="nav">
    <li>
      <a href="${createLink(controller: 'train', action: 'index')}">Annotate Data</a>
    </li>
    <li>
      <a href="${createLink(action: 'trainClassifier')}">Train Classifier</a>
    </li>
  </ul>
</div>
<div class="clearDiv"></div>
<div class="content">
  <h2>Train Classifier</h2>
  <p>A new classifier can be trained using manual annotations for the specified subset. This step is optional as an existing classifier is also available.</p>
  <div id="trainingDiv">
    <g:form name="trainForm"
        class="validatedForm"
        before="if (\$('#trainForm').valid()){"
        after="}">
      <h3 class="project"><label for="datasetID">Project: ${dataset.description}</label></h3>
      <g:if test="${!dataset.visible}">
        <span class="privateAlert">This is a private project. The token <i>${dataset.token}</i> is required to load this project.</span>
      </g:if>
      <g:hiddenField name="datasetID" value="${dataset.id}"/>
      <br />
      <label for="trainingID">Select training set:</label>
      <g:select name="trainingID" from="${subsets}" optionKey="id" optionValue="description"/>
      <br />

      <label>Select classifier:</label>
      <g:radioGroup labels="['SVM (RBF)','SVM (Linear)','Naive Bayes']" name="classifier" values="[0,1,2]" value="0">
        ${it.label} ${it.radio}
      </g:radioGroup>
      <br />

      <div id="parameterDiv">
        <label for="sigma">RBF Sigma:</label>
        <g:textField name="sigma" value="6.9414" />
        <br />
        <label for="boxConstraint">Soft-margin box constraint:</label>
        <g:textField name="boxConstraint" value="3.2789"/>
      </div>

      <g:if test="${svmsFileExists}">
        <p>A <b>${classifierType}</b> classifier already exists for this project and will be replaced.</p>
        <g:submitToRemote name="classifySubmit" class="button" value="Replace Classifier"
                url="[controller: 'classify', action: 'trainSVM']" update="resultsDiv"
                onLoading="\$('#resultsDiv').hide();\$('#spinner').show()" onComplete="\$('#spinner').hide();\$('#resultsDiv').show();\$('#numericalResult').show()"/>
      </g:if>
      <g:else>
        <br />
        <g:submitToRemote name="classifySubmit" class="button" value="Create Classifier"
              url="[controller: 'classify', action: 'trainSVM']" update="resultsDiv"
              onLoading="\$('#resultsDiv').hide();\$('#spinner').show()" onComplete="\$('#spinner').hide();\$('#resultsDiv').show();\$('#numericalResult').show()"/>
      </g:else>
    </g:form>
  </div>
  <div id="resultsDiv">
  </div>
  <div id="spinner" style="display: none">
    <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading..."/>
  </div>
</div>
</body>
</html>