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
	import zachg.gameObjects.Shop;

	public class ShopExtendedInfoComponent extends GameComponent
	{
		
		public var graphicHolder:CallbackSprite;
		public var spriteCanvas:Sprite
				
		public var windowBackground:Window;
		
		public var mineralListTitle:Label;
		public var mineralsList:List;
		public var totalMineralValue:Label;
		public var sellAllMinerals:PushButton;
		
		public var currentResearchLabel:Label;
		public var researchProgressLabel:Label;
		public var researchProgress:ProgressBar;
		
		public var botCreationLabel:Label;
		public var botCreationProgressLabel:Label;		
		public var botCreationProgress:ProgressBar;
		
		public var equipNewItem:PushButton;
		
		public var availableResourcesLabel:Label;
		
		public var x:Number;
		public var y:Number;
		
		protected var _pixels:BitmapData;
		
		public var showComponent:Boolean = true;
		
		public var cursor:VirtualMouse
		
		private var currentShownMinerals:Vector.<Mineral> = new Vector.<Mineral>();
		private var totalShownMineralValue:Number;
		
		public function ShopExtendedInfoComponent(CallbackFunction:Function=null,RootObject:FlxObject=null)
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
			
			windowBackground = new Window(spriteCanvas,0,0,"Resource Lab Information");
			windowBackground.width = 200;
			windowBackground.height = 115;
			
			totalMineralValue = new Label(windowBackground, 5, 20, "Current Resouces:");
			currentResearchLabel = new Label(windowBackground, 5, 30, "Current Research:");			
			
			researchProgressLabel = new Label(windowBackground, 5, 50, "Progress:");
			researchProgress = new ProgressBar(windowBackground, 55, 50);			
			
			
			
			botCreationLabel = new Label(windowBackground, 5, 70, "Creating Resource Bot");
			
			botCreationProgressLabel = new Label(windowBackground, 5, 80, "Progress:");
			botCreationProgress = new ProgressBar(windowBackground, 55, 85);			
			
			//mineralListTitle = new Label(windowBackground, 5, 20, "Current Minerals");
			
			//mineralsList = new List(windowBackground,5,40);
			//mineralsList.width = 150;
			//mineralsList.height = 40;	
			
			//totalMineralValue = new Label(windowBackground, 5, 80, "Current Resources:");
			
			//sellAllMinerals = new PushButton(windowBackground, 40, 100, "Sell All Minerals",sellAll);
			//availableResourcesLabel = new Label(windowBackground, 5, 130, "Current Resources: ");
			//equipNewItem = new PushButton(windowBackground, 40, 180, "Equip Now",equip);
			


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
//				if(mineralsList.items.length != (FlxG.state as PlayState).player.currentPlayerMinerals.length){
//					setList();
//				}
				
//				if(currentShownMinerals.length > 0){
//					sellAllMinerals.enabled = true;
//				} else {
//					sellAllMinerals.enabled = false;
//				}

				if(rootObject is Shop){
					totalMineralValue.text = "Current Resources: " + (rootObject as Shop).availableResources;
					botCreationProgress.maximum = (rootObject as Shop).botCreationDelay;
					botCreationProgress.value = (rootObject as Shop).lastBotCreationCounter;
					
					if( (rootObject as Shop).currentResearch != null){
						currentResearchLabel.text = "Current Research: "+(rootObject as Shop).currentResearch.growthItemTitle;
						researchProgress.maximum = (rootObject as Shop).currentResearch.requiredResearch;
						researchProgress.value = (rootObject as Shop).currentResearch.researchProgress;
//						if( (rootObject as Shop).currentResearch.isFullyResearched == true){
//							equipNewItem.enabled = true;
//						} else {
//							equipNewItem.enabled = false;
//						}
						
					} else if((rootObject as Shop).currentResearchQueue.length == 0) {
						currentResearchLabel.text = "No upgrades available";
						//equipNewItem.enabled = false;
					} else {
						currentResearchLabel.text = "No resources available";
						//equipNewItem.enabled = false;						
					}
				}				
				
				drawVisual();
			} else {
				graphicHolder.visible = false;
			}
		}
				
		private function setList():void
		{
			currentShownMinerals = (FlxG.state as PlayState).player.currentPlayerMinerals;
			var listData:Array = new Array();
			var totalValue:Number = 0;
			for(var i:int = 0 ; i < currentShownMinerals.length ; i++){
				listData.push(currentShownMinerals[i].fullName + " with value " + currentShownMinerals[i].resourceValue);
				totalValue += currentShownMinerals[i].resourceValue;
			}
			totalShownMineralValue = totalValue;
			//mineralsList.items = listData;
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
		
		public function equip(e:MouseEvent=null):String
		{
			if(rootObject is Shop){
				//equip player
				if ((rootObject as Shop).currentResearch == null){
					return null
				}
				
				if((rootObject as Shop).currentResearch.isFullyResearched == false){
					return null
				}
				
				if((rootObject as Shop).currentResearch.isWeapon == true){
					(FlxG.state as PlayState).player.gunComponent.loadPropertyMapping( (rootObject as Shop).currentResearch.weaponMapping );
					//TODO: rig is so that it unequips current weapons. RE-DO WHOLE MECHANISM OF ENABLING/DISABLING ITEMS.
				} else {
					(FlxG.state as PlayState).player.loadPropertyMapping((rootObject as Shop).currentResearch.playerMapping );
				}
				(FlxG.state as PlayState).player.levelComponent.currentExperience += 50;
				(rootObject as Shop).levelComponent.currentExperience += 50;
				
				var researchItemTitle:String = (rootObject as Shop).currentResearch.growthItemTitle;
				
				if((rootObject as Shop).currentResearchQueue.length > 0){
					(rootObject as Shop).currentResearch = (rootObject as Shop).currentResearchQueue.shift();
				} else {
					(rootObject as Shop).currentResearch = null;
				}
				return researchItemTitle
				
				//(rootObject as Shop).availableResources += totalShownMineralValue;
				//(FlxG.state as PlayState).player.currentPlayerMinerals = new Vector.<Mineral>();
				//setList();
			}
			return null
		}
		
		//TODO: move sell and equip out of this dialogue box;
		
		public function sellAll(e:MouseEvent=null):Number
		{
			if(rootObject is Shop){
				setList();
				(rootObject as Shop).levelComponent.currentExperience += 50;
				(rootObject as Shop).availableResources += totalShownMineralValue;
				var valueToReturn:Number = totalShownMineralValue;
				(FlxG.state as PlayState).player.currentPlayerMinerals = new Vector.<Mineral>();
				totalMineralValue.text = "Current Resouces: "+(rootObject as Shop).availableResources;
				return valueToReturn;
			}
			return 0;
		}
		
	}
}