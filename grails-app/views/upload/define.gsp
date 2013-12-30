%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%

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
  <r:require modules="jquery-validate"/>
  <g:javascript>

    function assocButtons() {
      $('#invertButton').click(function(){
        invertSelection($('#imageList'));
      });
      $('#clearButton').click(function(){
        clearSelection($('#imageList'));
      });
    }

    function invertSelection(list) {
      $(list).children().prop('selected',function(i,selected){return !selected;});
    }

    function clearSelection(list) {
      $(list).children().prop('selected',function(i){return false;});
    }

    $(document).ready( function() {
      assocButtons();

      $('.validatedForm').validate({
        rules: {
          subsetName: {
            minlength: 4,
            required: true
          }
        }
      });
    });
  </g:javascript>
</head>
<body>
  <h1>Subset Definition</h1>
  <div id="datasetDiv">
    <g:render template="dataset" model="[dataset: dataset]"/>
  </div>
  <div id="statusDiv">
    ${message}
  </div>
</body>
</html>