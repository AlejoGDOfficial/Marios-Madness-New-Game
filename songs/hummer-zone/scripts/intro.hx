skipCountdown = true;

function postCreate()
{
    blue = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF05132E);
    blue.alpha = 0.8;
    blue.cameras = [camHUD];
    add(blue);

    black = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    black.alpha = 0.99999;
    black.cameras = [camHUD];
    add(black);

    circle = new FlxSprite();
    circle.loadGraphic(Paths.image("hummerHud/circle"));
    circle.scale.set(0.4, 0.4);
    circle.cameras = [camOther];
    circle.x = 2000;
    circle.y = -100;
    add(circle);

    hummer = new FlxSprite();
    hummer.loadGraphic(Paths.image("hummerHud/hummer"));
    hummer.scale.set(0.4, 0.4);
    hummer.cameras = [camOther];
    hummer.x = -2000;
    hummer.y = 110;
    add(hummer);

    zone = new FlxSprite();
    zone.loadGraphic(Paths.image("hummerHud/zone"));
    zone.scale.set(0.4, 0.4);
    zone.cameras = [camOther];
    zone.x = -2000;
    zone.y = 190;
    add(zone);

    act = new FlxSprite();
    act.loadGraphic(Paths.image("hummerHud/act3"));
    act.scale.set(0.4, 0.4);
    act.cameras = [camOther];
    act.x = 2000;
    act.y = 210;
    add(act);

    FlxTween.tween(hummer, {x: 240}, 0.35);
    FlxTimer.wait(0.1, function() FlxTween.tween(circle, {x: 630}, 0.35));
    FlxTimer.wait(0.2, function() FlxTween.tween(zone, {x: 470}, 0.35));
    FlxTimer.wait(0.4, function() FlxTween.tween(act, {x: 630}, 0.35));

    FlxTimer.wait(2, function() FlxTween.tween(hummer, {x: -2000}, 0.5));
    FlxTimer.wait(2, function() FlxTween.tween(circle, {x: 2000}, 0.5));
    FlxTimer.wait(2, function() FlxTween.tween(zone, {x: -2000}, 0.5));
    FlxTimer.wait(2, function() FlxTween.tween(act, {x: 2000}, 0.5));

    FlxTimer.wait(2.4, function() black.alpha = 0);
    FlxTimer.wait(2.4, function() FlxTween.tween(blue, {alpha: 0}, 0.4));
}