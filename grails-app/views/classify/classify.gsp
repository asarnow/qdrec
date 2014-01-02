<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 12/1/13
  Time: 4:35 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="edu.sfsu.ntd.phenometrainer.Dataset" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>QDREC: Run Classifier</title>
  <meta name="layout" content="main" />
  <r:require modules="jquery-validate"/>
  <g:javascript src="dygraph-combined.js"/>
  <g:javascript>
    var g;
    var g2;

    function updateSubset(data,elem) {
        if (data) {
          var rselect = $(elem);
          rselect.empty();
          $.each(data, function (k, v) {
            rselect.append($("<option></option>").val(v.id).text(v.description));
          });
        }
      }

    function updateCurves() {
        ${remoteFunction(action: 'curves', update: 'curves2',
                     params: '\'xdim=time\'+\'&compound=\'+$(\'#compound\').val()', method: 'GET')}

        ${remoteFunction(action: 'curves', update: 'curves1',
                     params: '\'xdim=conc\'+\'&compound=\'+$(\'#compound\').val()', method: 'GET')}

    }

    function destroyPlots() {
        if (typeof g !== 'undefined') g.destroy();
        if (typeof g2 !== 'undefined') g2.destroy();
    }

    $(document).ready(function(){
      $('#trainingDiv').hide();
      $('#trainSVM').change(function(){
        $('#trainingDiv').toggle(this.checked);
      });
    });
  </g:javascript>
</head>
<body>
  <div id="subnav" class="nav">
    <ul class="nav">

    </ul>
  </div>
  <div class="clearDiv"></div>
  <div class="content">
    <h1>Classification and Response Calculation</h1>
    <p>
      Select a subset and a classifier to use in calculating phenotypic responses. The existing classifier has be found
      to be highly accurate.
    </p>
    <div id="classifyDiv">
      <g:render template="classifyForm" model="[dataset:dataset, subsets:subsets, svmsFileExists: svmsFileExists]"/>
    </div>
    <div id="resultsDiv">
    </div>
    <div id="spinner" style="display: none">
      <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading..."/>
    </div>
  </div>
</body>
</html>