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
  <title>QDREC: Review Segmentation</title>
  <meta name="layout" content="main"/>
  <r:require modules="jquery,jquery-validate,jquery-ui"/>
  <g:javascript>

    function showOptions(segmentation) {
      if (segmentation === 'Asarnow-Singh') {
        $('#pcParamDiv').show();
        $('#cannyParamDiv').hide();
        $('#watershedParamDiv').hide();
      } else if (segmentation === 'Canny') {
        $('#pcParamDiv').hide();
        $('#cannyParamDiv').show();
        $('#watershedParamDiv').hide();
      } else if (segmentation === 'Watershed') {
        $('#pcParamDiv').hide();
        $('#cannyParamDiv').hide();
        $('#watershedParamDiv').show();
      }
    }

    function beginResegmentation() {
      $('#resegmentationButton').hide();
      $('#segmentationFormMeta').show();
      $('#reviewDiv').hide();
    }

    function cancelResegmentation() {
      $('#resegmentationButton').show();
      $('#segmentationFormMeta').hide();
      $('#reviewDiv').show();
    }

    function confirmResegmentation() {
      return confirm("Warning: all training data will be discarded. Are you sure?");
    }

    $(document).ready(function () {
      $('.validatedForm').validate({
        rules: {
          nscale: {
            number: true,
            required: true
          },
          minwl: {
            number: true,
            required: true
          },
          mult: {
            number: true,
            required: true
          },
          sigma: {
            number: true,
            required: true
          },
          noise: {
            number: true,
            required: true
          },
          sigmaCanny: {
            number: true,
            required: true
          },
          lowCanny: {
            number: true,
            required: true
          },
          highCanny: {
            number: true,
            required: true
          },
          hmin: {
            number: true,
            required: true
          },
          lighting: {
            number: true,
            required: true
          },
          minSize: {
            number: true,
            required: true
          },
          maxBorder: {
            number: true,
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
      <li><a href="${createLink(action: 'review')}">Review Segmentation</a></li>
      <li><a href="${createLink(controller: 'project', action: 'define')}">Define Subsets</a></li>
    </ul>
  </div>
  <div class="clearDiv"></div>
  <div class="content">
    <h2>Review Segmentation</h2>
    <p>Segmented images should be checked to ensure they are sufficiently accurate, and resegmented with new parameters if necessary.</p>
    <h3 class="project">Project: ${dataset.description}</h3>
    <g:if test="${!dataset.visible}">
      <span class="privateAlert">This is a private project. The token <i>${dataset.token}</i> is required to load this project.</span>
    </g:if>
    <div id="segmentationFormMeta" hidden="hidden">
      <g:render template="segmentationForm" model=""/>
    </div>
    <div id="reviewDiv">
      <g:render template="reviewUI" model="[dataset: dataset, image:image, parasites: parasites]"/>
    </div>
    <div id="spinner" style="display: none">
      <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading..."/>
    </div>
    <div class="clearDiv"></div>
  </div>
</body>
</html>