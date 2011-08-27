package zachg.states
{
	import Playtomic.*;
	
	import com.GlobalVariables;
	import com.Resources;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.senocular.display.duplicateDisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
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
	
	public class OptionsState extends FlxState
	{
		
		public var title:Label;
		
		public var _previousState:FlxState;
		
		public var lowQualityButton:PushButton;
		public var mediumQualityButton:PushButton;
		public var highQualityButton:PushButton;
		
		public var sfxVolumeSlider:HSlider;
		public var musicVolumeSlider:HSlider;
		
		public var smallButtonOn:*
		public var smallButtonOff:*
			
		public function OptionsState( previousScreen:FlxState)
		{
			super();
			_previousState = previousScreen;
		}
		
		override public function create():void
		{
			FlxG.mouse.hide();
			flash.ui.Mouse.show();
			
			Log.CustomMetric("ViewedOptions");
			
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
			
			var optionsMain:* = new Resources.UIOptions();
			addChild(optionsMain);

			smallButtonOn = new Resources.UIButtonOnSmall();
			smallButtonOff = new Resources.UIButtonOffSmall();
			var backButton:PushButton = new PushButton(this, -7, FlxG.stage.stageHeight - 46, "Back",goBack,
				smallButtonOff,new Point(18,-17), smallButtonOn,new Point(18,-17),
				"MenuFont", 30, 0xf7f7ed);
			backButton.width = 100;
			backButton.height = 12;
			
			lowQualityButton = new PushButton(this, 175, 270, "Low",setLowQuality ,
				duplicateDisplayObject(smallButtonOff),new Point(10,10), duplicateDisplayObject(smallButtonOn),new Point(10,10),
				"MenuFont", 25, 0xf7f7ed);
			mediumQualityButton = new PushButton(this, 243, 270, "Medium",setMediumQuality,
				duplicateDisplayObject(smallButtonOff),new Point(0,10), duplicateDisplayObject(smallButtonOn),new Point(0,10),
				"MenuFont", 25, 0xf7f7ed);
			highQualityButton = new PushButton(this, 319, 270, "High",setHighQuality,
				duplicateDisplayObject(smallButtonOff),new Point(10,10), duplicateDisplayObject(smallButtonOn),new Point(10,10),
				"MenuFont", 25, 0xf7f7ed);
			
			setCurrentQualityButtons();
			
			var volumeSliderBackground:* = new Resources.UISliderBase();
			var volumeSliderBar:* = new Resources.UISliderBar();
			sfxVolumeSlider = new HSlider(this,249,352,
				duplicateDisplayObject(volumeSliderBackground),null,duplicateDisplayObject(volumeSliderBar),
				new Point(0,3), sfxVolumeChanged);
			sfxVolumeSlider.width = 144;
			sfxVolumeSlider.minimum = 0;
			sfxVolumeSlider.maximum = 1;
			sfxVolumeSlider.value = SoundController.soundEffectVolume;

			musicVolumeSlider = new HSlider(this,249,380,
				duplicateDisplayObject(volumeSliderBackground),null,duplicateDisplayObject(volumeSliderBar),
				new Point(0,3), musicVolumeChanged);
			musicVolumeSlider.width = 144;
			musicVolumeSlider.minimum = 0;
			musicVolumeSlider.maximum = 1;
			musicVolumeSlider.value = SoundController.musicVolume;
			
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
			
			transitionIn();
		}
		
		override public function update():void
		{
			super.update();
			sfxVolChangedCounter++;
		}
		
		public function refresh():void
		{
			
		}
		
		private function musicVolumeChanged(e:Event):void
		{
			SoundController.setMusicVolume(musicVolumeSlider.value);
		}

		
		private var sfxVolChangedCounter:Number = 6;
		private var sfxVolChangedDelay:Number = 5;
		private function sfxVolumeChanged(e:Event):void
		{
			SoundController.setSfxVolume(sfxVolumeSlider.value);
			if(sfxVolChangedCounter > sfxVolChangedDelay){
				sfxVolChangedCounter = 0;
				SoundController.playSoundEffect("SfxPurchaseShip");
			}
		}
		
		
		private function setLowQuality(e:Event):void
		{
			FlxG.stage.quality = StageQuality.LOW;  
			setCurrentQualityButtons();
		}
		private function setMediumQuality(e:Event):void
		{
			FlxG.stage.quality = StageQuality.MEDIUM;
			setCurrentQualityButtons();
		}
		private function setHighQuality(e:Event):void
		{
			FlxG.stage.quality = StageQuality.HIGH;
			setCurrentQualityButtons();
		}
		
		private function setCurrentQualityButtons():void
		{
			removeChild(lowQualityButton);
			removeChild(mediumQualityButton);
			removeChild(highQualityButton);
			
			if(FlxG.stage.quality == "LOW"){
				lowQualityButton = new PushButton(this, 175, 270, "Low",setLowQuality ,
					duplicateDisplayObject(smallButtonOn),new Point(10,10), duplicateDisplayObject(smallButtonOn),new Point(10,10),
					"MenuFont", 25, 0xf7f7ed);
				mediumQualityButton = new PushButton(this, 243, 270, "Medium",setMediumQuality,
					duplicateDisplayObject(smallButtonOff),new Point(0,10), duplicateDisplayObject(smallButtonOn),new Point(0,10),
					"MenuFont", 25, 0xf7f7ed);
				highQualityButton = new PushButton(this, 319, 270, "High",setHighQuality,
					duplicateDisplayObject(smallButtonOff),new Point(10,10), duplicateDisplayObject(smallButtonOn),new Point(10,10),
					"MenuFont", 25, 0xf7f7ed);				
			} else if(FlxG.stage.quality == "MEDIUM"){
				lowQualityButton = new PushButton(this, 175, 270, "Low",setLowQuality ,
					duplicateDisplayObject(smallButtonOff),new Point(10,10), duplicateDisplayObject(smallButtonOn),new Point(10,10),
					"MenuFont", 25, 0xf7f7ed);				
				mediumQualityButton = new PushButton(this, 243, 270, "Medium",setMediumQuality,
					duplicateDisplayObject(smallButtonOn),new Point(0,10), duplicateDisplayObject(smallButtonOn),new Point(0,10),
					"MenuFont", 25, 0xf7f7ed);				
				highQualityButton = new PushButton(this, 319, 270, "High",setHighQuality,
					duplicateDisplayObject(smallButtonOff),new Point(10,10), duplicateDisplayObject(smallButtonOn),new Point(10,10),
					"MenuFont", 25, 0xf7f7ed);				
			} else if(FlxG.stage.quality == "HIGH"){
				lowQualityButton = new PushButton(this, 175, 270, "Low",setLowQuality ,
					duplicateDisplayObject(smallButtonOff),new Point(10,10), duplicateDisplayObject(smallButtonOn),new Point(10,10),
					"MenuFont", 25, 0xf7f7ed);
				mediumQualityButton = new PushButton(this, 243, 270, "Medium",setMediumQuality,
					duplicateDisplayObject(smallButtonOff),new Point(0,10), duplicateDisplayObject(smallButtonOn),new Point(0,10),
					"MenuFont", 25, 0xf7f7ed);
				highQualityButton = new PushButton(this, 319, 270, "High",setHighQuality,
					duplicateDisplayObject(smallButtonOn),new Point(10,10), duplicateDisplayObject(smallButtonOn),new Point(10,10),
					"MenuFont", 25, 0xf7f7ed);				
			}
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
			FlxG.state = _previousState;
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