<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><g:layoutTitle default="Grails"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
    <g:layoutHead/>
    <r:layoutResources />
	</head>
	<body>
    <div id="title">
      <a class="logout" href="${createLink(controller: 'logout')}">Logout</a>
      <h1>QDREC</h1>
      <div class="nav">
        <ul>
          <li>
            <a href="${createLink(controller: 'upload', action: 'index')}">Upload</a>
            <a href="${createLink(controller: 'upload', action: 'define')}">Define</a>
            <a href="${createLink(controller: 'train', action: 'index')}">Train</a>
            <a href="${createLink(controller: 'classify', action: 'index')}">Classify</a>
            <a href="${createLink(controller: 'page', action: 'help')}">Instructions</a>
          </li>
        </ul>
      </div>
    </div>

		<g:layoutBody/>
		<div class="footer" role="contentinfo"></div>
		%{--<g:javascript library="application"/>--}%
		<r:layoutResources />
	</body>
</html>
