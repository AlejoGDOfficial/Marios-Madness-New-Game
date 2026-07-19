import funkin.visuals.shaders.FXShader;

startTime = Conductor.beatToTime(40);

final shader:FXShader = new FXShader('black');

function postCreate()
{
    shader.set({threshold: 0});
    //camGame.setShaders([shader]);
}

var updateFunc:Float -> Void;
var curTime:Float = 0;

cacheCharacter('mariohorror-melt');

function onSafeBeatHit(curBeat:Int)
{
    switch (curBeat)
    {
        case 12:
        camGame.tweenZoom(.7, 1, {ease: FlxEase.cubeOut});
        case 28:
        camGame.tweenZoom(.9, 1, {ease: FlxEase.cubeOut});
        case 32:
        camGame.tweenZoom(.6, 1, {ease: FlxEase.cubeOut});
        case 60:
        camGame.tweenZoom(.9, 1, {ease: FlxEase.cubeOut});
        case 61:
        FlxTween.num(0, .02, 1, {ease: FlxEase.quadIn, onComplete: _ -> camGame.stopFX()}, v -> camGame.shake(v, .05));
        case 64:
        camGame.tweenZoom(.6, 1, {ease: FlxEase.cubeOut});
        case 740:
            FlxTween.num(1, 1, 2, {ease: FlxEase.cubeOut}, v -> shader.set({threshold: v}));
        case 748: //MELT TIME BEGINS RAHHH
            changeCharacter(dad, 'mariohorror-melt');

            allowCameraMoving = false;
            camGame.tweenZoom(.7, 14, {ease: FlxEase.cubeOut});
            camGame.tweenPosition(100, 400, 14, {ease: FlxEase.cubeOut});
            FlxTween.num(1, .6, 3, {ease: FlxEase.cubeOut}, v -> shader.set({threshold: v}));
        case 776:
            camGame.tweenPosition(2000, 500, 2, {ease: FlxEase.cubeInOut});
            camGame.tweenZoom(.5, 2, {ease: FlxEase.quartIn});
        case 780:
            camGame.tweenZoom(.85, 2, {ease: FlxEase.quartOut});
        case 796:
            camGame.tweenPosition(1720, 550, .5, {ease: FlxEase.quadOut});
        case 812:
            camGame.tweenZoom(1.2, 2, {ease: FlxEase.quartOut});
        case 814:
            camGame.tweenPosition(200, 400, .3, {ease: FlxEase.cubeOut});
            camGame.tweenZoom(.7, .5, {ease: FlxEase.quartOut});
        case 815:
            camGame.tweenZoom(.4, .5, {ease: FlxEase.quartIn});
        case 816:
            allowCameraMoving = true;
            camGame.tweenZoom(.55, 1, {ease: FlxEase.quartOut});
        case 818:
            FlxTween.num(.6, .3, 1, {ease: FlxEase.cubeOut}, v -> shader.set({threshold: v}));
    }
}

function onEventHit(id:String)
{
    debugTrace(id);
}

spawnNotes = false;

function onUpdate(elapsed:Float)
{
    curTime += elapsed;

    if (updateFunc != null)
        updateFunc(elapsed);
}