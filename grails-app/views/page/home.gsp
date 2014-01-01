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
  <div class="content">
    <div class="homeleft">
      <h1>Welcome to QDREC</h1>
      <p>
        QDREC (<b>Q</b>uantal <b>D</b>ose <b>R</b>esponse <b>C</b>alculator) is a web server for automatically determining quantal dose-response characteristics of macroparasites in phenotypic drug screening.  Such parasites include the etiological agents of tropical diseases such as schistosomiasis, lymphatic filariasis, and onchocerciasis, which together afflict over 500 million people worldwide.
      </p>
      <p>
        Using a combination of biological imaging and supervised machine learning, QDREC automatically determines the number of parasites which differ significantly from controls at specific experimental conditions (e.g. compound and concentration). This statistic is then utilized to determine the corresponding quantitative dose-response characteristics of the parasite population. The image analysis part of QDREC has been optimized with a focus on post-infective larvae (schistosomula) of the parasitic Schistosoma flatworm, which cause the disease schistosomiasis. However, the algorithmic basis underlying the methodology for determining dose-response characteristics in QDREC is generic and the web server can equally be used for analyzing other macroparasites.
      </p>
      <p>
        QDREC is part of our effort to provide publicly available technologies that can be used to quantitatively, automatically, and effectively discover drugs against the neglected diseases of humankind.
      </p>
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
        The raw image data for these projects can be found <a href="${createLink(action: 'download')}">here</a>.
      </p>
      <p>
        Please be sure to read the <a href="${createLink(action: 'help')}">instructions</a> before proceeding. Failure to comply with the instructions, especially the
        conventions defined for user-uploaded data, is likely to result in errors.
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
  </div>
</body>
</html>