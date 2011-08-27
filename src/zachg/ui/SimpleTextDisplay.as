package zachg.ui
{
	
	import com.PlayState;
	import com.bit101.components.Label;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.easing.Sine;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flixel.FlxG;
	
	import zachg.gameObjects.CallbackSprite;

	public class SimpleTextDisplay extends Sprite
	{
		
		public var graphicHolder:CallbackSprite;
		public var spriteCanvas:Sprite;	
		public var title:Label;
		
		public var messageCounter:Number = 0;
		public var messageDuration:Number = .5;		
		
		public var destroyCallback:Function;
		
		public function SimpleTextDisplay(DestroyCallback:Function = null)
		{
			super();
			//createGraphic(10,10);
			destroyCallback = DestroyCallback;
			visible = true;
		}
		
		public function displayMessageAtPoint(X:Number,Y:Number,message:String,backgroundColor:uint = uint.MAX_VALUE, textColor:uint = uint.MAX_VALUE):void
		{
			x = X;
			y = Y;
			
			spriteCanvas = new Sprite();
			title = new Label(spriteCanvas,0,0,message,"system",8);
			if(textColor == uint.MAX_VALUE){
				title.textField.textColor = 0xFFFFFF;
			} else{
				title.textField.textColor = textColor;
			}
			title.draw();
			if(backgroundColor != uint.MAX_VALUE){
				spriteCanvas.graphics.beginFill(backgroundColor,.5);				
			} else {
				spriteCanvas.graphics.beginFill(0,.5);
			}
			spriteCanvas.graphics.drawRect(0,0,spriteCanvas.width,spriteCanvas.height);
			addChild(spriteCanvas);
			alpha = 1;
			var myTween:GTween = new GTween(this, messageDuration, {x:(x+7),alpha:0}, {ease:Sine.easeOut});
			myTween.addEventListener("complete",timerFinished,false,0,true);
			FlxG.state.addChild(this);
		}
		
		public function timerFinished(e:Event = null):void
		{
			if(destroyCallback != null){
				destroyCallback();
			}
			if(FlxG.state is PlayState){
				FlxG.state.removeChild(this);
			}
		}

	}
}