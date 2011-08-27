package zachg.components
{
	import com.GlobalVariables;
	import com.PlayState;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	import zachg.Mineral;
	import zachg.MineralGenerator;
	import zachg.PlayerStats;
	import zachg.gameObjects.CallbackSprite;
	import zachg.minerals.specialMinerals.Mine;
	import zachg.minerals.specialMinerals.SpecialMineral;
	import zachg.minerals.specialMinerals.TreasureBox;
	import zachg.util.EffectController;
	import zachg.util.LevelData;

	public class MiningComponent extends GameComponent
	{
		
		public var cargoSizeLimit:Number = 20;		
		public var mineralGenerator:MineralGenerator = new MineralGenerator();

		public var currentMinerals:Vector.<Mineral> = new Vector.<Mineral>();		
		
		public var mineDelay:Number = 50;
		public var lastMinedCounter:Number = 50;		
		
		public var location:Point = new Point();
		public var bodyObject:FlxObject;
		
		public var minValue:Number = 20;
		public var maxValue:Number = 10000;
		private var randomVariationAmount:Number = 20;
		
		public var numTimesMined:Number = 0;
		
		public function MiningComponent(CallbackFunction:Function=null,rootObject:FlxObject=null)
		{
			super(CallbackFunction);
		}
		
		override public function update():void
		{
			super.update();
			lastMinedCounter++;			
			
		}

		private function obtainMineral(numMinerals:Number,tileMap:FlxTilemap):void
		{
			var mineralsMined:Array = new Array();
			for (var i:int = 0 ; i < numMinerals ; i++){
				if(currentMinerals.length < cargoSizeLimit){
					var mineral:Mineral = mineralGenerator.generateMineral(tileMap)
					mineralsMined.push(mineral);
					currentMinerals.push(mineral);
				} else {
					EffectController.displayMessageAtPoint(	location.x,location.y-50,"No space in Cargo",
						0xEEEE00, 
						0x000000,
						50);
				}
			}
			var text:String = "Mined: ";
			for (var j:int = 0 ; j < mineralsMined.length ; j++){
				text += (mineralsMined[j] as Mineral).fullName;
				if(j < mineralsMined.length - 1){
					text +=", ";
				}
			}
			EffectController.displayMessageAtPoint(location.x,location.y,text);
		}
				
		
		//IF THE TILE SIZE CHANGES THIS WILL BREAK!
		private var _tileWidth:Number = 16;
		private var _tileHeight:Number = 16;
		
		private function checkForSpecialItems(X:Number,Y:Number,Width:Number,Height:Number,tileMap:FlxTilemap):Number
		{
			var XTile:Number = Math.round(X/_tileWidth);
			var YTile:Number = Math.round(Y/_tileHeight);
			var numTilesWide:Number = Math.round( Width/_tileWidth );
			var numTilesHigh:Number = Math.round( Height/_tileHeight );
			var tilesToClear:Dictionary = new Dictionary();
			for (var i:int = 0 ; i < numTilesHigh ; i++){
				for (var j:int = 0 ; j < numTilesWide ; j++){
					tilesToClear[(YTile + i)+","+(j+XTile)] = true;
				}
			}
			
			var tilesCleared:Number = 0;
			for (var key:Object in (FlxG.state as PlayState).currentLevel.specialTileLocations) {
				if( (FlxG.state as PlayState).currentLevel.specialTileLocations[key] != 0){
					for (var clearTileKey:Object in tilesToClear) {
						if(clearTileKey == key){
							var keyArray:Array = (clearTileKey as String).split(",");
							var keyY:int = keyArray[0];
							var keyX:int = keyArray[1];
							trace("mined special tile");
							var minedTileIndex:Number = (FlxG.state as PlayState).currentLevel.specialTileLocations[key];
							var specialTile:SpecialMineral = new LevelData.SpecialTileMapping[minedTileIndex](new Point(keyX,keyY)); 
							if(specialTile is Mine){
								(specialTile as Mine).explosionRange = (4 + Math.round(Math.random()*3))*20;
							} else if (specialTile is TreasureBox){
								(specialTile as TreasureBox).resourceValue =  5 + Math.round(Math.random()*(specialTile as TreasureBox).resourceValue);
								var percentageLevelFromEnd:Number = PlayerStats.currentLevelId/LevelData.LevelCreationData.length;
								(specialTile as TreasureBox).resourceValue = Math.round(minValue + ((specialTile as TreasureBox).resourceValue/10)*(maxValue-minValue)*(percentageLevelFromEnd) + Math.random()*randomVariationAmount);
							}
							specialTile.minedAction(tileMap);
							tilesCleared++;
						}
					}
				} 
					
				// iterates through each object key
			}
			return tilesCleared;
			
			//createdLevel.specialTileLocations			
			
			//Fix this:
/*			for( var i:int = 0 ; i < (LevelData.LevelSpecialTiles[PlayerStats.currentLevelId] as Array).length ; i++ ) {
				var specialMineral:SpecialMineral = LevelData.LevelSpecialTiles[PlayerStats.currentLevelId][i];
				if(specialMineral.isMined == false){
					var numTilesWide:uint = (X+Width)/_tileWidth - (X/_tileWidth);
					var numTilesHigh:uint = (Y+Height)/_tileHeight - (Y/_tileHeight);
					
					var tilesCleared:Number = 0;
					for (var l:int = 0 ; l < numTilesHigh ; l++){
						for (var j:int = 0 ; j < numTilesWide ; j++){
							var test:Number = Math.floor(X/_tileWidth)+j;
							var test2:Number = Math.floor(Y/_tileHeight)+l;
							if( Math.floor(X/_tileWidth)+j == specialMineral.location.x && Math.floor(Y/_tileHeight)+l == specialMineral.location.y ){
								specialMineral.minedAction(tileMap);
								tilesCleared++;
							}
						}
					}
				}
			}*/
		}
		
		
		public function mineArea(tileMap:FlxTilemap, side:String):Boolean
		{
			if( lastMinedCounter < mineDelay || tileMap == null){
				return false
			}
			
			if(tileMap.dataObject["Minable"]){
				if(tileMap.dataObject["Minable"] == true){
					
					var numTilesCleared:Number = 0;
					var amountMined:Number = 1;
					var tileSize:Number = 16;
					
					if(side == "down"){
						numTilesCleared = tileMap.clearTilesInArea( 
							location.x - bodyObject.width/2,
							location.y + amountMined*tileSize,
							bodyObject.width*2,
							bodyObject.height + amountMined*tileSize);
						for (var i:int = 0 ; i < (FlxG.state as PlayState).currentLevel.masterLayer.members.length; i++){
							if((FlxG.state as PlayState).currentLevel.masterLayer.members[i] is FlxTilemap){
								if( ((FlxG.state as PlayState).currentLevel.masterLayer.members[i] as FlxTilemap).dataObject.isDestroyable == true ){
									((FlxG.state as PlayState).currentLevel.masterLayer.members[i] as FlxTilemap).clearTilesInArea(
										location.x - bodyObject.width/2,
										location.y + amountMined*tileSize,
										bodyObject.width*2,
										bodyObject.height + amountMined*tileSize);
								}								
							}
						}
						
						if(numTilesCleared >0){
							obtainMineral(numTilesCleared,tileMap);
							checkForSpecialItems( location.x,
								location.y + amountMined*tileSize,
								bodyObject.width*2,
								bodyObject.height + amountMined*tileSize,
								tileMap);
							
							lastMinedCounter = 0;
							
							PlayerStats.currentLevelDataVo.areaMined += numTilesCleared;
						}
						numTimesMined++;
						return true
					} else if(side == "up"){
						numTilesCleared = tileMap.clearTilesInArea( 
							location.x,
							location.y - amountMined*tileSize,
							bodyObject.width*2,
							bodyObject.height + amountMined*tileSize);
						for (var i:int = 0 ; i < (FlxG.state as PlayState).currentLevel.masterLayer.members.length; i++){
							if((FlxG.state as PlayState).currentLevel.masterLayer.members[i] is FlxTilemap){
								((FlxG.state as PlayState).currentLevel.masterLayer.members[i] as FlxTilemap).clearTilesInArea(
									location.x,
									location.y - amountMined*tileSize,
									bodyObject.width*2,
									bodyObject.height + amountMined*tileSize);
							}
						}
						
						if(numTilesCleared >0){
							obtainMineral(numTilesCleared,tileMap);
							checkForSpecialItems( location.x,
								location.y - amountMined*tileSize,
								bodyObject.width*2,
								bodyObject.height + amountMined*tileSize,
								tileMap);
							lastMinedCounter = 0;
							PlayerStats.currentLevelDataVo.areaMined += numTilesCleared;
						}
						numTimesMined++;
						return true
					} else if(side == "left"){
						numTilesCleared = tileMap.clearTilesInArea( 
							location.x - amountMined*tileSize,
							location.y,
							bodyObject.width+10 + amountMined*tileSize,
							bodyObject.height+10);
						for (var i:int = 0 ; i < (FlxG.state as PlayState).currentLevel.masterLayer.members.length; i++){
							if((FlxG.state as PlayState).currentLevel.masterLayer.members[i] is FlxTilemap){
								((FlxG.state as PlayState).currentLevel.masterLayer.members[i] as FlxTilemap).clearTilesInArea(
									location.x - amountMined*tileSize,
									location.y,
									bodyObject.width+10 + amountMined*tileSize,
									bodyObject.height+10);
							}
						}
						
						if(numTilesCleared >0){
							obtainMineral(numTilesCleared,tileMap);
							checkForSpecialItems( location.x,
								location.y - amountMined*tileSize,
								bodyObject.width+10,
								bodyObject.height + amountMined*tileSize,
								tileMap);
							lastMinedCounter = 0;
							PlayerStats.currentLevelDataVo.areaMined += numTilesCleared;
						}
						numTimesMined++;
						return true
					} else if(side == "right"){
						numTilesCleared = tileMap.clearTilesInArea( 
							bodyObject.x,
							bodyObject.y,
							bodyObject.width+10 + amountMined*tileSize,
							bodyObject.height+10);
						for (var i:int = 0 ; i < (FlxG.state as PlayState).currentLevel.masterLayer.members.length; i++){
							if((FlxG.state as PlayState).currentLevel.masterLayer.members[i] is FlxTilemap){
								((FlxG.state as PlayState).currentLevel.masterLayer.members[i] as FlxTilemap).clearTilesInArea(
									bodyObject.x,
									bodyObject.y,
									bodyObject.width+10 + amountMined*tileSize,
									bodyObject.height+10);
							}
						}

						if(numTilesCleared >0){
							obtainMineral(numTilesCleared,tileMap);
							checkForSpecialItems(  bodyObject.x,
								bodyObject.y - amountMined*tileSize,
								bodyObject.width+10,
								bodyObject.height + amountMined*tileSize,
								tileMap);
							lastMinedCounter = 0;
							PlayerStats.currentLevelDataVo.areaMined += numTilesCleared;
						}
						numTimesMined++;
						return true
					}			
				}
			}
			return false
		}		
		
	}
}