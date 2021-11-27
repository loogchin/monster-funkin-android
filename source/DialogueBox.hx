package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var sound:FlxSound;

	var bf:FlxSprite;
	var gf:FlxSprite;
	var red:FlxSprite;
	var shadow:FlxSprite;
	var redsus:FlxSprite;
	var susdow:FlxSprite;

	var skipText:FlxText;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				sound = new FlxSound().loadEmbedded(Paths.music('Lunchbox'),true);
				sound.volume = 0;
				FlxG.sound.list.add(sound);
				sound.fadeIn(1, 0, 0.8);
			case 'thorns':
				sound = new FlxSound().loadEmbedded(Paths.music('LunchboxScary'),true);
				sound.volume = 0;
				FlxG.sound.list.add(sound);
				sound.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(0,100);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('dialogue/box2','shared');
				box.animation.addByPrefix('normal', 'box0', 24);
				box.animation.addByPrefix('normalOpen', 'box0', 24, false);
				box.width = 1300;
				//box.height = 200;
				/*box.x = -100;
				box.y = 430;*/
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		box.animation.play('normalOpen');
		//box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		//box.updateHitbox();
		add(box);

		bf = new FlxSprite(950, 400);
		bf.frames = Paths.getSparrowAtlas('dialogue/haha_nong_vanilou wait what','shared');
		bf.animation.addByPrefix('enter', 'bf0', 24, false);
		bf.scrollFactor.set();
		bf.setGraphicSize(Std.int(bf.width * 0.5));
		bf.updateHitbox();
		add(bf);

		gf = new FlxSprite(950, 400);
		gf.frames = Paths.getSparrowAtlas('dialogue/haha_nong_vanilou wait what','shared');
		gf.animation.addByPrefix('enter', 'gf0', 24, false);
		gf.scrollFactor.set();
		gf.setGraphicSize(Std.int(gf.width * 0.5));
		gf.updateHitbox();
		add(gf);

		red = new FlxSprite(100, 430);
		red.frames = Paths.getSparrowAtlas('dialogue/haha_nong_vanilou wait what','shared');
		red.animation.addByPrefix('enter', 'red0', 24, false);
		red.scrollFactor.set();
		red.setGraphicSize(Std.int(red.width * 0.45));
		red.updateHitbox();
		add(red);

		shadow = new FlxSprite(100, 430);
		shadow.frames = Paths.getSparrowAtlas('dialogue/haha_nong_vanilou wait what','shared');
		shadow.animation.addByPrefix('enter', 'shadow0', 24, false);
		shadow.scrollFactor.set();
		shadow.setGraphicSize(Std.int(shadow.width * 0.45));
		shadow.updateHitbox();
		add(shadow);

		redsus = new FlxSprite(100, 450);
		redsus.frames = Paths.getSparrowAtlas('dialogue/haha_nong_vanilou wait what','shared');
		redsus.animation.addByPrefix('enter', 'redsus0', 24, false);
		redsus.scrollFactor.set();
		redsus.setGraphicSize(Std.int(redsus.width * 0.45));
		redsus.updateHitbox();
		add(redsus);

		susdow = new FlxSprite(90, 450);
		susdow.frames = Paths.getSparrowAtlas('dialogue/haha_nong_vanilou wait what','shared');
		susdow.animation.addByPrefix('enter', 'susdow0', 24, false);
		susdow.scrollFactor.set();
		susdow.setGraphicSize(Std.int(susdow.width * 0.45));
		susdow.updateHitbox();
		add(susdow);

		bf.visible = false;
		gf.visible = false;
		red.visible = false;
		shadow.visible = false;
		redsus.visible = false;
		susdow.visible = false;

		//box.screenCenter(X);
		//portraitLeft.screenCenter(X); WT ทำไมมันทำเกมเด้ง hmmmmmmmmmmmmm

		skipText = new FlxText(10, 10, Std.int(FlxG.width * 0.6), "", 16);
		skipText.font = 'Pixel Arial 11 Bold';
		skipText.color = 0x000000;
		skipText.text = 'press back to skip';
		add(skipText);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(382, 482, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = FlxColor.BLACK;
		add(dropText);

		swagDialogue = new FlxTypeText(380, 480, Std.int(FlxG.width * 0.4), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = FlxColor.WHITE;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		#if mobile
		var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			justTouched = false;

			if (touch.justReleased){
				justTouched = true;
			}
		}
		#end

		if (FlxG.keys.justPressed.ANY #if mobile || justTouched #end && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						sound.fadeOut(2.2, 0);
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						bf.visible = false;
						gf.visible = false;
						red.visible = false;
						shadow.visible = false;
						redsus.visible = false;
						susdow.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		if (PlayerSettings.player1.controls.BACK && isEnding != true)
		{
			remove(dialogue);
			isEnding = true;
			switch (PlayState.SONG.song.toLowerCase())
			{
				case "senpai" | "thorns":
					sound.fadeOut(2.2, 0);
				case "roses":
					trace("roses");
				default:
					trace(PlayState.SONG.song.toLowerCase());
			}
			new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				box.alpha -= 1 / 5;
				bgFade.alpha -= 1 / 5 * 0.7;
				bf.visible = false;
				gf.visible = false;
				red.visible = false;
				shadow.visible = false;
				redsus.visible = false;
				susdow.visible = false;
				swagDialogue.alpha -= 1 / 5;
				dropText.alpha = swagDialogue.alpha;
			}, 5);

			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				finishThing();
				kill();
			});
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			/*case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}*/
			case 'bf':
				bf.visible = false;
				gf.visible = false;
				red.visible = false;
				shadow.visible = false;
				redsus.visible = false;
				susdow.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bf-text', 'shared'), 0.6)];
				if (!bf.visible)
				{
					bf.visible = true;
					bf.animation.play('enter');
				}
			case 'gf':
				bf.visible = false;
				gf.visible = false;
				red.visible = false;
				shadow.visible = false;
				redsus.visible = false;
				susdow.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gf-text', 'shared'), 0.6)];
				if (!gf.visible)
				{
					gf.visible = true;
					gf.animation.play('enter');
				}
			case 'red':
				bf.visible = false;
				gf.visible = false;
				red.visible = false;
				shadow.visible = false;
				redsus.visible = false;
				susdow.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('red-text', 'shared'), 0.6)];
				if (!red.visible)
				{
					red.visible = true;
					red.animation.play('enter');
				}
			case 'shadow':
				bf.visible = false;
				gf.visible = false;
				red.visible = false;
				shadow.visible = false;
				redsus.visible = false;
				susdow.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('red-text', 'shared'), 0.6)];
				if (!shadow.visible)
				{
					shadow.visible = true;
					shadow.animation.play('enter');
				}
			case 'redsus':
				bf.visible = false;
				gf.visible = false;
				red.visible = false;
				shadow.visible = false;
				redsus.visible = false;
				susdow.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('imposter-text', 'shared'), 0.6)];
				if (!redsus.visible)
				{
					redsus.visible = true;
					redsus.animation.play('enter');
				}
			case 'susdow':
				bf.visible = false;
				gf.visible = false;
				red.visible = false;
				shadow.visible = false;
				redsus.visible = false;
				susdow.visible = false;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('imposter-text', 'shared'), 0.6)];
				if (!susdow.visible)
				{
					susdow.visible = true;
					susdow.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}