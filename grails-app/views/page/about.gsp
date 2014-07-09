%{--
  - Copyright (C) 2014 Daniel Asarnow
  - San Francisco State University
  -
  - This program is free software: you can redistribute it and/or modify
  - it under the terms of the GNU General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - This program is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU General Public License
  - along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
  <title>QDREC: About</title>
  <meta name="layout" content="main" />
</head>
<body>
  <div class="content">
    <div class="about">
      <h1>Quantal Dose Response Calculator</h1>
      <p>
        QDREC, the <b>Q</b>uantal <b>D</b>ose <b>R</b>esponse <b>C</b>alculator (pronounced “QuadRec”) is a web application for automatically determining quantal dose-response characteristics of macroparasites in phenotypic drug screening.
      </p>
      <p>
        Input to QDREC consists of images of parasites. In typical usage, these images would correspond to a sequence of exposures of the parasite population to varying drug concentrations and exposure periods. These images are first segmented to distinguish the individual parasites from the background. For this purpose, users may opt to use the segmentation methods supported within QDREC or upload pre-segmented images (using an algorithm of their choice). Next, individual parasites in the image are represented in a feature space. QDREC computes 75 distinct image-based features that capture the phenotype(s) exhibited by the parasites in terms of their appearance and geometry. Subsequently, the extent to which each parasite differs from its corresponding control population in terms of its exhibited phenotypes is determined. This determination is made by using a soft-margin support vector machine classifier employing the Gaussian radial basis function kernel. Users have the option to either use a pre-trained classifier that is provided as part of QDREC or train their own classifier. The latter option is especially recommended if the user is not analyzing schistosomula images.
      </p>
      <p>
        Before proceeding with QDREC, please read the usage <a href="${createLink(action: 'help')}">instructions</a> thoroughly.
        Failure to follow the usage instructions will result in errors.
      </p>
    </div>
    <div class="authors">
      <h1>QDREC Design and Implementation</h1>
      <ul>
        <li><h4 style="display: inline">by </h4><a href="http://tintin.sfsu.edu/people/DanielAsarnow.html">Daniel Asarnow</a> and
          <a href="http://tintin.sfsu.edu/people/RahulSingh.html">Rahul Singh</a>
        </li>
      </ul>
      <h2>Related Publications</h2>
      <ol class="publist">
        <li>
          D.&nbsp;Asarnow and R.&nbsp;Singh,
          "Determination of Quantal Dose-Response Characteristics in Phenotypic Assays using Supervised Classification,"
          <i>San Francisco State Technical Report</i>, 2014.
          <a href="http://cs.sfsu.edu/techreports/14/QDREC.TechReport.14.01.pdf"><g:img dir="images" file="pdf.gif"/></a>
        </li>
        <li>
          D.&nbsp;Asarnow and R.&nbsp;Singh,
          "Segmenting the Etiological Agent of Schistosomiasis for High-Content Screening,"
          <i>IEEE Transactions on Medical Imaging</i>, vol. 32, no. 6, pp. 1007-10018, 2013.
          <a href="http://tintin.sfsu.edu/papers/Asarnow - 2012 - Segmenting the Etiological Agent of Schistosomiasis for High-Content Screening.pdf"><g:img dir="images" file="pdf.gif"/></a>
        </li>
        <li>
        L. Rojo-Arreola, T. Long, D. Asarnow, B.M. Suzuki, R. Singh and C.R. Caffrey,
        "Chemical and genetic validation of the statin drug target for the potential treatment of the helminth disease, schistosomiasis,"
        <i>PLoS ONE</i>, 9(1): e87594, 2014. (Corresponding author C.R. Caffrey).
        <a href="http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0087594"><g:img dir="images" file="pdf.gif"/></a>
        </li>
        <li>
          R. Singh, "Quantitative High-Content Screening-Based Drug Discovery against Helmintic Diseases", in <i>Parasitic Helminths</i>: Targets, Screens, Drugs, and Vaccines, Ed. C. Caffrey, Wiley-Blackwell, pp. 159-179 2012.
          <a href="http://www.wiley.com/WileyCDA/WileyTitle/productCd-3527330593.html"><g:img dir="images" file="pdf.gif"/></a>
        </li>
        <li>
          C. Marcellino, J. Gut, K. C. Lim, R. Singh, J. McKerrow, J. Sakanari, "WormAssay: A Novel Computer Application for Whole-Plate Screening of Macroscopic Parasites", <i>PLoS Neglected Tropical Diseases</i>, Vol. 6(1):e1494, 2012 (Corresponding author C. Marcellino).
          <a href="http://www.plosntds.org/article/info%3Adoi%2F10.1371%2Fjournal.pntd.0001494"><g:img dir="images" file="pdf.gif"/></a>
        </li>
        <li>
          H. Lee*, A. Moody-Davis, U. Saha, B. Suzuki, D. Asarnow, S. Chen, M. Arkin, C. Caffrey, and R. Singh*, "Quantification and Clustering of Phenotypic Screening Data Using Time Series Analysis for Chemotherapy of Schistosomiasis", <i>BMC Genomics</i>, 12 (Suppl 1):S4, 2012 (*H. Lee and R. Singh equal contributors. Corresponding author R. Singh).
          <a href="http://www.biomedcentral.com/1471-2164/13/S1/S4"><g:img dir="images" file="pdf.gif"/></a>
        </li>
        <li>
          R. Singh, M. Pittas, I. Heskia, F. Xu, J. H. McKerrow, and C. Caffrey, "Automated Image-Based Phenotypic Screening for High-Throughput Drug Discovery", <i>IEEE Symposium on Computer-Based Medical Systems (CBMS)</i>, pp. 1-8, 2009.
          <a href="http://tintin.sfsu.edu/papers/IEEE-CBMS-2009.pdf"><g:img dir="images" file="pdf.gif"/></a>
        </li>
      </ol>
    </div>
  </div>
</body>
</html>
