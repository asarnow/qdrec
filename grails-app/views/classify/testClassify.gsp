%{--
  - Copyright (c) 2013 Daniel Asarnow
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
  <title>PhenomeTrainer: Classifier</title>
  <meta name="layout" content="main" />
  <r:require modules="jquery-validate"/>
  <g:javascript>

    function updateSubset(data,elem) {
        if (data) {
          var rselect = $(elem);
          rselect.empty();
          $.each(data, function (k, v) {
            rselect.append($("<option></option>").val(v.id).text(v.description));
          });
        }
      }

    $(document).ready(function(){
      $('#trainingDiv').hide();
      $('#trainSVM').change(function(){
        $('#trainingDiv').toggle(this.checked);
      });
      $('.validatedForm').validate({
        rules: {
          sigma: {
            number: true,
            required: true
          },
          boxConstraint: {
            number: true,
            required: true
          }
        }
      });
    });
  </g:javascript>
</head>
<body>
  <div id="classifyDiv">
    <g:render template="classifyForm" model="[dataset:dataset, subsets:subsets]"/>
  </div>
  <div id="resultsDiv">
    <g:render template="result" model="[cm: cm,
                              Rtrain: Rtrain,
                              Rtest: Rtest,
                              trainImages: trainImages,
                              testImages: testImages]" />
  </div>
</body>
</html>