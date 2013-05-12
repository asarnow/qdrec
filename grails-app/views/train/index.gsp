<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 5/9/13
  Time: 5:41 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="edu.sfsu.ntd.phenometrainer.TrainState; edu.sfsu.ntd.phenometrainer.ParasiteTrainState" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Phenome Trainer</title>
  <meta name="layout" content="main" />
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
</head>
<body>
  <div id="main">
    <div>
      <a href="${createLink(action: 'prevImage')}"><button class="button">Previous</button></a>
      <a href="${createLink(action: 'nextImage')}"><button class="button">Next</button></a>
    </div>
    <div id="trainDiv">
      <div id="currentImage" class="parasiteImage">
        <h4>${imageName}</h4>
        <h4 class="right">${imageID} out of 118</h4>
        <img id="currentImg" class="parasiteImage" src="${createLink(action: 'image', params: [imageID: imageID])}" />
        <canvas id="parasiteImageCanvas" width="694" height="520">HTML5 Canvas not supported.</canvas>
      </div>

      <div id="control" class="parasiteImage">
        %{--<canvas id="controlImageCanvas"></canvas>--}%
        <h4>${controlName}</h4>
        <img id="controlImg" class="parasiteImage" src="${createLink(action: 'image', params: [imageID: controlID])}" />
      </div>

      <div class="clearDiv"></div>
    </div>
  </div>
</body>
</html>