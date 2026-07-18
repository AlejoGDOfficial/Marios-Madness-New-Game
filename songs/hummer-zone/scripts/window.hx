import openfl.Lib;
import lime.app.Application;

function postCreate()
{
    FlxG.resizeWindow(1036, 692);
    FlxG.resizeGame(1036, 692);

    Application.current.window.x = Std.int((Application.current.window.display.bounds.width - Application.current.window.width) / 2);
    Application.current.window.y = Std.int((Application.current.window.display.bounds.height - Application.current.window.height) / 2);
}