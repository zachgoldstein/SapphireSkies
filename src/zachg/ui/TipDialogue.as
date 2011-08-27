package zachg.ui
{
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.senocular.display.duplicateDisplayObject;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import org.flixel.FlxG;
	
	import zachg.PlayerStats;
	
	public class TipDialogue extends Sprite
	{
		
		public var lifeSpan:Number;
		public var lifeCounter:Timer;
		public var callback:Function;
		public var screenPosition:Point;
		public var _image:Class
		
		public function TipDialogue(delay:Number, message:String, image:String, position:Point, finishedCallback:Function)
		{
			super();
			
			(PlayerStats.currentPlayerDataVo.tutorialsShown as Array).push(message);
			PlayerStats.saveCurrentPlayerData();
			
			callback = finishedCallback;
			lifeSpan = delay;
			screenPosition = position
			_image = Resources[image];

			graphics.beginFill(0,.5);
			graphics.drawRect(2,2,246,246);
			
			var hintIcon:* = new Resources.UITutorialIcon();
			addChild(hintIcon);
			hintIcon.x = 5;
			hintIcon.y = 5;
			message = "     "+message;
			
			if(_image != null){
				var tipImage:* = new _image();
				addChild(tipImage);
				tipImage.y = 125; 
				tipImage.x = 0;
			}
			
			var tipBackground = new Resources.UITutorialTipBackground();
			addChild(tipBackground);
				
			var smallButtonOn:* = new Resources.UISmallLongButtonBackgroundOff();
			var smallButtonRoll:* = new Resources.UISmallLongButtonBackgroundRoll();			
			
			var continueButton:PushButton = new PushButton(this,(250)/2 - 100/2,230,"Next Tip",endTip,
				duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
				"MenuFont",15,0xffffcc);
			continueButton.width = 100;
			continueButton.height = 11;	
			
			var messageText:Text = new Text(this,10,10,message,"MenuFont",20,0xFFFFFF,false);
			messageText.selectable = false;
			messageText.editable = false;
			messageText.width = 230;
			messageText.height = 110;
			var textFrmt:TextFormat = messageText.textField.getTextFormat();
			textFrmt.align = TextFormatAlign.CENTER;
			messageText.textField.defaultTextFormat = textFrmt;
			
		}
		
		public function showTip(e:Event = null):void
		{
			x = Math.round( screenPosition.x);
			y = Math.round( screenPosition.y);
			(FlxG.state).addChild(this);
			
			if(lifeSpan != -1){
				lifeCounter = new Timer(lifeSpan,1);
				lifeCounter.addEventListener(TimerEvent.TIMER_COMPLETE, endTip, false,0,true);
				lifeCounter.start();
			}
			
		}
		
		public function endTip(e:Event = null):void
		{
			if(lifeSpan != -1){
				lifeCounter.removeEventListener(TimerEvent.TIMER_COMPLETE, endTip);
			}
			(FlxG.state).removeChild(this);
			callback();
		}
	}
}