%{--
  - Copyright (c) 2014 Daniel Asarnow
  --}%


<b>Options: </b>
<label for="Lines">Lines</label>
<g:if test="${xdim=='time'}">
  <g:checkBox name="Lines" onclick="updatePlotters(g2,this.checked)" checked="${false}"/>
</g:if>
<g:else>
  <g:checkBox name="Lines" onclick="updatePlotters(g,this.checked)" checked="${false}"/>
</g:else>