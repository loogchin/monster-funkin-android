package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.tweens.FlxEase;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['red', 'end', 'shadow'],
		['redsus', 'the-murder','darkness'],
		['???']
	];
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true];

	var weekCharacters:Array<Dynamic> = [
		['', '', ''],
		['', '', ''],
		['', '', '']
	];

	var weekNames:Array<String> = [
		"RED WEEK",
		"SUSSY WEEK",
		"MONS WEEK"

	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var weekSelectors:FlxGroup;
	var leftArrow2:FlxSprite;
	var rightArrow2:FlxSprite;

	var yellowBG:FlxSprite;
	var colorTween:FlxTween;

	var isCutscene:Bool = false;

	var characterName:FlxText;

	var bgred:FlxSprite;
	var bgred2:FlxSprite;

	var lock:FlxSprite;
	var weekThing:MenuItem;

	var weeklock:FlxSprite;

	var char1:FlxSprite;
	var char2:FlxSprite;
	var char3:FlxSprite;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		bgred = new FlxSprite().loadGraphic(Paths.image('main/story/week1/bg','shared')); //Made by Nong vanila >;0
		bgred.antialiasing = true;
		bgred.alpha = 1;
		add(bgred);

		bgred2 = new FlxSprite().loadGraphic(Paths.image('main/story/week1/bg2','shared'));
		bgred2.antialiasing = true;
		bgred2.alpha = 1;
		add(bgred2);

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		yellowBG = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, FlxColor.fromRGB(181,52,52));

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		//add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		weekSelectors = new FlxGroup();
		add(weekSelectors);

		leftArrow2 = new FlxSprite(811.05, 433);
		leftArrow2.frames = ui_tex;
		leftArrow2.animation.addByPrefix('idle', "arrow left");
		leftArrow2.animation.addByPrefix('press', "arrow push left");
		leftArrow2.animation.play('idle');
		weekSelectors.add(leftArrow2);

		rightArrow2 = new FlxSprite(1222, 433);
		rightArrow2.frames = ui_tex;
		rightArrow2.animation.addByPrefix('idle', 'arrow right');
		rightArrow2.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow2.animation.play('idle');
		weekSelectors.add(rightArrow2);

		for (i in 0...weekData.length)
		{
			weekThing = new MenuItem(863, 390, i);
			weekThing.y -= ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			//weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			//weekSelectors.add(weekThing);

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				lock = new FlxSprite(1002.1, 425);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				lock.alpha = 0;
				grpLocks.add(lock);
			}
		}

		weeklock = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
		weeklock.alpha = 0;
		add(weeklock);

		char1 = new FlxSprite(38, 148).loadGraphic(Paths.image('main/story/1','shared'));
		char1.antialiasing = true;
		char1.alpha = 0;
		add(char1);

		char2 = new FlxSprite(108, 236).loadGraphic(Paths.image('main/story/2','shared'));
		char2.antialiasing = true;
		char2.alpha = 0;
		add(char2);

		char3 = new FlxSprite(92, 137).loadGraphic(Paths.image('main/story/3','shared'));
		char3.antialiasing = true;
		char3.alpha = 0;
		add(char3);

		trace("Line 96");

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(863, 524.15);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(935, 531.05);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(1157.85, 524.15);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		//add(yellowBG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		//add(scoreText);
		//add(txtWeekTitle);

		characterName = new FlxText(900, 610.6, 0, "", 64);
		characterName.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		add(characterName);

		updateText();

		trace("Line 165");

		#if mobileC
        addVirtualPad(FULL, A_B);
        #end

		super.create();
	}

	override function update(elapsed:Float)
	{
		switch (curWeek)
		{
			case 0:
				characterName.text = "Red";
				grpWeekText.members[0].alpha = 1;
				grpWeekText.members[1].alpha = 0;
				grpWeekText.members[2].alpha = 0;
				lock.alpha = 0;
				FlxTween.tween(weeklock, {alpha: 0}, 0.15);
				FlxTween.tween(char1, {alpha: 1}, 0.15);
				FlxTween.tween(char2, {alpha: 0}, 0.05);
				FlxTween.tween(char3, {alpha: 0}, 0.05);
			case 1:
				characterName.text = 'Redsus';
				grpWeekText.members[0].alpha = 0;
				grpWeekText.members[1].alpha = 1;
				grpWeekText.members[2].alpha = 0;
				lock.alpha = 0;
				FlxTween.tween(weeklock, {alpha: 0}, 0.15);
				FlxTween.tween(char1, {alpha: 0}, 0.05);
				FlxTween.tween(char2, {alpha: 1}, 0.15);
				FlxTween.tween(char3, {alpha: 0}, 0.05);
			case 2:
				characterName.text = "???";
				grpWeekText.members[0].alpha = 0;
				grpWeekText.members[1].alpha = 0;
				grpWeekText.members[2].alpha = 1;
				lock.alpha = 1;
				FlxTween.tween(weeklock, {alpha: 0.3}, 0.15);
				FlxTween.tween(char1, {alpha: 0}, 0.05);
				FlxTween.tween(char2, {alpha: 0}, 0.05);
				FlxTween.tween(char3, {alpha: 1}, 0.15);
		}

		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

				if (gamepad != null)
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						changeWeek(-1);
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						changeWeek(1);
					}

					if (gamepad.pressed.DPAD_RIGHT)
						rightArrow.animation.play('press')
					else
						rightArrow.animation.play('idle');
					if (gamepad.pressed.DPAD_LEFT)
						leftArrow.animation.play('press');
					else
						leftArrow.animation.play('idle');

					if (gamepad.justPressed.DPAD_RIGHT)
					{
						changeDifficulty(1);
					}
					if (gamepad.justPressed.DPAD_LEFT)
					{
						changeDifficulty(-1);
					}
				}

				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;


			PlayState.storyDifficulty = curDifficulty;

			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			//var isCutscene:Bool = false;

			if (curWeek == 0 && !isCutscene) // Checks if the current week is garAlley.
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new VideoState("assets/videos/Aniamtion Cutsence So Hard.webm", new PlayState()));
			});
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					LoadingState.loadAndSwitchState(new PlayState(), true);
				});
			}
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 2)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 2;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();

		if(colorTween != null) {
			colorTween.cancel();
		}
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		txtTracklist.alpha = 0;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
