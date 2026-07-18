cameraFactory = () -> new FullScreenCamera();

final factor:Float = 1.5;

if (FlxG.fullscreen) FlxG.fullscreen = false;

CoolUtil.resizeGame(
    Std.int(FlxG.stage.fullScreenWidth * 0.54),
    Std.int(FlxG.stage.fullScreenHeight * 0.64),
    !CoolVars.data.developerMode,
    factor
);

window.x = Std.int((window.display.bounds.width - window.width) / 2);
window.y = Std.int((window.display.bounds.height - window.height) / 2);

function postCreate()
{
    allowCameraMoving = false;

    camGame.position.set(260, 1000);
    camGame.snapToTarget();
}

function onDestroy()
    CoolUtil.resizeGame(1280, 720, !CoolVars.data.developerMode, factor);