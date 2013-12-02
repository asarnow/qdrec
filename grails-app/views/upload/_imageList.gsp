<button class="button" id="invertButton">Invert</button>
<button class="button" id="clearButton">Clear</button>
<br />
<g:select name="imageList" from="${dataset.images}" size="25" multiple="true" optionKey="id" optionValue="name" value="${imageIDs}"/>