%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%
<g:if test="${dataset==null}">
  Project not found
</g:if>
<g:else>
  Project found: ${dataset.description}.
</g:else>