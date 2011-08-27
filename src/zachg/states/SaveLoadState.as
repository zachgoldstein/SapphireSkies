package zachg.states
{
	import Playtomic.*;
	
	import com.GlobalVariables;
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSave;
	import org.flixel.FlxState;
	
	import zachg.PlayerStats;
	import zachg.growthItems.GrowthItem;
	import zachg.growthItems.buildingItem.BuildingItem;
	import zachg.growthItems.playerItem.PlayerItem;
	import zachg.util.GameMessageController;
	import zachg.util.SoundController;
	import zachg.windows.GrowthItemDisplay;
	import zachg.windows.SaveLoadSlotDisplay;
	
	public class SaveLoadState extends FlxState
	{
				
		public var growthItems:Vector.<GrowthItem> = new Vector.<GrowthItem>();
		
		public var title:Label;
		public var availableClarityPts:Label;
		
		public var playerGrowthItemsLabel:Label;
		public var villageGrowthItemsLabel:Label;
		
		private var numSlots:Number = 3;
		
		private var saveLoadSlots:Array = new Array();
		
		public function SaveLoadState()
		{
			super();
			
		}
		
		override public function create():void
		{
			FlxG.mouse.hide();
			flash.ui.Mouse.show(); 
			
			Log.CustomMetric("ViewedSaveLoad");
			
			var background:* = new Resources.BackgroundStage1();
			background.x = -700;
			background.y = -915;
			addChild(background);
			
			var cloudLeft:* = new Resources.UICloud3();
			cloudLeft.x = 110;
			cloudLeft.y = 0;
			addChild(cloudLeft);			
			
			var cloudMiddle:* = new Resources.UICloud2();
			cloudMiddle.x = 276;
			cloudMiddle.y = 81;
			addChild(cloudMiddle);
			
			var cloudRight:* = new Resources.UICloud1();
			cloudRight.x = 345;
			cloudRight.y = 42;
			addChild(cloudRight);			
			
			var saveLoadMain:* = new Resources.UISaveLoadMain();
			saveLoadMain.x = 7;
			addChild(saveLoadMain);			
			
			var muteOn:Bitmap = new Resources.UIMuteOn();
			var muteOff:Bitmap = new Resources.UIMuteOff();
			if(FlxG.mute == true){
				muteButton = new PushButton(this, FlxG.stage.stageWidth - 25, 5, "",SoundController.toggleSound,muteOn,null,muteOff,null);
			} else {
				muteButton = new PushButton(this, FlxG.stage.stageWidth - 25, 5, "",SoundController.toggleSound,muteOff,null,muteOn,null);
			}			
			
			var helpOn:Bitmap = new Resources.UIHelpOn();
			var helpOff:Bitmap = new Resources.UIHelpOff();
			var helpButton:PushButton = new PushButton(this, FlxG.stage.stageWidth - 40, 5, "",GameMessageController.showMiniHelpWindow,helpOn,null,helpOff,null);			
			
			var backButtonBackground:* = new Resources.UIBackButton();
			backButtonBackground.y = 385;
			backButtonBackground.x = 5;
			addChild(backButtonBackground);

			var smallButtonOn:* = new Resources.UIButtonOnSmall();
			var smallButtonOff:* = new Resources.UIButtonOffSmall();
			var backButton:PushButton = new PushButton(this, -7, FlxG.stage.stageHeight - 46, "Back",goBack,
				smallButtonOff,new Point(18,-17), smallButtonOn,new Point(18,-17),
				"MenuFont", 30, 0xf7f7ed);
			backButton.width = 100;
			backButton.height = 12;			
			
			var saveLoadSlotsStartPoint:Point = new Point(50,50);
			var saveLoadSlotsSpacing:Number = 100;
			
			for (var i:int = 0 ; i < numSlots ; i++){
				var saveLoadSlot:SaveLoadSlotDisplay = null;
				if(PlayerStats.currentPlayerDataVoIndex == i){
					
					saveLoadSlot = new SaveLoadSlotDisplay(true,true,PlayerStats.playerDataVos[i],i);
					saveLoadSlots.push(saveLoadSlot);
					addChild(saveLoadSlot);
					saveLoadSlot.x = saveLoadSlotsStartPoint.x
					saveLoadSlot.y = saveLoadSlotsStartPoint.y +saveLoadSlotsSpacing*i 	
					
				} else {
					//Find the item in PlayerStats.playerDataVos that has the correct slotLocation:
					for (var j:int = 0 ; j < PlayerStats.playerDataVos.length ; j++){
						if( PlayerStats.playerDataVos[j].slotLocation == i && 
							PlayerStats.playerDataVos[j].slotLocation != PlayerStats.currentPlayerDataVoIndex){

							saveLoadSlot = new SaveLoadSlotDisplay(false,true,PlayerStats.playerDataVos[j],i);
							saveLoadSlots.push(saveLoadSlot);
							addChild(saveLoadSlot);
							saveLoadSlot.x = saveLoadSlotsStartPoint.x
							saveLoadSlot.y = saveLoadSlotsStartPoint.y +saveLoadSlotsSpacing*i							
						}
					}
					
					//if an item is still not created... create an empty slot to start a new game with
					if(saveLoadSlot == null){
						saveLoadSlot = new SaveLoadSlotDisplay(false,false,null,i);
						saveLoadSlots.push(saveLoadSlot);
						addChild(saveLoadSlot);
						saveLoadSlot.x = saveLoadSlotsStartPoint.x
						saveLoadSlot.y = saveLoadSlotsStartPoint.y +saveLoadSlotsSpacing*i						
					}
				}
				saveLoadSlot.x = 147 + i*45;
				saveLoadSlot.y = 230 + i*70;
			}
		
			transitionIn();
		}
		
		public function refresh():void
		{
			
		}

		private var isBackButtonPressed:Boolean = false;
		private function goBack(e:MouseEvent):void
		{
			if(isBackButtonPressed == false){
				isBackButtonPressed = true;
				SoundController.playSoundEffect("SfxButtonPress");
				transitionOut(actuallyGoBack);
			}		
		}
		
		private function actuallyGoBack():void
		{
			FlxG.state = new LevelSelectionState();
		}
		
		private function transitionIn():void
		{
			var transitionHolder:Sprite = new Sprite();
			
			var whiteOut:Sprite = new Sprite();
			whiteOut.graphics.beginFill(0xf9f8ec,1);
			whiteOut.graphics.drawRect(0,0,FlxG.stage.stageWidth, FlxG.stage.stageHeight);
			transitionHolder.addChild(whiteOut);
			
			var gameLogo:* = new Resources.UISapphireSkiesLogoLarge();
			gameLogo.x = Math.round(FlxG.stage.stageWidth/2 - gameLogo.width/2); 
			gameLogo.y = Math.round(FlxG.stage.stageHeight/2 - gameLogo.height/2);
			whiteOut.addChild(gameLogo);			
			
			var transitionIn:* = new Resources.UITransitionRight();
			transitionIn.x = whiteOut.width - 15;
			var blur:BlurFilter =new BlurFilter(25,5,2);
			transitionIn.filters = [blur];
			transitionHolder.addChild(transitionIn);
			addChild(transitionHolder);
			//.75
			var myTween:GTween = new GTween(transitionHolder, .5, {x:(-transitionHolder.width)}, {ease:Linear.easeNone});
			//myTween.addEventListener("complete",animationFinished,false,0,true);
		}
		
		private var finishedCallback:Function;
		private function transitionOut(callbackMethod:Function):void
		{			
			SoundController.playSoundEffect("SfxScreenTransition");
			
			finishedCallback = callbackMethod;
			
			var transitionHolder:Sprite = new Sprite();
			
			var whiteOut:Sprite = new Sprite();
			whiteOut.graphics.beginFill(0xf9f8ec,1);
			whiteOut.graphics.drawRect(0,0,FlxG.stage.stageWidth+15, FlxG.stage.stageHeight);
			transitionHolder.addChild(whiteOut);
			
			var gameLogo:* = new Resources.UISapphireSkiesLogoLarge();
			gameLogo.x = Math.round(FlxG.stage.stageWidth/2 - gameLogo.width/2); 
			gameLogo.y = Math.round(FlxG.stage.stageHeight/2 - gameLogo.height/2);
			whiteOut.addChild(gameLogo);
			
			
			var transitionOut:* = new Resources.UITransitionLeft();
			transitionOut.x = stage.stageWidth;
			var blur:BlurFilter =new BlurFilter(25,5,2);
			transitionOut.filters = [blur];
			transitionHolder.addChild(transitionOut);
			transitionOut.x = 0;
			whiteOut.x = transitionOut.width-15;
			transitionHolder.x = FlxG.stage.stageWidth;
			addChild(transitionHolder);
			
			var myTween:GTween = new GTween(transitionHolder, .5, {x:(-transitionOut.width)}, {ease:Linear.easeNone});
			myTween.addEventListener("complete",animatedOut,false,0,true);
		}
		
		private function animatedOut(e:Event = null):void
		{
			finishedCallback();
		}
		
	}
}