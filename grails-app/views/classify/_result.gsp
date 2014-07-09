<h3>%{--
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

${message}</h3>
<div id="numericalResult" hidden>
  <g:if test="${cm!=null}">
    <div id="confusionMatrixDiv" class="confusionMatrix">
      <table>
        <thead>
          <tr>
            Training Set Confusion Matrix
          </tr>
        </thead>
        <tbody>
          <tr>
            <td class="emptycell"></td>
            <td colspan="2" style="text-align: center; border: none;">Target Class</td>
          </tr>
          <tr>
            <td class="emptycell">Output Class</td>
            <td>Normal</td>
            <td>Degenerate</td>
          </tr>
          <tr>
            <td>Normal</td>
            <td>
              ${cm[0][0]}
            </td>
            <td>
              ${cm[0][1]}
            </td>
          </tr>
          <tr>
            <td>Degenerate</td>
            <td>
              ${cm[1][0]}
            </td>
            <td>
              ${cm[1][1]}
            </td>
          </tr>

        </tbody>
      </table>
    </div>
  </g:if>

  <g:if test="${Rtrain!=null}">
    <div id="trainResultDiv" class="result">
      <table>
        <thead>
          <tr>Training Set Results (cross-validated)</tr>
          <tr>
            <td>Image</td>
            <td>Response</td>
            <td>No. parasites</td>
          </tr>
        </thead>
        <tbody>
          <g:each in="${(0..<trainImages.size())}" var="i">
            <tr>
              <td>${trainImages[i]}</td>
              <td>${Rtrain[i][0].round(2)}</td>
              <td>${Rtrain[i][1]}</td>
            </tr>
          </g:each>
        </tbody>
      </table>
    </div>
  </g:if>

  <g:if test="${Rtest!=null}">
    <div id="testResultDiv" class="result">
      <table>
        <thead>
          <tr>
            Test Set Results
          </tr>
          <tr>
            <td>Image</td>
            <td>Response</td>
            <td>No. parasites</td>
          </tr>
        </thead>
        <tbody>
          <g:each in="${(0..<testImages.size())}" var="i">
            <tr>
              <td>${testImages[i]}</td>
              <td>${Rtest[i][0].round(2)}</td>
              <td>${Rtest[i][1]}</td>
            </tr>
          </g:each>
        </tbody>
      </table>
    </div>
  </g:if>
</div>