/*
jquery.percentageloader.js 
 
Copyright (c) 2015, David Jeffrey & Piotr Kwiatkowski
All rights reserved.

This jQuery plugin is licensed under the Simplified BSD License. Please
see the file license.txt that was included with the plugin bundle.

*/

(function() {
      "use strict";
    /*jslint browser: true */

    var imageLoaded = false;
    /* Our spiral gradient data */
    var imgdata = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAIAAAAiOjnJAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDY3IDc5LjE1Nzc0NywgMjAxNS8wMy8zMC0yMzo0MDo0MiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTUgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOkQzNDg4MTYyOTMzQTExRTU5RDIxRjg2MDVEQkRGQUEzIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOkQzNDg4MTYzOTMzQTExRTU5RDIxRjg2MDVEQkRGQUEzIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6RDM0ODgxNjA5MzNBMTFFNTlEMjFGODYwNURCREZBQTMiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6RDM0ODgxNjE5MzNBMTFFNTlEMjFGODYwNURCREZBQTMiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz5rDMJFAAAbnElEQVR42uyd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",
        gradient = new Image();

    gradient.src = imgdata;
    gradient.addEventListener('load', function() {
       imageLoaded = true;
    });


    window.PercentageLoader = function(el, params) {
      var settings, canvas, percentageText, valueText, items, i, item, selectors, s, ctx, progress,
            value, cX, cY, lingrad, innerGrad, tubeGrad, innerRadius, innerBarRadius, outerBarRadius,
            radius, startAngle, endAngle, counterClockwise, completeAngle, setProgress, setValue,
            applyAngle, drawLoader, clipValue, outerDiv, ready, plugin;

        plugin = this;
		
        /* Specify default settings */
        settings = {
            width: 200,
            height: 200,
            progress: 0,
            value: '0kb',
            controllable: false
        };

        /* Override default settings with provided params, if any */
        if (params !== undefined) {
            var prop;
            for (prop in settings) {
                if (settings.hasOwnProperty(prop) && !params.hasOwnProperty(prop)) {
                    params[prop] = settings[prop];
                }
            }
        } else {
            params = settings;
        }

        outerDiv = document.createElement('div');
        outerDiv.style.width = settings.width + 'px';
        outerDiv.style.height = settings.height + 'px';
        outerDiv.style.position = 'relative';

        el.appendChild(outerDiv);

        /* Create our canvas object */
        canvas = document.createElement('canvas');
        canvas.setAttribute('width', settings.width);
        canvas.setAttribute('height', settings.height);
        outerDiv.appendChild(canvas);

        /* Create div elements we'll use for text. Drawing text is
         * possible with canvas but it is tricky working with custom
         * fonts as it is hard to guarantee when they become available
         * with differences between browsers. DOM is a safer bet here */
        percentageText = document.createElement('div');
        percentageText.style.width = (settings.width.toString() - 2) + 'px';
        percentageText.style.textAlign = 'center';
        percentageText.style.height = '50px';
        percentageText.style.left = 0;
        percentageText.style.position = 'absolute';

        valueText = document.createElement('div');
        valueText.style.width = (settings.width - 2).toString() + 'px';
        valueText.style.textAlign = 'center';
        valueText.style.height = '0px';
        valueText.style.overflow = 'hidden';
        valueText.style.left = 0;
        valueText.style.position = 'absolute';

        /* Force text items to not allow selection */
        items = [valueText, percentageText];
        for (i  = 0; i < items.length; i += 1) {
            item = items[i];
            selectors = [
                '-webkit-user-select',
                '-khtml-user-select',
                '-moz-user-select',
                '-o-user-select',
                'user-select'];

            for (s = 0; s < selectors.length; s += 1) {
                item.style[selectors[s]] = 'none';
            }
        }

        /* Add the new dom elements to the containing div */
        outerDiv.appendChild(percentageText);
        outerDiv.appendChild(valueText);

        /* Get a reference to the context of our canvas object */
        ctx = canvas.getContext("2d");


        /* Set various initial values */

        /* Centre point */
        cX = (canvas.width / 2) - 1;
        cY = (canvas.height / 2) - 1;

        /* Create our linear gradient for the outer ring */
        lingrad = ctx.createLinearGradient(cX, 0, cX, canvas.height);
        lingrad.addColorStop(0, '#ffffff');
        lingrad.addColorStop(1, '#fafafa');

        /* Create inner gradient for the outer ring */
        innerGrad = ctx.createLinearGradient(cX, cX * 0.133333, cX, canvas.height - cX * 0.133333);
        innerGrad.addColorStop(0, '#f03b3b');
        innerGrad.addColorStop(1, '#e33232');

        /* Tube gradient (background, not the spiral gradient) */
        tubeGrad = ctx.createLinearGradient(cX, 0, cX, canvas.height);
        tubeGrad.addColorStop(0, '#f6f6f6');
        tubeGrad.addColorStop(1, '#e2e2e2');

        /* The inner circle is 2/3rds the size of the outer one */
        innerRadius = cX * 0.6666;
        /* Outer radius is the same as the width / 2, same as the centre x
        * (but we leave a little room so the borders aren't truncated) */
        radius = cX - 2;

        /* Calculate the radii of the inner tube */
        innerBarRadius = innerRadius + (cX * 0.06);
        outerBarRadius = radius - (cX * 0.06);

        /* Bottom left angle */
        startAngle = 2.1707963267949;
        /* Bottom right angle */
        endAngle = 0.9707963267949 + (Math.PI * 2.0);

        /* Nicer to pass counterClockwise / clockwise into canvas functions
        * than true / false */
        counterClockwise = false;

        /* Borders should be 1px */
        ctx.lineWidth = 1;

        /**
         * Little helper method for transforming points on a given
         * angle and distance for code clarity
         */
        applyAngle = function (point, angle, distance) {
            return {
                x : point.x + (Math.cos(angle) * distance),
                y : point.y + (Math.sin(angle) * distance)
            };
        };


        /**
         * render the widget in its entirety.
         */
        drawLoader = function () {
            /* Clear canvas entirely */
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            /*** IMAGERY ***/

            /* draw outer circle */
            ctx.fillStyle = lingrad;
            ctx.beginPath();
            ctx.strokeStyle = '#d6d6d6';
            ctx.arc(cX, cY, radius, 0, Math.PI * 2, counterClockwise);
            ctx.fill();
            ctx.stroke();

            /* draw inner circle */
            ctx.fillStyle = innerGrad;
            ctx.beginPath();
            ctx.arc(cX, cY, innerRadius, 0, Math.PI * 2, counterClockwise);
            ctx.fill();
            ctx.strokeStyle = '#d6d6d6';
            ctx.stroke();

            ctx.beginPath();

            /**
             * Helper function - adds a path (without calls to beginPath or closePath)
             * to the context which describes the inner tube. We use this for drawing
             * the background of the inner tube (which is always at 100%) and the
             * progress meter itself, which may vary from 0-100% */
            function makeInnerTubePath(startAngle, endAngle) {
                var centrePoint, startPoint, controlAngle, capLength, c1, c2, point1, point2;
                centrePoint = {
                    x : cX,
                    y : cY
                };

                startPoint = applyAngle(centrePoint, startAngle, innerBarRadius);

                ctx.moveTo(startPoint.x, startPoint.y);

                point1 = applyAngle(centrePoint, endAngle, innerBarRadius);
                point2 = applyAngle(centrePoint, endAngle, outerBarRadius);

                controlAngle = endAngle + (3.142 / 2.0);
                /* Cap length - a fifth of the canvas size minus 4 pixels */
                capLength = (cX * 0.20) - 4;

                c1 = applyAngle(point1, controlAngle, capLength);
                c2 = applyAngle(point2, controlAngle, capLength);

                ctx.arc(cX, cY, innerBarRadius, startAngle, endAngle, false);
                ctx.bezierCurveTo(c1.x, c1.y, c2.x, c2.y, point2.x, point2.y);
                ctx.arc(cX, cY, outerBarRadius, endAngle, startAngle, true);

                point1 = applyAngle(centrePoint, startAngle, innerBarRadius);
                point2 = applyAngle(centrePoint, startAngle, outerBarRadius);

                controlAngle = startAngle - (3.142 / 2.0);

                c1 = applyAngle(point2, controlAngle, capLength);
                c2 = applyAngle(point1, controlAngle, capLength);

                ctx.bezierCurveTo(c1.x, c1.y, c2.x, c2.y, point1.x, point1.y);
            }

            /* Background tube */
            ctx.beginPath();
            ctx.strokeStyle = '#d6d6d6';
            makeInnerTubePath(startAngle, endAngle);

            ctx.fillStyle = tubeGrad;
            ctx.fill();
            ctx.stroke();

            /* Calculate angles for the the progress metre */
            completeAngle = startAngle + (progress * (endAngle - startAngle));

            ctx.beginPath();
            makeInnerTubePath(startAngle, completeAngle);

            /* We're going to apply a clip so save the current state */
            ctx.save();
            /* Clip so we can apply the image gradient */
            ctx.clip();

            /* Draw the spiral gradient over the clipped area */
            ctx.drawImage(gradient, 0, 0, canvas.width, canvas.height);

            /* Undo the clip */
            ctx.restore();

            /* Draw the outline of the path */
            ctx.beginPath();
            makeInnerTubePath(startAngle, completeAngle);
            ctx.stroke();

            /*** TEXT ***/
            (function () {
                var fontSize, string, smallSize, heightRemaining;
                /* Calculate the size of the font based on the canvas size */
                fontSize = cX / 3;

                percentageText.style.top = ((settings.height / 2.4) - (fontSize / 4)).toString() + 'px';
                percentageText.style.color = '#ffffff';
                percentageText.style.font = fontSize.toString() + 'px Oxygen';
                percentageText.style.textShadow = '0 1px 1px #000000';

                /* Calculate the text for the given percentage */
                string = (progress * 100.0).toFixed(0) + '%';

                percentageText.innerHTML = string;

                /* Calculate font and placement of small 'value' text */
                smallSize = cX / 5.5;
                valueText.style.color = '#ffffff';
                valueText.style.font = smallSize.toString() + 'px Oxygen';
                valueText.style.height = smallSize.toString() + 'px';
                valueText.style.textShadow = 'None';

                /* Ugly vertical align calculations - fit into bottom ring.
                 * The bottom ring occupes 1/6 of the diameter of the circle */
                heightRemaining = (settings.height * 0.16666666) - smallSize;
                valueText.style.top = ((settings.height * 0.8333333) + (heightRemaining / 4)).toString() + 'px';
            }());
        };

        /**
        * Check the progress value and ensure it is within the correct bounds [0..1]
        */
        clipValue = function () {
            if (progress < 0) {
                progress = 0;
            }

            if (progress > 1.0) {
                progress = 1.0;
            }
        };

        /* Sets the current progress level of the loader
         *
         * @param value the progress value, from 0 to 1. Values outside this range
         * will be clipped
         */
        setProgress = function (value) {
            /* Clip values to the range [0..1] */
            progress = value;
            clipValue();
            drawLoader();
        };

        this.setProgress = setProgress;

        setValue = function (val) {
            value = val;
            valueText.innerHTML = value;
        };

        ready = function(fn) {
            if (imageLoaded) {
                fn();
            } else {
                gradient.addEventListener('load', fn);
            }
        };

        this.setValue = setValue;
        this.setValue(settings.value);

        this.loaded = ready;

        progress = settings.progress;
        clipValue();

        /* Do an initial draw */
        drawLoader();


        /* In controllable mode, add event handlers */
        if (params.controllable === true) {
            (function () {
                var mouseDown, getDistance, adjustProgressWithXY;
                getDistance = function (x, y) {
                    return Math.sqrt(Math.pow(x - cX, 2) + Math.pow(y - cY, 2));
                };

                mouseDown = false;

                adjustProgressWithXY = function (x, y) {
                    /* within the bar, calculate angle of touch point */
                    var pX, pY, angle, startTouchAngle, range, posValue;
                    pX = x - cX;
                    pY = y - cY;

                    angle = Math.atan2(pY, pX);
                    if (angle > Math.PI / 2.0) {
                        angle -= (Math.PI * 2.0);
                    }

                    startTouchAngle = startAngle - (Math.PI * 2.0);
                    range = endAngle - startAngle;
                    posValue = (angle - startTouchAngle) / range;
                    setProgress(posValue);

                    if (params.onProgressUpdate !== undefined) {
                        /* use the progress value as this will have been clipped
                         * to the correct range [0..1] after the call to setProgress
                         */
                        params.onProgressUpdate.call(plugin, progress);
                    }
                };

                outerDiv.addEventListener('mousedown', function (e) {
                    var offset, x, y, distance;
                    offset = this.getBoundingClientRect();
                    x = e.pageX - offset.left;
                    y = e.pageY - offset.top;

                    distance = getDistance(x, y);

                    if (distance > innerRadius && distance < radius) {
                        mouseDown = true;
                        adjustProgressWithXY(x, y);
                    }
                });

                outerDiv.addEventListener('mouseup', function () {
                    mouseDown = false;
                });

                outerDiv.addEventListener('mousemove', function (e) {
                    var offset, x, y;
                    if (mouseDown) {
                        offset = this.getBoundingClientRect();
                        x = e.pageX - offset.left;
                        y = e.pageY - offset.top;
                        adjustProgressWithXY(x, y);
                    }
                });

                outerDiv.addEventListener('mouseleave', function (e) {
                    mouseDown = false;
                });
            }());
        }

        return this;
    }
})();

// If jQuery is available, define this as a jQuery plugin
if (typeof jQuery !== 'undefined') {
    /*global jQuery */
    (function ($) {
        /* Strict mode for this plugin */

        /** Percentage loader
         * @param    params    Specify options in {}. May be on of width, height, progress or value.
         *
         * @example $("#myloader-container).percentageLoader({
                width : 256,  // width in pixels
                height : 256, // height in pixels
                progress: 0,  // initialise progress bar position, within the range [0..1]
                value: '0kb'  // initialise text label to this value
            });
         */
        $.fn.percentageLoader = function (params) {
            return this.each(function () {
                if (!$.data(this, 'dj_percentageloader')) {
                    $.data(this, 'dj_percentageloader', new PercentageLoader(this, params));
                } else {
                    var plugin = $.data(this, 'dj_percentageloader');
                    if (params['value'] !== undefined) {
                        plugin.setValue(params['value']);
                    }

                    if (params['progress'] !== undefined) {
                        plugin.setProgress(params['progress']);
                    }

                    if (params['onready'] !== undefined) {
                        plugin.loaded(params['onready']);
                    }
                }
            });
        };
    }(jQuery));
}
