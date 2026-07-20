import funkin.visuals.objects.Alphabet;

Conductor.bpm = CoolVars.data.bpm;

var logoBop:Bool = true;

var texts:FlxTypedGroup<FlxBasic> = new FlxTypedGroup<FlxBasic>();
add(texts);

function spawnIntroText(text:String)
{
    if (text == null)
    {
        texts.clear();

        return;
    }

    var objOffset:Float = FlxG.height * 0.225;

    if (texts.members.length >= 1)
    {
        var lastObj:Alphabet = texts.members[texts.members.length - 1];

        objOffset = lastObj.y + lastObj.height + 15;
    }

    var obj:Alphabet = new Alphabet(FlxG.width / 2, objOffset, text);
    texts.add(obj);
    obj.alignment = 'centered';
}

var menubg:FlxSprite = new FlxSprite(-130, -100);
menubg.loadGraphic(Paths.image('menuassets/mainmenubg'));
menubg.scale.set(1.1, 1.1);
menubg.updateHitbox();
menubg.screenCenter();
add(menubg);

var tvroom:FlxSprite = new FlxSprite(-130, -100);
tvroom.loadGraphic(Paths.image('menuassets/tvRoom'));
tvroom.scale.set(0.39, 0.39);
tvroom.updateHitbox();
tvroom.screenCenter();
add(tvroom);

var logo:FlxSprite = new FlxSprite(-130, -100);
logo.loadGraphic(Paths.image('menuassets/logo'));
logo.scale.set(0.15, 0.15);
logo.updateHitbox();
logo.screenCenter();
add(logo);

var enter:FlxSprite = new FlxSprite(135, 600);
enter.frames = Paths.getSparrowAtlas('menus/title/enter');
enter.animation.addByPrefix('idle', 'idle', 1);
enter.animation.addByPrefix('press', 'press', 24);
enter.animation.addByPrefix('freeze', 'freeze', 1);
enter.animation.play('idle');
enter.color = FlxColor.CYAN;

FlxTween.tween(enter, {alpha: 0.25}, 1.5, {ease: FlxEase.smoothStepInOut, type: FlxTweenType.PINGPONG});

var finishedIntro:Bool = false;

function finishIntro()
{
    if (finishedIntro)
        return;

    finishedIntro = true;

    texts.clear();
        
    add(logo);

    add(enter);
}

function onSafeBeatHit(safeBeat:Int)
{
    if (!finishedIntro)
    {
        if (safeBeat >= 16)
        {
            finishIntro();

            if (ClientPrefs.data.flashing)
                camGame.flash(FlxColor.WHITE, 2);
        } else if (introTexts.exists(safeBeat)) {
            spawnIntroText(introTexts.get(safeBeat));
        }
    }
}

function postBeatHit(curBeat:Int)
{
    if (finishedIntro)
    {
        if (logoBop)
        {
            logo.scale.set(0.16, 0.16);

            FlxTween.cancelTweensOf(logo.scale);
            FlxTween.tween(logo.scale,
            {
                x: 0.15,
                y: 0.15
            },
            0.3,
            {
                ease: FlxEase.quadOut
            });
        }
    }
}

finishIntro();

if (FlxG.sound.music == null || !FlxG.sound.music.playing)
    Conductor.play(Paths.music('freakyMenu'));

var canSelect:Bool = true;

function onUpdate(elapsed:Float)
{
    Conductor.songPosition = FlxG.sound.music.time;

    if (canSelect)
    {
        if (Controls.ACCEPT)
        {
            if (finishedIntro)
            {
                logoBop = false;

                FlxG.camera.shake(0.01, 0.4);

                canSelect = false;

                FlxTween.cancelTweensOf(enter);

                enter.alpha = 1;
                enter.color = FlxColor.WHITE;
                enter.animation.play(ClientPrefs.data.flashing ? 'press' : 'freeze', true);

                CoolUtil.playSound('confirm');

                FlxTimer.wait(1, () -> {
                    FlxTween.tween(tvroom.scale,
                    {
                        x: 1,
                        y: 1
                    },
                    1,
                    {
                        ease: FlxEase.cubeInOut
                    });

                    FlxTween.tween(logo.scale,
                    {
                        x: .25,
                        y: .25
                    },
                    1,
                    {
                        ease: FlxEase.cubeInOut
                    });

                    FlxTimer.wait(0.4, () -> FlxG.camera.shake(0.002, 0.2));
                    FlxTimer.wait(0.6, () -> FlxG.camera.shake(0.004, 0.2));
                    FlxTimer.wait(0.8, () -> FlxG.camera.shake(0.007, 0.2));
                    FlxTimer.wait(1, () -> FlxG.camera.shake(0.01, 1.8));

                    FlxTimer.wait(1.2, () -> {
                        FlxTween.tween(tvroom, {alpha: 0}, 1, {ease: FlxEase.cubeInOut});
                    });

                    FlxTimer.wait(1.8, () -> {
                        FlxTween.tween(logo.scale,
                        {
                            x: .12,
                            y: .12
                        },
                        1.2,
                        {
                            ease: FlxEase.cubeInOut
                        });
                    });

                    FlxTimer.wait(1.8, () -> FlxG.camera.shake(0.007, 0.2));
                    FlxTimer.wait(2, () -> FlxG.camera.shake(0.004, 0.2));
                    FlxTimer.wait(2.2, () -> FlxG.camera.shake(0, 0));
                });

                FlxTimer.wait(4.2, () -> {
                    CoolUtil.switchState('MainMenuState', true, true);
                });
            } else {
                finishIntro();

                camGame.flash(FlxColor.BLACK, 0.5);
            }
        }
    }
}