import funkin.visuals.shaders.FXShader;

startTime = Conductor.beatToTime(740);

final shader:FXShader = new FXShader('black');

function postCreate()
{
    shader.set({threshold: 0});
    camGame.setShaders([shader]);
}

var updateFunc:Float -> Void;
var curTime:Float = 0;

function onSafeBeatHit(curBeat:Int)
{
    switch (curBeat)
    {
        case 740:
            FlxTween.num(1, 1, 2, {ease: FlxEase.cubeOut}, v -> shader.set({threshold: v}));
        case 748: //MELT TIME BEGINS RAHHH
            allowCameraMoving = false;
            camGame.tweenZoom(.85, 2, {ease: FlxEase.cubeOut});
            camGame.tweenPosition(100, 400, 2, {ease: FlxEase.cubeOut});
            FlxTween.num(1, .6, 3, {ease: FlxEase.cubeOut}, v -> shader.set({threshold: v}));
        case 776:
            camGame.tweenPosition(2000, 500, 2, {ease: FlxEase.cubeInOut});
            camGame.tweenZoom(.5, 2, {ease: FlxEase.quartIn});
        case 780:
            camGame.tweenZoom(.85, 2, {ease: FlxEase.quartOut});
        case 796:
            camGame.tweenPosition(1800, 550, .5, {ease: FlxEase.cubeOut});
        case 816:
            allowCameraMoving = true;
            FlxTween.num(.6, .3, 1, {ease: FlxEase.cubeOut}, v -> shader.set({threshold: v}));
    }
}

function onUpdate(elapsed:Float)
{
    curTime += elapsed;

    if (updateFunc != null)
        updateFunc(elapsed);
}