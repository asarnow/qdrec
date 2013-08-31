<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 5/9/13
  Time: 5:41 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="edu.sfsu.ntd.phenometrainer.Dataset; edu.sfsu.ntd.phenometrainer.TrainState; edu.sfsu.ntd.phenometrainer.ParasiteTrainState" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Phenome Trainer</title>
  <meta name="layout" content="main" />

</head>
<body>
  <div id="main">
    <div>
      <g:form>
        <g:select name="datasetID" from="${datasets}" optionValue="description" optionKey="id" value="${datasetID}"/>
        <g:actionSubmit value="Switch" action="switchDataset" />
      </g:form>
    </div>

    <div id="trainDiv">
      <g:remoteLink action="prevImage" params="[imageIdx:imageIdx, imageID: imageID]" update="trainDiv"><button class="button">Prev</button></g:remoteLink>
        <g:remoteLink action="nextImage" params="[imageIdx:imageIdx, imageID: imageID]" update="trainDiv"><button class="button">Next</button></g:remoteLink>
      %{--<g:render template="trainUI" model="${pageScope.variables}"/>--}%
      <g:render template="trainUI" model="['datasetSize':datasetSize,'imageIdx':imageIdx,'imageID':imageID,'imageName':imageName,'controlID':controlID,'controlName':controlName,'parasites':parasites]"/>
    </div>

  </div>
</body>
</html>