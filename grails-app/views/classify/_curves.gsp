%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%
<g:if test="${curves?.size()>1}">
  <g:select name="curves" from="${curves}" multiple="true" size="${curves.size()}"/>
</g:if>
<g:else>
  <g:select name="curves" from="${curves}" multiple="false" size="1"/>
</g:else>