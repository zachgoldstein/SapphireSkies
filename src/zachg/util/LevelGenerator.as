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

	public class LevelGenerator
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
			
			var BackgroundStage1:ImageLayer = new ImageLayer( 0, 0, 1.000, 1.000,LevelData.LevelCreationData[levelToCreate][26]);
			createdLevel.masterLayer.add(BackgroundStage1);
			
			
			createdLevel.bgColor = 0xff000000;
			BaseLevel.boundsMinX = 0;
			BaseLevel.boundsMinY = 0;
			BaseLevel.boundsMaxX = 1600;
			BaseLevel.boundsMaxY = 1600;
			
			var mainTileData:Dictionary = generateLevelTileMap(TileData.basicTileData); 
			var levelData:String = convertDataDictionaryToString(mainTileData);
			
			//main level map
			properties = generateProperties( 
				{ name:"Minable", value:true}, {name:"MineralValue", value:LevelData.LevelCreationData[levelToCreate][28]},{name:"isDestroyable", value:true}, null );
			var layerMinableTerrainTileMap:FlxTilemap = createdLevel.addTileMapWithString( 
				levelData, LevelData.LevelCreationData[levelToCreate][13][0] , 0.000, 0.000, 16, 16, 1.000, 1.000, true, 1, 1, properties, onAddCallback );
			createdLevel.masterLayer.add(layerMinableTerrainTileMap);
			
			//undestroyable tiles below islands
			var islandTiles:Dictionary = generateIslandTileMap(TileData.basicTileData); 
			var islandTileData:String = convertDataDictionaryToString(islandTiles);			
			properties = generateProperties( { name:"Minable", value:false}, {name:"MineralValue", value:0},{name:"isDestroyable", value:false}, null );
			var islandTerrainTileMap:FlxTilemap = createdLevel.addTileMapWithString( 
				islandTileData, LevelData.LevelCreationData[levelToCreate][13][0] , 0.000, 0.000, 16, 16, 1.000, 1.000, false, 0, 1, properties, onAddCallback );
			createdLevel.masterLayer.add(islandTerrainTileMap);
			
			//decorations:
			//we need a cumulative dict so that decorations across multilple tilesets won't overwrite each other
			var cumulativeDict:Dictionary = new Dictionary();
			for (var i:int = 1 ; i < (LevelData.LevelCreationData[levelToCreate][13] as Array).length ; i++ ){
				var levelDecorationData:Dictionary = generateDecorationTileMap(mainTileData,cumulativeDict,TileData.basicTileData,25);
				var levelDecorationDataString:String = convertDataDictionaryToString(levelDecorationData); 
				cumulativeDict = addDictionaries(levelDecorationData,cumulativeDict);
				
				properties = generateProperties( { name:"Minable", value:false}, {name:"MineralValue", value:0},{name:"isDestroyable", value:true}, null );
				var decorativeTileMap:FlxTilemap = createdLevel.addTileMapWithString( 
					levelDecorationDataString, LevelData.LevelCreationData[levelToCreate][13][i] ,
					0.000, 0.000, 16, 16, 1.000, 1.000, false, 1, 1, properties, onAddCallback );
				createdLevel.masterLayer.add(decorativeTileMap);
			}
			
			//special tiles:
/*			createdLevel.specialTileLocations = generateSpecialTileMap( mainTileData, LevelData.SpecialTileMapping, LevelData.LevelCreationData[levelToCreate][27]);
			var levelSpecialDataString:String = convertDataDictionaryToString(createdLevel.specialTileLocations);
			var specialTileMap:FlxTilemap = createdLevel.addTileMapWithString( 
				levelSpecialDataString,Resources.TileSetSpecialTiles,
				0.000, 0.000, 16, 16, 1.000, 1.000, false, 1, 1, null, onAddCallback );
			createdLevel.masterLayer.add(specialTileMap);
			createdLevel.specialTilemaps.add(specialTileMap);*/
			
			var SpritesGroup:FlxGroup = new FlxGroup;
			SpritesGroup.scrollFactor.x = 1.000000;
			SpritesGroup.scrollFactor.y = 1.000000;
			createdLevel.masterLayer.add(SpritesGroup);
			
			var GameUIDialogueGroup:FlxGroup = new FlxGroup();
			GameUIDialogueGroup.uid = 999;
			createdLevel.masterLayer.add(GameUIDialogueGroup);			

			var randomVillageLevelToStartAt:Number;
			var hardCodedVillageName:String = "";
			for( var j:int = 0 ; j < enemyIslandLocations.length ; j++){
				if(j < (LevelData.LevelCreationData[levelToCreate][25] as Array).length ){
					hardCodedVillageName = LevelData.LevelCreationData[levelToCreate][25][j];
				} else {
					hardCodedVillageName = "";
				}
					
				randomVillageLevelToStartAt = Math.round(Math.random()*((LevelData.LevelCreationData[levelToCreate][18] as Array).length-1));
				createdLevel.addSpriteToLayer(	new Village( enemyIslandLocations[j].x, enemyIslandLocations[j].y+3,
					32.000,32.000,1.000,1.000,0,0,32,32,null,true,
					LevelData.LevelCreationData[levelToCreate][12],
					LevelData.LevelCreationData[levelToCreate][14],
					LevelData.LevelCreationData[levelToCreate][16],
					LevelData.LevelCreationData[levelToCreate][18][randomVillageLevelToStartAt],
					GameUIDialogueGroup,
					hardCodedVillageName,
					onAddCallback),
					Village, SpritesGroup , enemyIslandLocations[j].x, enemyIslandLocations[j].y+3, 0.000, false, 1.000, 1.000,
					generateProperties( { name:"image", value:null }, { name:"isEnemy", value:true }, null ), onAddCallback );//"Village"
			}				
			for( var i:int = 0 ; i < friendlyIslandLocations.length ; i++){
				if( i < (LevelData.LevelCreationData[levelToCreate][24] as Array).length){
					hardCodedVillageName = LevelData.LevelCreationData[levelToCreate][24][i];
				} else {
					hardCodedVillageName = "";
				}				
				randomVillageLevelToStartAt = Math.round(Math.random()*((LevelData.LevelCreationData[levelToCreate][17] as Array).length-1));
				createdLevel.addSpriteToLayer(	new Village( friendlyIslandLocations[i].x, friendlyIslandLocations[i].y+3,
					32.000,32.000,1.000,1.000,0,0,32,32,null,false,
					LevelData.LevelCreationData[levelToCreate][11],
					LevelData.LevelCreationData[levelToCreate][13],
					LevelData.LevelCreationData[levelToCreate][15],
					LevelData.LevelCreationData[levelToCreate][17][randomVillageLevelToStartAt],
					GameUIDialogueGroup,
					hardCodedVillageName,
					onAddCallback),
					Village, SpritesGroup , friendlyIslandLocations[i].x, friendlyIslandLocations[i].y+3, 0.000, false, 1.000, 1.000,
					generateProperties( { name:"image", value:null }, { name:"isEnemy", value:false }, null ), onAddCallback );//"Village"
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
		
		public static function generateLevelTileMap(tileLinkData:Array):Dictionary
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
				
				if(i < (numFriendlyIslands+numEnemyIslands)){
					while (isIslandLocationAcceptable(randomPoint, allIslands,
						LevelData.LevelCreationData[levelToCreate][5],
						LevelData.LevelCreationData[levelToCreate][6]) == false ){
						randomPoint = new Point(Math.random()*BaseLevel.boundsMaxX,Math.random()*BaseLevel.boundsMaxY);
					}
				} else {
					while (isIslandLocationAcceptable(randomPoint, allIslands,
						250,
						50) == false ){
						randomPoint = new Point(Math.random()*BaseLevel.boundsMaxX,Math.random()*BaseLevel.boundsMaxY);
					}
					
				}
				trace("Island at: x="+randomPoint.x + " y=" +randomPoint.y);
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
			var dataLookup:Dictionary = new Dictionary();
			var multiTileTargets:Dictionary = new Dictionary();
			var multiTileTargetCreators:Dictionary = new Dictionary();
			for (var i:int = 0 ; i < numTilesHigh ; i++){
				for (var j:int = 0 ; j < numTilesWide ; j++){
					if (testingIslandMapOutline.pixels.getPixel32( (j*tileWidth) + tileWidth/2,(i*tileHeight) + tileHeight/2 ) != 0){
						//tile exists
						//find tile to fit area
						
						var currentSurroundingTiles:Array = checkSurroundingTiles(	testingIslandMapOutline.pixels,
																					new Point( (j*tileWidth) + tileWidth/2,(i*tileHeight) + tileHeight/2),
																					tileWidth,
																					tileHeight);
						var doesCurrentTileFit:Boolean = false;
						while (doesCurrentTileFit == false){
							var tileIndex:Number = findMatchingTileIndex(currentSurroundingTiles, tileLinkData );
							if( dataLookup[i+","+j] == null){
								if( doesTileFit(j,i,tileIndex,[],testingIslandMapOutline,dataLookup,tileLinkData) == true){
									dataLookup = placeTile(j,i,tileIndex,[],dataLookup,tileLinkData);
									doesCurrentTileFit = true;
								}
							} else {
								//tile already determined by a previous tile placing a multi at this position
								doesCurrentTileFit = true;
							}
						}
					} else {
						dataLookup[i+","+j] = 0;
					}
				}
			}
			
			testingIslandMapOutline.visible = false;
			
			return dataLookup;
			//fuck getting to this was a struggle			
		}
		
		public static function generateIslandTileMap(tileLinkData:Array):Dictionary
		{
			var dataLookup:Dictionary = new Dictionary();
			for (var i:int = 0 ; i < numTilesHigh ; i++){
				for (var j:int = 0 ; j < numTilesWide ; j++){
					dataLookup[i+","+j] = 0;
				}
			}
			
			var underLayerWidth:Number = 10;
			for (var i:int = 0 ; i < friendlyIslandLocations.length ; i++){
				var pointOnGrid:Point = new Point( 
					Math.round( (friendlyIslandLocations[i].x/tileWidth) ) - 6,
					Math.round( (friendlyIslandLocations[i].y/tileHeight) ) 
				); 
				
				dataLookup[pointOnGrid.y+","+pointOnGrid.x] = 36;
				dataLookup[(pointOnGrid.y+1)+","+pointOnGrid.x] = 38;
				dataLookup[pointOnGrid.y+","+(pointOnGrid.x+underLayerWidth)] = 3;
				dataLookup[(pointOnGrid.y+1)+","+(pointOnGrid.x+underLayerWidth)] = 39;
				for( var j:int = 1 ; j < underLayerWidth ; j++){
					dataLookup[pointOnGrid.y+","+(pointOnGrid.x+j)] = 1;
					dataLookup[(pointOnGrid.y+1)+","+(pointOnGrid.x+j)] = 33;
				}
			}

			for (var i:int = 0 ; i < enemyIslandLocations.length ; i++){
				var pointOnGrid:Point = new Point( 
					Math.round( (enemyIslandLocations[i].x/tileWidth) ) - 6,
					Math.round( (enemyIslandLocations[i].y/tileHeight) ) 
				); 
				
				dataLookup[pointOnGrid.y+","+pointOnGrid.x] = 36;
				dataLookup[(pointOnGrid.y+1)+","+pointOnGrid.x] = 38;
				dataLookup[pointOnGrid.y+","+(pointOnGrid.x+underLayerWidth)] = 3;
				dataLookup[(pointOnGrid.y+1)+","+(pointOnGrid.x+underLayerWidth)] = 39;
				for( var j:int = 1 ; j < underLayerWidth ; j++){
					dataLookup[pointOnGrid.y+","+(pointOnGrid.x+j)] = 1;
					dataLookup[(pointOnGrid.y+1)+","+(pointOnGrid.x+j)] = 33;
				}
			}
			return dataLookup
		}
		
		public static function doesTileFit(j:int,
										   i:int,
										   tileIndex:int, 
										   checkedLocations:Array,
										   testingIslandMapOutline:GenericDisplay,
										   dataLookup:Dictionary,
										   tileLinkData:Array):Boolean
		{
			if( dataLookup[i+","+j] == null  &&
				testingIslandMapOutline.pixels.getPixel32( (j*tileWidth) + tileWidth/2,(i*tileHeight) + tileHeight/2 ) != 0
				){
				
				//If this is coming from a check on a multi, we don't know if that tile can fit in this area,
				//so we need to find it's surrounding tiles and check if this tile could fit in the area
				var currentSurroundingTiles:Array = checkSurroundingTiles(	testingIslandMapOutline.pixels,
					new Point( (j*tileWidth) + tileWidth/2,(i*tileHeight) + tileHeight/2),
					tileWidth,
					tileHeight);
				if (doesTileMatchSurroundingTiles(tileIndex,currentSurroundingTiles,tileLinkData) == true){
					
					//so the tile makes sense in this area, and it's free, check it's multi's and see if they are ok too
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
									
									//We've got to see if this location has already been checked somewhere in the recursive call
									//if it has, don't recursively check the multi
									//if it hasn't, add this location to what's been checked
									var hasThisLocationBeenCheckedPreviously:Boolean = false;
									for (var l:int = 0 ; l < checkedLocations.length ; l++){
										if(	tileCol == checkedLocations[l][0] &&
											tileRow == checkedLocations[l][1]){
											hasThisLocationBeenCheckedPreviously = true;
										}
									}
									if(hasThisLocationBeenCheckedPreviously == false){
										checkedLocations.push( [tileCol,tileRow] );
										if( doesTileFit(tileCol,tileRow,int(multiTileIndex), checkedLocations,testingIslandMapOutline,dataLookup,tileLinkData) == false){
											return false
										}										
									}
								}
							}
						}
					}
					
				} else {
					return false
				}
				
				
			} else {
				return false
			}
			return true
		}
		
		public static function placeTile(j:int,i:int,tileIndex:int, checkedLocations:Array,dataLookup:Dictionary,tileLinkData:Array):Dictionary
		{
			dataLookup[i+","+j] = tileIndex;
			
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
							
							var hasThisLocationBeenCheckedPreviously:Boolean = false;
							for (var l:int = 0 ; l < checkedLocations.length ; l++){
								if(	tileCol == checkedLocations[l][0] &&
									tileRow == checkedLocations[l][1]){
									hasThisLocationBeenCheckedPreviously = true;
								}
							}
							if(hasThisLocationBeenCheckedPreviously == false){
								checkedLocations.push( [tileCol,tileRow] );
								dataLookup = placeTile(tileCol,tileRow,int(multiTileIndex),checkedLocations,dataLookup,tileLinkData);
							}
						}
					}
				}
			}
			
			return dataLookup
		}
		
		/**
		 * 
		 * @param mainTileData
		 * @param tileLinkData
		 * @param decorationProbability input values from 0-100
		 * @return 
		 * 
		 */
		public static function generateDecorationTileMap( mainTileData:Dictionary,tilesToIgnore:Dictionary,tileLinkData:Array, decorationProbability:Number):Dictionary
		{
			
			var dataDictionary:Dictionary = new Dictionary();
			
			var linkedTiles:Dictionary = new Dictionary();
			
			for (var i:int = 0 ; i < numTilesHigh ; i++){
				for (var j:int = 0 ; j < numTilesWide ; j++){
					if( !dataDictionary[i+","+j]) {					
						if( (tilesToIgnore[i+","+j] == 0 || !tilesToIgnore[i+","+j]) ){
							var randomNumber:Number = (Math.random()*100);
							if(randomNumber  < decorationProbability){
								var refTileIndex:Number = mainTileData[i+","+j];
								//decoration tile goes here
								
								dataDictionary = placeTile(j,i,refTileIndex,[],dataDictionary,tileLinkData);
							} else {
								dataDictionary[i+","+j] = 0;
							}
						} else {
							dataDictionary[i+","+j] = 0;
						}
					}
				}
			}
			
			for (var key:Object in linkedTiles) {
				var indexArray:Array = (key as String).split(","); 
				var tileRow:Number = indexArray[0];
				var tileCol:Number = indexArray[1];
				dataDictionary[tileRow+","+tileCol] = linkedTiles[key]; 
			}
			
			return dataDictionary;
		}
		
		public static function generateSpecialTileMap( mainTileData:Dictionary, specialTileMapping:Array, specialProbability:Number):Dictionary
		{
			var dataDictionary:Dictionary = new Dictionary();
			
			for (var i:int = 0 ; i < numTilesHigh ; i++){
				for (var j:int = 0 ; j < numTilesWide ; j++){
					//check to see if there's stuff on all sides
					if( mainTileData[(i+1)+","+j] != 0 && mainTileData[(i-1)+","+j] != 0 &&
						mainTileData[(i)+","+(j+1)] != 0 && mainTileData[(i-1)+","+(j-1)] != 0){
						var randomNumber:Number = (Math.random()*100);
						if(randomNumber  < specialProbability){
							//which tile to place? mines or treasure boxes or whatever?
							// + 1 b/c LevelData.SpecialTileMapping[0] = null
							var whichSpecialTile:Number = Math.round(Math.random()*(LevelData.SpecialTileMapping.length-1))  + 1;
							if(specialTileMapping[whichSpecialTile] != null){
								dataDictionary[i+","+j] = whichSpecialTile;
							} else {
								dataDictionary[i+","+j] = 0;
							}
						} else {
							dataDictionary[i+","+j] = 0;
						}						
					} else {
						dataDictionary[i+","+j] = 0;
					}
				}
			}
			
			return dataDictionary;
		}		
		
		public static function addDictionaries(dictionaryToAdd:Dictionary, dictionaryToAddTo:Dictionary):Dictionary
		{
			for (var key:Object in dictionaryToAdd) {
				var indexArray:Array = (key as String).split(","); 
				var tileRow:Number = indexArray[0];
				var tileCol:Number = indexArray[1];
				dictionaryToAddTo[tileRow+","+tileCol] = dictionaryToAdd[key]; 
			}		
			return dictionaryToAddTo
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

		public static function convertDataDictionaryToString(dataDictionary:Dictionary):String
		{
			var dataString:String = ""; 
			//ok so now we've got a 2d array with all the indexes of tiles, make it into a string
			for (var i:int = 0 ; i < numTilesWide  ; i++){
				for (var j:int = 0 ; j < numTilesHigh ; j++){
					if(dataDictionary[i+","+j] == null){
						trace("data dictionary is messed up at: ("+i+","+j+")");
					} else {
						dataString += (dataDictionary[i+","+j] + ",");
					}
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
		
		public static function doesTileMatchSurroundingTiles(tileIndex:int, surroundingTiles:Array, tileData:Array):Boolean
		{
			var currentSurroundingTiles:Array = (tileData[tileIndex] as Array).slice(0,(tileData[tileIndex] as Array).length - 3)
			if( currentSurroundingTiles.length != surroundingTiles.length){
				return false
			} else {
				var doesContainAllTiles:Boolean = true;
				for( var i:int = 0 ; i < surroundingTiles.length ; i++){
					var doesContainThisTile:Boolean = false;
					for( var j:int = 0 ; j < currentSurroundingTiles.length ; j++){
						if( currentSurroundingTiles[j] == surroundingTiles[i] ){
							doesContainThisTile = true;
						}
					}
					if(doesContainThisTile == false ){
						doesContainAllTiles = false;	
					}
				}
				if (doesContainAllTiles == false ){
					return false
				}
			}
			return true
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
				return 0
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
 
			var numTimesTried:Number = 0;
			var maxTimesTried:Number = 50;
			var i:int = 0
			for (i = 0 ; i < (CurrentIslands.length) ; i++){
				var dx:Number = CurrentIslands[i].x - IslandToCheck.x;
				var dy:Number = CurrentIslands[i].y - IslandToCheck.y;
				var distanceToIsland:Number = Math.sqrt( dx*dx + dy*dy );
				trace("distanceToIsland:"+distanceToIsland);
				if( distanceToIsland < MinDistanceToNearestIsland){
					return false
				}
				if (numTimesTried > maxTimesTried){
					trace("Fucked, cannot generate that island");
					return false
				}
				numTimesTried++;
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