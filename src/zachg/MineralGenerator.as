package zachg
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.flixel.FlxTilemap;
	
	import zachg.minerals.Bones;
	import zachg.minerals.Diasporium;
	import zachg.minerals.Dicktite;
	import zachg.minerals.Dirt;
	import zachg.minerals.Exceediplutoriumite;
	import zachg.minerals.Excelsitrove;
	import zachg.minerals.Gadolinite;
	import zachg.minerals.GamecubeControl;
	import zachg.minerals.Gold;
	import zachg.minerals.Gretzky;
	import zachg.minerals.Hydrogrossular;
	import zachg.minerals.IceCube;
	import zachg.minerals.Iron;
	import zachg.minerals.JeremyClarkson;
	import zachg.minerals.Karaoke;
	import zachg.minerals.Kyanite;
	import zachg.minerals.Landfill;
	import zachg.minerals.Mormite;
	import zachg.minerals.Potatoe;
	import zachg.minerals.Tanzanite;
	import zachg.minerals.Tibonium;
	import zachg.minerals.Titanite;
	import zachg.minerals.Unobtanium;
	import zachg.minerals.Whiskey;
	import zachg.minerals.Worms;
	import zachg.minerals.Yttrium;
	import zachg.util.LevelData;

	/**
	 * Generates a mineral with value based on the current tilemap's MineralValue  
	 * @author zachgoldstein
	 * 
	 */
	public class MineralGenerator extends Object
	{			
			private var minRupeeValue:Number = 5;
			private var maxRupeeValue:Number = 50;
			private var minResourceValue:Number = 2;
			private var maxResourceValue:Number = 50;
			private var randomVariationAmount:Number = 10;
			
			public var possibleMinerals:Vector.<Mineral> = new Vector.<Mineral>();
			public var mineralWeights:Array = new Array();
			
			public function MineralGenerator()
			{
				possibleMinerals.push(
					new Dirt(),
					new Iron(),
					new Gold(),
					new Landfill(),
					new Worms(),
					new Tibonium(),
					new Mormite(),
					new Potatoe(),
					new Karaoke(),
					new IceCube()
				); 
			}
			
			public function generateMineral(tileMap:FlxTilemap):Mineral
			{
				//set mineral values appropriately
				var currentMinerals:Array = new Array();
				var percentageLevelFromEnd:Number = PlayerStats.currentLevelId/LevelData.LevelCreationData.length; 
				for (var i:int = 0 ; i < possibleMinerals.length ; i++){
					var ClassName:String = getQualifiedClassName(possibleMinerals[i]);
					var ClassReference:Class = getDefinitionByName(ClassName) as Class;
					var newMineral:Mineral = new ClassReference();
					newMineral.rupeeValue = Math.round(minRupeeValue + (newMineral.rupeeValue/10)*(maxRupeeValue-minRupeeValue)*(percentageLevelFromEnd) + Math.random()*randomVariationAmount);
					newMineral.resourceValue = Math.round(minResourceValue + (newMineral.resourceValue/10)*(maxResourceValue-minResourceValue)*(percentageLevelFromEnd) + Math.random()*(randomVariationAmount/10));
					currentMinerals.push(newMineral);
				}
				
				//FIX THIS
				if(tileMap.dataObject["MineralValue"] != null){
					var mineralValue:Number = tileMap.dataObject["MineralValue"];
/*					var extraMinerals:int = possibleMinerals.length - LevelData.LevelCreationData.length;
					var startIndex:int = PlayerStats.currentLevelId;
					var endIndex:int = startIndex + extraMinerals;
					if(endIndex > possibleMinerals.length){
						endIndex = possibleMinerals.length-1;
						startIndex = (possibleMinerals.length-1) - extraMinerals;
					}
*/					var weights:Array = new Array();
					for( var i:int = 0 ; i < possibleMinerals.length ; i++){
						weights.push( possibleMinerals[i].probability );
					}
					//mineralWeights = generateWeights(mineralValue);
					
					return currentMinerals[randomIndexByWeights(weights)];
				}
				return null
			}
			
			public function generateWeights(levelMineralValue:Number):Array{
				
				var mineralWeights:Array = new Array();
				for(var i:int = 0 ; i < possibleMinerals.length ; i++){
					var mineralProbability:Number =  possibleMinerals[i].probability;
					mineralWeights.push(mineralProbability);
				}
				return mineralWeights
			}
			
			/**
			 * Takes an array of weights, and returns a random index based on the weights
			 */
			private function randomIndexByWeights( weights:Array ) : int
			{
				// add weights
				var weightsTotal:Number = 0;
				for( var i:int = 0; i < weights.length; i++ ) weightsTotal += weights[i];
				// pick a random number in the total range
				var rand:Number = Math.random() * weightsTotal;
				// step through array to find where that would be 
				weightsTotal = 0;
				for( i = 0; i < weights.length; i++ )
				{
					weightsTotal += weights[i];
					if( rand < weightsTotal ) return i;
				}
				// if random num is exactly = weightsTotal
				return weights.length - 1;
			}			
			
	}
}