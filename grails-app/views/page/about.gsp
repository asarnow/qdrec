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
    <h1>Quantal Dose Response Calculator</h1>
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
    <h1>Authors</h1>
    <ul>
      <li><a href="http://tintin.sfsu.edu/people/DanielAsarnow.html">Daniel Asarnow</a></li>
      <li><a href="http://tintin.sfsu.edu/people/RahulSingh.html">Rahul Singh</a></li>
    </ul>
    <h2>Related Publications</h2>
    <h4>Software</h4>
    <ul class="publist">
      <li>
        D.&nbsp;Asarnow and R.&nbsp;Singh,
        "The Quantal Dose Response Calculator (QDREC)."
      </li>
    </ul>
    <h4>Screening Methodology</h4>
    <ul class="publist">
      <li>
        D.&nbsp;Asarnow, L.&nbsp;Arreola-Rojo, B.M.&nbsp;Suzuki, C.R.&nbsp;Caffrey and R.&nbsp;Singh,
        "Automatic Identification of Dose-Response Characteristics
        in Phenotypic Assays for Complex Macroparasites using
        Biological Imaging and Supervised Learning,"
        Under Review 2014.
      </li>
      <li>
        L.&nbsp;Arreola-Rojo, T.&nbsp;Long, D.&nbsp;Asarnow, B.M.&nbsp;Suzuki, R.&nbsp;Singh and C.R.&nbsp;Caffrey,
        "Chemical and genetic validation of the statin drug target to treat the helminth disease, schistosomiasis,"
        <i>PLoS ONE</i>, To Appear 2014.
      </li>
    </ul>
    <h4>Image Segmentation</h4>
    <ul class="publist">
      <li>
        D.&nbsp;Asarnow and R.&nbsp;Singh,
        "Segmenting the Etiological Agent of Schistosomiasis for High-Content Screening,"
        <i>IEEE Transactions on Medical Imaging</i>, vol. 32, no. 6, pp. 1007-10018, 2013.
      </li>
      <li>
        D.&nbsp;Asarnow and R.&nbsp;Singh,
        "Segmentation of Parasites for High-Content Screening using Phase Congruency and Grayscale Morphology",
        <i>International Symposium on Visual Computing (ISVC)</i>,
        Lecture Notes in Computer Science, Vol. 7431, pp. 51-60, Springer, 2012.
      </li>
      <li>
        A.&nbsp;Moody-Davis, L.&nbsp;Mennillo and R.&nbsp;Singh,
        "Region Based Segmentation of Parasites for High-Throughput Screening,"
        <i>International Symposium on Visiual Computing (ISVC)</i>,
        Lecture Notes in Computer Science, Vol. 6938, pp. 44-54, Springer, 2011.
      </li>
    </ul>
  </div>
</body>
</html>