package;

import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = " Custom Build";

	public static var kadeEngineVer:String = "1.5.4" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;
	var random:FlxSprite;
	var ayo:FlxSprite;
	var logo:FlxSprite;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		random = new FlxSprite();  //Made by Nong vanila >;0
		random.loadGraphic(Paths.image('main/random/p' + FlxG.random.int(1,11), 'shared'));
		random.scrollFactor.x = 0;
		random.scrollFactor.y = 0.10;
		random.screenCenter(X);
		random.screenCenter(Y);
		random.width = 1280;
		random.height = 720;
		random.y -= 50;
		random.antialiasing = true;
		add(random);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		ayo = new FlxSprite();
		ayo.loadGraphic(Paths.image('main/ayo', 'shared'));
		ayo.scrollFactor.x = 0;
		ayo.scrollFactor.y = 0.10;
		ayo.screenCenter(X);
		ayo.screenCenter(Y);
		ayo.width = 1280;
		ayo.height = 720;
		ayo.y -= 50;
		ayo.antialiasing = true;
		add(ayo);

		logo = new FlxSprite(50,-400);
		logo.frames = Paths.getSparrowAtlas('main/logo', 'shared');
		logo.animation.addByPrefix('idle', 'logo bumpin', 24);
		logo.animation.play('idle');
		logo.setGraphicSize(Std.int(logo.width * 0.8));
		logo.updateHitbox();
		logo.antialiasing = true;
		add(logo);

		var brain:FlxText = new FlxText(800,650,0,"My Brain is too Small", 108);
		brain.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		brain.setGraphicSize(Std.int(brain.width * 2));
		brain.updateHitbox();
		brain.scrollFactor.set();
		add(brain);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 40 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItem.scale.set(0.95, 0.95);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 0.15);
			menuItem.antialiasing = FlxG.save.data.antialiasing;
			if (firstStart)
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		#if mobileC
        addVirtualPad(UP_DOWN, A_B);
        #end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				/*if (optionShit[curSelected] == 'donate')
				{
					//fancyOpenURL("https://ninja-muffin24.itch.io/funkin");
					FlxG.switchState(new CreditsState());
				}*/
				//else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
			spr.x -= 250;
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");
			case 'donate':
				FlxG.switchState(new CreditsState()); //finally i make it >:) --nong

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
