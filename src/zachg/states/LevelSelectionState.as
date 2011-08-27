package zachg.states
{
	
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.easing.Sine;
	import com.onebyonedesign.td.OBO_3DCarousel;
	import com.onebyonedesign.td.TDCarouselItem;
	import com.senocular.display.duplicateDisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	import zachg.MainMenu;
	import zachg.PlayerStats;
	import zachg.ui.CarouselLevelItem;
	import zachg.ui.MoneyDisplay;
	import zachg.ui.dialogues.LevelInfoDialogue;
	import zachg.util.GameMessageController;
	import zachg.util.LevelData;
	import zachg.util.SoundController;
	import zachg.util.levelEvents.CarouselEvent;
	import zachg.windows.TutorialWindow;
	
	
	public class LevelSelectionState extends FlxState
	{
		public var map:Bitmap = new Bitmap();
		public var showUpgrades:PushButton;
		public var showMainMenu:PushButton;
		public var showSaveLoad:PushButton;
		public var showEquip:PushButton;

		public var infoDialogues:Array = new Array();
		
		public var title:Label;
		public var titlebackground:Sprite;
		
		public var right_mc:MovieClip = new MovieClip();
		public var left_mc:MovieClip = new MovieClip();
		public var loading_txt:TextField;
		
		public static const XML_URL:String = "images.xml";
		
		private var _carousel:OBO_3DCarousel;
		private var _imageList:XMLList;
		private var _numImages:int;
		private var _currentImage:int = 0;	
		
		public var currentlySelectedLevelDialogue:LevelInfoDialogue;
		public var currentlySelectedLevel:int = -1;
		
		public var smallButtonOn:*
		public var smallButtonOff:*		
		
		public var numLevelsPerStage:Number = 3;
		
		private var tutorialWindow:TutorialWindow;
		private var levelClassName:Class;
		
		public var stageImages:Array = [
			new Resources.UIIslandGraphicStage1(), 
			new Resources.UIIsland2(),
			new Resources.UIIsland3(),
			new Resources.UIIsland4(),
			new Resources.UIIsland5()
		];
		
		public var isAnimating:Boolean = false;
		
		public var allOnScreenItems:Array = new Array();
		public var screenDataItems:Array = new Array();
		
			
		public function LevelSelectionState()
		{
			super();
		}
		
		override public function create():void
		{			
			FlxG.mouse.hide();
			flash.ui.Mouse.show();
		
			setupBackground();
			setupLevelSelect();
			setupButtons();
			
			leftClickHandler();
			
			if(SoundController.isMenuMusicPlaying != true){
				SoundController.playSong(MusicMainMenu);
				SoundController.isMenuMusicPlaying = true;
			}
			
			transitionIn();
		}
		
		public function setupBackground():void
		{
			var background:* = new Resources.BackgroundStage1();
			background.x = -500;
			background.y = -715;
			background.width = background.width*(3/4);
			background.height = background.height*(3/4);
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
			
			var optionsMain:* = new Resources.UILevelSelect();
			addChild(optionsMain);			
		}
		
		public function setupButtons():void
		{
			smallButtonOn = new Resources.UIButtonOnSmall();
			smallButtonOff = new Resources.UIButtonOffSmall();
			
			showMainMenu = new PushButton(this, 42, FlxG.stage.stageHeight - 44, "Menu",goToMainMenu,
			duplicateDisplayObject(smallButtonOff),new Point(15,-15), duplicateDisplayObject(smallButtonOn),new Point(15,-15),
			"MenuFont", 35, 0xf7f7ed);
			showMainMenu.width = 100;
			showMainMenu.height = 12;

			var showOptions:PushButton = new PushButton(this, 147, FlxG.stage.stageHeight - 44, "Options",goToOptions,
				duplicateDisplayObject(smallButtonOff),new Point(16,-15), duplicateDisplayObject(smallButtonOn),new Point(16,-15),
				"MenuFont", 35, 0xf7f7ed);
			showOptions.width = 120;
			showOptions.height = 12;			

			showSaveLoad = new PushButton(this, 288, FlxG.stage.stageHeight - 44, "Save/Load",goToSaveLoad,
				duplicateDisplayObject(smallButtonOff),new Point(10,-15), duplicateDisplayObject(smallButtonOn),new Point(10,-15),
				"MenuFont", 35, 0xf7f7ed);
			showSaveLoad.width = 150;
			showSaveLoad.height = 12;			

			var showStats:PushButton = new PushButton(this, 450, FlxG.stage.stageHeight - 44, "Stats",goToStats,
				duplicateDisplayObject(smallButtonOff),new Point(17,-15), duplicateDisplayObject(smallButtonOn),new Point(17,-15),
				"MenuFont", 35, 0xf7f7ed);
			showStats.width = 100;
			showStats.height = 12;						
			
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

			
			var levelRewardDislay:MoneyDisplay = new MoneyDisplay();
			levelRewardDislay.x = 19;
			levelRewardDislay.y = 3;
			addChild(levelRewardDislay);
			levelRewardDislay.setMoney( String(Math.round(PlayerStats.currentPlayerDataVo.currentCurrency)));
			var rupee:* = new Resources.UIRupeeLarge();
			rupee.x = 7;
			rupee.y = 7;
			addChild(rupee);			
		}
		
		public function setupLevelSelect():void
		{
			currentlySelectedLevelDialogue = new LevelInfoDialogue(-1,goToHangar);
			currentlySelectedLevelDialogue.x = 160;
			currentlySelectedLevelDialogue.y = 25;
			addChild(currentlySelectedLevelDialogue);
			currentlySelectedLevelDialogue.disableStartLevel();
			
			_carousel = new OBO_3DCarousel(500, 400, 500);
			_carousel.useBlur = true;
			_carousel.y = 180;
			_carousel.x = 290;
			addChild(_carousel);
			
			setupLevelImages();
			
			
			var rightRotation:* = new Resources.UIRightRotate();
			var leftRotation:* = new Resources.UILeftRotate();
			var rightRotateButton:PushButton = new PushButton(this,480,344,"",leftClickHandler, rightRotation);
			var leftRotateButton:PushButton = new PushButton(this,67,344,"",rightClickHandler, leftRotation);
			
		}
		
		public function showTips():void
		{
			if (PlayerStats.currentPlayerDataVo.levelSelectTutorialShown == false){
				var levelSelectionTutorialData:Array = [
					[
						"Click an area of the current level to view more information about it",
						"Click the bottom bits to select different stages",
						"Click the hangar button to select the ship to use for the mission"
					],
					[null,null,null],
					[new Point(200,(450/2)-(135/2)),new Point(200,(450/2)-(135/2)),new Point(200,(450/2)-(135/2))]
				]
				GameMessageController.showTutorialTips(levelSelectionTutorialData[0],levelSelectionTutorialData[1],levelSelectionTutorialData[2],null);
				
				PlayerStats.currentPlayerDataVo.levelSelectTutorialShown = true;
				PlayerStats.saveCurrentPlayerData();
			}			
		}
		
		public function setupLevelImages():void
		{  
			
			for (var i:int = 0 ; i < stageImages.length ; i++){
				var carouselItem:Sprite = new Sprite();
				carouselItem.addChild( stageImages[i] );
				_carousel.addItem(carouselItem);
				(_carousel._items[i] as TDCarouselItem).stageReferenceId = i;
			}
		}
		
		public function selectLevel(e:CarouselEvent = null):void
		{
			currentlySelectedLevelDialogue.setLevel(e.data);
		}
		
		override public function update():void
		{
			if( currentlySelectedLevelDialogue.levelId != _currentImage ){
				
				
				//currentlySelectedLevelDialogue.setLevel(_currentImage);
			}
		}
		
		private function goToMainMenu(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(goToMainMenuTransitionFinished);
		}
		private function goToMainMenuTransitionFinished():void
		{
			FlxG.state = new MainMenuState();
		}
		
		
		private function goToSaveLoad(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(goToSaveLoadTransitionFinished);
		}
		private function goToSaveLoadTransitionFinished():void
		{
			FlxG.state = new SaveLoadState();
		}
		
		private function goToStats(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(goToStatsTransitionFinished);
		}
		private function goToStatsTransitionFinished():void
		{
			FlxG.state = new StatsState(false);
		}

		
		private function goToOptions(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(goToOptionsTransitionFinished);
		}
		private function goToOptionsTransitionFinished():void
		{
			FlxG.state = new OptionsState(this);
		}

		private function goToControls(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(goToControlsTransitionFinished)
		}
		private function goToControlsTransitionFinished():void
		{
			FlxG.state = new ControlsState();
		}

		private function goToHangar(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(goToHangarTransitionFinished);
		}		
		private function goToHangarTransitionFinished():void
		{
			FlxG.state = new HangarState(this);
		}		
		
		private function rightClickHandler(event:MouseEvent = null):void {
			if (isAnimating == false){
				SoundController.playSoundEffect("SfxRotateIslands");
				_currentImage = Math.abs(_currentImage+1)%(stageImages.length);
				_carousel.targetRotation += 360 / _carousel.numItems;
				var myTween:GTween = new GTween(_carousel, .5, {zRotation:_carousel.targetRotation}, {ease:Sine.easeInOut});
				myTween.addEventListener("complete",animationFinished,false,0,true);
				animationStarted();
			}
		}
		
		private function leftClickHandler(event:MouseEvent = null):void {
			if(isAnimating == false){
				SoundController.playSoundEffect("SfxRotateIslands");
				_currentImage = Math.abs(_currentImage-1)%(stageImages.length);
				_carousel.targetRotation -= 360 / _carousel.numItems;
				var myTween:GTween = new GTween(_carousel, .5, {zRotation:_carousel.targetRotation}, {ease:Sine.easeInOut});
				myTween.addEventListener("complete",animationFinished,false,0,true);
				animationStarted();
			}
		}
		
		private function animationStarted(e:Event = null):void
		{
			isAnimating = true;
			
			//animate everything out
			for (var i:int = 0 ; i < allOnScreenItems.length ; i++){
				var myTween:GTween = new GTween(allOnScreenItems[i], .25, {alpha:0}, {ease:Sine.easeIn});
				myTween.addEventListener(Event.COMPLETE, removeItem);
			}
			allOnScreenItems = new Array();
			screenDataItems = new Array();
		}
		
		private function removeItem(e:Event):void
		{
			removeChild(e.currentTarget.target as DisplayObject);
		}
			
		private function animationFinished(e:Event = null):void
		{
			isAnimating = false;
			
			var isCurrentStageUnlocked:Boolean = false;
			
			var frontMostItemY:int = -99999;
			var frontMostIndex:int = -99999;
			var numLevelsUnlockedFrontIndex:int = 0;
			
			for (var i:int = 0 ; i < _carousel._items.length ; i++){
				if( (_carousel._items[i] as TDCarouselItem).y > frontMostItemY){
					frontMostItemY = (_carousel._items[i] as TDCarouselItem).y;
					frontMostIndex = i;
				}
			}
			
			
			//set the icons for all except the front-most stage
			for (var i:int = 0 ; i < _carousel._items.length ; i++){
				var stageIndex:int = (_carousel._items[i] as TDCarouselItem).stageReferenceId;
				var visualIndex:int = (i-1)%_carousel._items.length
				if(i <= 0){
					visualIndex = _carousel._items.length + visualIndex;
				}
				
				var numLevelsUnlocked:int = 0;
				var numLevelsPlayed:int = 0;
				var numLevelsCompleted:int = 0;
				for ( var k:int = 0 ; k < numLevelsPerStage ; k++ ){
					var levelIndex:int = (stageIndex*numLevelsPerStage) + k;
					//trace("levelIndex:"+levelIndex);
					if( PlayerStats.isLevelUnlocked(levelIndex) == true){
						numLevelsUnlocked++;
					}
					if( PlayerStats.hasLevelBeenPlayed(levelIndex) == true){
						numLevelsPlayed++;
					}
					if( PlayerStats.hasLevelBeenCompleted(levelIndex) == true){
						numLevelsCompleted++;
					}
				}
				if( i == frontMostIndex){
					numLevelsUnlockedFrontIndex = numLevelsUnlocked;
				}
				
				if(numLevelsUnlocked > 0){
					if( i != frontMostIndex){
						//stage unlocked
						//is it safe or are there still conflicts?
						if(numLevelsCompleted == numLevelsPerStage){
							//safe
							var testGraphic:* = new Resources.UICompleteLevel();
							addChild(testGraphic);
							testGraphic.x = _carousel.x + (_carousel._items[i] as TDCarouselItem).x - 30;
							testGraphic.y = _carousel.y + (_carousel._items[i] as TDCarouselItem).y - 40;
							allOnScreenItems.push(testGraphic);
						} else {
							//conflict
							var testGraphic:* = new Resources.UIUnlockedLevel();
							addChild(testGraphic);
							testGraphic.x = _carousel.x + (_carousel._items[i] as TDCarouselItem).x - 30;
							testGraphic.y = _carousel.y + (_carousel._items[i] as TDCarouselItem).y - 40;
							allOnScreenItems.push(testGraphic);						
						}
					}
				} else {
					// level locked
					var testGraphic:* = new Resources.UILockedLevel();
					addChild(testGraphic);
					testGraphic.x = _carousel.x + (_carousel._items[i] as TDCarouselItem).x - 30;
					testGraphic.y = _carousel.y + (_carousel._items[i] as TDCarouselItem).y - 40;
					allOnScreenItems.push(testGraphic);
				}
			}			
			
			//add the level selectors
			if(numLevelsUnlockedFrontIndex > 0){
				for ( var k:int = 0 ; k < numLevelsPerStage ; k++ ){
					var stageIndex:int = (_carousel._items[frontMostIndex] as TDCarouselItem).stageReferenceId;					
					var levelPing:* = new Resources.UIPing();
					
					var testerButton:PushButton;
					var levelIndex:int = (stageIndex*numLevelsPerStage) + k ;
					if( PlayerStats.isLevelUnlocked(levelIndex) == false){
						var levelPingLocked:* = new Resources.UILevelLocked();
						testerButton = new PushButton(this,100,100,"",levelIndicatorClicked,duplicateDisplayObject(levelPingLocked),null);
					} else if( PlayerStats.hasLevelBeenCompleted(levelIndex) == true){
						var levelPingLocked:* = new Resources.UILevelDone()
						testerButton = new PushButton(this,100,100,"",levelIndicatorClicked,duplicateDisplayObject(levelPingLocked),null);
					} else {
						testerButton = new PushButton(this,100,100,"",levelIndicatorClicked,
							duplicateDisplayObject(levelPing),null);
					}
					
					testerButton.tag = levelIndex;
					testerButton.addEventListener(MouseEvent.MOUSE_OVER,levelIndicatorClicked);
					
/*					var mySprite:Sprite = new Sprite();
					var bData:BitmapData = new BitmapData(mySprite.width, mySprite.height, true);
					bData.draw(mySprite);
					var bmap:Bitmap = new Bitmap(bData);
*/					
					var levelLocation:Point = LevelData.LevelMapLocations[levelIndex];
					if(levelLocation != null){
						//testerButton.x = _carousel.x + levelLocation.x;
						//testerButton.y = _carousel.y + levelLocation.y;
						testerButton.x = _carousel.x - 180 + levelLocation.x;
						testerButton.y = _carousel.y + 75 + levelLocation.y;
						
						//setup mask
						var levelPingMask:Shape = new Shape();
						levelPingMask.graphics.beginFill(0);
						levelPingMask.graphics.drawRect(testerButton.x,testerButton.y,53,53);
						testerButton.width = 53;
						testerButton.height = 53;
						testerButton.mask = levelPingMask;
						
						allOnScreenItems.push(testerButton);
						screenDataItems.push(levelIndex);
					} else {
						removeChild(testerButton);
					}
				}
			}
				
			//tween in everything visible
			for (var i:int = 0 ; i < allOnScreenItems.length ; i++){
				allOnScreenItems[i].alpha = 0;
				var myTween:GTween = new GTween(allOnScreenItems[i], .5, {alpha:1}, {ease:Sine.easeIn});
			}	
			
		}
		
		private function levelIndicatorClicked(e:Event = null):void
		{
			SoundController.playSoundEffect("SfxSelectLevel");
			currentlySelectedLevelDialogue.setLevel( (e.currentTarget as Component).tag );
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
			
			var myTween:GTween = new GTween(transitionHolder, .45, {x:(-transitionOut.width)}, {ease:Linear.easeNone});
			myTween.addEventListener("complete",animatedOut,false,0,true);
		}
		
		private function animatedOut(e:Event = null):void
		{
			finishedCallback();
		}
		
	}
}