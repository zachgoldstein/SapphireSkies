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
	
	import zachg.GroupGameObject;
	import zachg.gameObjects.BuildingGroup;
	import zachg.gameObjects.CallbackSprite;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.Village;

	public class HealthComponent extends GameComponent
	{
		
		public var graphicHolder:CallbackSprite;
		public var spriteCanvas:Sprite
		
		private var _currentHealth:Number = 1000;
		public var maxHealth:Number = 2000;
		public var healthChange:Number = 0;
		
		public var healthBar:ProgressBar;
		public var title:Label;
		public var x:Number;
		public var y:Number;
		
		protected var _pixels:BitmapData;
		
		public var showHealth:Boolean = GlobalVariables.showHealthBars;
		
		public var showHealthCounter:Number = 999999;
		
		public function HealthComponent(CallbackFunction:Function=null,rootObject:FlxObject=null)
		{
			super(CallbackFunction);
			//(FlxG.state as PlayState).gameGraphics
			spriteCanvas = new Sprite();
			spriteCanvas.visible = false;
			healthBar = new ProgressBar(spriteCanvas,0,4);
			healthBar.maximum = maxHealth;
			healthBar.value = currentHealth;
			healthBar.draw();
			title = new Label(spriteCanvas,0,0,"Health");
			title.textField.textColor = 0x000000;
			
			graphicHolder = new CallbackSprite();
			graphicHolder.visible = false;
			graphicHolder.solid = false;
			
			update();
			drawVisual();
		}
		
		override public function update():void
		{
			if(currentHealth < 0){
				if(rootObject != null){
					(rootObject as GroupGameObject).destroyObject();
				}
			}
			
			if(currentHealth < maxHealth){
				currentHealth += healthChange;
			}
			
			super.update();
			if(showHealthCounter < GlobalVariables.showHealthDuration){
				showHealth = true;
			} else {
				showHealth = false;
			}
			
			if(showHealth == true){
				graphicHolder.visible = true;
				graphicHolder.x = x;
				graphicHolder.y = y;
				
				healthBar.value = currentHealth;
				healthBar.maximum = maxHealth;
				//drawVisual();
			} else {
				graphicHolder.visible = false;
			}
			showHealthCounter++
		}
		
		public function drawVisual():void
		{
			if(currentHealth < -1){
				currentHealth = -1;
			}
			healthBar.value = currentHealth;
			healthBar.maximum = maxHealth;
			healthBar.draw();
			
			if(graphicHolder.onScreen() == true){
				graphicHolder.createGraphic(spriteCanvas.width, spriteCanvas.height);
				var bitmapData:BitmapData = new BitmapData(spriteCanvas.width, spriteCanvas.height, true, 0x00FFFFFF);
				var mat:Matrix = new Matrix();
				bitmapData.draw(spriteCanvas);
				graphicHolder.pixels.copyPixels(bitmapData,new Rectangle(0,0,spriteCanvas.width, spriteCanvas.height),new Point());
			}
		}

		public function get currentHealth():Number
		{
			return _currentHealth;
		}

		public function set currentHealth(value:Number):void
		{
			if(rootObject is Village){
				//trace("test");
			} 
			_currentHealth = value;
			
			drawVisual();
		}

		
	}
}