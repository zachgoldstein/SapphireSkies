package zachg.util
{
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Label;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import neoart.flectrum.*;
	import neoart.flod.*;
	
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	import zachg.gameObjects.CallbackSprite;
	import zachg.ui.SimpleTextDisplay;

	public class EffectController
	{
		public function EffectController()
		{
			
		}
		
		public static function displayMessageAtPoint(
			X:Number,
			Y:Number,
			message:String,
			backgroundColor:uint = uint.MAX_VALUE,
			textColor:uint = uint.MAX_VALUE,
			showLength:Number=20,
			isInGame:Boolean = true
		):void
		{
			
			if(isInGame == true){
				var genericDisplay:GenericDisplay = new GenericDisplay(removeMessage);
				
				//TODO: this line is repeated because one call will render a white box the first time it's called. FIX THIS
				if(backgroundColor != uint.MAX_VALUE){
					if(textColor != uint.MAX_VALUE){
						genericDisplay.displayMessageAtPoint(X,Y,message,backgroundColor,textColor);
						genericDisplay.displayMessageAtPoint(X,Y,message,backgroundColor,textColor);
					} else {
						genericDisplay.displayMessageAtPoint(X,Y,message,backgroundColor);
						genericDisplay.displayMessageAtPoint(X,Y,message,backgroundColor);					
					}
				} else {
					if(textColor != uint.MAX_VALUE){
						genericDisplay.displayMessageAtPoint(X,Y,message,uint.MAX_VALUE,textColor);
						genericDisplay.displayMessageAtPoint(X,Y,message,uint.MAX_VALUE,textColor);
					} else {
						genericDisplay.displayMessageAtPoint(X,Y,message);
						genericDisplay.displayMessageAtPoint(X,Y,message);					
					}
				}
				if(showLength != 20){
					genericDisplay.messageDuration = showLength; 
				}
				(FlxG.state as PlayState).effectDisplays.add(genericDisplay);
			} else {
				var genericDisplay2:SimpleTextDisplay = new SimpleTextDisplay();
				genericDisplay2.displayMessageAtPoint(X,Y,message,uint.MAX_VALUE,textColor);
			}
		}
		
		public static function showEffectAnimation(resourceName:String,numFrames:Number,size:Point,position:Point,offset:Point):void
		{
			var effectanimation:FlxSprite = new FlxSprite();
			effectanimation.loadGraphic(Resources[resourceName],true,false,size.x,size.y);
			effectanimation.x = position.x - offset.x;
			effectanimation.y = position.y - offset.y;
			var frameArray:Array = new Array();
			for(var i:int = 0 ; i < numFrames-1 ; i++ ){
				frameArray.push(i);
			}			
			effectanimation.addAnimation("explosion",frameArray, 15,false);
			effectanimation.addAnimationCallback(killAnimation);
			effectanimation.play("explosion");
			(FlxG.state as PlayState).effectDisplays.add(effectanimation);
		}

		public static function killAnimation(animationName:String,frameNumber:uint,frameIndex:uint, flxSprite:FlxSprite):void
		{
			if(flxSprite.finished == true){
				flxSprite.destroy();
				(FlxG.state as PlayState).effectDisplays.remove(flxSprite);
			}
		}
		
		public static function explodeAtPoint(flxObject:FlxObject, spriteName:String = "Gibs", spritesInTile:Number = 9, quantity:Number = 20, distanceMultiplier:Number = 1):void
		{
			var deathEmitter:FlxEmitter = new FlxEmitter();
			(FlxG.state as PlayState).effectDisplays.add(deathEmitter);
			deathEmitter.delay = 3;
			deathEmitter.setXSpeed(-150*distanceMultiplier,150*distanceMultiplier);
			deathEmitter.setYSpeed(-200*distanceMultiplier,0);
			deathEmitter.setRotation(-720,-720);
			//deathEmitter.setSize(6,6);
			deathEmitter.createSprites(Resources[spriteName],spritesInTile,10,true,0);
			deathEmitter.at(flxObject);
			deathEmitter.start(true,0,quantity);
		}
		
		public static function removeMessage(genericDisplay:GenericDisplay):void
		{
			(FlxG.state as PlayState).effectDisplays.remove(genericDisplay);
		}
		
		//TODO: something feels so wrong about doing noise this way. It's probably pretty inefficient. Investigate.
		
		public static var noise:Noise;
		public static var noiseDuration:Number = 0;
		public static var noisePlayCounter:Number = 0;		
		public static var noiseWrapper:MovieClip = new MovieClip();
		
		public static function showNoise(duration:Number = 0):void
		{
			if( noiseDuration != 0 ){
				return
			}
			if(noiseDuration == 0){
				noiseDuration = duration;
				noise = new Noise({width:550, height:500, targetObj:noiseWrapper});
				noise.LEVELX = 400;
				noise.LEVELY = 2;
				noise.CURVEX = 10;
			}
			noise.name = "noise";
			FlxG.state.addChild(noise);
			drawNoise();
			noise.init();
			noise.START();
		}
		
		public static function stopNoise():void
		{
			noiseDuration = 0;
			if(noiseWrapper.numChildren > 0){
				noiseWrapper.removeChildAt(0);
			}			
			if( FlxG.state.getChildByName("noise") != null){
				FlxG.state.removeChild(noise);
				noise.PAUSE();
			}
		}
		
		public static function update():void
		{
			//noise counter
			
			if(noiseDuration != 0 && noiseDuration < noisePlayCounter){
				stopNoise();
				noisePlayCounter = 0;
			} else if(noiseDuration != 0 && noiseDuration >= noisePlayCounter){
				drawNoise();
				noisePlayCounter++
			}
		}
		
		public static function drawNoise():void{
			if(noiseWrapper.numChildren > 0){
				noiseWrapper.removeChildAt(0);
			}
			noiseWrapper.addChild(new Bitmap(FlxG.buffer.clone(),"auto",true));
		}
		
		
		
	}
}