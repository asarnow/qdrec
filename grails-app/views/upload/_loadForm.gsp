<%@ page import="edu.sfsu.ntd.phenometrainer.Dataset" %>
%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%

<div id='datasetFormDiv'>
  <g:form name='datasetForm' action="load">
    <label for="datasetID">Select project from list:</label>
    <g:select name="datasetID" from="${Dataset.findWhere(visible:true)}" optionValue="description" optionKey="id" noSelection="${[0L:'none']}"/>
    <h4>OR</h4>
    <label for="token">Enter project token:</label>
    <g:textField name="token"/>
    <button class="button" type="button" onclick="${remoteFunction(action: 'datasetInfo',
            params: '{token: $(\'#token\').val()}', update: 'datasetInfo', method: 'GET')}">Check</button>
    <span id="datasetInfo"></span>
    <br />
    <g:submitButton name="datasetSubmit" class="button" value="Load project"/>
  </g:form>
</div>