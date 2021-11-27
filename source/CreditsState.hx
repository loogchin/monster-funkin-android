package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

using StringTools;

class CreditsState extends MusicBeatState //Made by Nong vanila >:) https://www.youtube.com/channel/UCGwph3rtuvm9D7yvjceZBbg
{
    var creditsList:Array<String> = [
        'G land',
        'FTH_YT',
        'May ButNotGirl',
        'dinvin',
        'save',
        'Sans what the tale TH',
        'namoxd',
        'jth channel',
        'Nong vanila',
        'knth',
    ];
    var creditsColor:Array<Dynamic> = [
        '0x0099FF', //G land
        '0x3EB9FE', //FTH_YT
        '0x795949', //May ButNotGirl
        '0xDBE546', //dinvin
        '0x757575', //save
        '0xCCCCCC', //Sans what the tale TH
        '0xFFFFFF', //namoxd
        '0xFF0000', //jth channel
        '0xCFE7FF', //Nong vanila
        '0x621BFF', //knth
    ];

    var bg:FlxSprite;
    var grpMenuShit:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var colorTween:FlxTween;

    override function create()
    {
        #if desktop
		DiscordClient.changePresence("Credits menu", null);
		#end

        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set();
		add(bg);

        grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

        for (i in 0...creditsList.length)
            {
                var creditsText:Alphabet = new Alphabet(0, (70 * i) + 30, creditsList[i], true, false);
                creditsText.isMenuItem = true;
                creditsText.targetY = i;
                grpMenuShit.add(creditsText);
            }

        //bg.color = creditsColor[curSelected]; //bg color change
        changeSelection();

        #if mobileC
        addVirtualPad(UP_DOWN, A_B);
        #end

        super.create();
    
    }
    override function update(elapsed:Float)
	{
        super.update(elapsed);

        if(colorTween != null) {
			colorTween.cancel();
		}

        colorchange();

        if (controls.UP_P)
		{
			changeSelection(-1);
   
		}else if (controls.DOWN_P)
		{
			changeSelection(1);
		}
        if (controls.BACK)
		{
            FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
            if(colorTween != null) {
				colorTween.cancel();
			}
		}
        else if (controls.ACCEPT)
        {
            var daSelected:String = creditsList[curSelected];

            switch (daSelected)
			{
                case 'G land':
                    urlOpen('https://www.youtube.com/channel/UCY_M7b7-aOV4oeJ9Exgh7gQ');
                case 'FTH_YT':
                    urlOpen('https://youtube.com/channel/UCj0pBFqcLcp8o32EMkb6eGw');
                case 'May ButNotGirl':
                    urlOpen('https://youtube.com/channel/UC2Um8ziv07Y4OmvATDkJrIA');
                case 'dinvin':
                    urlOpen('https://youtube.com/channel/UCpH2xG3mXWz7Yu3nE_TVS-g');
                case 'save':
                    urlOpen('https://youtube.com/channel/UCYZ0KsPj7zMYwk6Ggsk8JOQ');
                case 'Sans what the tale TH':
                    urlOpen('https://youtube.com/channel/UCZHFDyK16p_diNNILoKTBEw');
                case 'namoxd':
                    urlOpen('https://www.youtube.com/channel/UCmM2bfDKTPg7MbNnWk_dlLw');
                case 'jth channel':
                    urlOpen('https://www.youtube.com/channel/UCFM0KvWIkFNTIkN-V6CvkSQ');
                case 'Nong vanila':
                    urlOpen('https://www.youtube.com/channel/UCGwph3rtuvm9D7yvjceZBbg');
                case 'knth':
                    urlOpen('https://www.youtube.com/c/KNTHalsoilikepurplelol');
            }
            if(colorTween != null) {
				colorTween.cancel();
			}
        }
    }
    function colorchange()
    {
        var colorSelected:String = creditsList[curSelected];

        switch (colorSelected)
			{
                case 'G land':
                    bgtweencolor('0x0099FF');
                case 'FTH_YT':
                    bgtweencolor('0x3EB9FE');
                case 'May ButNotGirl':
                    bgtweencolor('0x795949');
                case 'dinvin':
                    bgtweencolor('0xDBE546');
                case 'save':
                    bgtweencolor('0x757575');
                case 'Sans what the tale TH':
                    bgtweencolor('0xCCCCCC');
                case 'namoxd':
                    bgtweencolor('0xFFFFFF');
                case 'jth channel':
                    bgtweencolor('0xFF0000');
                case 'Nong vanila':
                    bgtweencolor('0xCFE7FF');
                case 'knth':
                    bgtweencolor('0x621BFF');
            }
    }
    function bgtweencolor(color:String)
    {
        FlxTween.color(bg, 0.1, bg.color, FlxColor.fromString(color),{ onComplete: function(twn:FlxTween) { colorTween = null;}});
    }
    function urlOpen(url:String)
    {
        #if linux
        Sys.command('/usr/bin/xdg-open', [url, "&"]);
        #else
        FlxG.openURL(url);
        #end
    }
    function changeSelection(change:Int = 0):Void
	{
        FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;

		if (curSelected < 0)
			curSelected = creditsList.length - 1;
		if (curSelected >= creditsList.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
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