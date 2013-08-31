<%@ page import="edu.sfsu.ntd.phenometrainer.TrainState" %>
<g:javascript>
  var parasites = ${parasites};
  var theCanvas = $("#parasiteImageCanvas").get(0);
  var context = theCanvas.getContext("2d");
  context.lineWidth = 2;

  $("#currentImg").load(function (){
//        $("#currentImg").width(694)
//        $("#currentImg").height(520)
//        theCanvas.width = 694;
//        theCanvas.height = 520;
  });

  var image = $("#currentImg").get(0);

  function drawBoundingBoxes() {
      for (var i=0; i < parasites.length; i++) {

          parasites[i].trainState.name == "${TrainState.NORMAL}" ?
                  context.strokeStyle = '#f00' : context.strokeStyle = '#0f0';

          context.strokeRect(
                  parasites[i].upperLeftX,
                  parasites[i].upperLeftY,
                  parasites[i].width,
                  parasites[i].height );
      }
  }

  function draw() {
      context.drawImage(image,0,0,694,520);
      drawBoundingBoxes();
  }

  function getMousePos(canvas, evt) {
      var rect = canvas.getBoundingClientRect();
      return {
          x: evt.clientX - (rect.left),
          y: evt.clientY - (rect.top)
      };
  }

  theCanvas.addEventListener("click", function (event) {
          var mousePos = getMousePos(theCanvas, event);
          jQuery.ajax({type: 'GET',
                       data: { parasiteX: mousePos.x, parasiteY: mousePos.y, imageID: "${imageID}" },
                       dataType: 'json',
                       url: '/PhenomeTrainer/train/parasite',
                       success: function (data, textStatus) {
                           parasites = data; // Object from JSON as parsed by JQuery
                           draw();
                       },
                       error: function (XMLHttpRequest, textStatus, errorThrown) {
                           alert("No (segmented) parasite at cursor location");
                       }});
      }, false);

  $(window).load(function () {
      draw();
  });

</g:javascript>
<div id="imageNavigation">
  %{--<a href="${remoteLink(action: 'prevImage', params: [imageIdx:imageIdx], update: 'trainDiv')}"><button class="button">Previous</button></a>--}%
  %{--<a href="${remoteLink(action: 'nextImage', params: [imageIdx:imageIdx], update: 'trainDiv')}"><button class="button">Next</button></a>--}%
</div>
<div id="currentImage" class="parasiteImage">
  <h4>${imageName}</h4>
  <h4 class="right">${imageIdx} out of ${datasetSize}</h4>
  <img id="currentImg" class="parasiteImage" src="${createLink(action: 'image', params: [imageID: imageID])}" />
  <canvas id="parasiteImageCanvas" width="694" height="520">HTML5 Canvas not supported.</canvas>
</div>

<div id="control" class="parasiteImage">
  %{--<canvas id="controlImageCanvas"></canvas>--}%
  <h4>${controlName}</h4>
  <img id="controlImg" class="parasiteImage" src="${createLink(action: 'image', params: [imageID: controlID])}" />
</div>

<div class="clearDiv"></div>