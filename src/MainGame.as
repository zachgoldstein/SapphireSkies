package  
{
	import com.PlayState;
	import com.Resources;
	import com.gskinner.motion.GTween;
	
	import org.flixel.*;
	
	import zachg.states.MainMenuState;
	
	[SWF(width = "600", height = "450", backgroundColor = "#000000")]
	[Frame(factoryClass = "Preloader")]
	public class MainGame extends FlxGame
	{
		public function MainGame():void
		{
			GTween.defaultDispatchEvents = true;
			FlxG.debug = false;
			super(600, 450, MainMenuState, 1);
		}
		
	}

}