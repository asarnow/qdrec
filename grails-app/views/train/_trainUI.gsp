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

<%@ page import="edu.sfsu.ntd.phenometrainer.Subset; edu.sfsu.ntd.phenometrainer.TrainState" %>
<g:javascript>
  var parasites;
  var theCanvas;
  var context;
  var image;
  var imageID;
  var controlSrc, controlW, controlH, controlName;

  function refreshVars() {
    theCanvas = $("#parasiteImageCanvas").get(0);
    context = theCanvas.getContext("2d");
    context.lineWidth = 2;
    image = $("#currentImg").get(0);
  }

  function drawBoundingBoxes(parasites, context) {
      for (var i=0; i < parasites.length; i++) {

          parasites[i].trainState.name == "${TrainState.NORMAL}" ?
                  context.strokeStyle = '#0000ff' : context.strokeStyle = '#ff0000';

          context.strokeRect(
                  parasites[i].upperLeftX,
                  parasites[i].upperLeftY,
                  parasites[i].width,
                  parasites[i].height );
      }
  }

  function draw(parasites, context, image) {
      context.drawImage(image,0,0,image.width,image.height);
      drawBoundingBoxes(parasites, context);
  }

  function getMousePos(canvas, evt) {
      var rect = canvas.getBoundingClientRect();
      return {
          x: evt.clientX - (rect.left),
          y: evt.clientY - (rect.top)
      };
  }

  function updateCanvas(canvas,img) {
          canvas.addEventListener("click", function (event) {
                    var mousePos = getMousePos(canvas, event);
                    jQuery.ajax({type: 'GET',
                                 data: { parasiteX: mousePos.x, parasiteY: mousePos.y, imageID: imageID },
                                 dataType: 'json',
                                 url: '${request.contextPath}/train/parasite',
                                 success: function (data, textStatus) {
                                     parasites = data; // Object from JSON as parsed by JQuery
                                     draw(parasites, context, img);
                                 },
                                 error: function (XMLHttpRequest, textStatus, errorThrown) {
                                     alert("No (segmented) parasite at cursor location");
                                 }});
                }, false);
    }

  function refreshTrainUI() {
    refreshVars();
    updateCanvas(theCanvas,image);
    draw(parasites, context, image);
  }

  function setImageOnLoad() {
    $("#currentImg").load(refreshTrainUI());
  }

  function updateParasites(data) {
    parasites = data;
    draw(parasites, context, image);
  }

  function updateControl() {
    var controlImg = $("#controlImg");
    if ( controlImg.attr('src') !== controlSrc) {
      controlImg.attr('src',controlSrc);
      controlImg.css('width',controlW);
      controlImg.css('height',controlH);
      $('#controlName').text(controlName);
    }
  }

  function showLoading() {
    theCanvas.width = theCanvas.width;
    var cimg = $('#currentImage');
    var control = $('#control');
    cimg.children('h4').text('');
    cimg.addClass('loading');
    cimg.width(control.width());
    cimg.height(control.height());
  }

</g:javascript>
<div id="subsetForm">
  <h4 class="subset">Subset:</h4>
  <g:select name="subsetID" id="subset" from="${subsets}" optionValue="description" optionKey="id" value="${subset.id}" noSelection="[0L:'Select Subset']"
      onchange="${remoteFunction(action: 'switchSubset',
              params: '\'datasetID='+ (dataset.id as String) + '&imageSubsetID='+ (imageSubset.id as String) + '&subsetID=\'+this.value',
              update: 'trainDiv', onComplete: 'updateControl()', onLoading: 'showLoading()')}"/>
</div>
<div id="imageNavigation">
  <g:remoteLink action="prevImage" params="[imageSubsetID: imageSubset.id, done: done]" update="trainDiv" onComplete="updateControl();" onLoading="showLoading()">
                %{--onSuccess="${remoteFunction(action: "imageParasites", params: [imageID: image.id], onSuccess: "setParasites(data);")}">--}%
    <button class="button" type="button">Prev</button>
  </g:remoteLink>
  <g:remoteLink action="nextImage" params="[imageSubsetID: imageSubset.id, done: done]" update="trainDiv" onComplete="updateControl();" onLoading="showLoading()">
                %{--onSuccess="${remoteFunction(action: "imageParasites", params: [imageID: image.id], onSuccess: "setParasites(data);")}">--}%
    <button class="button" type="button">Next</button>
  </g:remoteLink>
  <g:remoteLink action="toggleParasites" onSuccess="updateParasites(data);">
    <button class="button" type="button">Toggle all</button>
  </g:remoteLink>
  <g:remoteLink action="resetParasites" onSuccess="updateParasites(data);">
      <button class="button" type="button">Reset all</button>
  </g:remoteLink>
  <g:remoteLink action="saveParasites" onSuccess="updateParasites(data);\$('#saveMessage').text('Saved')">
    <button class="button" type="button">Save</button>
  </g:remoteLink>
  <span id="saveMessage"></span>
  <g:if test="${done}">
    <span class="doneAlert">This subset has been completely trained. It may still be updated.</span>
  </g:if>
  <script>
    parasites = ${parasites};
    imageID = ${image.id};
    controlSrc = "${createLink(action: 'image', params: [imageID: control.id])}";
    controlName = "${control.name}";
    controlW = ${control.width * control.displayScale};
    controlH = ${control.height * control.displayScale};
  </script>
</div>
<div id="currentImage" class="parasiteImage">
  <h4>${image.name}</h4>
  <h4 class="right">${imageSubset.position + 1} out of ${subset.size}</h4>
  <img id="currentImg" class="parasiteImage"
       onload="refreshTrainUI();"
       src="${createLink(action: 'image', params: [imageID: image.id])}"
       width="${image.width*image.displayScale}"
       height="${image.height*image.displayScale}"/>
  <canvas id="parasiteImageCanvas"
          width="${image.width*image.displayScale}"
          height="${image.height*image.displayScale}">
    HTML5 Canvas not supported.
  </canvas>
</div>