<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 11/29/13
  Time: 11:31 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="edu.sfsu.ntd.phenometrainer.Dataset" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>QDREC: Create Project</title>
  <meta name="layout" content="main" />
  <r:require modules="uploadr,jquery-validate"/>
  <g:javascript>

    $(document).ready( function() {

//      $('#datasetForm').addClass('validatedForm')
      $('.validatedForm').validate({
        rules: {
                  datasetName: {
                    minlength: 4,
                    required: true
                }
        }
      });

    });
  </g:javascript>
</head>
<body>
  <div id="subnav" class="nav">
    <ul class="nav">
      <li><a href="${createLink(action: 'index')}">Create Project</a></li>
      <li><a href="${createLink(action: 'index', params: [load:true])}">Load Project</a></li>
      <li><a href="${createLink(action: 'review', params: [load:datasetDir==null])}">Review Segmentation</a></li>
    </ul>
  </div>
  <div class="clearDiv"></div>
  <div class="content">
    <div class="clearDiv"></div>
    <div id="uploadDiv">
      <g:if test="${datasetDir==null}">
        <g:render template="loadForm" model="[dataset:dataset]"/>
      </g:if>
      <g:else>
        <g:render template="createForm" model="[datasetDir: datasetDir]"/>
      </g:else>
    </div>
    <div id="statusDiv">
      ${message}
    </div>
    <div id="spinner" style="display: none">
      <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading..."/>
    </div>
  </div>
</body>
</html>