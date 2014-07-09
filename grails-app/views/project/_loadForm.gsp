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

<%@ page import="edu.sfsu.ntd.phenometrainer.Dataset" %>
%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%
<h2>Load Project</h2>
<p>
  A project containing parasite images and the corresponding segmentations must be created or loaded.
</p>
<div id='datasetFormDiv'>
  <g:form name='datasetForm' action="load">
    <label for="datasetID">Select project from list:</label>
    <g:select name="datasetID" from="${Dataset.findAllByVisible(true)}" optionValue="description" optionKey="id" noSelection="${[0L:'none']}"
              onchange="${remoteFunction(action: 'datasetInfo',
                      params: '\'datasetID=\'+this.value',
                      onSuccess: '\$(\'#token\').val(data)',
                      method: 'GET')}"/>
    <h4>OR</h4>
    <label for="token">Enter project identifier:</label>
    <g:textField name="token"/>
    %{--<button class="button" type="button" onclick="${remoteFunction(action: 'datasetInfo',
            params: '{token: $(\'#token\').val()}', update: 'datasetInfo', method: 'GET')}">Check</button>
    <span id="datasetInfo"></span>--}%
    <br />
    <g:submitButton name="datasetSubmit" class="button" value="Load Project"/>
  </g:form>
</div>
<g:if test="${dataset!=null}">
  <div id='projectInfo'>
    <table>
      <thead>
        <tr>
          Loaded Project
        </tr>
        <tr>
          <td>
            Project
          </td>
          <td>
            Identifier
          </td>
          <td>
            Visibility
          </td>
          <td>
            Size
          </td>
          <td>
            Subsets
          </td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>
            ${dataset.description}
          </td>
          <td>
            <i>${dataset.token}</i>
          </td>
          <td>
            <g:if test="${dataset.visible}">
              <b>public</b>
            </g:if>
            <g:else>
              <b>private</b>
            </g:else>
          </td>
          <td>
            ${dataset.size}
          </td>
          <td>
            ${dataset.subsets.description.join(', ')}
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</g:if>