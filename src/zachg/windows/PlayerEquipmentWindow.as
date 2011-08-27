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
	import zachg.growthItems.playerItem.PlayerItem;
	
	public class PlayerEquipmentWindow extends Sprite
	{
		
		public var background:Window;
		public var closeButton:PushButton;
		
		public var closeCallBack:Function
		
		public var currentAvailableXP:Label;
		
		public var playerGrowthItemsLabel:Label; 
		
		public var playerGrowthItemDisplays:Vector.<GrowthItemDisplay> = new Vector.<GrowthItemDisplay>();
		
		public var warningLabel1:Label;
		public var warningLabel2:Label;
		
		//TODO: re-work whole class to handle more than 3 items
		
		public function PlayerEquipmentWindow(CloseCallBack:Function = null)
		{
			super();
			closeCallBack = CloseCallBack
			
			background = new Window(this,0,0,"View Growth Items");
			background.width = 160;
			background.height = 410;
			background.draggable = false;
			closeButton = new PushButton(this,105,3,"Close",close);
			closeButton.width = 50;
			closeButton.height = 14;
			
			warningLabel1 = new Label(this,5,410-25,"Purchased items don't come ");
			warningLabel2 = new Label(this,5,410-15,"into effect until level restarted");

			currentAvailableXP = new Label(this,5,30,"Current Available XP to spend: ");
			currentAvailableXP.text = "Current Available XP to spend: ";
			
			//player upgrade display
			playerGrowthItemsLabel = new Label(this,5,20,"Player Upgrades:");
			var playerGrowthItems:Vector.<PlayerItem> = PlayerStats.getAllPlayerItems();
			for(var i:int = 0 ; i < playerGrowthItems.length ; i++){
				var growthItemDisplay:GrowthItemDisplay = new GrowthItemDisplay(playerGrowthItems[i],refresh);
				addChild(growthItemDisplay);
				growthItemDisplay.x = playerGrowthItemsLabel.x;
				growthItemDisplay.y = playerGrowthItemsLabel.y + i*(growthItemDisplay.height + 10) + 25;
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