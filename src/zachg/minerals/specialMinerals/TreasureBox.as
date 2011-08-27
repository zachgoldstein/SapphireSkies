package zachg.minerals.specialMinerals
{
	import com.PlayState;
	
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	
	import zachg.util.EffectController;

	public class TreasureBox extends SpecialMineral
	{
		
		public function TreasureBox(Location:Point, value:Number = 10)
		{
			super();
			fullName = "Treasure Box";
			description = "Surprise! You mined a special area and earned some extra loot.";
			imageName = "UICargoIconIron";
			location = Location;
			rupeeValue = 1;
			rupeeValue += value;
			resourceValue = value;
		}
		
		override public function minedAction(flxTileMap:FlxTilemap=null):void 
		{
			if( (FlxG.state as PlayState).player.currentPlayerMinerals.length < (FlxG.state as PlayState).player.cargoSizeLimit){
				(FlxG.state as PlayState).player.currentPlayerMinerals.push(this);
				EffectController.displayMessageAtPoint( (FlxG.state as PlayState).player.MainHullSprite.x,
														(FlxG.state as PlayState).player.MainHullSprite.y-15,
														"Found Treasure!",
														0xEEEE00,
														0x000000,
														50);
			} else {
				EffectController.displayMessageAtPoint( (FlxG.state as PlayState).player.MainHullSprite.x,
					(FlxG.state as PlayState).player.MainHullSprite.y-15,
					"Found Treasure but lost it! (not enough space in cargo)",
					0xEEEE00,
					0x000000,
					50);				
			}
				
			isMined = true;
		}
	}
}