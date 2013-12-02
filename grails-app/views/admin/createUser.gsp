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
  <g:javascript library="jquery" />
  <r:layoutResources/>
  <jqval:resources/>

</head>
<body>
<g:javascript>
    $('.validatedForm').validate({
      debug: true,
      submitHandler: function(form) {
        $.ajax({
          type:     'POST',
          data:     $(form).serialize(),
          url:      '${createLink(controller: 'admin', action: 'initUser')}',
          success:  function(data,textStatus){},
          error:    function(XMLHttpRequest,textStatus,errorThrown){}
        });
        return false;
      },
      invalidHandler: function(event, validator) {
          // 'this' refers to the form
          var errors = validator.numberOfInvalids();
          if (errors) {
            var message = errors == 1
              ? 'You missed 1 field. It has been highlighted'
              : 'You missed ' + errors + ' fields. They have been highlighted';
            $("div.error span").html(message);
            $("div.error").show();
          } else {
            $("div.error").hide();
          }
      },
      rules: {
        username: {
          minlength: 4,
          required: true
        },
        password: {
          minlength: 5,
          required: true
        },
        password_confirm: {
          minlength: 5,
          equalTo: "#password",
          required: true
        }
      }
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
  %{--<g:formRemote name="createUserForm" url="[controller: 'admin', action: 'initUser']" class="validatedForm">--}%
    <form method="post" action="${createLink(controller: 'admin', action: 'initUser')}" class="validatedForm" id="createUserForm">
      <p>
        <label for="username">Username:</label>
        <g:textField name="username" maxlength="50"></g:textField>
      </p>
      <p>
        <label for="password">Password:</label>
        <input type="password" name="password" id="password" class="password"/>
      </p>
      <p>
        <label for="passwordConfirm">Confirm:</label>
        <input type="password" name="password_confirm" id="passwordConfirm" class="password"/>
        <span id="passwordMessage"></span>
      </p>
      <button class='button' id="createUserSubmit">Submit</button>
    </form>
  %{--</g:formRemote>--}%
  </div>
<r:layoutResources/>
</body>
</html>