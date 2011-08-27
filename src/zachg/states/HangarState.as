package zachg.states
{
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.easing.Sine;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	import zachg.PlayerStats;
	import zachg.growthItems.GrowthItem;
	import zachg.growthItems.buildingItem.BuildingItem;
	import zachg.growthItems.playerItem.PlayerItem;
	import zachg.ui.MoneyDisplay;
	import zachg.ui.UpgradeList;
	import zachg.ui.dialogues.EquipItemDisplay;
	import zachg.util.GameMessageController;
	import zachg.util.PlayerDataVo;
	import zachg.util.SoundController;
	import zachg.windows.GrowthItemDisplay;
	
	public class HangarState extends FlxState
	{
	
		//TODO: extend to support more than the current screen of items.
		
		public var growthItems:Vector.<GrowthItem> = new Vector.<GrowthItem>();
		
		public var title:Label;

		public var levelClassName:Class;
		
		public var availableClarityPts:Label;
		
		public var playerGrowthItemsLabel:Label;
		public var villageGrowthItemsLabel:Label;
		
		public var currentFundsLabel:Label;
		
		public var itemTab:Panel;
		public var itemList:UpgradeList;
		
		public var equipButtonBackground:* = new Resources.UIHangarEquipTabOn();
		public var purchaseButtonBackground:* = new Resources.UIHangarPurchaseTabOn();	
		
		public var currentMoney:MoneyDisplay;
		
		public var currentlySelectedItemDisplay:EquipItemDisplay;
		//public var currentlyEquippedItemDisplay:EquipItemDisplay;
		
		public var background:Sprite;
		
		public var _previousState:FlxState;		
		
		public var startedMoving:Boolean = false;
		public var centerPoint:Point;
		public var randomMovementDistance:Point = new Point(40,10);
		public var shipHolder:Sprite;
		public var shipInHangar:*;
		public var shipMask:Sprite
		
		public function HangarState(previousScreen:FlxState)
		{
			super();
			_previousState = previousScreen;
		}
		
		override public function create():void
		{
			FlxG.mouse.hide();
			flash.ui.Mouse.show(); 
			
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
			
			var hangarMain:* = new Resources.UIHangarMain();
			addChild(hangarMain);
			
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
			
			var muteOn:Bitmap = new Resources.UIMuteOn();
			var muteOff:Bitmap = new Resources.UIMuteOff();
			if(FlxG.mute == true){
				muteButton = new PushButton(this, FlxG.stage.stageWidth - 15, 10, "",SoundController.toggleSound,muteOn,null,muteOff,null);
			} else {
				muteButton = new PushButton(this, FlxG.stage.stageWidth - 15, 10, "",SoundController.toggleSound,muteOff,null,muteOn,null);
			}
			var helpOn:Bitmap = new Resources.UIHelpOn();
			var helpOff:Bitmap = new Resources.UIHelpOff();
			var helpButton:PushButton = new PushButton(this, FlxG.stage.stageWidth - 30, 10, "",GameMessageController.showMiniHelpWindow,helpOn,null,helpOff,null);

			
			var moneyDisplayBackground:* = new Resources.UIMoneyBackground();
			addChild(moneyDisplayBackground)
			currentMoney = new MoneyDisplay();
			currentMoney.x = 19;
			currentMoney.y = 3;
			addChild(currentMoney);
			currentMoney.setMoney( String(Math.round(PlayerStats.currentPlayerDataVo.currentCurrency)));
			var rupee:* = new Resources.UIRupeeLarge();
			rupee.x = 7;
			rupee.y = 7;
			addChild(rupee);			
			
			var launchOn:* = new Resources.UIHangarLaunchOn();
			var launchRoll:* = new Resources.UIHangarLaunchRoll();
			var launchButton:PushButton = new PushButton(this,235,9,"",startLevel,
				launchOn,null,launchRoll
			);
			
			setShipInHangar(PlayerStats.currentPlayerDataVo.currentPlayerEquip);
			
			growthItems = new Vector.<GrowthItem>();
			growthItems.push(new GrowthItem() );
			for (var i:int = 0 ; i < PlayerStats.growthItems.length ; i++){
				growthItems.push(PlayerStats.growthItems[i]);
			}
			
			var currentlyEquippedSelectRegion:PushButton = new PushButton(this,130,55,"",selectPlayerShip,
				null,null,null,null,null,-1,0x000000,true);
			currentlyEquippedSelectRegion.width = 180;
			currentlyEquippedSelectRegion.height = 110;
			currentlyEquippedSelectRegion.alpha = 0;

			itemTab = new Panel(this,426,36);
			itemTab._doesDrawBackground = false;
			itemTab.initAgain();	
			itemTab.shadow = false;
			
			itemTab.width = 300;
			itemTab.height = 500;
			itemList = new UpgradeList(itemTab,0,0,growthItems);
			itemList._scrollbar._backgroundColor = 0x2b331e;
			itemList._scrollbar._barBackgroundColor = 0x9ca065;
			itemList._scrollbar._arrowBackgroundColor = 0xa0a064;
			itemList._scrollbar._arrowColor = 0xece8dc;
			itemList._scrollbar.initForce();			
			itemList._scrollbar.visible = false;
			itemList.width = 172;
			itemList.height = 400;
			
			itemList.addEventListener(Event.SELECT,itemListSelected);
			//setListItems();
			
			currentlySelectedItemDisplay = 
				new EquipItemDisplay(
					PlayerStats.growthItems[ PlayerStats.currentPlayerDataVo.currentPlayerEquip],
					true, true,true,purchaseAndEquip);
			addChild(currentlySelectedItemDisplay);
			currentlySelectedItemDisplay.x = 113;
			currentlySelectedItemDisplay.y = 213;
			
			currentlySelectedItemDisplay.setItem(null);
			
/*			if (PlayerStats.currentPlayerDataVo.hangarTutorialShown == false){
				var hangarTutorialData:Array = [
					[
						"Blah Blah hangar tut goes here",
						"A second tutorial just to bother ya.",
						"And one more just for kicks. Annoying? Yes."
					],
					[null,null,null],
					[new Point(200,(450/2)-(135/2)),new Point(200,(450/2)-(135/2)),new Point(200,(450/2)-(135/2))]
				]
				GameMessageController.showTutorialTips(hangarTutorialData[0],hangarTutorialData[1],hangarTutorialData[2],null);
				
				PlayerStats.currentPlayerDataVo.hangarTutorialShown = true;
				PlayerStats.saveCurrentPlayerData();
			}*/
			transitionIn();
		}		
		
		public function setListItems():void
		{
			itemList.items = growthItems; 
			
/*			var itemsToEquip:Vector.<GrowthItem> = new Vector.<GrowthItem>();
			for (var i:int = 0 ; i < (PlayerStats.currentPlayerDataVo.growthItemsPurchased as Array).length ; i++){
				itemsToEquip.push( PlayerStats.growthItems[ (PlayerStats.currentPlayerDataVo.growthItemsPurchased as Array)[i] ] );
			}
			
			
			var itemsToEquip:Vector.<GrowthItem> = new Vector.<GrowthItem>();
			for (var i:int = 0 ; i < (PlayerStats.currentPlayerDataVo.growthItemsPurchased as Array).length ; i++){
				itemsToEquip.push( PlayerStats.growthItems[ (PlayerStats.currentPlayerDataVo.growthItemsPurchased as Array)[i] ] );
			}
			var itemsToPurchase:Vector.<GrowthItem> = new Vector.<GrowthItem>();
			for (var i:int = 0 ; i < (PlayerStats.growthItems).length ; i++){
				if( (PlayerStats.growthItems)[i].isPurchased == false){
					itemsToPurchase.push(PlayerStats.growthItems[i]);
				}
			}
			//For some reason the purchase list misses the first item. Make it miss an empty one.
			if(itemsToPurchase.length > 4){
				itemsToPurchase.splice(0,0,new GrowthItem() );
			}
			purchaseList.items = itemsToPurchase;
			if(itemsToEquip.length > 4){
				itemsToEquip.splice(0,0,new GrowthItem() );
			}
			equipList.items = itemsToEquip;*/
		}
		
		override public function update():void
		{
		}
		
		public function purchaseAndEquip():void
		{
			if (itemList.selectedItem != null && itemList.selectedIndex != -1){
				if ( PlayerStats.isUpgradePurchased( (itemList.selectedIndex-1) ) == true){
					//equip
					if( PlayerStats.currentPlayerDataVo.currentPlayerEquip != (itemList.selectedIndex-1) ){
						for ( var i:int = 0 ; i < PlayerStats.growthItems.length ; i++){
							if( PlayerStats.growthItems[i].isEquipped == true){
								PlayerStats.growthItems[i].isEquipped = false;
							}
						}
						PlayerStats.growthItems[(itemList.selectedItem as GrowthItem).id].isEquipped = true
						PlayerStats.currentPlayerDataVo.currentPlayerEquip = (itemList.selectedItem as GrowthItem).id;
						(itemList.selectedItem as GrowthItem).isEquipped = true;	
						PlayerStats.saveCurrentPlayerData();
						
						currentlySelectedItemDisplay.setItem( (itemList.selectedItem as GrowthItem) );
						setShipInHangar((itemList.selectedItem as GrowthItem).id);	
						itemList.draw();
					} 
					
				} else {
					//purchase unless it's locked(premium)
					//if( isItemLocked == true){
					
					if( PlayerStats.currentPlayerDataVo.currentCurrency >= (itemList.selectedItem as GrowthItem).clarityPtsRequired){
						SoundController.playSoundEffect("SfxPurchaseShip");
						(itemList.selectedItem as GrowthItem).isPurchased = true;
						
						PlayerStats.currentPlayerDataVo.currentCurrency -= (itemList.selectedItem as GrowthItem).clarityPtsRequired;
						(PlayerStats.currentPlayerDataVo.growthItemsPurchased as Array).push( PlayerStats.getGrowthItemId((itemList.selectedItem as GrowthItem).description) );
						PlayerStats.saveCurrentPlayerData();
						
						//setShipInHangar(-1);
						setListItems();
						currentlySelectedItemDisplay.setItem( (itemList.selectedItem as GrowthItem) );
						itemList.draw();
						
						//currentFundsLabel.text = "Current Funds: $" + PlayerStats.currentPlayerDataVo.currentCurrency;
						//purchaseButton.label = "Purchased";
					}					
				}
			}
			currentMoney.setMoney( String(Math.round(PlayerStats.currentPlayerDataVo.currentCurrency)));
			//FlxG.state = new EquipState();
			//go to purchase or equip panels
		}
		
		private function selectLevel(e:MouseEvent):void
		{
			FlxG.state = new LevelSelectionState();
		}

		public var currentShipInHangarIndex:Number = -1;
		private function setShipInHangar(itemIndex:Number):void
		{
			if(currentShipInHangarIndex == itemIndex){
				return
			} else {
				currentShipInHangarIndex = itemIndex;
			}
			if(shipInHangar != null){
				if (itemIndex != -1){
					shipHolder.removeChild(shipInHangar);
					shipHolder.removeChild(shipMask);
				}
			} else {
				shipHolder = new Sprite();
				addChild(shipHolder);				
			}
			if (itemIndex == -1){
				shipHolder.visible = false;
				return
			} else {
				shipHolder.visible = true;
			}			
			
			var currentplayerGrowthItem:GrowthItem = PlayerStats.growthItems[ itemIndex];
			
			shipInHangar = new Resources[currentplayerGrowthItem.shipGraphic]();
			shipHolder.addChild(shipInHangar);
			shipMask = new Sprite();
			shipHolder.addChild(shipMask);
			shipMask.alpha = 0;
			shipMask.graphics.beginFill(0x000000);
			shipMask.graphics.drawRect(0,0,currentplayerGrowthItem.shipGraphicParameters[2],currentplayerGrowthItem.shipGraphicParameters[3]);
			shipInHangar.mask = shipMask; 
			shipHolder.x = 131 + (318-131)/2 - shipMask.width/2;
			//shipMask.x = shipInHangar.x;
			shipHolder.y = 175 - shipMask.height - 20;
			//shipMask.y = shipInHangar.y;
			
			centerPoint = new Point(
				131 + (318-131)/2 - shipMask.width/2,
				175 - shipMask.height - 20);
			if(startedMoving == false){
				startedMoving = true;
				randomShipMove();
			}			
		}
		
		private function itemListSelected(e:Event = null):void
		{
			currentlySelectedItemDisplay.setItem(itemList.selectedItem as GrowthItem);
		}
		
		private function randomShipMove(e:Event = null):void
		{
			var randomPointToMove:Point = new Point(Math.random()*randomMovementDistance.x + centerPoint.x,Math.random()*randomMovementDistance.y + centerPoint.y);
			var myTween:GTween = new GTween(shipHolder, 2, {x:randomPointToMove.x, y:randomPointToMove.y}, {ease:Back.easeOut});
			//var myTween2:GTween = new GTween(shipMask, 2, {x:randomPointToMove.x, y:randomPointToMove.y}, {ease:Back.easeOut});
			myTween.addEventListener(Event.COMPLETE, randomShipMove);
		}
		
		private function selectPlayerShip(e:MouseEvent = null):void
		{
			itemList.selectedItem = PlayerStats.growthItems[ PlayerStats.currentPlayerDataVo.currentPlayerEquip];
			currentlySelectedItemDisplay.setItem( (itemList.selectedItem as GrowthItem) );
			setShipInHangar((itemList.selectedItem as GrowthItem).id);
			
		}

		private var isBackButtonPressed:Boolean = false;		
		private function goBack(e:MouseEvent):void
		{
			if(isBackButtonPressed == false){
				isBackButtonPressed = true;
				SoundController.playSoundEffect("SfxButtonPress");
				transitionOut(goBackTransitionFinished);
			}
		}		
		private function goBackTransitionFinished():void
		{
			FlxG.state = _previousState;
		}		
		
		private function startLevel(e:Event = null):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(startLevelTransitionFinished);
		}
		private function startLevelTransitionFinished():void
		{
			FlxG.state = new PlayState(null);
		}
		
		private function startSpecificLevel(e:MouseEvent = null):void
		{
			//FlxG.state = new PlayState(levelClassName);
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