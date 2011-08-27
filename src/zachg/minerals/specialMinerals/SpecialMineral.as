package zachg.minerals.specialMinerals
{
	import flash.geom.Point;
	
	import org.flixel.FlxTilemap;
	
	import zachg.Mineral;
	
	public class SpecialMineral extends Mineral
	{
		
		//NOTE THAT THIS IS THE TILE LOCATION, NOT ACTUAL X AND Y
		public var location:Point = new Point(-100,-100);
		public var isMined:Boolean = false;
		
		public function SpecialMineral()
		{
			super();
		}
		
		public function minedAction(flxTileMap:FlxTilemap=null):void
		{
			
		}
	}
}