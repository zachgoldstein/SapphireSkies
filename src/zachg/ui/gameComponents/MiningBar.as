package zachg.ui.gameComponents
{
	import zachg.components.GameComponent;

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
	
	public class MiningBar extends GameComponent
	{
		
		public var graphicHolder:CallbackSprite;
		public var spriteCanvas:Sprite
		
		private var _currentMineProgress:Number = 0;
		private var _mineDelay:Number = 0;
		
		public var mineBar:ProgressBar;
		public var title:Label;
		
		public var x:Number;
		public var y:Number;
		
		protected var _pixels:BitmapData;
		
		public var showMineProgress:Boolean = GlobalVariables.showMineProgress;
		public var showMineCounter:Number = 9999;
		
		public function MiningBar(CallbackFunction:Function=null)
		{
			super(CallbackFunction);
			//(FlxG.state as PlayState).gameGraphics
			spriteCanvas = new Sprite();
			spriteCanvas.visible = false;
			mineBar = new ProgressBar(spriteCanvas,0,4);
			title = new Label(spriteCanvas,0,0,"XP:");
			title.textField.textColor = 0x000000;
			mineBar.maximum = mineDelay;
			mineBar.value = currentMineProgress;
			mineBar.draw();
			
			graphicHolder = new CallbackSprite();
			graphicHolder.visible = false;
			graphicHolder.solid = false;
			
			update();
			drawVisual();
		}
				
		override public function update():void
		{
			super.update();
			
			if(showMineCounter < GlobalVariables.showLevelDuration){
				showMineProgress = true;
			} else {
				showMineProgress = false;
			}
			
			if(showMineProgress == true){
				graphicHolder.visible = true;
				graphicHolder.x = x;
				graphicHolder.y = y;
				
				mineBar.value = currentMineProgress;
				title.text = "Mining: "+currentMineProgress+"/"+mineDelay;
				drawVisual();
			} else {
				graphicHolder.visible = false;
			}
			showMineCounter++;
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

		public function get currentMineProgress():Number
		{
			return _currentMineProgress;
		}
		
		public function set currentMineProgress(value:Number):void
		{
			_currentMineProgress = value;
			mineBar.value = value;
			drawVisual();
		}

		public function get mineDelay():Number
		{
			return _mineDelay;
		}

		public function set mineDelay(value:Number):void
		{
			_mineDelay = value;
			mineBar.maximum = value;
		}

	}
}
