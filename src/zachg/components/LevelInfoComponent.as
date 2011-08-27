package zachg.components
{
	
	import com.GlobalVariables;
	import com.PlayState;
	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.Text;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	import zachg.gameObjects.CallbackSprite;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.Village;

	public class LevelInfoComponent extends GameComponent
	{
		
		public var graphicHolder:CallbackSprite;
		public var spriteCanvas:Sprite
		
		private var _currentLevel:Number = 0;
		private var _currentExperience:Number = 0;
		public var totalExperience:Number = 0;
		public var maxTotalExperience:Number = 0;
		private var _maxLevel:Number = 2000;
		public var experienceRequired:Number = 1000;
		
		private var _defaultPopulation:Number
		
		public var experienceBar:ProgressBar;
		public var title:Label;
		public var levelLabel:Label;
		
		public var x:Number;
		public var y:Number;
		
		protected var _pixels:BitmapData;
		
		public var showLevel:Boolean = GlobalVariables.showLevelBars;
		public var showLevelCounter:Number = 9999;
		
		public var levelUpCallback:Function;
		
		public function LevelInfoComponent(LevelUpCallback:Function=null,RootObject:FlxObject=null)
		{
			super();
			rootObject = RootObject;
			levelUpCallback = LevelUpCallback;
			//(FlxG.state as PlayState).gameGraphics
			spriteCanvas = new Sprite();
			spriteCanvas.visible = false;
			experienceBar = new ProgressBar(spriteCanvas,0,4);
			title = new Label(spriteCanvas,0,0,"XP:");
			title.textField.textColor = 0x000000;
			levelLabel = new Label(spriteCanvas,0,10,"Level:");
			levelLabel.textField.textColor = 0x000000;
			experienceBar.maximum = experienceRequired;
			experienceBar.value = currentExperience;
			experienceBar.draw();
			
			graphicHolder = new CallbackSprite();
			graphicHolder.visible = false;
			graphicHolder.solid = false;
			
			update();
			drawVisual();
		}		
		
		override public function update():void
		{
			super.update();
			
			if(showLevelCounter < GlobalVariables.showLevelDuration){
				showLevel = true;
			} else {
				showLevel = false;
			}

			if(showLevel == true){
				graphicHolder.visible = true;
				graphicHolder.x = x;
				graphicHolder.y = y;
				
				experienceBar.value = (rootObject as Village).villagePopulation
				experienceBar.maximum = (rootObject as Village).villageMaxPopulation;
				title.text = "Pop: "+Math.round((rootObject as Village).villagePopulation)+"/"+((rootObject as Village).villageMaxPopulation);
				levelLabel.text = "Level: "+currentLevel;
				drawVisual();
			} else {
				graphicHolder.visible = false;
			}
			showLevelCounter++;
		}
		
		public function drawVisual():void
		{
			if(graphicHolder.onScreen() == true){
				graphicHolder.createGraphic(spriteCanvas.width, spriteCanvas.height);
				var bitmapData:BitmapData = new BitmapData(spriteCanvas.width, spriteCanvas.height, true, 0x00FFFFFF);
				var mat:Matrix = new Matrix();
				bitmapData.draw(spriteCanvas);
				graphicHolder.pixels.copyPixels(bitmapData,new Rectangle(0,0,spriteCanvas.width, spriteCanvas.height),new Point());
			}
		}

		public function findNextRequiredExperience():void
		{
			experienceRequired += experienceRequired*currentLevel;
			experienceBar.maximum = experienceRequired;
		}
		
		public function get currentLevel():Number
		{
			return _currentLevel;
		}

		public function set currentLevel(value:Number):void
		{
			var prevCurrentLevel:Number = _currentLevel;
			_currentLevel = value;
			if(levelUpCallback != null && prevCurrentLevel < value){
				levelUpCallback(value);
			}
			drawVisual();
		}

		public function get currentExperience():Number
		{
			return _currentExperience;
		}

		public function set currentExperience(value:Number):void
		{
			totalExperience += value - _currentExperience;
			_currentExperience = value;
			
			if(currentExperience >= experienceRequired ){
				_currentExperience = 0;
				currentLevel++;
				findNextRequiredExperience();
			}
			drawVisual();
		}

		public function get maxLevel():Number
		{
			return _maxLevel;
		}

		public function set maxLevel(value:Number):void
		{
			_maxLevel = value;
			maxTotalExperience = findMaxTotalExperience(defaultPopulation,value);
		}
		
		public function findMaxTotalExperience(currentXP:Number,level:Number):Number
		{
			currentXP += experienceRequired*level
			if(level > 0){
				currentXP = findMaxTotalExperience(currentXP,level-1);
			}
			return currentXP
		}

		public function get defaultPopulation():Number
		{
			return _defaultPopulation;
		}

		public function set defaultPopulation(value:Number):void
		{
			_defaultPopulation = value;
			maxTotalExperience = findMaxTotalExperience(defaultPopulation,_maxLevel);
		}

		
	}
}