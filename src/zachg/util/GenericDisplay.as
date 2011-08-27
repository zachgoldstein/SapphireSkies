package zachg.util
{
	
	import com.bit101.components.Label;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.easing.Sine;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import zachg.gameObjects.CallbackSprite;

	public class GenericDisplay extends CallbackSprite
	{
		
		public var graphicHolder:CallbackSprite;
		public var spriteCanvas:Sprite;	
		public var title:Label;
		
		public var messageCounter:Number = 0;
		public var messageDuration:Number = 20;		
		
		public var destroyCallback:Function;
		
		public function GenericDisplay(DestroyCallback:Function = null)
		{
			super();
			//createGraphic(10,10);
			destroyCallback = DestroyCallback;
			visible = true;
			solid = false;
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
			
			if(onScreen() == true){
				createGraphic(spriteCanvas.width, spriteCanvas.height);
				var bitmapData:BitmapData = new BitmapData(spriteCanvas.width, spriteCanvas.height, true, 0x00FFFFFF);
				var mat:Matrix = new Matrix();
				bitmapData.draw(spriteCanvas);
				pixels.copyPixels(bitmapData,new Rectangle(0,0,spriteCanvas.width, spriteCanvas.height),new Point());
			} else {
				visible = false;
			}
			alpha = 1;
			var myTween:GTween = new GTween(this, .35, {x:(x+10),alpha:0}, {ease:Sine.easeOut});
			update();
			
		}
		
		override public function update():void
		{
 			super.update();
			if(messageDuration != -1){
				if( messageCounter > messageDuration){
					if(destroyCallback != null){
						destroyCallback(this);
					}
					destroy();
				}
			}
			messageCounter++;
		}
	}
}