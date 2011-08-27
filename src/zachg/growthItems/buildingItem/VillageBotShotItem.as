package zachg.growthItems.buildingItem
{
	import zachg.components.maps.FactoryPeopleBoostMapping;
	import zachg.components.maps.FactoryResourceBoostMapping;
	import zachg.components.maps.Mapping;
	import zachg.components.maps.PopulationCenterPopBoostMapping;
	import zachg.components.maps.PopulationCenterUnitRateBoostMapping;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.PopulationCenter;
	import zachg.gameObjects.Shop;
	import zachg.gameObjects.Village;
	import zachg.growthItems.GrowthItem;

	public class VillageBotShotItem extends BuildingItem
	{

		public function VillageBotShotItem()
		{
			
			propertyMapping = new Mapping();
			propertyMapping.properties.botShotBonus = 25;
			buildingType = Village;
			buildingLevelRequired = 0;
			clarityPtsRequired = 10;
			growthItemTitle = "Unit Damage";
			description = "Units do more damage."
			iconName = "Fortress";
			
		}
		
	}
}