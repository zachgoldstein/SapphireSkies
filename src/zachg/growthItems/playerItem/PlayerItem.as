package zachg.growthItems.playerItem
{
	import zachg.components.maps.Mapping;
	import zachg.growthItems.GrowthItem;

	public class PlayerItem extends GrowthItem
	{
		
		public var requiredResearch:Number = 200;
		public var researchProgress:Number = 0;
		public var isFullyResearched:Boolean = false;
		public var isWeapon:Boolean = false;
		
		//Needed to rebuild the class after getting it from a local shared object
		public var explicitClassName:String = "PlayerItem";		
		
		public var weaponMapping:Mapping;
		public var playerMapping:Mapping;
		
		public var tutorialTipData:Array;
		
		public function PlayerItem(Id:int)
		{
			id = Id;
		}
	}
}