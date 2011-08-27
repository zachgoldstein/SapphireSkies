package zachg.windows
{
	import com.PlayState;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.flixel.FlxG;
	
	import zachg.PlayerStats;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.PopulationCenter;
	import zachg.gameObjects.Shop;
	import zachg.growthItems.buildingItem.BuildingItem;
	import zachg.growthItems.playerItem.PlayerItem;
	
	public class GrowthItemWindow extends Sprite
	{
		
		public var background:Window;
		public var closeButton:PushButton;
		
		public var closeCallBack:Function
		
		public var currentAvailableXP:Label;
		
		public var shopGrowthItemsLabel:Label;
		public var popCenterGrowthItemsLabel:Label;
		public var factoryGrowthItemsLabel:Label;
		
		public var playerGrowthItemDisplays:Vector.<GrowthItemDisplay> = new Vector.<GrowthItemDisplay>();
		
		public function GrowthItemWindow(CloseCallBack:Function = null)
		{
			super();
			closeCallBack = CloseCallBack
			
			background = new Window(this,0,0,"View Growth Items");
			background.width = 480;
			background.height = 400;
			background.draggable = false;
			closeButton = new PushButton(this,480-55,3,"Close",close);
			closeButton.width = 50;
			closeButton.height = 14;

			currentAvailableXP = new Label(this,background.width/2 - 50,3,"Current Available XP to spend: ");
			currentAvailableXP.text = "Current Available XP to spend: ";
			
			//shop upgrade display
			shopGrowthItemsLabel = new Label(this,5,20,"Research Lab Upgrades:");
			
			var shopGrowthItems:Vector.<BuildingItem> = PlayerStats.getAllGrowthItemsForBuilding(Shop);
			for(var i:int = 0 ; i < shopGrowthItems.length ; i++){
				var growthItemDisplay:GrowthItemDisplay = new GrowthItemDisplay(shopGrowthItems[i],refresh);
				addChild(growthItemDisplay);
				growthItemDisplay.x = shopGrowthItemsLabel.x;
				growthItemDisplay.y = shopGrowthItemsLabel.y + i*(growthItemDisplay.height + 10) + 25;
			}
			//population center upgrade display
			popCenterGrowthItemsLabel = new Label(this,160,20,"Population Center Upgrades:");
			
			var popCenterGrowthItems:Vector.<BuildingItem> = PlayerStats.getAllGrowthItemsForBuilding(PopulationCenter);
			for(var i:int = 0 ; i < popCenterGrowthItems.length ; i++){
				var growthItemDisplay:GrowthItemDisplay = new GrowthItemDisplay(popCenterGrowthItems[i],refresh);
				addChild(growthItemDisplay);
				growthItemDisplay.x = popCenterGrowthItemsLabel.x;
				growthItemDisplay.y = popCenterGrowthItemsLabel.y + i*(growthItemDisplay.height + 10) + 25;
			}
			//factory upgrade display
			factoryGrowthItemsLabel = new Label(this,315,20,"Factory Upgrades:");
			
			var factoryGrowthItems:Vector.<BuildingItem> = PlayerStats.getAllGrowthItemsForBuilding(Factory);
			for(var i:int = 0 ; i < factoryGrowthItems.length ; i++){
				var growthItemDisplay:GrowthItemDisplay = new GrowthItemDisplay(factoryGrowthItems[i],refresh);
				addChild(growthItemDisplay);
				growthItemDisplay.x = factoryGrowthItemsLabel.x;
				growthItemDisplay.y = factoryGrowthItemsLabel.y + i*(growthItemDisplay.height + 10) + 25;
			}
		
			
			
		}
		
		public function close(e:MouseEvent):void
		{
			closeCallBack();
		}
		
		public function refresh():void
		{
			currentAvailableXP.text = "Current Available XP to spend: "+(FlxG.state as PlayState).player.levelComponent.totalExperience;
		}
	}
}