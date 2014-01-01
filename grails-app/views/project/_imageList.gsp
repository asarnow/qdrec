<label for="imageList">Images:</label>
<br />
<g:select name="imageList" from="${dataset.images}" size="15" multiple="true" optionKey="id" optionValue="name" value="${imageIDs}"/>
<br />
<button class="button" id="invertButton" type="button">Invert</button>
<button class="button" id="clearButton" type="button">Clear</button>