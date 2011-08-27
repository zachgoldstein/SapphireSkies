package zachg.ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import zachg.util.levelEvents.CarouselEvent;

	public class CarouselLevelItem extends Sprite
	{
		public var data:*;
		
		public function CarouselLevelItem()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN,dispatchLevelClick);
		}
		
		public function dispatchLevelClick(e:MouseEvent = null):void
		{
			var eventToDispatch:CarouselEvent = new CarouselEvent(CarouselEvent.clickEvent);
			eventToDispatch.data = data;
			dispatchEvent( eventToDispatch );
		}
	}
}