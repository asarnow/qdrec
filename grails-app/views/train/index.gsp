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
  <title>PhenomeTrainer: Training</title>
  <meta name="layout" content="main" />
  <g:javascript library="jquery" />
  <r:layoutResources/>
</head>
<body>
  <div id="main">

    <div id="trainDiv">
      <g:render template="trainUI" model="['dataset': dataset, 'subsets': dataset.subsets,
              'imageSubset': imageSubset, 'subset':subset, 'image':image, 'control':control, parasites: parasites]"/>
    </div>

    <div id="control" class="parasiteImage">
      %{--<canvas id="controlImageCanvas"></canvas>--}%
      <h4>${control.name}</h4>
      <img id="controlImg" class="parasiteImage" src="${createLink(action: 'image', params: [imageID: control.id])}" width="${control.width*control.displayScale}" height="${control.height*control.displayScale}" />
    </div>

    <div class="clearDiv"></div>

  </div>
</body>
</html>