package zachg.windows
{
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.senocular.display.duplicateDisplayObject;	
	
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
	import zachg.states.SaveLoadState;
	
	public class SaveLoadSlotDisplay extends Sprite
	{
		public var label:Label;
		public var growthItem:GrowthItem;
		
		public var purchaseButton:PushButton;
		
		public var textDescription:Text;
		public var costLabel:Label;
		public var callBack:Function;
		
		public var data:Object;
		public var saveSlot:int;
		
		public function SaveLoadSlotDisplay(isCurrentPlayerSlot:Boolean = false,isLoadedSlot:Boolean=false, dataObject:Object=null, SaveSlot:int=-1)
		{
			super();
			data = dataObject;
			saveSlot = SaveSlot;
			
			//Image icon goes here...
			var standardIcon:* = new Resources.UIHangarStandardIcon();
			addChild(standardIcon);				
			var shipIconOverlay:* = new Resources.UIHangarDefaultShipIcon()
			addChild(shipIconOverlay);
			
//			if(GrowthItemPassed.iconName != ""){
//				var icon:Bitmap = new Resources[GrowthItemPassed.iconName]();
//				addChild(icon);
//				icon.x = 8;
//				icon.y = 18;
//				icon.width = 47;
//				icon.height = 47;
//			}
			
			var saveInfoLabel:Label = new Label(this,57,10,"", "system",8,0xffffcc);
			var itemTitle:Label = new Label(this,57,0,"Slot "+saveSlot+" is open","system",8,0xffffcc);
			
			if(dataObject != null){
				if(dataObject.currentPlayerName != ""){
					itemTitle.text = dataObject.currentPlayerName+ "'s data","system";
				} else {
					itemTitle.text = "Captain McNoname's data","system";
				}
				saveInfoLabel.text = 	Math.round(dataObject.totalCashBalance)+"$, "+
										(dataObject.levelsUnlocked as Array).length + " levels, "+
										(dataObject.growthItemsPurchased as Array).length + " ships";
			} else {
				itemTitle.text = "Slot "+saveSlot+" is open","system";
			}
			
			var smallButtonOn:* = new Resources.UISmallButtonBackgroundOff();
			var smallButtonRoll:* = new Resources.UISmallButtonBackgroundRoll();
			
			if(isCurrentPlayerSlot == true){
				var saveGameButton:PushButton = new PushButton(this,57,25,"Save",saveGame,
					duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
					"MenuFont",15,0xffffcc);
				saveGameButton.width = 50;
				saveGameButton.height = 12;				
				var currentGameIndicator:Label = new Label(this,57,40,"(Current game data)","system",8,0xffffcc);				
			}
			var startNewGameButton:PushButton = new PushButton(this,117,25,"New",startNewGame,
				duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
				"MenuFont",15,0xffffcc);
			startNewGameButton.width = 50;
			startNewGameButton.height = 12;				
			
			if(isLoadedSlot == true){
				//var warningLabel:Label = new Label(this,230,60,"WARNING: Erases data in this slot"); 
				if(isCurrentPlayerSlot == false){
					var loadGameButton:PushButton = new PushButton(this,174,25,"Load",loadGame,
						duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
						"MenuFont",15,0xffffcc);
					loadGameButton.width = 50;
					loadGameButton.height = 12;
				}
			}

			if(isCurrentPlayerSlot == false && isLoadedSlot == false){
				itemTitle.text = "Empty Save Slot";
			}
		}
		
		public function saveGame(e:MouseEvent):void
		{
			PlayerStats.saveCurrentPlayerData();
		}
		
		public function loadGame(e:MouseEvent):void
		{
			PlayerStats.loadCurrentPlayerData(saveSlot);
			FlxG.state = new SaveLoadState();
		}
		
		public function startNewGame(e:MouseEvent):void
		{
			if(data == null){
				PlayerStats.newGame(saveSlot);
			} else {
				PlayerStats.newGame(data.slotLocation);
			}
			FlxG.state = new SaveLoadState();
		}		
		
	}
}