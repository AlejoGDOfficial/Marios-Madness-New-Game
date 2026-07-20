import funkin.visuals.objects.Alphabet;

import flixel.input.keyboard.FlxKey;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText.FlxTextBorderStyle;

import sys.Http;

using StringTools;

@typedef OptionData = {
    @:optional var state:String;
    @:optional var variables:StringMap<Dynamic>;
    @:optional var behavior:Void -> Void;
    @:optional var overrideDefaultBehavior:Bool;
};

var canMouseMove:Bool = false;

var menuShakeAmount:Float = 0.5;
var menuShakeSpeed:Float = 0.2;

var bgMoveAmount:Float = 4;
var bgMoveSpeed:Float = 0.4;

var bgDefaultX:Float = 0;
var bgDefaultY:Float = 0;

var logoDefaultX:Float = 0;
var logoDefaultY:Float = 0;

var selInt:Int = Save.custom.data.mainMenuSelection ?? 0;

var sprites:Array<FlxSprite> = [];

final OPTION_SPACE:Int = 120;
final OPTION_Y:Int = 270;

final CAMERA_SPEED:Float = 0.25;

var canSelect:Bool = false;

var options:StringMap<OptionData> = [
    {
        id: 'storyMode',
        state: 'StoryMenuState'
    },
    {
        id: 'freeplay',
        state: 'FreeplayState'
    },
    {
        id: 'credits',
        state: 'CreditsState'
    },
    {
        id: 'options',
        state: 'OptionsState',
        arguments: [false]
    }
];

function createOption(id:String, index:Int)
{
    var spr:FlxSprite = new FlxSprite(0, OPTION_Y + index * OPTION_SPACE);
    spr.frames = Paths.getSparrowAtlas('menus/main/' + id);
    spr.animation.addByPrefix('basic', 'basic', 24, true);
    spr.animation.addByPrefix('white', 'white', 24, true);
    spr.animation.play('basic');
    spr.scale.set(0.65, 0.65);
    spr.updateHitbox();
    spr.x = FlxG.width / 2 - spr.width / 2;
    spr.y = OPTION_Y + index * OPTION_SPACE;

    add(spr);

    sprites.push(spr);
}

function changeSelection()
{
    if (selInt < 0)
        selInt = options.length - 1;

    if (selInt > options.length - 1)
        selInt = 0;

    for (index => spr in sprites)
    {
        spr.animation.play(index == selInt ? 'white' : 'basic', true);
        spr.centerOffsets();
        spr.updateHitbox();
        spr.x = FlxG.width / 2 - spr.width / 2;
        spr.y = OPTION_Y + index * OPTION_SPACE;
    }
}

function selectMenu(data:OptionData)
{
    canSelect = false;

    if (ClientPrefs.data.flashing)
        FlxFlicker.flicker(sprites[selInt], 0, 0.075);
    
    for (index => spr in sprites)
        if (index != selInt)
            FlxTween.tween(spr, {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});

    CoolUtil.playSound('confirm');

    FlxTimer.wait(1, () -> {
        CoolUtil.switchState(new CustomState(data.state, data.arguments, data.arguments));
    });
}

var bg:FlxSprite = new FlxSprite(-130, -100);
bg.loadGraphic(Paths.image('menuassets/mainmenubg'));
bg.scale.set(1.1, 1.1);
bg.updateHitbox();
bg.screenCenter();
bgDefaultX = bg.x;
bgDefaultY = bg.y;
add(bg);

var logo:FlxSprite = new FlxSprite(-130, -100);
logo.loadGraphic(Paths.image('menuassets/logo'));
logo.scale.set(0.12, 0.12);
logo.updateHitbox();
logo.screenCenter();
logoDefaultX = logo.x;
logoDefaultY = logo.y;
add(logo);

for (index => option in options)
    createOption(option.id, index);

var versionText:Array<String> = [
    'ALE Psych ' + CoolVars.engineVersion,
    (CoolVars.mobileControls ? '' : 'Press [Ctrl + Shift + ${[for (key in ClientPrefs.controls.engine.switch_mod) if (key == null || key == 0) continue; else FlxKey.toStringMap.get(key)].join(' / ')}] to open the Mods Menu'),
    'Friday Night Funkin\' v0.2.8'
];

var version = new FlxText(10, 0, 0, versionText.join('\n'));
version.setFormat(Paths.font('vcr.ttf'), 17.5, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
version.scrollFactor.set();
version.y = FlxG.height - version.height - 10;
version.borderSize = 1.125;
add(version);

if (CoolUtil.onlineVersion != null && CoolUtil.onlineVersion != CoolVars.engineVersion.trim())
{
    var prefix:String = 'ALE Psych ';

    versionText[0] = prefix + CoolVars.engineVersion + ' [Current Version: ' + CoolUtil.onlineVersion + ']';

    version.text = versionText.join('\n');

    version.addFormat(new flixel.text.FlxTextFormat(FlxColor.RED), prefix.length, prefix.length + CoolVars.engineVersion.length);
}

changeSelection();

for (index => spr in sprites)
{
    var finalY:Float = spr.y;
    spr.y = FlxG.height + 100;

    FlxTween.tween(logo, {y: -50}, 1, {ease: FlxEase.cubeInOut});

    FlxTimer.wait(0.5, () -> {
        FlxTween.tween(spr, {y: finalY}, 1.2, {
            ease: FlxEase.cubeInOut,
            startDelay: index * 0.15
        });
    });
}

FlxTimer.wait(2.2, () -> {
    logoDefaultX = logo.x;
    logoDefaultY = logo.y;
    canMouseMove = true;
    canSelect = true;
});

function postUpdate(elapsed:Float)
{
    game.camGame.scroll.x = FlxG.random.float(-menuShakeAmount, menuShakeAmount);
    game.camGame.scroll.y = FlxG.random.float(-menuShakeAmount, menuShakeAmount);

    if (canSelect)
    {
        if (Controls.BACK)
        {
            canSelect = false;

            CoolUtil.switchState('InitialState');

            CoolUtil.playSound('cancel');
        }

        var hoveredIndex:Int = -1;

        for (index => spr in sprites)
        {
            if (FlxG.mouse.overlaps(spr))
                hoveredIndex = index;
        }

        if (hoveredIndex != -1 && selInt != hoveredIndex)
        {
            selInt = hoveredIndex;
            
            changeSelection();

            CoolUtil.playSound('scroll');
        }

        if (hoveredIndex == -1)
        {
            selInt = -1;

            for (index => spr in sprites)
            {
                spr.animation.play('basic');
                spr.centerOffsets();
                spr.updateHitbox();
                spr.x = FlxG.width / 2 - spr.width / 2;
                spr.y = OPTION_Y + index * OPTION_SPACE;
            }
        }

        if (FlxG.mouse.justPressed && selInt != -1)
        {
            var data:OptionData = options[selInt];

            if (data.behavior != null)
                data.behavior();

            if (!data.overrideDefaultBehavior)
                selectMenu(data);
        }
    }

    if (canMouseMove)
    {
        bg.x = CoolUtil.fpsLerp(bg.x, bgDefaultX + ((FlxG.mouse.x - FlxG.width / 2) / (FlxG.width / 2)) * -bgMoveAmount, bgMoveSpeed);
        bg.y = CoolUtil.fpsLerp(bg.y, bgDefaultY + ((FlxG.mouse.y - FlxG.height / 2) / (FlxG.height / 2)) * -bgMoveAmount, bgMoveSpeed);

        logo.x = CoolUtil.fpsLerp(logo.x, logoDefaultX + ((FlxG.mouse.x - FlxG.width / 2) / (FlxG.width / 2)) * -(bgMoveAmount * 0.2), bgMoveSpeed);
        logo.y = CoolUtil.fpsLerp(logo.y, logoDefaultY + ((FlxG.mouse.y - FlxG.height / 2) / (FlxG.height / 2)) * -(bgMoveAmount * 0.2), bgMoveSpeed);

        for (index => spr in sprites)
        {
            spr.x = CoolUtil.fpsLerp(spr.x, FlxG.width / 2 - spr.width / 2 + ((FlxG.mouse.x - FlxG.width / 2) / (FlxG.width / 2)) * -bgMoveAmount, bgMoveSpeed);
            spr.y = CoolUtil.fpsLerp(spr.y, OPTION_Y + index * OPTION_SPACE + ((FlxG.mouse.y - FlxG.height / 2) / (FlxG.height / 2)) * -bgMoveAmount, bgMoveSpeed);
        }
    }
}

function onDestroy()
{
    Save.custom.data.mainMenuSelection = selInt;
}