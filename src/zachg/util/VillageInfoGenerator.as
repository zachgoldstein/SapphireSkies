package zachg.util
{
	public class VillageInfoGenerator
	{
		public function VillageInfoGenerator()
		{
		}
		
		public static function generateName(isEnemy:Boolean):String
		{
			var name:String = "";
			if(isEnemy == true){
				name += enemyVillagePrefixes[Math.round(Math.random()*(enemyVillagePrefixes.length-1))];
				name += enemyVillageSuffixes[Math.round(Math.random()*(enemyVillageSuffixes.length-1))];
			} else {
				name += friendlyVillagePrefixes[Math.round(Math.random()*(friendlyVillagePrefixes.length-1))];
				name += friendlyVillageSuffixes[Math.round(Math.random()*(friendlyVillageSuffixes.length-1))];				
			}
			return name;
		}
		
		public static function generatePopulation(villageTier:Number):Number
		{
			var population:Number = Math.round((villageTier*villageTier*100)*Math.random() + villageTier*100);
			return population
		}
		
		public static var friendlyVillagePrefixes:Array = [		
		"Garden","Forest","Maple","Spring","River","Green","Fern",
		"Clover","Honey","Pine","Olive","Azure","Cyan","Sunny","Oak",
		"Water","Lily","Dove","Flower"
		];
		public static var friendlyVillageSuffixes:Array = [
		"glen","grove","glade","field","meadows","ridge","hope",
		"lea","llyn","dale","crest","vale","haven","valley"
		]

		public static var enemyVillagePrefixes:Array = [
		"Stone","Barron","Shackle","Drum","Lard","Hoard",
		"Forge","Oil","Dim","Wilting","Darth","Rusting",
		"Lock","Shun","Strong","Bone","Swine","Iron","Rot",
		"Grim","Wrath"
		]
		
		public static var enemyVillageSuffixes:Array = [
		"wick","treath","thorp","ham","stow","shaw","mouth",
		"law","fort","ford","forth","caster","burg","borough",
		"burn","ton","shire","gate","wart"
		]
		
	}
}