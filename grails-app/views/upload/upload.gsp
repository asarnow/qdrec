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
  <r:require modules="uploadr"/>
  <g:javascript>

    function invertSelection(list) {
      $(list).children().prop('selected',function(i,selected){return !selected;});
    }

    function clearSelection(list) {
      $(list).children().prop('selected',function(i){return false;});
    }

    $(document).ready( function() {
      $('#invertButton').click(function(){
        invertSelection($('#imageList'));
      });
      $('#clearButton').click(function(){
        clearSelection($('#imageList'));
      });
    });
  </g:javascript>
</head>
<body>
  <div id="uploadDiv">
    <g:if test="${skipUpload}">
      <g:render template="dataset" model="[datasetDir: datasetDir, dataset: Dataset.get(skipUpload)]"/>
    </g:if>
    <g:else>
      <g:render template="uploadForm" model="[datasetDir: datasetDir]"/>
    </g:else>

  </div>
  <div id="statusDiv">

  </div>

</body>
</html>