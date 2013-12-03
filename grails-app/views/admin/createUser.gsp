<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 11/30/13
  Time: 1:00 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>PhenomeTrainer: Create new user</title>
  <meta name='layout' content='main'/>
  <r:require modules="jquery-validate"/>
</head>
<body>
<g:javascript>

    $(document).ready(function() {
      $('.validatedForm').validate({
        rules: {
          username: {
            minlength: 4,
            required: true
          },
          password: {
            minlength: 5,
            required: true
          },
          passwordConfirm: {
            minlength: 5,
            equalTo: "#password",
            required: true
          }
        }
      });
    });
    /*$('.password').change(function() {
      if (!$('.validatedForm').valid()) {
        $('#passwordMessage').text("Passwords do not match!")
      } else {
        $('#passwordMessage').text("Passwords match.")
      }
    });*/
</g:javascript>
  <div id="createUserFormDiv">
  <g:formRemote name="createUserForm"
                url="[controller: 'admin', action: 'initUser']"
                class="validatedForm"
                before="if (\$('#createUserForm').valid()){"
                after="}"
                update="createUserResult">
    %{--<form method="post" action="${createLink(controller: 'admin', action: 'initUser')}" class="validatedForm" id="createUserForm">--}%
      <p>
        <label for="username">Username:</label>
        <g:textField name="username" maxlength="50"/>
      </p>
      <p>
        <label for="password">Password:</label>
        %{--<input type="password" name="password" id="password" class="password"/>--}%
        <g:passwordField name="password" class="password" />
      </p>
      <p>
        <label for="passwordConfirm">Confirm:</label>
        %{--<input type="password" name="password_confirm" id="passwordConfirm" class="password"/>--}%
        <g:passwordField name="passwordConfirm" class="password" />
        %{--<span id="passwordMessage"></span>--}%
      </p>
      %{--<button class='button' id="createUserSubmit">Submit</button>--}%
    <g:submitButton name="createUserSubmit" value="Submit" class="button"/>
    %{--</form>--}%
  </g:formRemote>
  </div>
  <div id="createUserResult"></div>
</body>
</html>