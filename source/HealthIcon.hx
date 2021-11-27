package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-old', [2, 3], 0, false, isPlayer);
		animation.add('gf', [4], 0, false, isPlayer);
		animation.add('dad', [5, 5], 0, false, isPlayer);
		animation.add('face', [6, 7], 0, false, isPlayer);
		animation.add('red', [8, 9], 0, false, isPlayer);
		animation.add('shadow', [10, 11], 0, false, isPlayer);
		animation.add('wire-shadow', [12, 13], 0, false, isPlayer);
		animation.add('wire-bf', [14, 15], 0, false, isPlayer);
		animation.add('wire-gf', [16, 16], 0, false, isPlayer);
		animation.add('redsus', [17, 18], 0, false, isPlayer);
		animation.add('Susdow', [19, 20], 0, false, isPlayer);
		animation.add('blue', [21, 22], 0, false, isPlayer);
		animation.add('lightdown-bf', [23, 24], 0, false, isPlayer);
		animation.add('lightdown-redsus', [25, 26], 0, false, isPlayer);
		animation.add('lightdown-Susdow', [27, 28], 0, false, isPlayer);
		animation.add('lightdown-gf', [4], 0, false, isPlayer);
		animation.add('redsus-Susdow-blue', [5, 5], 0, false, isPlayer);
		animation.play(char);

		switch(char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				antialiasing = false;
		}

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
