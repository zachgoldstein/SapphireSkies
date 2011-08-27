package zachg.components
{
	
	import com.GlobalVariables;
	import com.PlayState;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.Window;
	import com.senocular.ui.VirtualMouse;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	import zachg.Mineral;
	import zachg.gameObjects.BuildingGroup;
	import zachg.gameObjects.CallbackSprite;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.PopulationCenter;
	import zachg.gameObjects.Shop;

	public class PopulationCenterExtendedInfoComponent extends GameComponent
	{
		
		public var graphicHolder:CallbackSprite;
		public var spriteCanvas:Sprite
				
		public var windowBackground:Window;

		public var growthRateLabel:Label;
		public var availableResourcesLabel:Label;
		public var availablePeopleLabel:Label;
		public var unitCreationProgressBar:ProgressBar;
		public var progressLabel:Label;
		public var sendingUnitToLabel:Label;
		
		public var x:Number;
		public var y:Number;
		
		protected var _pixels:BitmapData;
		
		public var showComponent:Boolean = true;
		
		public var cursor:VirtualMouse
		
		private var currentShownMinerals:Vector.<Mineral> = new Vector.<Mineral>();
		private var totalShownMineralValue:Number;
		
		public function PopulationCenterExtendedInfoComponent(CallbackFunction:Function=null,RootObject:FlxObject=null)
		{
			super(CallbackFunction);
			rootObject = RootObject
			spriteCanvas = new Sprite();
			//Hack. The visibility is on to enable mouse events on the sprite. 
			//We don't want it actually visible though, so we place it way out of range of the stage.
			spriteCanvas.visible = true;
			FlxG.stage.addChild(spriteCanvas);
			spriteCanvas.x = 1000;
			setupComponents();
			
			graphicHolder = new CallbackSprite();
			graphicHolder.visible = false;
			graphicHolder.solid = false;
			
			update();
		}
		
		private function setupComponents():void{
			
			windowBackground = new Window(spriteCanvas,0,0,"Population Center Information");
			windowBackground.width = 200;
			windowBackground.height = 100;
			
			growthRateLabel = new Label(windowBackground, 5, 20, "Growth Rate:");
			availableResourcesLabel = new Label(windowBackground, 5, 30, "Available Resources:");
			availablePeopleLabel = new Label(windowBackground, 5, 40, "Available People:");
			unitCreationProgressBar = new ProgressBar(windowBackground, 65, 75);
			progressLabel = new Label(windowBackground, 5, 70, "Progress:");
			
			//Note this is not hooked up to anything. Always sends civilians to factory.
			sendingUnitToLabel = new Label(windowBackground, 5, 60, "Sending civilian to Factory");
			
			if(cursor == null){
				cursor = new VirtualMouse( (FlxG.stage) ,0,0);
			}

		}
		
		override public function update():void
		{
			super.update();
			//required to do this in the update because the stage is not set when object calls constructor
			if(cursor == null){
				cursor = new VirtualMouse( (FlxG.stage) ,0,0);
			}
			if(showComponent == true){
				var mousePositionOnComponent:Point = new Point(FlxG.mouse.x - graphicHolder.x,FlxG.mouse.y - graphicHolder.y);				

				//Hack so that mouse events that are on this region trigger stuff on the sprite
				if( (mousePositionOnComponent.x > 0 && mousePositionOnComponent.x < graphicHolder.width) &&
					(mousePositionOnComponent.y > 0 && mousePositionOnComponent.y < graphicHolder.height) ){
					FlxG.stage.setChildIndex(spriteCanvas,FlxG.stage.numChildren - 1);
					cursor.x = mousePositionOnComponent.x + 1000;
					cursor.y = mousePositionOnComponent.y;
					if(FlxG.mouse.justPressed() == true){
						cursor.press();
					} else if (FlxG.mouse.justReleased() == true){
						cursor.release();						
					} else if(FlxG.mouse.pressed() == true){
						cursor.press();
					} else if(FlxG.mouse.pressed() == false){
						cursor.release();
					}
				}
				
				graphicHolder.visible = true;
				graphicHolder.x = x;
				graphicHolder.y = y;
				
				if(rootObject is PopulationCenter){
					growthRateLabel.text = "Growth Rate: "+ (rootObject as PopulationCenter).populationToAdd;
					availableResourcesLabel.text = "Available Resources: " + (rootObject as PopulationCenter).availableResources;
					availablePeopleLabel.text = "Available People: " + (rootObject as PopulationCenter).availablePeople;
					unitCreationProgressBar.maximum = (rootObject as PopulationCenter).botCreationDelay;
					unitCreationProgressBar.value = (rootObject as PopulationCenter).lastBotCreationCounter;
				}
				
				drawVisual();
			} else {
				graphicHolder.visible = false;
			}
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
		
	}
}