<g:if test="${cm!=null}">
  <div id="confusionMatrixDiv">
    ${cm}
  </div>
</g:if>

<g:if test="${Rtrain!=null}">
  <div id="trainResultDiv">
    ${Rtrain} ${trainImages}
  </div>
</g:if>

<g:if test="${Rtest!=null}">
  <div id="testResultDiv">
    ${Rtest} ${testImages}
  </div>
</g:if>