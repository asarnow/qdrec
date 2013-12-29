%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%
<h3 onclick="$('#plotDiv').toggle();" class="hideshow">Plot Results</h3>
<g:render template="resultPlot" model="[error:error, compound:compounds]"/>
<div class="clearDiv"></div>
<h3 onclick="$('#numericalResult').toggle();" class="hideshow">Tabular Results</h3>
<g:render template="result" model="[cm:cm, testImages:testImages, trainImages:trainImages, Rtest:Rtest, Rtrain:Rtrain]"/>