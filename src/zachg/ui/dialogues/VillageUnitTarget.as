package zachg.ui.dialogues
{
	
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.Panel;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.Window;
	import com.senocular.ui.VirtualMouse;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
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
	import zachg.components.GameComponent;
	import zachg.gameObjects.BuildingGroup;
	import zachg.gameObjects.CallbackSprite;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.Shop;
	import zachg.gameObjects.Village;
	import zachg.util.EffectController;
	import zachg.util.VillageInfoGenerator;

	public class VillageUnitTarget extends GameComponent 
	{
		
		public var graphicHolder:CallbackSprite;
		public var spriteCanvas:Sprite
		
		public var targetLocation:FlxPoint;
		public var nameOfLocation:String = "";
		
		public var x:Number;
		public var y:Number;
		
		protected var _pixels:BitmapData;
		
		public var showComponent:Boolean = true;
		
		public var cursor:VirtualMouse
		
		private var _percentageUnitsSentHere:Number = -1;
		
		public var id:String;
		
		public function VillageUnitTarget(CallbackFunction:Function=null,RootObject:FlxObject=null)
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
		
		private var label:Label;
		private var percentageToSendControl:NumericStepper
		
		private function setupComponents():void{
			
			var crossHairs:* = new Resources.UIGameVillageTarget();
			//crossHairs.x  = -Math.round(crossHairs.width/2);
			//crossHairs.y  = -Math.round(crossHairs.height/2);
			spriteCanvas.addChild(crossHairs);
			//var testPanel:Panel = new Panel(spriteCanvas,0,0);
			
/*			spriteCanvas.graphics.beginFill(0,.85);
			spriteCanvas.graphics.drawRect(0,0,130,65);
			
			label = new Label(spriteCanvas,0,0,"% Deployed to "+nameOfLocation );
			label.textField.textColor = 0xffffff;
			percentageToSendControl = new NumericStepper(spriteCanvas,0,20,changedPercentageValue);
			percentageToSendControl.minimum = 0;
			percentageToSendControl.maximum = 100;
			percentageToSendControl.repeatTime = 10;
			
			var closeButton:PushButton = new PushButton(spriteCanvas,5,40,"Remove this deployment",removeTarget);
			*/
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
/*				if(FlxG.keys.SHIFT){
					percentageToSendControl.step = 5;
				} else {
					percentageToSendControl.step = 1;
				}
				
				spriteCanvas.visible = true;
				percentageToSendControl.value = percentageUnitsSentHere;
				label.text = "% Deployed to " + nameOfLocation;*/
				
				var mousePositionOnComponent:Point = new Point(FlxG.mouse.x - graphicHolder.x,FlxG.mouse.y - graphicHolder.y);				

				
				graphicHolder.visible = true;
				graphicHolder.x = x - Math.round(spriteCanvas.width/2);
				graphicHolder.y = y - Math.round(spriteCanvas.height/2);
				
				if(rootObject is Village){
					//refresh object
					
				}
				drawVisual();

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
			} else {
				spriteCanvas.visible = false;
				graphicHolder.visible = false;
			}
		}
		
		public function changedPercentageValue(e:Event = null):void
		{
			if ( (rootObject as Village).canTargetChangeToValue(percentageToSendControl.value,id ) == false){
				percentageToSendControl.value = percentageToSendControl._previousValue;
				EffectController.displayMessageAtPoint(x,y,"You need to send fewer units elsewhere first");
			} else {
				percentageUnitsSentHere = percentageToSendControl.value;
			}
		}
		
		public function removeTarget(e:Event):void
		{
			showComponent = false;
			spriteCanvas = new Sprite();
			graphicHolder.visible = false;
			graphicHolder.destroy();
			(rootObject as Village).removeTarget(id);
		}
		
		public function drawVisual():void
		{
			graphicHolder.createGraphic(spriteCanvas.width, spriteCanvas.height);
			var bitmapData:BitmapData = new BitmapData(spriteCanvas.width, spriteCanvas.height, true, 0x00FFFFFF);
			var mat:Matrix = new Matrix();
			bitmapData.draw(spriteCanvas);
			graphicHolder.pixels.copyPixels(bitmapData,new Rectangle(0,0,spriteCanvas.width, spriteCanvas.height),new Point());

			graphicHolder.createGraphic(spriteCanvas.width, spriteCanvas.height);
			var bitmapData:BitmapData = new BitmapData(spriteCanvas.width, spriteCanvas.height, true, 0x00FFFFFF);
			var mat:Matrix = new Matrix();
			bitmapData.draw(spriteCanvas);
			graphicHolder.pixels.copyPixels(bitmapData,new Rectangle(0,0,spriteCanvas.width, spriteCanvas.height),new Point());
		}

		public function get percentageUnitsSentHere():Number
		{
			return _percentageUnitsSentHere;
		}

		public function set percentageUnitsSentHere(value:Number):void
		{
			_percentageUnitsSentHere = value;
			//percentageToSendControl.value = value;
		}

		
	}
}