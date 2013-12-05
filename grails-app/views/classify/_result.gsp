<g:if test="${cm!=null}">
  <div id="confusionMatrixDiv">
    <table>
      <thead>
        <tr>
          Cross-validated confusion matrix
        </tr>
        <tr>
          <td></td>
          <td></td>
        </tr>
      </thead>
      <tbody>
        <g:each in="${cm}">
          <tr>
            <td>
              ${it[0]}
            </td>
            <td>
              ${it[1]}
            </td>
          </tr>
        </g:each>
      </tbody>
    </table>
  </div>
</g:if>

<g:if test="${Rtrain!=null}">
  <div id="trainResultDiv">
    <table>
      <thead>
        <tr>Cross-validated Training</tr>
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
  <div id="testResultDiv">
    <table>
      <thead>
        <tr>
          Testing
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