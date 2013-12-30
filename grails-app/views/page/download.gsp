%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%

<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 12/30/13
  Time: 11:42 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>QDREC Downloads</title>
  <meta name="layout" content="main" />
</head>
<body>
  <h1>Example Project Data</h1>
  <ul class="downloads">
    <li>
      <a href="${resource(dir: 'download', file: 'Niclosamide.zip')}">Niclosamide example data</a>
      <p>
        Contains two replicate dose-response series for 4 days of exposure to Niclosamide (5 images and 1 control image each, 12 images total).
        Segmented images are included.
      </p>
    </li>
    <li>
      <a href="${resource(dir: 'download', file: 'Mevastatin.zip')}">Mevastatin example data</a>
      <p>
        Contains dose- and time-response series for Mevastatin, including controls, with two time-points replicated across concentrations (30 images total).
        Segmented images are included.
      </p>
    </li>
  </ul>
</body>
</html>