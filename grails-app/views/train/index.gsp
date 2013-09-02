<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 5/9/13
  Time: 5:41 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="edu.sfsu.ntd.phenometrainer.Dataset; edu.sfsu.ntd.phenometrainer.TrainState; edu.sfsu.ntd.phenometrainer.ParasiteTrainState" contentType="text/html;charset=UTF-8" %>
<g:javascript>
  function updateSubset(data) {
    if (data) {
      var rselect = $("#subset");
      rselect.empty();
      $.each(data, function (k, v) {
        rselect.append($("<option></option>").val(v.id).text(v.description));
      });
    }
  }
</g:javascript>
<html>
<head>
  <title>Phenome Trainer</title>
  <meta name="layout" content="main" />
</head>
<body>
  <div id="main">
    <div>
      <h4>Subset "${subset.description}" selected from dataset "${dataset.description}"</h4>
      <g:form>
        <g:select name="datasetID" from="${datasets}" optionValue="description" optionKey="id" value="${dataset.id}"
                  onchange="${remoteFunction(controller: "train", action: "subsets",
                          params: '\'datasetID=\' + this.value', onSuccess: "updateSubset(data)")}"/>
        <g:select name="subsetID" id="subset" from="${subsets}" optionValue="description" optionKey="id" value="${subset.id}"/>
        <g:actionSubmit value="Switch" action="switchDataset" />
      </g:form>
    </div>

    <div id="trainDiv">
      <g:render template="trainUI" model="['imageSubset': imageSubset, 'subset':subset, 'image':image, 'control':control, parasites: parasites]"/>
    </div>

  </div>
</body>
</html>