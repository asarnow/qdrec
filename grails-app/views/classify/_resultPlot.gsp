%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%
<div id="plotDiv">
  <g:if test="${!error}">
    %{--<g:formRemote name="plotForm" url="[controller:'classify',action:'plotsrc']" onSuccess="\$('#plot').attr('src',data)">--}%
    <g:formRemote name="plotForm" url="[controller:'classify',action:'csvdata']" method="GET" onSuccess="
        \$('#dygraphArea').addClass('dygraphDiv');
        g = new Dygraph(document.getElementById('dygraphArea'), data, {
          labelsDiv: 'legend',
          labelsSeparateLines: true,
          errorBars: true,
          sigma: 1.0,
          legend: 'always',
          valueRange: [-0.05,1.05],
          title: \$('#compound').val(),
          ylabel: 'Fraction Degenerate',
          xlabel: \$('[name=xdim]:checked').val()=='time' ? 'Exposure Time' : 'Log Concentration (&micro;M)'
        });"
                  onComplete="${remoteFunction(action: 'curves',
                          update: 'curves',
                          params: '\'xdim=\'+$(\'[name=xdim]:checked\').val()+\'&compound=\'+$(\'#compound\').val()', method: 'GET')}">
      <label for="compound">Select compound:</label>
      %{--<g:select name="compound" from="${compounds}" noSelection="${['':'-']}"
                onchange="${remoteFunction(action: 'curves', update: 'curves',
                      params: '\'xdim=\'+$(\'[name=xdim]:checked\').val()+\'&compound=\'+this.value', method: 'GET')}"/>--}%
      <g:select name="compound" from="${compounds}" noSelection="${['':'-']}"/>
      <br />
      <label for="xdim">Abscissa dimension:</label>
      <br />
      %{--<g:radioGroup values="['time','conc']" name="xdim" value="${'conc'}" labels="['Time','Concentration']"
        onchange="${remoteFunction(action: 'curves', update: 'curves',
                params: '\'xdim=\'+this.value+\'&compound=\'+$(\'#compound\').val()', method: 'GET')}">--}%
      <g:radioGroup values="['time','conc']" name="xdim" value="${'conc'}" labels="['Time','Concentration']">
        <p>${it.label} ${it.radio}</p>
      </g:radioGroup>
      <div class="clearDiv"></div>
      %{--<div id="curves">
        <g:render template="curves"/>
      </div>--}%
      <g:submitButton class="button" name="plotSubmit" value="Plot" onclick="if (typeof g !== 'undefined') g.destroy()"/>
    </g:formRemote>
    <div id="dygraphArea">
        %{--<img id="plot" src="" width="512"/>--}%
    </div>
    <div id="legend" class="dygraph-legend"></div>
    <div class="clearDiv"></div>
    <div id="curves"></div>
  </g:if>
  <g:else>
    <p>An error ocurred during plotting.</p>
  </g:else>
</div>

