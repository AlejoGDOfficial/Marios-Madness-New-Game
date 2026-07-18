package;

import lime.app.Application;

class FullScreenCamera extends scripting.haxe.ScriptedFXCamera
{
    public function new()
    {
        super();
    }

    override function setScale(x:Float, y:Float)
    {
        final window:Window = Application.current.window;

        final gameScale:FlxPoint = FlxG.scaleMode.scale;

        flashSprite.scaleX = flashSprite.scaleY = Math.max(window.width / (FlxG.width * gameScale.x), window.height / (FlxG.height * gameScale.y));

        super.setScale(x / flashSprite.scaleX, y / flashSprite.scaleY);
    }
}