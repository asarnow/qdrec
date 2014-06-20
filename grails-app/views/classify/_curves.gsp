%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%
%{--<label for="curves">Available curves:</label>--}%
%{--
<br />
<g:if test="${curves?.size()>1}">
  <g:select name="curves" from="${curves}" multiple="true" size="${curves.size()}"/>
</g:if>
<g:else>
  <g:select name="curves" from="${curves}" multiple="false" size="1"/>
</g:else>--}%
<b>Display: </b>
<g:each in="${0..<curves.size()}">
  <label for="${xdim + it}">${curves[it]}</label>
  <g:if test="${xdim=='time'}">
    <g:checkBox name="${xdim + it}" onclick="g2.setVisibility(${it},this.checked)" checked="${true}"/>
  </g:if>
  <g:else>
    <g:checkBox name="${xdim + it}" onclick="g.setVisibility(${it},this.checked)" checked="${true}"/>
  </g:else>
</g:each>
