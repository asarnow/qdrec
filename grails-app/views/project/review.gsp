<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 12/31/13
  Time: 4:56 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>QDREC Review Segmentation</title>
  <meta name="layout" content="main"/>
  <r:require modules="jquery"/>
</head>
<body>
  <div id="subnav" class="nav">
    <ul class="nav">
      <li><a href="${createLink(action: 'index')}">Create Project</a></li>
      <li><a href="${createLink(action: 'index', params: [load:true])}">Load Project</a></li>
      <li><a href="${createLink(action: 'review')}">Review Segmentation</a></li>
    </ul>
  </div>
  <div class="clearDiv"></div>
  <div class="content">
    <h2>Review Segmentation</h2>
    <p>Segmented images should be checked to ensure they are sufficiently accurate.</p>
    <h3 class="project">Project: ${dataset.description}</h3>
    <g:if test="${!dataset.visible}">
      <span class="privateAlert">This is a private project. The token <i>${dataset.token}</i> is required to load this project.</span>
    </g:if>
    <div id="reviewDiv">
      <g:render template="reviewUI" model="[dataset: dataset, image:image, parasites: parasites]"/>
    </div>
    <div class="clearDiv"></div>
  </div>
</body>
</html>