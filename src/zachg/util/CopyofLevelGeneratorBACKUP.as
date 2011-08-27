package zachg.util
{
	import com.BaseLevel;
	import com.ImageLayer;
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Label;
	import com.cartogrammar.drawing.CubicBezier;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.core.ByteArrayAsset;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	import zachg.gameObjects.PlayerGroup;
	import zachg.gameObjects.Village;

	public class LevelGeneratorBACKUP
	{
		public function LevelGenerator()
		{
		}
		
		[Embed(source="../../../data/mapCSV_DemoLevel_LevelTerrain.csv", mimeType="application/octet-stream")] public static var CSV_LevelTerrain:Class;
		[Embed(source="../../../data/tileSet2.png")] public static var Img_LevelTerrain:Class;
		
		public static var levelToCreate:Number = -1;
		
		public static function createLevel(addToStage:Boolean = true, levelIndexToCreate:Number = -1, onAddCallback:Function = null):BaseLevel
		{
			levelToCreate = levelIndexToCreate;
			
			var createdLevel:BaseLevel = new BaseLevel();
			
			// Generate maps.
			var properties:Array = [];
			
			var BackgroundStage1:ImageLayer = new ImageLayer( 0, 0, 1.000, 1.000,'BackgroundStage1');
			createdLevel.masterLayer.add(BackgroundStage1);
			
			
			createdLevel.bgColor = 0xff000000;
			BaseLevel.boundsMinX = 0;
			BaseLevel.boundsMinY = 0;
			BaseLevel.boundsMaxX = 1600;
			BaseLevel.boundsMaxY = 1600;
			
			var mainTileData:Array = generateLevelTileMap(TileData.basicTileData); 
			var levelData:String = convertDataArrayToString(mainTileData);
			
			//main level map
			properties = generateProperties( { name:"Minable", value:true}, {name:"MineralValue", value:2}, null );
			var layerMinableTerrainTileMap:FlxTilemap = createdLevel.addTileMapWithString( 
				levelData, LevelData.LevelCreationData[levelToCreate][13][0] , 0.000, 0.000, 16, 16, 1.000, 1.000, true, 1, 1, properties, onAddCallback );
			createdLevel.masterLayer.add(layerMinableTerrainTileMap);
			
			//decorations:
/*			for (var i:int = 1 ; i < (LevelData.LevelCreationData[levelToCreate][13] as Array).length ; i++ ){
				var levelDecorationData:Array = generateDecorationTileMap(mainTileData,TileData.basicTileData,25);
				var levelDecorationDataString:String = convertDataArrayToString(levelDecorationData); 
				
				properties = generateProperties( { name:"Minable", value:false}, {name:"MineralValue", value:0}, null );
				var decorativeTileMap:FlxTilemap = createdLevel.addTileMapWithString( 
					levelDecorationDataString, LevelData.LevelCreationData[levelToCreate][13][i] ,
					0.000, 0.000, 16, 16, 1.000, 1.000, false, 1, 1, properties, onAddCallback );
				createdLevel.masterLayer.add(decorativeTileMap);
			}*/
						
			var SpritesGroup:FlxGroup = new FlxGroup;
			SpritesGroup.scrollFactor.x = 1.000000;
			SpritesGroup.scrollFactor.y = 1.000000;
			createdLevel.masterLayer.add(SpritesGroup);
			
			var GameUIDialogueGroup:FlxGroup = new FlxGroup();
			GameUIDialogueGroup.uid = 999;
			createdLevel.masterLayer.add(GameUIDialogueGroup);			

			var randomVillageLevelToStartAt:Number;
			for( var i:int = 0 ; i < friendlyIslandLocations.length ; i++){
				randomVillageLevelToStartAt = Math.round(Math.random()*((LevelData.LevelCreationData[levelToCreate][17] as Array).length-1));
				createdLevel.addSpriteToLayer(	new Village( friendlyIslandLocations[i].x+16, friendlyIslandLocations[i].y-16 ,
					32.000,32.000,1.000,1.000,0,0,32,32,"Fortress",false,
					LevelData.LevelCreationData[levelToCreate][11],
					LevelData.LevelCreationData[levelToCreate][13],
					LevelData.LevelCreationData[levelToCreate][15],
					LevelData.LevelCreationData[levelToCreate][17][randomVillageLevelToStartAt],
					GameUIDialogueGroup,
					onAddCallback),
					Village, SpritesGroup , friendlyIslandLocations[i].x+16, friendlyIslandLocations[i].y-16 , 0.000, false, 1.000, 1.000,
					generateProperties( { name:"image", value:"Fortress" }, { name:"isEnemy", value:false }, null ), onAddCallback );//"Village"
			}
			for( var j:int = 0 ; j < enemyIslandLocations.length ; j++){
				randomVillageLevelToStartAt = Math.round(Math.random()*((LevelData.LevelCreationData[levelToCreate][18] as Array).length-1));
				createdLevel.addSpriteToLayer(	new Village( enemyIslandLocations[j].x+16, enemyIslandLocations[j].y-16 ,
					32.000,32.000,1.000,1.000,0,0,32,32,"Fortress",true,
					LevelData.LevelCreationData[levelToCreate][12],
					LevelData.LevelCreationData[levelToCreate][14],
					LevelData.LevelCreationData[levelToCreate][16],
					LevelData.LevelCreationData[levelToCreate][18][randomVillageLevelToStartAt],
					GameUIDialogueGroup,
					onAddCallback),
					Village, SpritesGroup , enemyIslandLocations[j].x+16, enemyIslandLocations[j].y-16 , 0.000, false, 1.000, 1.000,
					generateProperties( { name:"image", value:"Fortress" }, { name:"isEnemy", value:true }, null ), onAddCallback );//"Village"
			}			
			
			createdLevel.addSpriteToLayer(new PlayerGroup(	friendlyIslandLocations[0].x,friendlyIslandLocations[0].y -100,100,100,1.000,1.000,0,0,60,40,"ImgPlayer",onAddCallback),
															PlayerGroup, SpritesGroup , friendlyIslandLocations[0].x, friendlyIslandLocations[0].y - 50, 0.000, false, 1.000, 1.000,
															generateProperties( { name:"image", value:"ImgPlayer" }, null ) , onAddCallback );//"PlayerGroup"
			
			FlxG.state.add(createdLevel.masterLayer);
			
			return createdLevel
		}
		
//		public static var numFriendlyIslands:Number = 2;
//		public static var numEnemyIslands:Number = 2;
//		
//		public static var minIslandDistance:Number = 250;
//		public static var minIslandDistanceToWall:Number = 300;
//		
//		public static var islandSize:Number = 100;
//		public static var islandSizeVariability:Number = 100;
//		public static var islandTopHeight:Number = 90; //0-180 degrees, angle is starting from top going counter clockwise
//		
//		public static var verticalRanomization:Number = 75; 
		
		public static var friendlyIslandLocations:Array = new Array();
		public static var enemyIslandLocations:Array = new Array();
		public static var allIslands:Array = new Array();
		
		public static var tileWidth:Number = 16;
		public static var tileHeight:Number = 16;
		public static var numTilesWide:Number;
		public static var numTilesHigh:Number;
		
		public static function generateLevelTileMap(tileLinkData:Array):Array
		{
			trace("BaseLevel.boundsMinX:"+BaseLevel.boundsMinX+ " BaseLevel.boundsMinY:"+BaseLevel.boundsMinY+" BaseLevel.boundsMaxX:"+BaseLevel.boundsMaxX+" BaseLevel.boundsMaxY:"+BaseLevel.boundsMaxY);	
			
			numTilesWide = BaseLevel.boundsMaxX/tileWidth;
			numTilesHigh = BaseLevel.boundsMaxX/tileHeight;
			
			var testingIslandMapOutline:GenericDisplay = new GenericDisplay();
			
			testingIslandMapOutline.spriteCanvas = new Sprite();
			testingIslandMapOutline.spriteCanvas.graphics.beginFill(0,0);
			testingIslandMapOutline.spriteCanvas.graphics.drawRect(0,0,BaseLevel.boundsMaxX,BaseLevel.boundsMaxY);
			testingIslandMapOutline.spriteCanvas.graphics.endFill();
			
			//generate random island locations and graphic outline of the islands
			var i:int = 0
			var j:int = 0
			allIslands = new Array();
			friendlyIslandLocations = new Array();
			enemyIslandLocations = new Array();
			
			var numFriendlyIslands:Number = LevelData.LevelCreationData[levelToCreate][0];
			var numEnemyIslands:Number = LevelData.LevelCreationData[levelToCreate][1];
			
			var totalIslandsToCreate:Number = LevelData.LevelCreationData[levelToCreate][20];
			if(totalIslandsToCreate<(numFriendlyIslands+numEnemyIslands)){
				totalIslandsToCreate = (numFriendlyIslands+numEnemyIslands);
			}
			
			for (i = 0 ; i < totalIslandsToCreate ; i++){
				var randomPoint:Point = new Point(Math.random()*BaseLevel.boundsMaxX,Math.random()*BaseLevel.boundsMaxY);
				
				while (isIslandLocationAcceptable(randomPoint, allIslands,
					LevelData.LevelCreationData[levelToCreate][5],
					LevelData.LevelCreationData[levelToCreate][6]) == false ){
					randomPoint = new Point(Math.random()*BaseLevel.boundsMaxX,Math.random()*BaseLevel.boundsMaxY);
				}
				var pointOnGrid:Point = new Point( 
					Math.round( (randomPoint.x/BaseLevel.boundsMaxX)*numTilesWide)*tileWidth,
					Math.round( (randomPoint.y/BaseLevel.boundsMaxY)*numTilesHigh)*tileHeight ); 
				
				if( i < (numFriendlyIslands+numEnemyIslands) ){
					createIsland(testingIslandMapOutline.spriteCanvas,0xff0000,pointOnGrid,
						LevelData.LevelCreationData[levelToCreate][2],
						LevelData.LevelCreationData[levelToCreate][3],
						90,
						LevelData.LevelCreationData[levelToCreate][4]);
				} else {
					createIsland(testingIslandMapOutline.spriteCanvas,0xff0000,pointOnGrid,
						LevelData.LevelCreationData[levelToCreate][21],
						LevelData.LevelCreationData[levelToCreate][22],
						0,
						LevelData.LevelCreationData[levelToCreate][4]);					
				}
				if(i<numFriendlyIslands){
					friendlyIslandLocations.push(pointOnGrid);
				} else if(i<(numFriendlyIslands+numEnemyIslands)){
					enemyIslandLocations.push(pointOnGrid);
				}
				allIslands.push(pointOnGrid);
			}			
			
			//SO FUCKING ODD THAT THIS IS DONE TWICE.
			testingIslandMapOutline.createGraphic(testingIslandMapOutline.spriteCanvas.width, testingIslandMapOutline.spriteCanvas.height);
			var bitmapData:BitmapData = new BitmapData(testingIslandMapOutline.spriteCanvas.width, testingIslandMapOutline.spriteCanvas.height, true, 0x00FFFFFF);
			var mat:Matrix = new Matrix();
			bitmapData.draw(testingIslandMapOutline.spriteCanvas);
			testingIslandMapOutline.pixels.copyPixels(bitmapData,new Rectangle(0,0,testingIslandMapOutline.spriteCanvas.width, testingIslandMapOutline.spriteCanvas.height),new Point());

			testingIslandMapOutline.createGraphic(testingIslandMapOutline.spriteCanvas.width, testingIslandMapOutline.spriteCanvas.height);
			var bitmapData:BitmapData = new BitmapData(testingIslandMapOutline.spriteCanvas.width, testingIslandMapOutline.spriteCanvas.height, true, 0x00FFFFFF);
			var mat:Matrix = new Matrix();
			bitmapData.draw(testingIslandMapOutline.spriteCanvas);
			testingIslandMapOutline.pixels.copyPixels(bitmapData,new Rectangle(0,0,testingIslandMapOutline.spriteCanvas.width, testingIslandMapOutline.spriteCanvas.height),new Point());
			
			testingIslandMapOutline.messageDuration = -1;
			
			(FlxG.state as PlayState).effectDisplays.add(testingIslandMapOutline);
			
			var levelTerrainString:String = "";			
			var dataString:String = "";
			var dataLookup:Array = new Array();
			var multiTileTargets:Dictionary = new Dictionary();
			var multiTileTargetCreators:Dictionary = new Dictionary();
			for (var i:int = 0 ; i < numTilesHigh ; i++){
				dataLookup[i] = new Array();
				for (var j:int = 0 ; j < numTilesWide ; j++){
					if (testingIslandMapOutline.pixels.getPixel32( (j*tileWidth) + tileWidth/2,(i*tileHeight) + tileHeight/2 ) != 0){
						//tile exists					
						var currentSurroundingTiles:Array = checkSurroundingTiles(	testingIslandMapOutline.pixels,
																					new Point( (j*tileWidth) + tileWidth/2,(i*tileHeight) + tileHeight/2),
																					tileWidth,
																					tileHeight);
						
						//If this is a multi-tile item, we need to figure out if 
						//it's usable and if not, continue to ask for a different tile until we find one that is
						var isTileUsable:Boolean = false;
						
						
						while (isTileUsable == false){
							//find the tile
							var tileIndex:Number = findMatchingTileIndex(currentSurroundingTiles, tileLinkData );
							if(tileIndex == -1 || tileIndex == 0 ){
								tileIndex = 0
								isTileUsable = true;
								continue;
							}
							if(tileIndex == 6 || tileIndex == 7){
								trace("test");
							}
							isTileUsable = true;
							//The following loop is fucked and likely wrong.
							//It makes me want to punch a baby directly in the face.
							
							//figure out if the tile is usable. (It won't be if it's multi-tile and the other tiles can't be placed)
							var specificMultiTileData:Array = (tileLinkData[tileIndex][ (tileLinkData[tileIndex] as Array).length - 3 ] as Array);
							if( specificMultiTileData != null){
								if( specificMultiTileData.length > 0 ){
									var multiTileIndex:String = "";
									var tileRow:Number = i;
									var tileCol:Number = j;
									for( var k:int = 0 ; k < specificMultiTileData.length ; k++){
										if(k%2 == 0){
											//this is an id
											multiTileIndex = specificMultiTileData[k];
											//reset the tilerow/col
											tileRow = i;
											tileCol = j;											
										} else {
											//this is where it goes in relation to the current tile
											if(specificMultiTileData[k] == "right"){
												tileCol++;
											} else if(specificMultiTileData[k] == "left"){
												tileCol--;										
											} else if(specificMultiTileData[k] == "top"){
												tileRow--;
											} else if(specificMultiTileData[k] == "bottom"){
												tileRow++;
											}

											//var indexToCheckForMultiTile:Number =  tileRow + tileCol*numTilesWide;
											//check to see if another tile has already got a multi-tile going where we want this mult-tile to go.
											if( multiTileTargets[tileRow+","+tileCol] != null ){
												isTileUsable = false;
											}
										}
									}
									
									// if the tile is usable, then we need to go back and set all the appropriate links
									if(isTileUsable == true){
										for( var k:int = 0 ; k < specificMultiTileData.length ; k++){
											if(k%2 == 0){
												//this is an id
												multiTileIndex = specificMultiTileData[k];
												//reset the tilerow/col
												tileRow = i;
												tileCol = j;											
											} else {
												//this is where it goes in relation to the current tile
												if(specificMultiTileData[k] == "right"){
													tileCol++;
												} else if(specificMultiTileData[k] == "left"){
													tileCol--;										
												} else if(specificMultiTileData[k] == "top"){
													tileRow--;
												} else if(specificMultiTileData[k] == "bottom"){
													tileRow++;
												}
												if( multiTileTargets[tileRow+","+tileCol] == null ){
													multiTileTargets[tileRow+","+tileCol] = multiTileIndex;
													multiTileTargetCreators[tileRow+","+tileCol] = i+","+j+","+tileIndex;
												}												
											}
										}
									}
								} else {
									isTileUsable = true;
								}
							} else {
								isTileUsable = true;
							}
						}
						dataLookup[i].push(tileIndex);
					} else {
						dataLookup[i].push(0);
					}
				}	
			}
			//so now there's a bunch of multi-tiles sitting around waiting to get added to the map.
			//figure out which ones can be added, and if some can't, go back to the original tile
			//and replace it with another tile that has no multis
			
			for (var key:Object in multiTileTargets) {
				var indexArray:Array = (key as String).split(","); 
				var tileRow:Number = indexArray[0];
				var tileCol:Number = indexArray[1];
				var tileIndex:Number = dataLookup[tileRow][tileCol];
				//If the specific tile this multi is going to overwrite is overwritable, then do it. Otherwise replace it.
				if( tileLinkData[tileIndex][ (tileLinkData[tileIndex] as Array).length - 2 ] == true){
					dataLookup[tileRow][tileCol] = multiTileTargets[key];
				} else {
					//figure out which tile has this one as a multi.
					//there's a second dictionary corresponding to the creators of the multis
					var XYindexOfCreator:String = multiTileTargetCreators[key];
					var multiCreatorIndexArray:Array = XYindexOfCreator.split(","); 
					var multiCreatorTileId:Number = multiCreatorIndexArray[2];
					var multiCreatorTileRow:Number = multiCreatorIndexArray[0];
					var multiCreatorTileCol:Number = multiCreatorIndexArray[1];					
					
					var tileIndex:Number = -1;
					var dataArray = [0];
					while ( dataArray.length > 0 ){
						var currentSurroundingTiles:Array = (tileLinkData[multiCreatorTileId] as Array).slice(0,(tileLinkData[multiCreatorTileId] as Array).length - 3)
						tileIndex = findMatchingTileIndex(currentSurroundingTiles, tileLinkData );
						if(tileIndex == -1){
							dataArray = [0];
						} else {
							dataArray = (tileLinkData[tileIndex][ (tileLinkData[tileIndex] as Array).length - 3 ] as Array);
						}
					}
					
					//now replace the creator tile and all it's links
					var specificMultiTileData:Array = (tileLinkData[tileIndex][ (tileLinkData[tileIndex] as Array).length - 3 ] as Array);
					for( var k:int = 0 ; k < specificMultiTileData.length ; k++){
						if(k%2 == 0){
							//this is an id
							multiTileIndex = specificMultiTileData[k];
							//reset the tilerow/col
							tileRow = multiCreatorTileRow;
							tileCol = multiCreatorTileCol;											
						} else {
							//this is where it goes in relation to the current tile
							if(specificMultiTileData[k] == "right"){
								tileCol++;
							} else if(specificMultiTileData[k] == "left"){
								tileCol--;										
							} else if(specificMultiTileData[k] == "top"){
								tileRow--;
							} else if(specificMultiTileData[k] == "bottom"){
								tileRow++;
							}
							if( multiTileTargets[tileRow+","+tileCol] == null ){
								dataLookup[tileRow][tileCol] = tileIndex;
							}												
						}
					}					
					
					dataLookup[multiCreatorTileRow][multiCreatorTileCol] = tileIndex;
				}
			}			
			
			testingIslandMapOutline.visible = false;
			
			return dataLookup;
			//fuck this is the most ridiculous function
		}
		
		/**
		 * 
		 * @param mainTileData
		 * @param tileLinkData
		 * @param decorationProbability input values from 0-100
		 * @return 
		 * 
		 */
		public static function generateDecorationTileMap( mainTileData:Array,tileLinkData:Array, decorationProbability:Number):Array
		{
			
			var dataArray:Array = new Array();
			
			var linkedTiles:Dictionary = new Dictionary();
			
			for (var i:int = 0 ; i < mainTileData.length ; i++){
				dataArray[i] = new Array();
				for (var j:int = 0 ; j < mainTileData[i].length ; j++){
					var randomNumber:Number = (Math.random()*100);
					if(randomNumber  < decorationProbability){
						trace("DO IT:"+randomNumber);
						var refTileIndex:Number = mainTileData[i][j];
						//decoration tile goes here
						dataArray[i][j] = refTileIndex;
						
						//go through links, find what's at that location in the mainTileData, then make sure that always gets decorated.
						var specificMultiTileData:Array = (tileLinkData[refTileIndex][ (tileLinkData[refTileIndex] as Array).length - 3 ] as Array);
						if( specificMultiTileData != null){
							if( specificMultiTileData.length > 0 ){
								for( var k:int = 0 ; k < specificMultiTileData.length ; k++){
									var tileRow:Number = i;
									var tileCol:Number = j;
									if(k%2 == 0){
										//reset the tilerow/col
										tileRow = i;
										tileCol = j;
									} else {
										if(specificMultiTileData[k] == "right"){
											tileCol++;
										} else if(specificMultiTileData[k] == "left"){
											tileCol--;										
										} else if(specificMultiTileData[k] == "top"){
											tileRow--;
										} else if(specificMultiTileData[k] == "bottom"){
											tileRow++;
										}
										linkedTiles[tileRow+","+tileCol] = mainTileData[tileRow][tileCol];
									}
									
								}
							}
						}
					} else {
						trace("Fuck THat:"+randomNumber);
						dataArray[i][j] = 0;
					}
				}
			}
			
			for (var key:Object in linkedTiles) {
				var indexArray:Array = (key as String).split(","); 
				var tileRow:Number = indexArray[0];
				var tileCol:Number = indexArray[1];
				dataArray[tileRow][tileCol] = linkedTiles[key];
			}
				
			return dataArray;
		}
		
		public static function convertDataArrayToString(dataArray:Array):String
		{
			var dataString:String = ""; 
			//ok so now we've got a 2d array with all the indexes of tiles, make it into a string
			for (var i:int = 0 ; i < dataArray.length ; i++){
				for (var j:int = 0 ; j < dataArray[i].length ; j++){
					dataString += (dataArray[i][j] + ",");
				}	
				dataString += "\n";
			}			
			return dataString
		}
		
		public static function checkSurroundingTiles(tileGraphic:BitmapData, tileToCheckCenter:Point, tileWidth:Number, tileHeight:Number):Array
		{
			var surroundingTiles:Array = new Array();
			
			if ( tileGraphic.getPixel32( tileToCheckCenter.x-tileWidth,tileToCheckCenter.y-tileHeight ) != 0){
				//surroundingTiles.push("topLeft");
			}
			if ( tileGraphic.getPixel32( tileToCheckCenter.x-tileWidth,tileToCheckCenter.y ) != 0){
				surroundingTiles.push("left");
			}
			if (tileGraphic.getPixel32( tileToCheckCenter.x-tileWidth,tileToCheckCenter.y+tileHeight ) != 0){
				//surroundingTiles.push("bottomLeft");
			}
			if (tileGraphic.getPixel32( tileToCheckCenter.x,tileToCheckCenter.y+tileHeight ) != 0){
				surroundingTiles.push("bottom");
			}
			if (tileGraphic.getPixel32( tileToCheckCenter.x+tileWidth,tileToCheckCenter.y+tileHeight ) != 0){
				//surroundingTiles.push("bottomRight");
			}
			if (tileGraphic.getPixel32( tileToCheckCenter.x+tileWidth,tileToCheckCenter.y ) != 0){
				surroundingTiles.push("right");
			}
			if (tileGraphic.getPixel32( tileToCheckCenter.x+tileWidth,tileToCheckCenter.y-tileHeight ) != 0){
				//surroundingTiles.push("topRight");
			}
			if (tileGraphic.getPixel32( tileToCheckCenter.x,tileToCheckCenter.y-tileHeight ) != 0){
				surroundingTiles.push("top");
			}
			return surroundingTiles;
		}
		
		public static function findMatchingTileIndex(surroundingTileArray:Array, availableTileData:Array):Number
		{
			var possibleTiles:Array = new Array();
			for (var i:int = 0 ; i < surroundingTileArray.length ; i++){
				
				var cutDownAvailableTileData:Array = new Array(); 
				for (var j:int = 0 ; j < availableTileData.length ; j++){
					var doesTileContainThisData:Boolean = false;
					for (var k:int = 0 ; k < (availableTileData[j] as Array).length ; k++){
						if( availableTileData[j][k] == surroundingTileArray[i] ){
							doesTileContainThisData = true;
						}
					}
					if(doesTileContainThisData == true && ((availableTileData[j] as Array).length - 3 == surroundingTileArray.length) ){
						cutDownAvailableTileData.push(availableTileData[j]);
					}
				}
				availableTileData = cutDownAvailableTileData;
			}
			possibleTiles = availableTileData;
			var whichPossibleTile:Number = Math.round(Math.random()*(possibleTiles.length - 1)); 
			
			if (possibleTiles.length == 0 || surroundingTileArray.length == 0){
				return -1
			} else {
				return possibleTiles[whichPossibleTile][(possibleTiles[whichPossibleTile] as Array).length - 1]; 
			}
			
		}
		
		public static function isIslandLocationAcceptable(IslandToCheck:Point , CurrentIslands:Array , MinDistanceToNearestIsland:Number , MinDistanceToWall:Number):Boolean
		{
			//check distance to wall
			if(  	(IslandToCheck.x < MinDistanceToWall || IslandToCheck.x > (BaseLevel.boundsMaxX - MinDistanceToWall) ) ||
					(IslandToCheck.y < MinDistanceToWall || IslandToCheck.y > (BaseLevel.boundsMaxY - MinDistanceToWall) ) ){
				return false
			}
			trace("IslandToCheck: x="+IslandToCheck.x + " y=" +IslandToCheck.y); 
			
			var i:int = 0
			for (i = 0 ; i < (CurrentIslands.length) ; i++){
				var dx:Number = CurrentIslands[i].x - IslandToCheck.x;
				var dy:Number = CurrentIslands[i].y - IslandToCheck.y;
				var distanceToIsland:Number = Math.sqrt( dx*dx + dy*dy );
				trace("distanceToIsland:"+distanceToIsland);
				if( distanceToIsland < MinDistanceToNearestIsland){
					return false
				}
			}
			return true
		}
		
		public static var levelGenSpriteColor:uint = 0xFF0000; 
		public static function createIsland(	DrawSprite:Sprite,
												Color:uint,
												IslandLocation:Point, 
												IslandSize:Number, 
												IslandSizeVariability:Number,
												IslandTopAngleDegrees:Number,
												VerticalRanomization:Number
		):void {
			DrawSprite.graphics.beginFill(levelGenSpriteColor,1);
			DrawSprite.graphics.drawCircle(IslandLocation.x,IslandLocation.y,3);
			DrawSprite.graphics.endFill();
			DrawSprite.graphics.lineStyle(3);
			DrawSprite.graphics.beginFill(Color,.5);
			
			IslandSize += Math.random()*IslandSizeVariability;
			
			var IslandPoints:Array = new Array();
			
			var radIslandTopAngle:Number = (-IslandTopAngleDegrees-90) * (Math.PI/180);
			
			var numPoints:Number = 20;
			//negative to start at top left pt.
			var firstPoint:Point = new Point( IslandLocation.x + IslandSize*Math.cos(radIslandTopAngle), IslandLocation.y + IslandSize*Math.sin(radIslandTopAngle) );
			IslandPoints.push(firstPoint);
			
			var angleDifference:Number = (360) - (IslandTopAngleDegrees * 2);
			var angleChange:Number = angleDifference/numPoints;
			var angleChangeRads:Number = angleChange * (Math.PI/180);
			
			for( var i:int = 1 ; i < numPoints+1 ; i++){
				var nextPoint:Point = new Point( IslandLocation.x + IslandSize*Math.cos(radIslandTopAngle-(i*angleChangeRads) ), IslandLocation.y + IslandSize*Math.sin(radIslandTopAngle-(i*angleChangeRads)) );
				nextPoint.y -= (Math.random()*VerticalRanomization);				
				if(nextPoint.y < firstPoint.y){
					nextPoint.y = firstPoint.y;
				}
				IslandPoints.push(nextPoint);
			}
			IslandPoints.push(firstPoint);
			CubicBezier.curveThroughPoints(DrawSprite.graphics,IslandPoints);
			
			//DrawSprite.graphics.drawCircle(IslandLocation.x,IslandLocation.y, IslandSize + (Math.random()*IslandSizeVariability-IslandSizeVariability/2) );
		}
		
		public static function generateProperties( ... arguments ):Array
		{
			var properties:Array = [];
			if ( arguments.length )
			{
				var i:uint = arguments.length - 1;
				while(i--)
				{
					properties.push( arguments[i] );
				}
			}
			return properties;
		}		
		
	}
}

/*
currentLevel = new levelClassName(true, onObjectAddedCallback);

//Code generated with DAME. http://www.dambots.com

package com
{
	import org.flixel.*;
	import zachg.*;
	import zachg.components.*;
	import zachg.gameObjects.*;
	public class Level_DemoLevel extends BaseLevel
	{
		//Embedded media...
		[Embed(source="../../data/mapCSV_DemoLevel_LevelTerrain.csv", mimeType="application/octet-stream")] public var CSV_LevelTerrain:Class;
		[Embed(source="../../data/tileSet2.png")] public var Img_LevelTerrain:Class;
		[Embed(source="../../data/mapCSV_DemoLevel_MinableTerrain.csv", mimeType="application/octet-stream")] public var CSV_MinableTerrain:Class;
		[Embed(source="../../data/tileSet2.png")] public var Img_MinableTerrain:Class;
		
		//Tilemaps
		public var layerLevelTerrain:FlxTilemap;
		public var layerMinableTerrain:FlxTilemap;
		
		//Sprites
		public var SpritesGroup:FlxGroup = new FlxGroup;
		
		//Images
		public var BackgroundStage1:ImageLayer;
		
		//Properties
		
		
		public function Level_DemoLevel(addToStage:Boolean = true, onAddCallback:Function = null)
		{
			// Generate maps.
			var properties:Array = [];
			
			properties = generateProperties( { name:"Minable", value:false }, null );
			layerLevelTerrain = addTilemap( CSV_LevelTerrain, Img_LevelTerrain, 0.000, 0.000, 16, 16, 1.000, 1.000, true, 1, 1, properties, onAddCallback );
			properties = generateProperties( { name:"Minable", value:true }, { name:"MineralValue", value:0.5 }, null );
			layerMinableTerrain = addTilemap( CSV_MinableTerrain, Img_MinableTerrain, 0.000, 0.000, 16, 16, 1.000, 1.000, true, 1, 1, properties, onAddCallback );
			
			//Create image layer objects
			BackgroundStage1= new ImageLayer( 0, 0, 1.000, 1.000,'BackgroundStage1');
			
			//Add layers to the master group in correct order.
			masterLayer.add(BackgroundStage1);
			masterLayer.add(layerLevelTerrain);
			masterLayer.add(layerMinableTerrain);
			masterLayer.add(SpritesGroup);
			SpritesGroup.scrollFactor.x = 1.000000;
			SpritesGroup.scrollFactor.y = 1.000000;
			
			if ( addToStage )
				createObjects(onAddCallback);
			
			boundsMinX = 0;
			boundsMinY = 0;
			boundsMaxX = 1600;
			boundsMaxY = 1600;
			bgColor = 0xff000000;
		}
		
		override public function createObjects(onAddCallback:Function = null):void
		{
			addSpritesForLayerSprites(onAddCallback);
			generateObjectLinks(onAddCallback);
			FlxG.state.add(masterLayer);
		}
		
		public function addSpritesForLayerSprites(onAddCallback:Function = null):void
		{
			addSpriteToLayer(new PlayerGroup(222.000,412.000,60.000,40.000,1.000,1.000,0,0,60,40,"ImgPlayer",onAddCallback), PlayerGroup, SpritesGroup , 222.000, 412.000, 0.000, false, 1.000, 1.000, generateProperties( { name:"image", value:"ImgPlayer" }, null ), onAddCallback );//"PlayerGroup"
			linkedObjectDictionary[1] = addSpriteToLayer(new Village(176.000,432.000,32.000,32.000,1.000,1.000,0,0,32,32,"Fortress",false,onAddCallback), Village, SpritesGroup , 176.000, 432.000, 0.000, false, 1.000, 1.000, generateProperties( { name:"image", value:"Fortress" }, { name:"isEnemy", value:false }, null ), onAddCallback );//"Village"
			linkedObjectDictionary[3] = addSpriteToLayer(new Village(770.000,577.000,32.000,32.000,1.000,1.000,0,0,32,32,"Fortress",true,onAddCallback), Village, SpritesGroup , 770.000, 577.000, 0.000, false, 1.000, 1.000, generateProperties( { name:"image", value:"Fortress" }, { name:"isEnemy", value:true }, null ), onAddCallback );//"Village"
			linkedObjectDictionary[0] = addSpriteToLayer(new Crystal(176.000,480.000,32.000,48.000,1.000,1.000,0,0,32,48,"Crystal",false,onAddCallback), Crystal, SpritesGroup , 176.000, 480.000, 0.000, false, 1.000, 1.000, generateProperties( { name:"image", value:"Crystal" }, { name:"isEnemy", value:false }, null ), onAddCallback );//"Crystal"
			linkedObjectDictionary[2] = addSpriteToLayer(new Crystal(768.000,624.000,32.000,48.000,1.000,1.000,0,0,32,48,"Crystal",false,onAddCallback), Crystal, SpritesGroup , 768.000, 624.000, 0.000, false, 1.000, 1.000, generateProperties( { name:"image", value:"Crystal" }, { name:"isEnemy", value:false }, null ), onAddCallback );//"Crystal"
		}
		
		public function generateObjectLinks(onAddCallback:Function = null):void
		{
			createLink(linkedObjectDictionary[0], linkedObjectDictionary[1], onAddCallback, generateProperties( null ) );
			createLink(linkedObjectDictionary[2], linkedObjectDictionary[3], onAddCallback, generateProperties( null ) );
		}
		
	}
}
*/