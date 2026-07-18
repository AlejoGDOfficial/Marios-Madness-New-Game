function postCreate()
{
    trace(FlxG.state);
}

function postUpdate(elapsed:Float)
{
    var speed:Float = FlxG.keys.pressed.SPACE ? 5 : 1;

    FlxG.timeScale = speed;

    if (FlxG.sound.music != null)
        FlxG.sound.music.pitch = speed;

    if (vocals != null)
        vocals.pitch = speed;
}