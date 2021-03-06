<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>%{--
  - Copyright (C) 2014
  - Daniel Asarnow
  - Rahul Singh
  - San Francisco State University
  -
  - This program is free software: you can redistribute it and/or modify
  - it under the terms of the GNU Affero General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - This program is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU Affero General Public License
  - along with this program.  If not, see <http://www.gnu.org/licenses/>.
  --}%

<g:layoutTitle default="Grails"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
    <g:layoutHead/>
    <r:layoutResources />
    <ga:trackPageview />
	</head>
	<body>
    <div id="topbar">
      <div id="leftbar">
        <div id="toplogo">
              <a href="http://tintin.sfsu.edu"><img src="${resource(dir: 'images', file: 'sfsu.png')}"/></a>
              <a href="http://tintin.sfsu.edu"><h1>Biocomputing and Media Resarch Lab</h1></a>
              <div class="clearDiv"></div>
        </div>
        <div id="title">
          %{--<sec:ifLoggedIn>
            <a class="logout" href="${createLink(controller: 'logout')}">Logout</a>
          </sec:ifLoggedIn>
          <sec:ifNotLoggedIn>
            <a class="logout" href="${createLink(controller: 'login')}">Login</a>
          </sec:ifNotLoggedIn>--}%
          <a href="${createLink(controller: 'page', action: 'home')}"><img src="${resource(dir: 'images', file: 'schistosoma.png')}"/></a>
          <a href="${createLink(controller: 'page', action: 'home')}"><h1>QDREC</h1></a>
          <a href="${createLink(controller: 'page', action: 'home')}"><h2>Quantal Dose Response Calculator</h2></a>
        </div>
        <div class="nav">
          <ul class="nav">
            <li><a href="${createLink(controller: 'page', action: 'home')}">Home</a></li>
            <li><a href="${createLink(controller: 'project', action: 'index', params: [load:session['datasetID']!=null])}">Create Project</a></li>
            <li><a href="${createLink(controller: 'train', action: 'index')}">Create New Classifier</a></li>
            <li><a href="${createLink(controller: 'classify', action: 'index')}">Run Classifier</a></li>
          </ul>
        </div>
      </div>
      <div id="rightbar">
        <ul class="nav">
          <li>
            <a href="${createLink(controller: 'page', action: 'help')}">Help</a>
          </li>
          <li>
            <a href="${createLink(controller: 'page', action: 'tutorial')}">Sample Screening Data and Tutorial</a>
          </li>
          <li>
            <a href="http://tintin.sfsu.edu/projects/phenotypicAssays.html">Source Code and Data Sets</a>
          </li>
          <li class="bottom">
            <a href="${createLink(controller: 'page', action: 'about')}">About</a>
          </li>
        </ul>
      </div>
    </div>
    <div class="clearDiv"></div>
    <g:layoutBody/>
		<div class="footer" role="contentinfo"></div>
		%{--<g:javascript library="application"/>--}%
		<r:layoutResources />
	</body>
</html>
