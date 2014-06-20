/*
 * Copyright (c) 2014 Daniel Asarnow
 */

/**
 * Created with IntelliJ IDEA.
 * User: da
 * Date: 6/19/14
 * Time: 2:38 PM
 * To change this template use File | Settings | File Templates.
 */

/**
 * Converts any valid CSS color (hex, rgb(), named color) to an RGB tuple.
 *
 * @param {!string} colorStr Any valid CSS color string.
 * @return {{r:number,g:number,b:number}} Parsed RGB tuple.
 * @private
 */
Dygraph.toRGB_ = function(colorStr) {
  // TODO(danvk): cache color parses to avoid repeated DOM manipulation.
  var div = document.createElement('div');
  div.style.backgroundColor = colorStr;
  div.style.visibility = 'hidden';
  document.body.appendChild(div);
  var rgbStr = window.getComputedStyle(div, null).backgroundColor;
  document.body.removeChild(div);
  var bits = /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/.exec(rgbStr);
  return {
    r: parseInt(bits[1], 10),
    g: parseInt(bits[2], 10),
    b: parseInt(bits[3], 10)
  };
};

/**
 * Draws error bars for each series.
 * This happens before the center lines or points are drawn, since these
 * need to be drawn on top of the error bars for all series.
 * @private
 */
DygraphCanvasRenderer.errorBarPlotter = function(e) {
  var g = e.dygraph;
  var setName = e.setName;
  var errorBars = g.getOption("errorBars") ||
      g.getOption("customBars");
  if (!errorBars) return;

  var fillGraph = g.getOption("fillGraph", setName);
  if (fillGraph) {
    Dygraph.warn("Can't use fillGraph option with error bars");
  }

  var barRadius = g.getOption('errorBarRadius',setName);

  var ctx = e.drawingContext;
  var color = e.color;
  var fillAlpha = g.getOption('fillAlpha', setName);
  var points = e.points;

  var iter = Dygraph.createIterator(points, 0, points.length,
      DygraphCanvasRenderer._getIteratorPredicate(
          g.getOption("connectSeparatedPoints", setName)));

  var newYs;

  // setup graphics context
  var prevX = NaN;
  var prevY = NaN;
  var prevYs = [-1, -1];
  // should be same color as the lines but only 15% opaque.
  var rgb = Dygraph.toRGB_(color);
  var err_color =
      'rgba(' + rgb.r + ',' + rgb.g + ',' + rgb.b + ',' + fillAlpha + ')';
  ctx.strokeStyle = err_color;
  ctx.beginPath();

  var isNullUndefinedOrNaN = function(x) {
    return (x === null ||
            x === undefined ||
            isNaN(x));
  };

  while (iter.hasNext) {
    var point = iter.next();
    if (isNullUndefinedOrNaN(point.y)) {
      prevX = NaN;
      continue;
    }

    newYs = [ point.y_bottom, point.y_top ];

    newYs[0] = e.plotArea.h * newYs[0] + e.plotArea.y;
    newYs[1] = e.plotArea.h * newYs[1] + e.plotArea.y;
//    if (!isNaN(prevX)) {
      // Draw bottom cap
      ctx.moveTo(point.canvasx - barRadius, newYs[0]);
      ctx.lineTo(point.canvasx + barRadius, newYs[0]);
      // Draw error bar
      ctx.moveTo(point.canvasx,newYs[0]);
      ctx.lineTo(point.canvasx,newYs[1]);
      // Draw top cap
      ctx.moveTo(point.canvasx - barRadius, newYs[1]);
      ctx.lineTo(point.canvasx + barRadius, newYs[1]);

      ctx.stroke();
//    }
    prevYs = newYs;
    prevX = point.canvasx;
  }

};

/**
 * Plotter which draws points for a series.
 * @private
 */
DygraphCanvasRenderer.pointPlotter = function(e) {
  var g = e.dygraph;
  var setName = e.setName;

  // TODO(danvk): Check if there's any performance impact of just calling
  // getOption() inside of _drawStyledLine. Passing in so many parameters makes
  // this code a bit nasty.

  var drawPointCallback = g.getOption("drawPointCallback", setName) ||
      Dygraph.Circles.DEFAULT;

  var pointSize = g.getOption("pointSize", setName);

  DygraphCanvasRenderer._drawStyledPoints(e,
      e.color,
      drawPointCallback,
      pointSize
  );
};

/**
 * Draws a line with the styles passed in and calls all the drawPointCallbacks.
 * @param {Object} e The dictionary passed to the plotter function.
 * @private
 */
DygraphCanvasRenderer._drawStyledPoints = function(e,
    color, drawPointCallback, pointSize) {
  var g = e.dygraph;
  // TODO(konigsberg): Compute attributes outside this method call.

  var points = e.points;
  var setName = e.setName;
  var iter = Dygraph.createIterator(points, 0, points.length,
      DygraphCanvasRenderer._getIteratorPredicate(
          g.getOption("connectSeparatedPoints", setName)));


  var ctx = e.drawingContext;
  ctx.save();

  var pointsOnLine = DygraphCanvasRenderer._getPointsOnLine(e, iter);
  DygraphCanvasRenderer._drawPointsOnLine(
      e, pointsOnLine, drawPointCallback, color, pointSize);

  ctx.restore();
};

/**
 * Get points on line for _drawPointsOnLine API method.
 * @param {Object} e The dictionary passed to the plotter function.
 * @param {Iterator} iter Iterator for points in e
 * @private
 */
DygraphCanvasRenderer._getPointsOnLine = function(e,iter) {
  var point; // the point being processed in the while loop
  var pointsOnLine = []; // Array of [canvasx, canvasy] pairs.

  // NOTE: we break the iterator's encapsulation here for about a 25% speedup.
  var arr = iter.array_;
  var limit = iter.end_;
  var predicate = iter.predicate_;

  for (var i = iter.start_; i < limit; i++) {
    point = arr[i];
    if (predicate) {
      while (i < limit && !predicate(arr, i)) {
        i++;
      }
      if (i == limit) break;
      point = arr[i];
    }
    pointsOnLine.push([point.canvasx, point.canvasy, point.idx]);
  }
  return pointsOnLine;
};