package zachg.windows
{
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	
	import zachg.PlayerStats;
	import zachg.gameObjects.BuildingGroup;
	import zachg.gameObjects.PlayerGroup;
	import zachg.growthItems.GrowthItem;
	import zachg.growthItems.buildingItem.BuildingItem;
	
	public class GrowthItemDisplay extends Sprite
	{
		public var background:Panel;
		public var label:Label;
		public var growthItem:GrowthItem;
		
		public var purchaseButton:PushButton;
		
		public var textDescription:Text;
		public var costLabel:Label;
		public var callBack:Function
		
		public function GrowthItemDisplay(GrowthItemPassed:GrowthItem, CallBack:Function)
		{
			super();
			growthItem = GrowthItemPassed;
			callBack = CallBack;
			
			background = new Panel(this,0,0);
			background.height = 110;
			background.width = 150;
			label = new Label(background,5,0,"Testing Title");
			label.text = growthItem.growthItemTitle;
			
			
			var testPanel:Panel =new Panel(background,5,15);
			testPanel.width = 50;
			testPanel.height = 50;
			if(GrowthItemPassed.iconName != ""){
				var icon:Bitmap = new Resources[GrowthItemPassed.iconName]();
				addChild(icon);
				icon.x = 8;
				icon.y = 18;
				icon.width = 47;
				icon.height = 47;
			}
			
			textDescription = new Text(background,60,15,"Testing...........................................................................................");
			textDescription.width = 85;
			textDescription.height = 50;
			textDescription.text = growthItem.description;
			textDescription.editable = false;
			
			costLabel = new Label(background,150/2-50/2,100-30,"Cost: ");
			costLabel.text = "Cost: "+growthItem.clarityPtsRequired;
			
			purchaseButton = new PushButton(background,150/2-60/2,100-15,"Buy",purchaseItem);
			purchaseButton.width = 60;
			if( growthItem.isPurchased == true){
				purchaseButton.label = "Purchased";
			}
			
			if(growthItem.isPurchased == true){
				purchaseButton.enabled = false;
			}
		}
		
		public function purchaseItem(e:MouseEvent=null):void
		{
			if( PlayerStats.currentPlayerDataVo.currentCurrency >= growthItem.clarityPtsRequired){
				
				//TODO fix this dirty hack to get the window to update after a change to the player's current XP.
				//NOTE that, when FlxG.framerate = 0, the update does not register until the framerate resumes.
				
				growthItem.isPurchased = true;
				purchaseButton.enabled = false;
				
				PlayerStats.currentPlayerDataVo.currentCurrency -= growthItem.clarityPtsRequired;
				(PlayerStats.currentPlayerDataVo.growthItemsPurchased as Array).push( PlayerStats.getGrowthItemId(growthItem.description) );
				PlayerStats.saveCurrentPlayerData();
				
				//No point in loading upgrades into items, since we're not in the playState
/*				if( (growthItem is BuildingItem) ){
					
					var buildings:FlxGroup = (FlxG.state as PlayState).buildings;
					for (var i:int = 0; i < buildings.members.length ; i++){
						if( (buildings.members[i] as BuildingGroup).isEnemy == ((FlxG.state as PlayState).player as PlayerGroup).isEnemy ){
							(buildings.members[i] as BuildingGroup).loadPropertyMapping( (growthItem as BuildingItem).propertyMapping );
						} 
					} 
				}
*/				purchaseButton.label = "Purchased";
				callBack();
			}
		}		
		
	}
}