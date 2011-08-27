package zachg
{
	import com.BaseLevel;
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.senocular.display.duplicateDisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	
	import zachg.states.LevelSelectionState;
	import zachg.ui.Minimap;
	import zachg.ui.MoneyDisplay;
	import zachg.ui.dialogues.InteruptDialogue;
	import zachg.util.GameMessageController;
	import zachg.util.LevelData;
	import zachg.util.SoundController;
	import zachg.windows.CargoWindow;
	import zachg.windows.EndLevelWindow;
	import zachg.windows.GrowthItemWindow;
	import zachg.windows.PlayerEquipmentWindow;
	
	public class GameInterface extends Sprite
	{
				
		public var overAllInfoSprite:Sprite = new Sprite();
		
		public var optionsSprite:Sprite = new Sprite();
		public var playerToggleSprite:Sprite = new Sprite();
		public var optionsSpriteBackground:Sprite = new Sprite();
		public var playerToggleSpriteBackground:Sprite = new Sprite();
		
		public var helpButton:PushButton;
		public var reportBugButton:PushButton;
		public var soundToggleButton:PushButton;
		
		public var equipmentChangeButton:PushButton;
		public var viewAllGrowthItemsButton:PushButton;
		public var viewCargoButton:PushButton;
		public var quitLevelButton:PushButton;
		public var pauseButton:PushButton;
		public var freezeButton:PushButton;
		
		public var growthItemWindow:GrowthItemWindow;
		public var playerEquipmentWindow:PlayerEquipmentWindow;
		public var cargoWindow:CargoWindow;
		
		public var secondaryWeaponReloadIndicator:ProgressBar;
		public var primaryWeaponReloadIndicator:ProgressBar;
		public var miningReloadIndicator:ProgressBar;
		
		public var clickBlocker:Sprite;
		
		public var minimap:Minimap;

		public var currentMoney:MoneyDisplay;	
		
		public var dangerLeft:*
		public var dangerRight:*
		public var cargoDangerLeft:*
		public var cargoDangerRight:*

			
		//TODO: fix this class so that the framerate can be set to 0 while it's displayed
		
		public function GameInterface()
		{
			super();
			
			dangerLeft = new Resources.UIGameLeftDanger();
			addChild(dangerLeft);
			dangerLeft.alpha = 0;
			dangerRight = new Resources.UIGameRightDanger();
			addChild(dangerRight);
			dangerRight.x = FlxG.stage.stageWidth - dangerRight.width;
			dangerRight.alpha = 0;
			cargoDangerLeft = new Resources.UIGameOverloadLeft();
			cargoDangerRight = new Resources.UIGameOverloadRight();
			cargoDangerRight.x = FlxG.stage.stageWidth - dangerRight.width;
			cargoDangerRight.alpha = 0;
			cargoDangerLeft.alpha = 0;
			addChild(cargoDangerRight);
			addChild(cargoDangerLeft);
			
			setupTopBar();
						
			setupBottomLeftInfo();
			
			setupRadar();
			
			var reportBugButton:PushButton = new PushButton(this,FlxG.stage.stageWidth - 118 - 20,FlxG.stage.stageWidth - 109,"Report Bug",reportBugClicked,
				null,null,null,null,null,-1,0x000000,true);

			
			
//			
//			growthItemWindow = new GrowthItemWindow(windowClosed);
//			addChild(growthItemWindow);
//			growthItemWindow.visible = false;
//
//			playerEquipmentWindow = new PlayerEquipmentWindow(windowClosed);
//			addChild(playerEquipmentWindow);
//			playerEquipmentWindow.visible = false;
//			

//			optionsSprite.addChild(optionsSpriteBackground);
//			helpButton = new PushButton(optionsSprite,5,5,"Help",helpClicked)
//			helpButton.width = 40;

			//soundToggleButton = new PushButton(optionsSprite,130,5,"Turn Sound Off",toggleSound)
//			optionsSpriteBackground.graphics.beginFill(0x808080);
//			optionsSpriteBackground.graphics.drawRect(0,0,optionsSprite.width + 10,30);
//			reportBugButton.width = 70
//			optionsSpriteBackground.alpha = .50;
//			optionsSprite.x = FlxG.stage.stageWidth - optionsSprite.width;
//			addChild(optionsSprite);
//			
//			playerToggleSprite.addChild(playerToggleSpriteBackground)
//			//equipmentChangeButton = new PushButton(playerToggleSprite,5,5,"Change Equipment",toggleEquipment);
//			//viewAllGrowthItemsButton = new PushButton(playerToggleSprite,115,5,"View Growth Items",toggleGrowthItems);
//			viewCargoButton = new PushButton(playerToggleSprite,5,5,"View Cargo",toggleCargo);
//			viewCargoButton.width = 45;
//			quitLevelButton = new PushButton(playerToggleSprite,55,5,"Restart Level",restartLevel);
//			quitLevelButton.width = 60;
//			pauseButton = new PushButton(playerToggleSprite,115,5,"P to Pause",pauseGame);
//			pauseButton.width = 60;
//			freezeButton = new PushButton(playerToggleSprite,225,5,"Tactical Mode (T)",toggleFrozenState);
//			
//			playerToggleSpriteBackground.graphics.beginFill(0x808080);
//			playerToggleSpriteBackground.graphics.drawRect(0,0,playerToggleSprite.width + 10,30);
//			playerToggleSpriteBackground.alpha = .50;
//			playerToggleSprite.y = FlxG.stage.stageHeight - playerToggleSprite.height;
//			addChild(playerToggleSprite);

		}
		
		private function setupTopBar():void
		{
			var missionNameBackground:Sprite = new Sprite();
			missionNameBackground.graphics.beginFill(0,.5);
			missionNameBackground.graphics.drawRect(0,0,300,26);
			addChild(missionNameBackground);
			
			var missionLabel:Label = new Label(
				missionNameBackground,16,6,
				"Mission: "+LevelData.LevelTitles[PlayerStats.currentLevelId],
				"MenuFont",15,0xf7f7ed
			);
			
			var topbar:* = new Resources.UIGameTopBar();
			addChild(topbar);
			
			var buttonOn:Bitmap = new Resources.UIButtonOffSmall();
			var buttonRollOver:Bitmap = new Resources.UIButtonOnSmall();
			
			var menuButton:PushButton = new PushButton(this, 218,5,"[M]enu",gotoMenu,
				duplicateDisplayObject(buttonOn),new Point(-3,2),duplicateDisplayObject(buttonRollOver),new Point(-3,2),"MenuFont", 22, 0xf7f7ed);
			menuButton.width = 75;
			menuButton.height = 12;
			
			var menuTactical:PushButton = new PushButton(this, 297,5,"[T]actical",toggleFrozenState,
				duplicateDisplayObject(buttonOn),new Point(-3,2),duplicateDisplayObject(buttonRollOver),new Point(-3,2),"MenuFont", 22, 0xf7f7ed);
			menuTactical.width = 115;
			menuTactical.height = 12;
			
			var menuCargo:PushButton = new PushButton(this, 410,5,"[C]argo",toggleCargo,
				duplicateDisplayObject(buttonOn),new Point(-3,2),duplicateDisplayObject(buttonRollOver),new Point(-3,2),"MenuFont", 22, 0xf7f7ed);
			menuCargo.width = 90;
			menuCargo.height = 12;
			
			var menuPause:PushButton = new PushButton(this, 502,5,"[P]ause",pauseGame,
				duplicateDisplayObject(buttonOn),new Point(-3,2),duplicateDisplayObject(buttonRollOver),new Point(-3,2),"MenuFont", 22, 0xf7f7ed);
			menuPause.width = 90;
			menuPause.height = 12;
			
			var muteOn:Bitmap = new Resources.UIMuteOn();
			var muteOff:Bitmap = new Resources.UIMuteOff();
			if(FlxG.mute == true){
				FlxG.state.muteButton = new PushButton(this, FlxG.stage.stageWidth - 15, 14, "",SoundController.toggleSound,muteOn,null,muteOff,null);
			} else {
				FlxG.state.muteButton = new PushButton(this, FlxG.stage.stageWidth - 15, 14, "",SoundController.toggleSound,muteOff,null,muteOn,null);
			}
			var helpOn:Bitmap = new Resources.UIHelpOn();
			var helpOff:Bitmap = new Resources.UIHelpOff();
			var helpButton:PushButton = new PushButton(this, FlxG.stage.stageWidth - 15, 2, "",GameMessageController.showMiniHelpWindow,helpOn,null,helpOff,null);

		}
		
		public function setupRadar():void
		{
			var radarBackgroundBox:Sprite = new Sprite();
			radarBackgroundBox.graphics.beginFill(0x000000,.5);
			radarBackgroundBox.graphics.drawRect(0,0,116,106);
			addChild(radarBackgroundBox);
			
			var radarBackground:* = new Resources.UIGameRadar();
			radarBackground.x = FlxG.stage.stageWidth - 118;
			radarBackground.y = FlxG.stage.stageHeight - 108;
			addChild(radarBackground);

			radarBackgroundBox.x = radarBackground.x + 2;
			radarBackgroundBox.y = radarBackground.y + 2;
			
			var radarKey:* = new Resources.UIGameRadarKey();
			radarKey.x = radarBackgroundBox.x - 61;
			radarKey.y = FlxG.stage.stageHeight - 52;
			addChild(radarKey);
			
			minimap = new Minimap();
			minimap.x = 485;
			minimap.y = 352;
			addChild(minimap);			
			
			var radarKeyBackground:Sprite = new Sprite();
			radarKeyBackground.graphics.beginFill(0x000000);
			radarKeyBackground.graphics.drawRect(0,0,radarKey.width - 6,radarKey.height - 2);
			radarKeyBackground.alpha = .5;
			radarKeyBackground.x = radarKey.x;
			radarKeyBackground.y = radarKey.y;
			addChild(radarKeyBackground);
			
			var playerKeyText:Label = new Label(this,radarKeyBackground.x + 3,radarKeyBackground.y + 4,"Player","system",8,minimap.playerTextColor);
			var friendlyKeyText:Label = new Label(this,radarKeyBackground.x + 3,radarKeyBackground.y + 4 + 15,"Friendly","system",8,minimap.friendlyTextColor);
			var enemyKeyText:Label = new Label(this,radarKeyBackground.x + 3,radarKeyBackground.y + 4 + 30,"Enemy","system",8,minimap.enemyTextColor);
			
		}
		
		public var healthBar:HSlider;
		public var cargoBar:HSlider;
		
		public function setupBottomLeftInfo():void
		{
			var bottomLeft:* = new Resources.UIGameBottomLeft();
			bottomLeft.y = FlxG.stage.stageHeight - 105;
			addChild(bottomLeft);
			
			var marker:* = new Resources.UIGameMarker();
			var healthBarBackground:* = new Resources.UIGameHealthBar();
			
			healthBar = new HSlider(this,0,398,
				duplicateDisplayObject(healthBarBackground),null,duplicateDisplayObject(marker),
				new Point(0,3));
			healthBar.width = 135;
			healthBar.minimum = 0;
			healthBar.maximum = (FlxG.state as PlayState).player.healthComponent.maxHealth;
			healthBar.value = (FlxG.state as PlayState).player.healthComponent.currentHealth;			
			

			var cargoBarBackground:* = new Resources.UIGameCargoBar();
			cargoBar = new HSlider(this,0,424,
				duplicateDisplayObject(cargoBarBackground),null,duplicateDisplayObject(marker),
				new Point(0,3));
			cargoBar.width = 135;
			cargoBar.minimum = 0;
			cargoBar.maximum = (FlxG.state as PlayState).player.cargoSizeLimit;
			cargoBar.value = (FlxG.state as PlayState).player.currentPlayerMinerals.length;			
			
			var moneyDisplayBackground:* = new Resources.UIMoneyBackground();
			addChild(moneyDisplayBackground)
			currentMoney = new MoneyDisplay();
			moneyDisplayBackground.x = 2;
			moneyDisplayBackground.y = 342;
			currentMoney.x = 20;
			currentMoney.y = 345;
			addChild(currentMoney);
			currentMoney.setMoney( PlayerStats.currentPlayerDataVo.currentCurrency);
			var rupee:* = new Resources.UIRupeeLarge();
			rupee.x = 8;
			rupee.y = 348;
			addChild(rupee);
			
			var weaponIndicator1:* = new Resources.UIGameWeaponMain();
			weaponIndicator1.x = 182;
			weaponIndicator1.y = 390;
			addChild(weaponIndicator1);
			
			var weaponIndicator2:* = new Resources.UIGameWeaponSecondary();
			weaponIndicator2.x = 182;
			weaponIndicator2.y = 410;
			addChild(weaponIndicator2);

			var weaponIndicator3:* = new Resources.UIGameMining();
			weaponIndicator3.x = 182;
			weaponIndicator3.y = 430;
			addChild(weaponIndicator3);
			
			primaryWeaponReloadIndicator = new ProgressBar(this,198,392);
			primaryWeaponReloadIndicator.maximum = (FlxG.state as PlayState).player.gunComponent.shotDelay;
			primaryWeaponReloadIndicator.value = (FlxG.state as PlayState).player.gunComponent.lastShotCounter;
			
			secondaryWeaponReloadIndicator = new ProgressBar(this,198,412);
			secondaryWeaponReloadIndicator.maximum = (FlxG.state as PlayState).player.gunComponent.secondaryShotDelay;
			secondaryWeaponReloadIndicator.value = (FlxG.state as PlayState).player.gunComponent.lastSecondaryShotCounter;
			if( (FlxG.state as PlayState).player.gunComponent.canRam == true){
				var ramLabel:Label = new Label(this,198,410,"Ram Equipped","system",8,0x000000);
			}

			miningReloadIndicator = new ProgressBar(this,198,432);
			miningReloadIndicator.maximum = (FlxG.state as PlayState).player.gunComponent.mineDelay;
			miningReloadIndicator.value = (FlxG.state as PlayState).player.gunComponent.mineCounter;
		}

		public function helpClicked(e:MouseEvent):void
		{
			gotoUrl("http://www.reindeerflotilla.net/forum/");
		}

		public function reportBugClicked(e:MouseEvent):void
		{
			gotoUrl("http://www.reindeerflotilla.net/forum/");
		}		
		
		public function toggleFrozenState(e:MouseEvent = null):void
		{
			(FlxG.state as PlayState).doChangeFrozenState = true;
		}
		
		public var interuptDialogue:InteruptDialogue;
		public function pauseGame(e:MouseEvent = null):void
		{
			
			
			if ( (FlxG.state as PlayState).isFrozen == false){
				clickBlocker = new Sprite();
				clickBlocker.graphics.beginFill(0xFFFFFF,.25);
				clickBlocker.graphics.drawRect(0,0,FlxG.stage.stageWidth,FlxG.stage.stageHeight);
				FlxG.state.addChild(clickBlocker);
				
				interuptDialogue = new InteruptDialogue(
					pauseGame,
					new Point(600/2-250/2,450/2-150/2),
					"Game Paused","Unpause");
				interuptDialogue.showTip();
				
				(FlxG.state as PlayState).stageMoveEnabled = false;
				(FlxG.state as PlayState).doChangeFrozenState = true;
			} else {
				if(interuptDialogue != null){
					(FlxG.state).removeChild(interuptDialogue);
					interuptDialogue = null
				}
				interuptDialogue = null;
				(FlxG.state as PlayState).stageMoveEnabled = true;
				(FlxG.state as PlayState).doChangeFrozenState = true;				
				if(clickBlocker != null){
					FlxG.state.removeChild(clickBlocker);
				}
			}						
			
/*			if(FlxG.pause == true){
				FlxG.pause = false;
				pauseButton.label = "P to Pause";
			} else {
				FlxG.pause = true;
				pauseButton.label = "P to Unpause";
			}
*/		}
		
		//TODO: doing toggles this way is NOT extensible. RETHINK this shit!
		public function toggleSound(e:MouseEvent):void
		{
//			if(SoundController.processor.isPlaying == true){
//				SoundController.pauseSong();
//				soundToggleButton.label = "Turn Sound On";
//			} else {
//				SoundController.resumeSong();
//				soundToggleButton.label = "Turn Sound Off";
//			}

		}

		public var cargoToggled:Boolean = false;
		public function toggleCargo(e:MouseEvent = null):void
		{
			if(cargoToggled == false){
				cargoToggled = true;
				clickBlocker = new Sprite();
				clickBlocker.graphics.beginFill(0xFFFFFF,.25);
				clickBlocker.graphics.drawRect(0,0,FlxG.stage.stageWidth,FlxG.stage.stageHeight);
				FlxG.state.addChild(clickBlocker);

				cargoWindow = new CargoWindow(windowClosed);
				cargoWindow.x = 104;
				cargoWindow.y = 10;
				cargoWindow.visible = true;
				cargoWindow.setList();
				FlxG.state.addChild(cargoWindow);
				
				if ( (FlxG.state as PlayState).isFrozen == false){
					(FlxG.state as PlayState).stageMoveEnabled = false;
					(FlxG.state as PlayState).doChangeFrozenState = true;
				}
			}
		}

		public function windowClosed():void
		{
			cargoToggled = false;
			
			FlxG.state.removeChild(cargoWindow);
			cargoWindow.visible = false;
			
			if(clickBlocker != null){
				FlxG.state.removeChild(clickBlocker);
			}			
			
			if ( (FlxG.state as PlayState).isFrozen == true){
				(FlxG.state as PlayState).stageMoveEnabled = true;
				(FlxG.state as PlayState).doChangeFrozenState = true;
			}			
		}
		
		public function restartLevel(e:MouseEvent):void
		{
			GlobalVariables.doRestart = true;
			FlxG.state = new PlayState( (FlxG.state as PlayState).levelClassName );
			//(FlxG.state as PlayState).create();
			//(FlxG.state as PlayState).switchTest = false;
			FlxG.framerate = 30;
			growthItemWindow.visible = false;
			playerEquipmentWindow.visible = false;
			cargoWindow.visible = false;			
		}
		
		public function gotoUrl(url:String):void {
			//var url:String = "http://www.example.com/";
			var request:URLRequest = new URLRequest(url);
			try {
				navigateToURL(request, '_blank');
			} catch (e:Error) {
				trace("Error occurred!");
			}
		}
		
		public var warningCounter:Number = 10;
		public var warningDelay:Number = 20;
		public function refresh():void
		{
			//playerEquipmentWindow.refresh();
			//growthItemWindow.refresh();
			
			cargoBar.value = (FlxG.state as PlayState).player.cargoSizeLimit - (FlxG.state as PlayState).player.currentPlayerMinerals.length;
			healthBar.value = (FlxG.state as PlayState).player.healthComponent.currentHealth;
			currentMoney.setMoney( String(Math.round(PlayerStats.currentLevelDataVo.cashBalance)) );
			
			primaryWeaponReloadIndicator.value = (FlxG.state as PlayState).player.gunComponent.lastShotCounter;
			secondaryWeaponReloadIndicator.value = (FlxG.state as PlayState).player.gunComponent.lastSecondaryShotCounter; 
			miningReloadIndicator.value = (FlxG.state as PlayState).player.gunComponent.mineCounter;
			
			var isHealthWarningOn:Boolean = false;
			var isCargoWarningOn:Boolean = false;
			if( (FlxG.state as PlayState).player.healthComponent.currentHealth < 
				((FlxG.state as PlayState).player.healthComponent.maxHealth * 0.25)
			){
				isHealthWarningOn = true;
			}
			var percentageFilled:Number = (FlxG.state as PlayState).player.currentPlayerMinerals.length/(FlxG.state as PlayState).player.cargoSizeLimit;
			if( percentageFilled > .75){
				isCargoWarningOn = true;
			}
			
			cargoDangerLeft.alpha = 0;
			cargoDangerRight.alpha = 0;
			dangerRight.alpha = 0;
			dangerLeft.alpha = 0;
			
			if( warningCounter > (warningDelay)){
				warningCounter = 0;
			} else if( warningCounter > (warningDelay/2) ){
				if(isHealthWarningOn == true){
					dangerRight.alpha = 0;
					dangerLeft.alpha = 0;
				}
				if(isCargoWarningOn == true){
					cargoDangerLeft.alpha = 1;
					cargoDangerRight.alpha = 1;
				}
			} else {
				if(isHealthWarningOn == true){
					dangerRight.alpha = 1;
					dangerLeft.alpha = 1;
				} 
				if(isCargoWarningOn == true){
					cargoDangerLeft.alpha = 0;
					cargoDangerRight.alpha = 0;
				}				
			}
			warningCounter++;
			
			
/*			var minimapStartX:Number = FlxG.stage.stageWidth - (minimap.width + minimap.x);
			var minimapEndX:Number = minimapStartX + minimap.x;
			var minimapStartY:Number = FlxG.stage.stageHeight - (minimap.height + minimap.y);
			var minimapEndY:Number = minimapStartX + minimap.x;
*/			
			if(	FlxG.mouse.justPressed() == true &&
				FlxG.mouse.screenX > minimap.x  &&
				FlxG.mouse.screenY > minimap.y){
				var localPoint:FlxPoint = new FlxPoint( 
					FlxG.mouse.screenX - minimap.x,
					FlxG.mouse.screenY - minimap.y 
				);
				
				var worldPoint:FlxPoint = new FlxPoint( (localPoint.x/minimap.mapWidth)*(BaseLevel.boundsMaxX),
					(localPoint.y/minimap.mapHeight)*(BaseLevel.boundsMaxY) );
				(FlxG.state as PlayState).moveCamera(worldPoint);
			}
			minimap.drawMinimap();
		}
		
		public var menuWarningToggled:Boolean = false;
		public function gotoMenu(e:Event = null):void
		{
			if(menuWarningToggled == false){
				menuWarningToggled = true;
				(FlxG.state as PlayState).stageMoveEnabled = false;
				(FlxG.state as PlayState).doChangeFrozenState = true;							
				
				clickBlocker = new Sprite();
				clickBlocker.graphics.beginFill(0xFFFFFF,.25);
				clickBlocker.graphics.drawRect(0,0,FlxG.stage.stageWidth,FlxG.stage.stageHeight);
				FlxG.state.addChild(clickBlocker);
				
				var interuptDialogue:InteruptDialogue = new InteruptDialogue(
					switchToMenuState,
					new Point(600/2-250/2,450/2-150/2),
					"Warning: Returning to the menu will quit the current mission","Continue",
					"Cancel",cancelMenuStateSwitch);
				interuptDialogue.showTip();
			}
		}
		
		public function switchToMenuState(e:Event = null):void
		{
			
			(FlxG.state as PlayState).stageMoveEnabled = true;
			(FlxG.state as PlayState).doChangeFrozenState = true;				
			if(clickBlocker != null){
				FlxG.state.removeChild(clickBlocker);
			}			
			menuWarningToggled = false;
			
			//display warning, then go to level select
			FlxG.state = new LevelSelectionState();
		}
		
		public function cancelMenuStateSwitch(e:Event = null):void
		{
			menuWarningToggled = false;
			
			(FlxG.state as PlayState).stageMoveEnabled = true;
			(FlxG.state as PlayState).doChangeFrozenState = true;				
			if(clickBlocker != null){
				FlxG.state.removeChild(clickBlocker);
			}			
		}
		
	}
}