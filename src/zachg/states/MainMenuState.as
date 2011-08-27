package zachg.states
{
	import Playtomic.*;
	
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.easing.Sine;
	import com.senocular.display.duplicateDisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	import zachg.MainMenu;
	import zachg.PlayerStats;
	import zachg.util.CustomConsole;
	import zachg.util.GameMessageController;
	import zachg.util.SoundController;
	
	public class MainMenuState extends FlxState
	{
		public function MainMenuState()
		{
			super();
		}
		
		public var startGameClicked:Function;
		private var background:Sprite;
		
		public var creditsText:Text;
		public var creditsButton:PushButton;
				
		override public function create():void
		{
			
			FlxG.mouse.hide();
			flash.ui.Mouse.show();
			PlayerStats.initializeStats();
			
			Log.CustomMetric("GameVersionInPlay"+GlobalVariables.versionNumber);
			
			FlxG._game._console = new CustomConsole(0,0,1);
			FlxG._game.addChild(FlxG._game._console);
			
			SoundController.initialize();
			
			if(SoundController.isMenuMusicPlaying != true){
				SoundController.playSong(MusicMainMenu);
				SoundController.isMenuMusicPlaying = true;
			}
			
			graphics.beginFill(0x0000FF,1);
			graphics.drawRect(0,0,FlxG.stage.stageWidth,FlxG.stage.stageHeight);
			
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
			
			
			addChild(new Resources.UIMainMenu() );			

			var logo:* = new Resources.UILogo();
			logo.x = 450;
			logo.y = 375;
			addChild(logo);
			
			var gameLogo:* = new Resources.UISapphireSkiesLogoSmall();
			gameLogo.x = Math.round(FlxG.stage.stageWidth/2 - gameLogo.width/2); 
			gameLogo.y = 5;
			addChild(gameLogo);
			
			var buttonOn:Bitmap = new Resources.UIButtonOffLarge();
			var buttonRollOver:Bitmap = new Resources.UIButtonOnLarge();
			
			var start:PushButton = new PushButton(this, 187,227, "Play",startClick,
				duplicateDisplayObject(buttonOn),null,duplicateDisplayObject(buttonRollOver),null,"MenuFont", 30, 0xf7f7ed);
			start.width = 120;
			start.height = 12;
			
			var controls:PushButton = new PushButton(this, 208, 270, "Tutorial",showControls,
				duplicateDisplayObject(buttonOn),null,duplicateDisplayObject(buttonRollOver),null,"MenuFont", 30, 0xf7f7ed);
			controls.width = 175;
			controls.height = 12;
			
			var options:PushButton = new PushButton(this, 231, 312, "Options",showOptions,
				duplicateDisplayObject(buttonOn),null,duplicateDisplayObject(buttonRollOver),null,"MenuFont", 30, 0xf7f7ed);
			options.width = 175;
			options.height = 12;

			creditsButton = new PushButton(this, 251, 353, "Credits",showCredits,
				duplicateDisplayObject(buttonOn),null,duplicateDisplayObject(buttonRollOver),null,"MenuFont", 30, 0xf7f7ed);
			creditsButton.width = 175;
			creditsButton.height = 12;
			
			//optionsSprite.x = FlxG.stage.stageWidth - optionsSprite.width; //Resources.buttonImageTest
			//var resetSaves:PushButton = new PushButton(this, FlxG.stage.stageWidth- 300, 400, "DEBUG: Reset Saves",resetSaves);
			
			//creditsButton = new PushButton(this, FlxG.stage.stageWidth - 300, 325, "Show Credits",showCredits);
			
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
			
/*			background = new Sprite();
			background.graphics.beginFill(0x000000,1);
			background.graphics.drawRect(0,0,130,15);
			background.y = FlxG.stage.stageHeight - 15;
			background.alpha = .75
			addChild(background);
*/			
			//var nameLabel:Label = new Label(this,5,FlxG.stage.stageHeight - 15,"V"+GlobalVariables.versionNumber+", Reindeer Flotilla 2010");
			//nameLabel.textField.textColor = 0xFFFFFF;
			
			transitionIn();
			
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
		
		public function startClick(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			selectLevel();
		}
		
		public function resetSaves(e:MouseEvent):void
		{
			PlayerStats.flxSave._so.clear();
		}
		
		public function showCredits(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(goToCredits);
		}
		private function goToCredits():void
		{
			FlxG.state = new CreditsState();
		}				
		
		private function showControls(e:MouseEvent = null):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(goToControls);
		}
		private function goToControls():void
		{
			FlxG.state = new ControlsState();
		}		
		
		private function showOptions(e:MouseEvent = null):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(goToOptions);
		}		
		private function goToOptions():void
		{
			FlxG.state = new OptionsState(this);
		}
		
		private function selectLevel():void
		{
			Log.Play();
			transitionOut(playGameClicked);
			GlobalVariables.gameStarted = true;
			//GlobalVariables.introShown = true;
						
		}
		
		private function playGameClicked():void
		{
			if (PlayerStats.currentPlayerDataVo.currentPlayerName == ""){
				PlayerStats.currentLevelId = 0;
				PlayerStats.currentLevelDataVo = PlayerStats.currentPlayerDataVo.levelData[0];
				PlayerStats.currentLevelDataVo.levelId = 0;
				FlxG.state = new PlayState(null);
			} else {
				FlxG.state = new LevelSelectionState();
				
				//testing
				//FlxG.state = new PlayState(null);
			}
		}
		
		private function transitionIn():void
		{
			//SoundController.playSoundEffect("SfxScreenTransition");
			
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