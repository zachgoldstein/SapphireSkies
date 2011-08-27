package zachg.minerals.specialMinerals
{
	import com.PlayState;
	
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	
	import zachg.util.EffectController;

	public class Mine extends SpecialMineral
	{
		
		public var explosionRange:Number = 10;
		
		public function Mine(Location:Point,ExplosionRange:Number = 10)
		{
			super();
			fullName = "Mine";
			location = Location;
			resourceValue = 0;
			explosionRange = ExplosionRange;
		}
		
		override public function minedAction(flxTileMap:FlxTilemap=null):void
		{
			EffectController.displayMessageAtPoint( (FlxG.state as PlayState).player.MainHullSprite.x,
													(FlxG.state as PlayState).player.MainHullSprite.y-15,
													"Detonated Mine!",
													0xEEEE00,
													0x000000,
													50);
			if(flxTileMap!=null){
				for (var i:int = 0 ; i < (FlxG.state as PlayState).currentLevel.masterLayer.members.length; i++){
					if((FlxG.state as PlayState).currentLevel.masterLayer.members[i] is FlxTilemap){
						((FlxG.state as PlayState).currentLevel.masterLayer.members[i] as FlxTilemap).clearTilesInCircle(
							location.x*flxTileMap._tileWidth+flxTileMap._tileWidth/2,
							location.y*flxTileMap._tileHeight+flxTileMap._tileHeight/2,
							explosionRange)					
					}
				}				
				
			}
			isMined = true;
		}
	}
}