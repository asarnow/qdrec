%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%

<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 12/10/13
  Time: 4:28 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>About QDREC</title>
  <meta name="layout" content="main" />
</head>
<body>
  <div class="about">
    <h2>Quantal Dose Response Calculator</h2>
    <p>
      The Quantal Dose Response Calculator (abbreviated QDREC, and pronounced “QuadRec”) is an interactive web application
      supporting automated analaysis of schistosoma phenotypes.
      Users may upload their own unique data (consisting of segmented parasite images),
      provide expert annotation using an interactive training interface
      and apply either an existing or a newly trained SVM classifier to generate quantal dose-response measurements
      over the uploaded images.
    </p>
    <p>
      Before proceeding with QDREC, please read the usage <a href="${createLink(action: 'help')}">instructions</a> thoroughly.
      Failure to follow the usage instructions will result in errors.
    </p>
  </div>
  <div class="authors">
    <h2>Authors</h2>
    <ul>
      <li><a href="http://tintin.sfsu.edu/people/DanielAsarnow.html">Daniel Asarnow</a></li>
      <li><a href="http://tintin.sfsu.edu/people/RahulSingh.html">Rahul Singh</a></li>
    </ul>
    <h2>Publication</h2>
    <p>
      D. Asarnow, L. Arreola-Rojo, B.M. Suzuki, C.R. Caffrey and R. Singh,
      "Automatic Identification of Dose-Response Characteristics
      in Phenotypic Assays for Complex Macroparasites using
      Biological Imaging and Supervised Learning," 2014.
    </p>
  </div>
</body>
</html>