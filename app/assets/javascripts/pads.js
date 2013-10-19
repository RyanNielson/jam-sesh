
var oldNote = -1;
var dot = {};
var size = 0;
var animationSpeed = 10;
var gravity = 25;
var winW, winH;
var lastOrientation;
var animationId;
//var notes = [0, 2, 3, 5, 7];
var notes = [0, 0, 2, 4, 5, 5, 7, 7];

var baseNote = 440;

function init() {
    gyro.frequency = 200;

    gyro.startTracking(function(o){
        var xDelta, yDelta;
        switch (window.orientation) {
            /*case 0:
                 = o.z;
                yDelta = o.x;
                break;
            case 180:
                xDelta = o.z * -1;
                yDelta = o.x * -1;
                break;
            case 90:
                xDelta = o.x;
                yDelta = o.z * -1;
                break;
            case -90:
                xDelta = o.x * -1;
                yDelta = o.z;
                break;*/
            default:
                xDelta = (o.x + 10) * 5 / 2;
                yDelta = (o.z + 10) * 5 / 2;
        }
        window.xDelta = xDelta;
        window.yDelta = yDelta;
        renderDot(xDelta, yDelta);
    });
    lastOrientation = {};
    window.addEventListener('resize', doLayout, false);
    if ('webkitRequestFullScreen' in document.body) {
        document.addEventListener('webkitfullscreenchange', onFullscreenChange, false);
    } else {
        id('fullscreenButton').style.display = 'none';
    }
    window.addEventListener('deviceorientation', deviceOrientationTest, false);
    doLayout(document);
}

function deviceOrientationTest(event) {
    window.removeEventListener('deviceorientation', deviceOrientationTest);
    if (event.beta != null && event.gamma != null) {
        window.addEventListener('deviceorientation', onDeviceOrientationChange, false);
        animationId = setInterval(onRenderUpdate, animationSpeed); 
    }
}

function doLayout(event) {
    winW = window.innerWidth;
    winH = window.innerHeight;
    /*var surface = id('surface');
    surface.width = winW;
    surface.height = winH;*/
    dot = {
    	x: (winW-size)/2,
    	y: (winH-size)/2,
        winW: winW
    }
    //renderDot();
}

function renderDot(x, y) {
    //console.log(dot.x/winW);
    //console.log( (dot.x/winW)*50 );
    //$('.page-wrap').css({boxShadow: 'inset 0 ' + y + 'px 100px -45px rgba(255,0,102,0.85), inset -' + x + 'px 0 100px -45px rgba(255,0,102,0.85)'});
    //console.log('inset ' + dot.x/winW*100 + 'px 0px 100px -45px rgba(255,0,102,0.85), inset -' + dot.y/winH*100 + 'px 0 100px -45px rgba(255,0,102,0.85)');
    //console.log('inset 0 ' + (dot.y/winH)*50 + 'px 100px -45px rgba(255,0,102,0.85), inset -' + (dot.x/winW)*50 + 'px 0 100px -45px rgba(255,0,102,0.85)');
    /*var surface = id('surface');
    var context = surface.getContext('2d');
    context.canvas.width = context.canvas.width;
    context.fillStyle = dot.color;
    context.arc(dot.x - (dot.size/2), dot.y - (dot.size/2), dot.size, 0, 2 * Math.PI, false);
    context.fill();
    //oscillator1.frequency.value = (dot.x/10) * (dot.y/10);
    noteSize = surface.width/notes.length;
    theNote = Math.floor(dot.x / noteSize);

    if(theNote != oldNote){
        oldNote = theNote;
        $.ajax({
            url: '/submit_accelerometer',
            type: 'POST',
            data: {accelerometer: notes[theNote]}
        });
    }*/
}

function moveDot(x, y) {
	dot.x += (x/gravity);
    dot.y += (y/gravity);
    if(dot.y >= winH-size)
    	dot.y = winH-size;
    if(dot.x >= winW-size)
    	dot.x = winW-size;
    if(dot.y <= 0)
    	dot.y = 0;
    if(dot.x <= 0)
    	dot.x = 0;
    renderDot();
}

function onDeviceOrientationChange(event) {
    lastOrientation.gamma = event.gamma;
    lastOrientation.beta = event.beta;
}

function onRenderUpdate(event) {
    var xDelta, yDelta;
    switch (window.orientation) {
        case 0:
            xDelta = lastOrientation.gamma;
            yDelta = lastOrientation.beta;
            break;
        case 180:
            xDelta = lastOrientation.gamma * -1;
            yDelta = lastOrientation.beta * -1;
            break;
        case 90:
            xDelta = lastOrientation.beta;
            yDelta = lastOrientation.gamma * -1;
            break;
        case -90:
            xDelta = lastOrientation.beta * -1;
            yDelta = lastOrientation.gamma;
            break;
        default:
            xDelta = lastOrientation.gamma;
            yDelta = lastOrientation.beta;
    }
    //moveDot(xDelta, yDelta);
}

function onFullscreen(event) {
    document.body.webkitRequestFullScreen();
}

function onFullscreenChange(event) {
    if (document.webkitIsFullScreen) {
        id('fullscreenButton').style.display = 'none';
        if (navigator.webkitPointer) navigator.webkitPointer.lock(document.body);
    } else {
        if (navigator.webkitPointer) navigator.webkitPointer.unlock();
        id('fullscreenButton').style.display = 'block';
    }
}

function id(name) { return document.getElementById(name); };
function getRandomWholeNumber(min, max) { return Math.round(((Math.random() * (max - min)) + min)); };
function getRandomHex() { return (Math.round(Math.random() * 0xFFFFFF)).toString(16); };

(function($) {
    $(document).ready(function(){
        if($('#pads').length>0){
            init();
        }
    });
})(jQuery);