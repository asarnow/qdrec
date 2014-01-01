<%@ page import="edu.sfsu.ntd.phenometrainer.TrainState" %>
%{--
  - Copyright (c) 2013 Daniel Asarnow
  --}%

<g:javascript>
  var parasites;
  var theCanvas;
  var context;
  var image;
  var imageID;

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

  function refreshTrainUI() {
    refreshVars();
    draw(parasites, context, image);
  }

  function setImageOnLoad() {
    $("#currentImg").load(refreshTrainUI());
  }

  function updateParasites(data) {
    parasites = data;
    draw(parasites, context, image);
  }

</g:javascript>
<div id="imageNavigation">
  <g:remoteLink action="prevImage" params="[imageID: image.id]" update="reviewDiv">
                %{--onSuccess="${remoteFunction(action: "imageParasites", params: [imageID: image.id], onSuccess: "setParasites(data);")}">--}%
    <button class="button" type="button">Prev</button>
  </g:remoteLink>
  <g:remoteLink action="nextImage" params="[imageID: image.id]" update="reviewDiv">
                %{--onSuccess="${remoteFunction(action: "imageParasites", params: [imageID: image.id], onSuccess: "setParasites(data);")}">--}%
    <button class="button" type="button">Next</button>
  </g:remoteLink>
  <script>
    parasites = ${parasites};
    imageID = ${image.id};
  </script>
</div>

<div id="currentImage" class="parasiteImage">
  <h4>${image.name}</h4>
  <h4 class="right">${image.position + 1} out of ${dataset.size}</h4>
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
<div id="control" class="parasiteImage">
  <h4 style="float: none;">Segmented Image</h4>
  <img id="controlImg"
       class="parasiteImage"
       src="${createLink(action: 'image', params: [imageID: image.id, segmented: true])}"
       width="${image.width*image.displayScale}"
       height="${image.height*image.displayScale}" />
</div>
