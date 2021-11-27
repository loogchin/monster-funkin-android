package;

import flixel.input.gamepad.FlxGamepad;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.tweens.FlxTween;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var bg2:FlxSprite;
	var bg3:FlxSprite;
	var bg4:FlxSprite;

	var weeknum:FlxText;
	var week:Alphabet;

	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	
	var colorTween:FlxTween;

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('main/freeplay/bg1','shared'));  //Made by Nong vanila >;0
		add(bg);

		bg2 = new FlxSprite().loadGraphic(Paths.image('main/freeplay/bg2','shared'));
		add(bg2);

		bg3 = new FlxSprite().loadGraphic(Paths.image('main/freeplay/bg3','shared'));
		add(bg3);

		bg4 = new FlxSprite().loadGraphic(Paths.image('main/freeplay/bg4','shared'));
		add(bg4);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isFreeplayItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			//icon.sprTracker = songText;
			icon.setPosition(535.15, 606.4);

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 60, 0, "", 16);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;
		scoreText.setGraphicSize(Std.int(scoreText.width * 0.65));
		scoreText.updateHitbox();
		scoreText.x += 50;


		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		//add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		//add(diffText);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.x += 40;
		comboText.font = diffText.font;
		//add(comboText);

		leftArrow = new FlxSprite(960.9, 103.1);
		leftArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.x += 10;
		add(leftArrow);

		sprDifficulty = new FlxSprite(1007.9, 107.35);
		sprDifficulty.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('hard');
		sprDifficulty.setGraphicSize(Std.int(sprDifficulty.width * 0.9));
		sprDifficulty.updateHitbox();
		sprDifficulty.x += 30;

		add(sprDifficulty);

		rightArrow = new FlxSprite(1222.5, 103.1);
		rightArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.x -= 10;
		add(rightArrow);

		add(scoreText);

		weeknum = new FlxText(535.15, 592.05, 0, "", 72);
		weeknum.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		weeknum.x -= 10;
		add(weeknum);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		 var textBG:FlxSprite = new FlxSprite(742.4, FlxG.height - 26).makeGraphic(537, 26, 0xFF000000);
		 textBG.alpha = 0.6;
		 add(textBG);
		 var leText:String = "Press P to listen to this Song.";
		 var text:FlxText = new FlxText(0, textBG.y + 4, FlxG.width, leText, 18);
		 text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		 text.scrollFactor.set();
		 add(text);

		 #if mobileC
		addVirtualPad(FULL, A_B);
		#end

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (songs[curSelected].songName.toLowerCase()){
			case 'tutorial':
				weeknum.text = 'For Week 0';
			 case 'red':
				weeknum.text = 'For Week 1';
			case 'end':
				weeknum.text = 'For Week 1';
			case 'shadow':
				weeknum.text = 'For Week 1';
			case 'redsus':
				weeknum.text = 'For Week 2';
			case 'the-murder':
				weeknum.text = 'For Week 2';
			case 'darkness':
				weeknum.text = 'For Week 2';
		}
		

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		if(colorTween != null) {
			colorTween.cancel();
		}

		switch (songs[curSelected].songName.toLowerCase()) // ;/
        {
            case 'tutorial':
				FlxTween.color(bg, 0.1, bg.color, FlxColor.fromRGB(245, 66, 152),{ onComplete: function(twn:FlxTween) { colorTween = null;}});
			 case 'red':
				FlxTween.color(bg, 0.1, bg.color, FlxColor.fromRGB(255, 67, 87),{ onComplete: function(twn:FlxTween) { colorTween = null;}});
			case 'end':
				FlxTween.color(bg, 0.1, bg.color, FlxColor.fromRGB(181, 44, 115),{ onComplete: function(twn:FlxTween) { colorTween = null;}});
			case 'shadow':
				FlxTween.color(bg, 0.1, bg.color, FlxColor.fromRGB(102, 16, 55),{ onComplete: function(twn:FlxTween) { colorTween = null;}});
			case 'redsus':
				FlxTween.color(bg, 0.1, bg.color, FlxColor.fromRGB(137, 39, 55),{ onComplete: function(twn:FlxTween) { colorTween = null;}});
			case 'the-murder':
				FlxTween.color(bg, 0.1, bg.color, FlxColor.fromRGB(104, 31, 41),{ onComplete: function(twn:FlxTween) { colorTween = null;}});
			case 'darkness':
				FlxTween.color(bg, 0.1, bg.color, FlxColor.fromRGB(104, 31, 41),{ onComplete: function(twn:FlxTween) { colorTween = null;}});
		}

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.DPAD_UP)
			{
				changeSelection(-1);
			}
			if (gamepad.justPressed.DPAD_DOWN)
			{
				changeSelection(1);
			}
			if (gamepad.justPressed.DPAD_LEFT)
			{
				changeDiff(-1);
			}
			if (gamepad.justPressed.DPAD_RIGHT)
			{
				changeDiff(1);
			}
		}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT)
			changeDiff(-1);
		if (controls.RIGHT)
			changeDiff(1);

		if (controls.RIGHT)
			rightArrow.animation.play('press')
		else
			rightArrow.animation.play('idle');

		if (controls.LEFT)
			leftArrow.animation.play('press');
		else
			leftArrow.animation.play('idle');
		
		if (FlxG.keys.justPressed.P)
		{
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
			if(colorTween != null) {
				colorTween.cancel();
			}
		}

		if (accepted)
		{
			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}
			
			trace(songs[curSelected].songName);

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);

			trace(poop);
			
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
			if(colorTween != null) {
				colorTween.cancel();
			}
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 2)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 2;

		// adjusting the highscore song name to be compatible (changeDiff)
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}
		
		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		#end
		
		/*switch (curDifficulty)
		{
			case 0:
				diffText.text = "< EASY >";
			case 1:
				diffText.text = '< NORMAL >';
			case 2:
				diffText.text = "< HARD >";
		}*/
		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);

		diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;
		
		// adjusting the highscore song name to be compatible (changeSelection)
		// would read original scores if we didn't change packages
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		//FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0); //just delete to fix lag
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
