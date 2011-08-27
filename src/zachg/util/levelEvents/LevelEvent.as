package zachg.util.levelEvents
{
	import flash.events.MouseEvent;

	public class LevelEvent
	{
		public var startedPlaying:Boolean = false;
		public var finishedPlaying:Boolean = false;
		
		public function LevelEvent()
		{
		}
		
		public function testForTrigger():Boolean{ return false}
		
		public function start():void {}
		public function end(e:MouseEvent = null):void {}
		
		public function showText(e:MouseEvent = null):void {}
			
	}
}