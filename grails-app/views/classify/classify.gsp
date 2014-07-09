%{--
  - Copyright (C) 2014 Daniel Asarnow
  - San Francisco State University
  -
  - This program is free software: you can redistribute it and/or modify
  - it under the terms of the GNU General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - This program is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU General Public License
  - along with this program.  If not, see <http://www.gnu.org/licenses/>.
  --}%

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
  <g:javascript src="dygraph-ext.js"/>
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
        ${remoteFunction(action: 'options', update: 'options2',
                         params: '\'xdim=time\'', method: 'GET')}
        ${remoteFunction(action: 'options', update: 'options1',
                         params: '\'xdim=conc\'', method: 'GET')}
    }

    function updatePlotters(g,lines) {
        if (lines) {
          g.updateOptions({
            fillAlpha: 0.15,
            plotter: [Dygraph.Plotters.fillPlotter, Dygraph.Plotters.errorPlotter, Dygraph.Plotters.linePlotter]
          });
        } else {
          g.updateOptions({
            fillAlpha: 0.85,
            plotter: [DygraphCanvasRenderer.errorBarPlotter, DygraphCanvasRenderer.pointPlotter]
          });
        }
    }

    function destroyPlots() {
        if (typeof g !== 'undefined') g.destroy();
        if (typeof g2 !== 'undefined') g2.destroy();
    }

    function svmSelection(classifierType) {
        var classifier = $('input[name="useSVM"]:checked').val();
        if (classifier === "new") {
            $('#svmMessage').html("Will use new <b>" + classifierType + "</b> classifier.")
        } else {
            $('#svmMessage').html("Will use existing <b>SVM (RBF)</b> classifier.")
        }
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
      <li><a href="${createLink(action: 'index')}">Run Classifier</a></li>
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
      <g:render template="classifyForm" model="[dataset:dataset, subsets:subsets, svmsFileExists: svmsFileExists, classifierType: classifierType]"/>
    </div>
    <div id="resultsDiv">
    </div>
    <div id="spinner" style="display: none">
      <img src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading..."/>
    </div>
  </div>
</body>
</html>