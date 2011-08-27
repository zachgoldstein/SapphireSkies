package zachg.growthItems.buildingItem
{
	import zachg.components.maps.Mapping;
	import zachg.components.maps.PopulationCenterPopBoostMapping;
	import zachg.gameObjects.PopulationCenter;
	import zachg.growthItems.GrowthItem;

	public class PopulationCenterPopBoostItem extends BuildingItem
	{

		public function PopulationCenterPopBoostItem()
		{
			
			propertyMapping = new PopulationCenterPopBoostMapping();
			buildingType = PopulationCenter;
			buildingLevelRequired = 0;
			playerXPRequired = 100;
			growthItemTitle = "Population Boost";
			description = "Create people at a faster rate."
			iconName = "Apartment";
		}
		
	}
}