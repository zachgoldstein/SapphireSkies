package zachg.states
{
	import Playtomic.*;
	
	import com.GlobalVariables;
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.senocular.display.duplicateDisplayObject;
	
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
	import zachg.util.SoundController;
	import zachg.windows.GrowthItemDisplay;
	import zachg.windows.SaveLoadSlotDisplay;
	
	public class ControlsState extends FlxState
	{
				
		
		public var currentTutorialGraphics:Array = [
			new Resources.GameTutorialsBig1(),
			new Resources.GameTutorialsBig2(),
			new Resources.GameTutorialsBig3(),
			new Resources.GameTutorialsBig4(),
			new Resources.GameTutorialsBig5()
		];
			
		public var currentTutorialTip:int = 0;
		//public var tutorialText:Text;
		public var currentTutorialGraphic:*;
		
		
		public function ControlsState()
		{
			super();
			
		}
		
		override public function create():void
		{
			FlxG.mouse.hide();
			flash.ui.Mouse.show(); 
			
/*			currentTutorialTips = PlayerStats.currentPlayerDataVo.tutorialsShown;
			if(currentTutorialTips.length == 0){
				currentTutorialTips = [ "Play the game and the tips will show you the controls as you go" ];
			}*/
			
			Log.CustomMetric("ViewedTutorial");
			
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
			
			var tutorialMain:* = new Resources.UITutorialMain();
			addChild(tutorialMain);
			
			var muteOn:Bitmap = new Resources.UIMuteOn();
			var muteOff:Bitmap = new Resources.UIMuteOff();
			if(FlxG.mute == true){
				muteButton = new PushButton(this, FlxG.stage.stageWidth - 25, 5, "",SoundController.toggleSound,muteOn,null,muteOff,null);
			} else {
				muteButton = new PushButton(this, FlxG.stage.stageWidth - 25, 5, "",SoundController.toggleSound,muteOff,null,muteOn,null);
			}
			
			var smallButtonOn:* = new Resources.UIButtonOnSmall();
			var smallButtonOff:* = new Resources.UIButtonOffSmall();
			var backButton:PushButton = new PushButton(this, 5, 382, "Main Menu",goBack,
				smallButtonOff,new Point(-7,0), smallButtonOn,new Point(-7,0),
				"MenuFont", 20, 0xf7f7ed);
			backButton.width = 100;
			backButton.height = 12;
			
			var nextTutorialTip:PushButton = new PushButton(this, 5, 405, "Next Tutorial",showNextTutorialTip ,
				duplicateDisplayObject(smallButtonOff),new Point(-7,0), duplicateDisplayObject(smallButtonOn),new Point(-7,0),
				"MenuFont", 20, 0xf7f7ed);
			nextTutorialTip.width = 135;
			nextTutorialTip.height = 12;
			var prevTutorialTip:PushButton = new PushButton(this, 5, 428, "Prev Tutorial",showPrevTutorialTip,
				duplicateDisplayObject(smallButtonOff),new Point(-7,0), duplicateDisplayObject(smallButtonOn),new Point(-7,0),
				"MenuFont", 20, 0xf7f7ed);
			prevTutorialTip.width = 135;
			prevTutorialTip.height = 12;

			currentTutorialGraphic = currentTutorialGraphics[0];
			addChild(currentTutorialGraphic);
			currentTutorialGraphic.x = 93;
			currentTutorialGraphic.y = 198;
			
/*			tutorialText = new Text(this,110,220,"","MenuFont",20,0xffffcc,false);
			tutorialText.width = 350;
			tutorialText.height = 180;
			tutorialText.selectable = false;
			tutorialText.editable = false;
*/			
			transitionIn();
		}
		
		override public function update():void
		{
			super.update();
			
			//tutorialText.text = currentTutorialTips[currentTutorialTip%currentTutorialTips.length];
			
		}
		
		public function refresh():void
		{
			
		}
		
		public function showNextTutorialTip(e:Event):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			currentTutorialTip++;
			if(currentTutorialTip > (currentTutorialGraphics.length-1)){
				currentTutorialTip = currentTutorialTip%(currentTutorialGraphics.length-1);
			}
			
			removeChild(currentTutorialGraphic)
			currentTutorialGraphic = currentTutorialGraphics[currentTutorialTip];
			addChild(currentTutorialGraphic);
			currentTutorialGraphic.x = 93;
			currentTutorialGraphic.y = 198;

		}
		
		public function showPrevTutorialTip(e:Event):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			if( currentTutorialTip <= 0 ){
				currentTutorialTip += currentTutorialGraphics.length-1;
			}
			currentTutorialTip--;

			removeChild(currentTutorialGraphic)
			currentTutorialGraphic = currentTutorialGraphics[currentTutorialTip];
			addChild(currentTutorialGraphic);
			currentTutorialGraphic.x = 93;
			currentTutorialGraphic.y = 198;

		}

		private function goBack(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(goBackTransitionFinished);
		}
		private function goBackTransitionFinished():void
		{
			FlxG.state = new MainMenuState();
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