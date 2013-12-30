%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%

<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 12/29/13
  Time: 11:58 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>QDREC Home</title>
  <meta name="layout" content="main" />
</head>
<body>
  <div class="homeleft">
    <h1>Welcome to QDREC</h1>
    <p>
      QDREC is a web server for automatic measurement of the quantal phenotypic response of macroparasites,
      specifically juvenile schistomes, to drug exposure.
    </p>
    <p>
      These parasites are the etiological agent of the disease schistosomiasis,
      which is considered the second most socioeconomically devastating illness after malaria
      and has been identified by WHO as a neglected tropical disease for which new therapies are urgently required.
    </p>
    <p>
      The purpose of QDREC is to provide an interactive environment for automated drug screening against schistosomiasis
      so as to facilitate ongoing efforts to identify new drugs effective against the disease.
    </p>
    <h2>Requirements</h2>
    <p>
      <a href="http://www.getfirefox.com"><img class="requirement" src="${resource(dir: 'images', file: 'mozilla_firefox.png')}" alt="Mozilla Firefox" /></a>
      <a href="https://www.google.com/chrome/"><img class="requirement" src="${resource(dir: 'images', file: 'google_chrome.png')}" alt="Google Chrome" /></a>
      <a href="https://en.wikipedia.org/wiki/HTML5"><img class="requirement" src="${resource(dir: 'images', file: 'html5.png')}" alt="HTML5" /></a>
      <a href="http://enable-javascript.com/"><img class="requirement" src="${resource(dir: 'images', file: 'js.png')}" alt="JS" /></a>
    </p>
    <noscript>
      For full functionality of this site it is necessary to enable JavaScript.
      Here are the <a href="http://www.enable-javascript.com/" target="_blank">
      instructions how to enable JavaScript in your web browser</a>.
    </noscript>
  </div>
  <div class="homeright">
    <h1>Get Started</h1>
    <p>
      Get started with QDREC's example projects.
    </p>
    <p>
      The <a href="${createLink(controller: 'upload', action: 'load', params: [token:'tpiwsb'])}">Niclosamide</a> project demonstrates training and testing for a small
      set of 12 images, and the <a href="${createLink(controller: 'upload', action: 'load', params: [token:'iwarhr'])}">Mevastatin</a> project demonstrates construction of time and dose-response curves for
      replicated experiments.
    </p>
    <p>
      The raw image data for these projects can be found on the <a href="${createLink(action: 'download')}">download page</a>.
    </p>
    <p>
      Please be sure to read the <a href="${createLink(action: 'help')}">instructions</a> before proceeding. Failure to comply with the instructions, especially the
      conventions defined for user-uploaded data, is likely to result in errors.
    </p>
  </div>
</body>
</html>