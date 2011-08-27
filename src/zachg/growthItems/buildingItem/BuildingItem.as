package zachg.growthItems.buildingItem
{
	import zachg.components.maps.Mapping;
	import zachg.growthItems.GrowthItem;

	public class BuildingItem extends GrowthItem
	{
		
		public var buildingLevelRequired:Number = 0;
		
		public var buildingType:Class;
		
		//TODO: separating into another set of mapping objects seems stupid. Fix this
		public var propertyMapping:Mapping;
		
		//Needed to rebuild the class after getting it from a local shared object
		public var explicitClassName:String = "BuildingItem";		
		
		public function BuildingItem()
		{
		}
		
	}
}