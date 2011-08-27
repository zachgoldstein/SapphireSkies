package zachg.ui.dialogues
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
	import zachg.ui.MoneyDisplay;
	
	
	
	public class EquipItemDisplay extends Sprite
	{
		public var background:Panel;
		public var label:Label;
		public var isEquippedLabel:Label;
		public var growthItem:GrowthItem;
		
		public var _isEquip:Boolean = false;
		
		public var equipButton:PushButton;
		public var icon:Bitmap;
		
		public var textDescription:Text;
		public var textWeaponListing:Text;
		
		public var costLabel:Label;
		public var currentMoney:MoneyDisplay;
		public var callBack:Function;
		
		public var equippableIcon:*;
		public var equippedGraphic:* = new Resources.UIHangarEquippedOff();
		public var equipGraphicOn:* = new Resources.UIHangarEquipOn();
		public var equipGraphicOff:* = new Resources.UIHangarEquipOff();		
		public var equipRollGraphic:* = new Resources.UIHangarEquipRoll();
		public var purchaseGraphicOn:* = new Resources.UIHangarPurchaseOn();
		public var purchaseGraphicOff:* = new Resources.UIHangarPurchaseOff();		
		public var purchaseRollGraphic:* = new Resources.UIHangarPurchaseRoll();
		public var moneyBackground:* = new Resources.UIMoneyBackground();
		public var rupee:*;
		public var hintIcon:*;	
		public var currentItemIcon:*;
		
		public function EquipItemDisplay(GrowthItemPassed:GrowthItem, showButton:Boolean, isEquip:Boolean, isCurrentlyEquipped:Boolean, CallBack:Function = null)
		{
			super();
			growthItem = GrowthItemPassed;
			callBack = CallBack;
			
			_isEquip = isEquip;
			
			background = new Panel(this,0,0);
			background.width = 300;
			background.height = 300;
			background.visible = false;
			label = new Label(this,60,5,"Testing Title","MenuFont", 16, 0xf7f7ed);
			
			textWeaponListing = new Text(this,60,30,"Weapon 1. \n Weapon 2.","system", 8, 0xf7f7ed,false);
			textWeaponListing.width = 237;
			textWeaponListing.height = 35;
			textWeaponListing.editable = false;
			textWeaponListing.selectable = false;
			
			textDescription = new Text(this,5,70,"Testing...... /n Testing...... Testing...... Testing...... Testing...... Testing...... Testing...... Testing...... "
				,"system", 8, 0xf7f7ed,false);
			textDescription.width = 285;
			textDescription.height = 133;
			textDescription.editable = false;
			textDescription.selectable = false;
			
			equippableIcon = new Resources.UIHangarEquippableIcon();
			addChild(equippableIcon);
			equippableIcon.x = 5;
			equippableIcon.y = 5;

/*			equipButton = new PushButton(this,80,208,"",equipUnequipItem,
				duplicateDisplayObject(equipGraphicOn),null,duplicateDisplayObject(equipRollGraphic)
			);
*/			moneyBackground = new Resources.UIMoneyBackground();
			addChild(moneyBackground)
			moneyBackground.x = 80;
			moneyBackground.y = 180
			currentMoney = new MoneyDisplay();
			currentMoney.x = 19 + 80;
			currentMoney.y = 3 + 180;
			addChild(currentMoney);
			rupee = new Resources.UIRupeeLarge();
			rupee.x = 7 + 80;
			rupee.y = 7 + 180;
			addChild(rupee);			
			
			textDescription.height -= 30;
			
			costLabel = new Label(this,45,185,"Cost: ","MenuFont", 16, 0xf7f7ed);
/*			equipButton = new PushButton(this,80,208,"",purchase,
				duplicateDisplayObject(purchaseGraphicOn),null,duplicateDisplayObject(purchaseRollGraphic)
			);						
*/			
			if(growthItem == null){
				label.text = "------------------";
				//equipButton.enabled = false;
			} else {
				//equipButton.enabled = true;
				setItem(growthItem);
			}		
			
		}
		
		public function setItem(item:GrowthItem):void
		{
			if(item == null){
				label.text = "Nothing Selected";
				textWeaponListing.text = "Select an item from the list on the right to view more informaiton about it"; 
				textDescription.text = "You can also click on the hangar to view information about the currently equipped ship. \n \n " +
					"Use the equip and purchase buttons in the top right to toggle between viewing the available ships you can buy and the ships you can equip.";
				if(icon != null){
					icon.alpha = 0;
				}
			} else {
				label.text = item.growthItemTitle;
				textWeaponListing.text = item.weaponListing;
				textDescription.text = item.description;
				if(icon != null){
					removeChild(icon);
				}
				if(item.iconName != ""){
/*					icon = new Resources[item.iconName]();
					icon.x = 8;
					icon.y = 18;
					icon.width = 47;
					icon.height = 47;			
					addChild(icon);
					
					icon.alpha = 1;*/
				}
					
				if(currentItemIcon != null){
					removeChild(currentItemIcon);
				}
					
				if( PlayerStats.isUpgradePurchased(item.id) ){
					moneyBackground.visible = false;
					currentMoney.visible = false;
					rupee.visible = false;
					costLabel.visible = false;
					var equipIcon:* = new Resources.UIHangarEquippableIcon();
					addChild(equipIcon);
					equipIcon.x = 5;
					equipIcon.y = 5;					
					if(equipButton != null){
						removeChild(equipButton);
					}					
					if(PlayerStats.currentPlayerDataVo.currentPlayerEquip == item.id){
						currentItemIcon = new Resources.UIHangarCurrentIcon();
						equipButton = new PushButton(this,80,208,"",equipUnequipItem,
							duplicateDisplayObject(equippedGraphic)
						);
						equipButton.enabled = false;
					} else {
						currentItemIcon = new Resources.UIHangarEquipIcon();
						equipButton = new PushButton(this,80,208,"",equipUnequipItem,
							duplicateDisplayObject(equipGraphicOn),null,duplicateDisplayObject(equipRollGraphic)
						);
						equipButton.enabled = true;
					}
				} else {
					moneyBackground.visible = true;
					currentMoney.visible = true;
					rupee.visible = true; 		
					costLabel.visible = false;
					currentItemIcon = new Resources.UIHangarPurchaseIcon();
					var standardIcon:* = new Resources.UIHangarStandardIcon();
					addChild(standardIcon);
					standardIcon.x = 5;
					standardIcon.y = 5;					
					if(equipButton != null){
						removeChild(equipButton);
					}										
					equipButton = new PushButton(this,80,208,"",purchase,
						duplicateDisplayObject(purchaseGraphicOn),null,duplicateDisplayObject(purchaseRollGraphic)
					);

					if(PlayerStats.currentPlayerDataVo.currentCurrency >= item.clarityPtsRequired){
						equipButton.enabled = true;
					} else {
						equipButton.enabled = false;
					}
				}

				if(item.growthItemTitle == ""){
					var shipIconOverlay:* = new Resources.UITutorialIcon();
				} else {
					var shipIconOverlay:* = new Resources[item.iconName]();
				}
				addChild(shipIconOverlay);
				shipIconOverlay.x = 5;
				shipIconOverlay.y = 5;								

				currentItemIcon.x = 220;
				currentItemIcon.y = 5;
				addChild(currentItemIcon);
				
				if(costLabel != null){
					currentMoney.setMoney(String(item.clarityPtsRequired));
				}
			}
			if(item == null){
				var standardIcon:* = new Resources.UIHangarStandardIcon();
				addChild(standardIcon);
				standardIcon.x = 5;
				standardIcon.y = 5;	
				hintIcon = new Resources.UITutorialIcon();
				addChild(hintIcon);
				hintIcon.x = 12;
				hintIcon.y = 12;
			}				
		}
		
		public function purchase(e:MouseEvent = null):void
		{
			callBack();
		}
		
		public function equipUnequipItem(e:MouseEvent=null):void
		{
//			if(growthItem.isEquipped == true){
//				equipButton.label = "Equip";
//			} else {
//				equipButton.label = "Unequip";
//			}
			callBack();
		}		
		
	}
}