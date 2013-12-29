%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%
<label for="curves">Available curves:</label>
<br />
<g:if test="${curves?.size()>1}">
  <g:select name="curves" from="${curves}" multiple="true" size="${curves.size()}"/>
</g:if>
<g:else>
  <g:select name="curves" from="${curves}" multiple="false" size="1"/>
</g:else>