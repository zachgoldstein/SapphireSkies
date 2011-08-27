package zachg.ui.dialogues
{
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.senocular.display.duplicateDisplayObject;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.flixel.FlxG;
	
	public class InteruptDialogue extends Sprite
	{
		public var _finishedCallback:Function;
		public var _cancelCallback:Function;
		public var screenPosition:Point;
		
		public function InteruptDialogue(
			finishedCallback:Function,
			point:Point,
			message:String = "",
			buttonText:String = "",
			extraButtonText:String = "",
			cancelCallback:Function = null
		)
		{
			super();
			
			_finishedCallback = finishedCallback;
			_cancelCallback = cancelCallback;
			screenPosition = point;
			
			graphics.beginFill(0,.5);
			graphics.drawRect(2,2,246,146);
			
			var tipBackground = new Resources.UIInteruptMessageOutline();
			addChild(tipBackground);
			
			var smallButtonOn:* = new Resources.UISmallLongButtonBackgroundOff();
			var smallButtonRoll:* = new Resources.UISmallLongButtonBackgroundRoll();			
			
			var continueButton:PushButton = new PushButton(this,(250)/2 - 100/2,120,buttonText,endInterupt,
				duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
				"MenuFont",15,0xffffcc);
			continueButton.width = 100;
			continueButton.height = 11;
			
			if (extraButtonText != ""){
				continueButton.x  = (250/2-100/2) + 60;
				
				var cancelButton:PushButton = new PushButton(this,(250)/2 - 100/2 - 60,120,extraButtonText,cancelInterupt,
					duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
					"MenuFont",15,0xffffcc);
				cancelButton.width = 100;
				cancelButton.height = 11;
			}
			
			var messageText:Text = new Text(this,10,10,message,"MenuFont",25,0xFFFFFF,false);
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
		}
		
		public function endInterupt(e:Event = null):void
		{
			(FlxG.state).removeChild(this);
			(FlxG.state as PlayState).gameInterface.interuptDialogue = null;
			_finishedCallback();
		}

		public function cancelInterupt(e:Event = null):void
		{
			(FlxG.state).removeChild(this);
			if(_cancelCallback != null){
				_cancelCallback();
			}
		}		
		
	}
}