<g:if test="${user != null}">
  <p>Successfully created user: ${user.username}. <a href="${createLink(controller:'login', action: 'auth')}">Login.</a></p>
</g:if>
<g:else>
  <p>Error creating user - username may be taken. <a href="${createLink(action: 'createUser')}">Retry.</a> </p>
</g:else>