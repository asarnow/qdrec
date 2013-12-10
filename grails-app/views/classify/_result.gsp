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
            <td>${testImages[i]}</td>
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