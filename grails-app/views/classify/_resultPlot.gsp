%{--
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
<div id="plotDiv">
  <h4>Plot Results</h4>
  <g:if test="${!error}">
    %{--<g:formRemote name="plotForm" url="[controller:'classify',action:'plotsrc']" onSuccess="\$('#plot').attr('src',data)">--}%
    <g:formRemote name="plotForm" url="[controller:'classify',action:'csvdata']" method="GET" onSuccess="
        \$('#dygraphArea').addClass('dygraphDiv');
        g = new Dygraph(document.getElementById('dygraphArea'), data['csv2'], {
          labelsDiv: 'legend',
          labelsSeparateLines: true,
          errorBars: true,
          sigma: 1.0,
          legend: 'always',
          valueRange: [-0.05,1.05],
          title: \$('#compound').val(),
          ylabel: 'Fraction Degenerate',
          xlabel: 'Log Concentration (&micro;M)',
          connectSeparatedPoints: false,
          pointSize: 3,
          errorBarRadius: 8,
          fillAlpha: 0.85,
          plotter: [DygraphCanvasRenderer.errorBarPlotter, DygraphCanvasRenderer.pointPlotter]
        });

        \$('#dygraphArea2').addClass('dygraphDiv');
        g2 = new Dygraph(document.getElementById('dygraphArea2'), data['csv1'], {
          labelsDiv: 'legend2',
          labelsSeparateLines: true,
          errorBars: true,
          sigma: 1.0,
          legend: 'always',
          valueRange: [-0.05,1.05],
          title: \$('#compound').val(),
          ylabel: 'Fraction Degenerate',
          xlabel: 'Exposure Time',
          connectSeparatedPoints: false,
          pointSize: 3,
          errorBarRadius: 8,
          fillAlpha: 0.85,
          plotter: [DygraphCanvasRenderer.errorBarPlotter, DygraphCanvasRenderer.pointPlotter]
        });
        "
                  onComplete="updateCurves()">
      %{--<label for="compound">Select compound:</label>--}%
      %{--<g:select name="compound" from="${compounds}" noSelection="${['':'-']}"
                onchange="${remoteFunction(action: 'curves', update: 'curves',
                      params: '\'xdim=\'+$(\'[name=xdim]:checked\').val()+\'&compound=\'+this.value', method: 'GET')}"/>--}%
      <g:select name="compound" from="${compounds}" noSelection="${['':'select compound']}"/>
      %{--<br />
      <label for="xdim">Abscissa dimension:</label>
      <br />--}%
      %{--<g:radioGroup values="['time','conc']" name="xdim" value="${'conc'}" labels="['Time','Concentration']"
        onchange="${remoteFunction(action: 'curves', update: 'curves',
                params: '\'xdim=\'+this.value+\'&compound=\'+$(\'#compound\').val()', method: 'GET')}">--}%
      %{--<g:radioGroup values="['time','conc']" name="xdim" value="${'conc'}" labels="['Time','Concentration']">
        <p>${it.label} ${it.radio}</p>
      </g:radioGroup>--}%
      %{--<div class="clearDiv"></div>--}%
      %{--<div id="curves">
        <g:render template="curves"/>
      </div>--}%
      <g:submitButton class="button" name="plotSubmit" value="Plot" onclick="destroyPlots()"/>
    </g:formRemote>
    <div class="dygraphOuter">
      <div id="dygraphArea"></div>
      <div id="legend" class="dygraph-legend"></div>
      <div class="clearDiv"></div>
      <div id="curves1" class="curves"></div>
      <div id="options1" class="options"></div>
    </div>
    <div class="dygraphOuter">
      <div id="dygraphArea2"></div>
      <div id="legend2" class="dygraph-legend"></div>
      <div class="clearDiv"></div>
      <div id="curves2" class="curves"></div>
      <div id="options2" class="options"></div>
    </div>
    <div class="clearDiv"></div>

  </g:if>
  <g:else>
    <p>An error ocurred during plotting.</p>
  </g:else>
</div>

