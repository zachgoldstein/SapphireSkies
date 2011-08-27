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
//			linkedObjectDictionary[1] = addSpriteToLayer(new Village(176.000,432.000,32.000,32.000,1.000,1.000,0,0,32,32,"Fortress",false,onAddCallback), Village, SpritesGroup , 176.000, 432.000, 0.000, false, 1.000, 1.000, generateProperties( { name:"image", value:"Fortress" }, { name:"isEnemy", value:false }, null ), onAddCallback );//"Village"
//			linkedObjectDictionary[3] = addSpriteToLayer(new Village(770.000,577.000,32.000,32.000,1.000,1.000,0,0,32,32,"Fortress",true,onAddCallback), Village, SpritesGroup , 770.000, 577.000, 0.000, false, 1.000, 1.000, generateProperties( { name:"image", value:"Fortress" }, { name:"isEnemy", value:true }, null ), onAddCallback );//"Village"
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
