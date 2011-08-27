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

	public class FactoryExtendedInfoComponent extends GameComponent
	{
		
		public var graphicHolder:CallbackSprite;
		public var spriteCanvas:Sprite
				
		public var windowBackground:Window;

		public var peopleAvailableLabel:Label;
		public var resourcesAvailableLabel:Label;
		public var unitCreationProgressBar:ProgressBar;
		public var progressLabel:Label;
		public var unitToCreateLabel:Label;
		public var unitCreationCostLabel:Label;
		
		public var x:Number;
		public var y:Number;
		
		protected var _pixels:BitmapData;
		
		public var showComponent:Boolean = true;
		
		public var cursor:VirtualMouse
		
		private var currentShownMinerals:Vector.<Mineral> = new Vector.<Mineral>();
		private var totalShownMineralValue:Number;
		
		public function FactoryExtendedInfoComponent(CallbackFunction:Function=null,RootObject:FlxObject=null)
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
			
			windowBackground = new Window(spriteCanvas,0,0,"Factory Information");
			windowBackground.width = 200;
			windowBackground.height = 100;
			
			peopleAvailableLabel = new Label(windowBackground, 5, 20, "Available People: ");
			
			resourcesAvailableLabel = new Label(windowBackground, 5, 30, "Available Resources: ");

			unitToCreateLabel = new Label(windowBackground, 5, 50, "Creating: ");
			unitCreationCostLabel = new Label(windowBackground, 5, 60, "Unit Cost: ");
			progressLabel = new Label(windowBackground, 5, 70, "Progress:");
			unitCreationProgressBar = new ProgressBar(windowBackground, 55, 75);

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
				
				if(rootObject is Factory){
					peopleAvailableLabel.text = "Available People: "+ (rootObject as Factory).availablePeople;
					resourcesAvailableLabel.text = "Available Resources: " + (rootObject as Factory).availableResources;

					if((rootObject as Factory).botCreationQueue.length > 0){
						unitToCreateLabel.text = "Creating: " + (rootObject as Factory).botCreationQueue[0].botName;
						unitCreationCostLabel.text = "Unit Cost: " + (rootObject as Factory).botCreationQueue[0].resourceValue;
						unitCreationProgressBar.maximum = (rootObject as Factory).botCreationQueue[0].botCreationDelay;
					} else {
						unitToCreateLabel.text = "";
						unitCreationProgressBar.maximum = 0;
					}
					unitCreationProgressBar.value = (rootObject as Factory).lastBotCreationCounter;
				}				
				
				
				graphicHolder.visible = true;
				graphicHolder.x = x;
				graphicHolder.y = y;
				
				if(rootObject is PopulationCenter){

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