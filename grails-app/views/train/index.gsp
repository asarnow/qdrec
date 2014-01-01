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
  <title>QDREC: Annotate Data</title>
  <meta name="layout" content="main" />
  <r:require modules="jquery"/>
</head>
<body>
  <div id="subnav" class="nav">
    <ul class="nav">
      <li>
        <a href="${createLink(action: 'index')}">Annotate Data</a>
      </li>
      <li>
        <a href="${createLink(controller: 'classify', action: 'trainClassifier')}">Train Classifier</a>
      </li>
    </ul>
  </div>
  <div class="clearDiv"></div>
  <div class="content">
    <div id="main">
      <h2>Training Annotation</h2>
      <p>
        Training the classifier requires manual annotation of parasites as 'normal' (<span style="color:#0000ff">blue</span>) or 'degenerate' (<span style="color:#ff0000">red</span>).
      </p>
      <h3 class="project">Project: ${dataset.description}</h3>
      <g:if test="${!dataset.visible}">
        <span class="privateAlert">This is a private project. The token <i>${dataset.token}</i> is required to load this project.</span>
      </g:if>
      <div id="trainDiv">
        <g:render template="trainUI" model="['dataset': dataset, 'subsets': dataset.subsets,
                'imageSubset': imageSubset, 'subset':subset, 'image':image, 'control':control, done: done, parasites: parasites]"/>
      </div>

      <div id="control" class="parasiteImage">
        %{--<canvas id="controlImageCanvas"></canvas>--}%
        <h4 id="controlName">${control.name}</h4>
        <img id="controlImg" class="parasiteImage" src="${createLink(action: 'image', params: [imageID: control.id])}" width="${control.width*control.displayScale}" height="${control.height*control.displayScale}" />
      </div>

      <div class="clearDiv"></div>

    </div>
  </div>
</body>
</html>