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
  <r:layoutResources/>
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
    <div id="imageUploadrDiv">
      <h4>Upload images</h4>
      <uploadr:add name="imageUploadr"
              path="${imgDir}"
                direction="up"
                maxVisible="8"
                unsupported="${createLink(plugin: 'uploadr', controller: 'project', action: 'warning')}"
                rating="false"
                voting="false"
                colorPicker="false"
                allowedExtensions="png"
                noSound="true"
                maxSize="${2**20 * 50}" />
    </div>
    <div id="segUploadrDiv" hidden>
      <h4>Upload segmented images</h4>
      <uploadr:add name="segUploadr"
          path="${segDir}"
          direction="up"
          maxVisible="8"
          unsupported="${createLink(plugin: 'uploadr', controller: 'project', action: 'warning')}"
          rating="false"
          voting="false"
          colorPicker="false"
          allowedExtensions="png"
          noSound="true"
          maxSize="${2**20 * 50}" />
    </div>
    <div class="clearDiv"></div>
    <div id="uploadDiv">
      <g:if test="${datasetDir==null}">
        <g:render template="loadForm" model="[dataset:dataset]"/>
      </g:if>
      <g:else>
        <g:render template="createForm" model="[datasetDir: datasetDir]"/>
      </g:else>
      <div class="clearDiv"></div>
      <button type=button class="button" onclick="$('#datasetSubmit').click()">Create Project</button>
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