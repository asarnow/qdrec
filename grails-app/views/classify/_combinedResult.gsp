%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%
<h3>Display Results</h3>
<h4 style="margin-top: 0.25em;">Tabular Results</h4>
<button class="button" type="button" onclick="$('#numericalResult').toggle();">Display</button>
<a href="${createLink(action: 'downloadResults')}"><button class="button" type="button">Download</button></a>
<g:render template="result" model="[cm:cm, testImages:testImages, trainImages:trainImages, Rtest:Rtest, Rtrain:Rtrain]"/>
<div class="clearDiv"></div>
<g:render template="resultPlot" model="[error:error, compounds:compounds]"/>
