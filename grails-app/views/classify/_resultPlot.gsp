%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%
<div id="plotDiv">
  <h4>Results</h4>
  <g:if test="${!error}">
    <g:formRemote name="plotForm" url="[controller:'classify',action:'plotsrc']" onSuccess="\$('#plot').attr('src',data)">
      <g:select name="compound" from="${compounds}" noSelection="${['':'-']}"
                onchange="${remoteFunction(action: 'curves', update: 'curves',
                      params: '\'xdim=\'+$(\'[name=xdim]:checked\').val()+\'&compound=\'+this.value', method: 'GET')}"/>
      <br />
      <label for="xdim">Abscissa dimension:</label>
      <br />
      <g:radioGroup values="['time','conc']" name="xdim" value="${'conc'}" labels="['Time','Concentration']"
        onchange="${remoteFunction(action: 'curves', update: 'curves',
                params: '\'xdim=\'+this.value+\'&compound=\'+$(\'#compound\').val()', method: 'GET')}">
        <p>${it.label} ${it.radio}</p>
      </g:radioGroup>
      <div class="clearDiv"></div>
      <div id="curves">
        <g:render template="curves"/>
      </div>
      <g:submitButton class="button" name="plotSubmit" value="Plot"/>
    </g:formRemote>
    <div>
        <img id="plot" src=""/>
    </div>
  </g:if>
  <g:else>
    <p>An error ocurred during plotting.</p>
  </g:else>
</div>

