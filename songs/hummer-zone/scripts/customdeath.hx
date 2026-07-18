final playState:PlayState = PlayState.instance;

var somariDeath:Bool = false;
var restarting:Bool = false;
var centerX = FlxG.width / 2;
var canRestart:Bool = false;

function postUpdate(elapsed:Float)
{
    if (!somariDeath && health <= 0.05)
    {
        somariDeath = true;
        health = 0.01;

        playState.pauseMusic();
        playState.canPause = false;

        for (strl in strumLines)
        {
            for (strum in strl.strums)
                FlxTween.tween(strum, {alpha: 0}, 0.25);

            for (note in strl.notes)
                FlxTween.tween(note, {alpha: 0}, 0.25);
        }

        for (obj in uiGroup.members)
        {
            if (obj != null)
                FlxTween.tween(obj, {alpha: 0}, 0.25);
        }

        blue = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF05132E);
        blue.alpha = 0;
        blue.cameras = [camHUD];

        black = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        black.cameras = [camHUD];
        black.alpha = 0;
        add(black);

        pop = new FlxSprite();
        pop.frames = Paths.getSparrowAtlas("hummerHud/pop");
        pop.animation.addByPrefix("pop", "pop", 24, false);
        pop.animation.play("pop");
        pop.x = boyfriend.x;
        pop.y = boyfriend.y;

        playState.defaultCamZoom = 0.4;
        FlxTween.tween(playState.camGame, {zoom: 0.4}, 0.7, {ease: FlxEase.cubeOut});

        boyfriend.animation.paused = true;

        dad.playAnim("spin", true);

        FlxTween.tween(dad, {x: boyfriend.x}, 0.6, {ease: FlxEase.linear});
        FlxTween.tween(dad, {y: boyfriend.y -500}, 0.3, {ease: FlxEase.cubeOut});

        FlxTimer.wait(0.3, function() FlxTween.tween(dad, {y: boyfriend.y}, 0.3, {ease: FlxEase.cubeIn}));

        FlxTimer.wait(0.65, function() FlxG.camera.shake(0.03, 0.14));
        FlxTimer.wait(0.65, function() add(pop));
        FlxTimer.wait(0.7, function() FlxTween.tween(dad, {x: boyfriend.x + 2000}, 0.7, {ease: FlxEase.linear}));
        FlxTimer.wait(0.7, function() FlxTween.tween(dad, {y: boyfriend.y -700}, 0.35, {ease: FlxEase.cubeOut}));

        FlxTimer.wait(1.05, function() FlxTween.tween(dad, {y: boyfriend.y}, 0.35, {ease: FlxEase.cubeIn}));

        game = new FlxSprite();
        game.loadGraphic(Paths.image("hummerHud/game"));
        game.scale.set(0.4, 0.4);
        game.updateHitbox();
        game.cameras = [camOther];
        game.x = -2000;
        game.y = (FlxG.height - game.height) / 2;
        add(game);

        over = new FlxSprite();
        over.loadGraphic(Paths.image("hummerHud/over"));
        over.scale.set(0.4, 0.4);
        over.updateHitbox();
        over.cameras = [camOther];
        over.x = 2000;
        over.y = (FlxG.height - over.height) / 2;
        add(over);

        FlxTimer.wait(1.5, function() FlxTween.tween(game, {x: centerX - game.width - 20}, 1));
        FlxTimer.wait(1.5, function() FlxTween.tween(over, {x: centerX + 20}, 1));

        FlxTimer.wait(2.5, function() canRestart = true);
    }

    if (somariDeath)
    {
        playState.defaultCamZoom = 0.4;

        if (dad.animation.curAnim == null || dad.animation.curAnim.name != "spin")
            dad.playAnim("spin", true);
    }

    if (somariDeath && canRestart && !restarting && FlxG.keys.justPressed.ENTER)
    {
        restarting = true;

        add(blue);

        FlxTween.tween(game, {alpha: 0}, 0.4);
        FlxTween.tween(over, {alpha: 0}, 0.4);

        FlxTween.tween(blue, {alpha: 1}, 0.4, {
            onComplete: function()
            {
                black.alpha = 1;
                playState.restart();
            }
        });
    }
}