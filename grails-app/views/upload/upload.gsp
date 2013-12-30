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
  <title></title>
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
  <h1>Project Selection</h1>
  <div id="metaUploadDiv">
    <g:form controller="upload" action="project" method="GET">
      <g:radioGroup name="load"
                values="[true,false]"
                value="${datasetDir==null}"
                labels="['Load existing project','Create new project']"
                onchange="submit()">
        <p>${it.label} ${it.radio}</p>
      </g:radioGroup>
    </g:form>
  </div>
  <div class="clearDiv"></div>
  <div id="uploadDiv">
    <g:if test="${datasetDir==null}">
      <g:render template="loadForm"/>
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
</body>
</html>