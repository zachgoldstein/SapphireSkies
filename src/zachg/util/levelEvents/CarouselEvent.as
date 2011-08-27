package zachg.util.levelEvents
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	public class CarouselEvent extends MouseEvent
	{
		public static var clickEvent:String = "CarouselEvent";		
		public var data:* = null;
		
		public function CarouselEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false, localX:Number=-1, localY:Number=-1, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
		}
	}
}