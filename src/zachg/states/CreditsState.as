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
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
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
	
	public class CreditsState extends FlxState
	{
		public var smallButtonOn:*
		public var smallButtonOff:*		
		
		public function CreditsState()
		{
			super();
			
		}

		override public function create():void
		{
			
			FlxG.mouse.hide();
			flash.ui.Mouse.show();
			
			Log.CustomMetric("ViewedCredits");
			
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
			
			var creditsMain:* = new Resources.UICreditsMain();
			addChild(creditsMain);		
			
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
			smallButtonOn = new Resources.UIButtonOnSmall();
			smallButtonOff = new Resources.UIButtonOffSmall();
			var backButton:PushButton = new PushButton(this, -7, FlxG.stage.stageHeight - 46, "Back",goBack,
				smallButtonOff,new Point(18,-17), smallButtonOn,new Point(18,-17),
				"MenuFont", 30, 0xf7f7ed);
			backButton.width = 100;
			backButton.height = 12;			
			
			var zachLabelButton:PushButton = new PushButton(this,0,60 + 65*0,"Development: Zach Goldstein", gotoZach,
				null,null,null,null,
				"MenuFont",30,0x000000);
			zachLabelButton._label.height = 30;
			zachLabelButton.width = FlxG.stage.stageWidth;
			zachLabelButton._label.autoSize = false;
			zachLabelButton._label.width = FlxG.stage.stageWidth;
			var textFrmt:TextFormat = zachLabelButton._label.textField.getTextFormat();
			textFrmt.align = TextFormatAlign.CENTER;
			zachLabelButton._label.textField.defaultTextFormat = textFrmt;
			zachLabelButton.addEventListener(MouseEvent.MOUSE_OVER,playOverSound,false,0,true);

			var labelButton:PushButton = new PushButton(this,0,60 + 65*1,"Music: Shannon Mason", gotoShannon,
				null,null,null,null,
				"MenuFont",30,0x000000);
			labelButton._label.height = 30;
			labelButton.width = FlxG.stage.stageWidth;
			labelButton._label.autoSize = false;
			labelButton._label.width = FlxG.stage.stageWidth;
			var textFrmt:TextFormat = labelButton._label.textField.getTextFormat();
			textFrmt.align = TextFormatAlign.CENTER;
			labelButton._label.textField.defaultTextFormat = textFrmt;
			labelButton.addEventListener(MouseEvent.MOUSE_OVER,playOverSound,false,0,true);
			
			var labelButton:PushButton = new PushButton(this,0,60 + 65*2,"Game Sprites: Martin Reimann", gotoMartin,
				null,null,null,null,
				"MenuFont",30,0x000000);
			labelButton._label.height = 30;
			labelButton.width = FlxG.stage.stageWidth;
			labelButton._label.autoSize = false;
			labelButton._label.width = FlxG.stage.stageWidth;
			var textFrmt:TextFormat = labelButton._label.textField.getTextFormat();
			textFrmt.align = TextFormatAlign.CENTER;
			labelButton._label.textField.defaultTextFormat = textFrmt;
			labelButton.addEventListener(MouseEvent.MOUSE_OVER,playOverSound,false,0,true);
			
			var labelButton:PushButton = new PushButton(this,0,60 + 65*3,"Game UI Art: Stephen Cousins", gotoSteve,
				null,null,null,null,
				"MenuFont",30,0x000000);
			labelButton._label.height = 30;
			labelButton.width = FlxG.stage.stageWidth;
			labelButton._label.autoSize = false;
			labelButton._label.width = FlxG.stage.stageWidth;
			var textFrmt:TextFormat = labelButton._label.textField.getTextFormat();
			textFrmt.align = TextFormatAlign.CENTER;
			labelButton._label.textField.defaultTextFormat = textFrmt;	
			labelButton.addEventListener(MouseEvent.MOUSE_OVER,playOverSound,false,0,true);
			
			var labelButton:PushButton = new PushButton(this,0,60 + 65*4,"Game Levels Art: EworkProxy", gotoYue,
				null,null,null,null,
				"MenuFont",30,0x000000);
			labelButton._label.height = 30;
			labelButton.width = FlxG.stage.stageWidth;
			labelButton._label.autoSize = false;
			labelButton._label.width = FlxG.stage.stageWidth;
			var textFrmt:TextFormat = labelButton._label.textField.getTextFormat();
			textFrmt.align = TextFormatAlign.CENTER;
			labelButton._label.textField.defaultTextFormat = textFrmt;	
			labelButton.addEventListener(MouseEvent.MOUSE_OVER,playOverSound,false,0,true);
			
			var labelButton:PushButton = new PushButton(this,0,60 + 65*5,"Game Background Art: Dimitri Popov", gotoDimitri,
				null,null,null,null,
				"MenuFont",30,0x000000);
			labelButton._label.height = 30;
			labelButton.width = FlxG.stage.stageWidth;
			labelButton._label.autoSize = false;
			labelButton._label.width = FlxG.stage.stageWidth;
			var textFrmt:TextFormat = labelButton._label.textField.getTextFormat();
			textFrmt.align = TextFormatAlign.CENTER;
			labelButton._label.textField.defaultTextFormat = textFrmt;
			labelButton.addEventListener(MouseEvent.MOUSE_OVER,playOverSound,false,0,true);
			
			transitionIn();
		}
		
		public function refresh():void
		{
			
		}
		
		private function playOverSound(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxPurchaseShip");
		}
		
		private function goBack(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(actuallyGoBack)
		}		
		private function actuallyGoBack():void
		{
			FlxG.state = new MainMenuState();
		}
		
		
		private function gotoShannon(e:MouseEvent):void
		{
			gotoUrl("http://www.shannonaudio.com/");
		}

		private function gotoZach(e:MouseEvent):void
		{
			gotoUrl("http://reindeerflotilla.net/");
		}

		private function gotoSteve(e:MouseEvent):void
		{
			gotoUrl("http://www.visit-dengistan.com/stevesite/home.html");
		}

		private function gotoMartin(e:MouseEvent):void
		{
			gotoUrl("http://aetherpunk.daportfolio.com/");
		}

		private function gotoYue(e:MouseEvent):void
		{
			gotoUrl("http://www.eworkproxy.com/");
		}
		
		private function gotoDimitri(e:MouseEvent):void
		{
			gotoUrl("http://jimhatama.deviantart.com/gallery/");
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