/**
 * ListItem.as
 * Keith Peters
 * version 0.9.7
 * 
 * A single item in a list. 
 * 
 * Copyright (c) 2010 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


package  zachg.ui
{
	import com.Resources;
	import com.bit101.components.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import zachg.PlayerStats;
	import zachg.growthItems.GrowthItem;
	
	public class UpgradeListItem extends Component
	{
		protected var _data:Object;
		protected var _label:Label;
		protected var _defaultColor:uint = 0x3333ff;
		protected var _selectedColor:uint = 0x3333ff;
		protected var _selectedColorPremium:uint = 0x685e2b;
		protected var _rolloverColor:uint = 0x9999ff;
		protected var _rolloverColorPremium:uint = 0xb2a14b;

		protected var _selected:Boolean;
		protected var _mouseOver:Boolean = false;
		protected var _backgroundOverlay:Sprite = new Sprite();
		
		protected var itemDescription:Text;
		protected var itemWeaponList:Text;
		protected var picBackground:Panel;
		protected var pic:*;
		protected var costLabel:Label;
		protected var costRupee:* = new Resources.UIRupeeSmall();
		protected var currentItemIcon:*;
		
		public var _isPurchaseList:Boolean = false
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ListItem.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param data The string to display as a label or object with a label property.
		 */
		public function UpgradeListItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, passedData:Object = null)
		{
			data = passedData;
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initilizes the component.
		 */
		protected override function init() : void
		{
			super.init();
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			setSize(100, 20);
		}

		/**
		 * Extra var in constructor doesn't get in, so we need to set it on the created object and call this after.
		 */
		public function initListItem() : void
		{
			super.init();
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			setSize(100, 20);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren() : void
		{
			super.addChildren();
			_backgroundOverlay = new Sprite();
			addChild(_backgroundOverlay);
			_backgroundOverlay.alpha = .5;
			_backgroundOverlay.addEventListener(MouseEvent.CLICK, mouseClick);
			
			_label = new Label(this, 60, 0,"","MenuFont",16, 0xf7f7ed);
			_label.addEventListener(MouseEvent.CLICK, mouseClick);
//			picBackground = new Panel(this,5,5);
//			picBackground.addEventListener(MouseEvent.CLICK, mouseClick);
//			picBackground.width = 45;
//			picBackground.height = 40;
//			picBackground.visible = false;
			itemWeaponList = new Text(this,60,20,"","system",8, 0xf7f7ed,false);
			itemWeaponList.selectable = false;
			itemWeaponList.editable = false;
			itemWeaponList.visible = false;
			itemWeaponList.addEventListener(MouseEvent.CLICK, mouseClick);
			
			itemDescription = new Text(this,5,45,"","system",8, 0xf7f7ed,false);
			itemDescription.selectable = false;
			itemDescription.editable = false;
			itemDescription.visible = false;
			itemDescription.text = "Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing";
			itemDescription.addEventListener(MouseEvent.CLICK, mouseClick);
			
			costLabel = new Label(this,70,80,"","system",8, 0xf7f7ed);
			costLabel.visible = false;
			costLabel.addEventListener(MouseEvent.CLICK, mouseClick);
			addChild(costRupee)
			costRupee.x = costLabel.x + 27;
			costRupee.y = costLabel.y + 3;
			costRupee.addEventListener(MouseEvent.CLICK, mouseClick);
			
			if(_isPurchaseList == true){
				currentItemIcon = new Resources.UIHangarPurchaseIcon();
			} else {
				if (PlayerStats.currentPlayerDataVo.currentPlayerEquip == (_data as GrowthItem).id ){
					currentItemIcon = new Resources.UIHangarCurrentIcon();
				} else {
					currentItemIcon = new Resources.UIHangarEquipIcon();
				}
			}
			currentItemIcon.x = 60;
			currentItemIcon.y = 20;
			addChild(currentItemIcon);
			
			if(_isPurchaseList == true){
				costLabel.visible = true;
				costRupee.visible = true;				
			} else {
				costLabel.visible = false;
				costRupee.visible = false;
			}
			
            _label.draw();
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		public function mouseClick(e:MouseEvent = null):void
		{
			dispatchEvent(new Event(MouseEvent.CLICK) );
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		public override function draw() : void
		{
			super.draw();
			_backgroundOverlay.graphics.clear();

			itemDescription.width = width - 20;
			if(_isPurchaseList == true){
				itemDescription.height = height - 60;
			} else {
				itemDescription.height = height - 40;
			}
			
			itemWeaponList.width = width - 70;
			itemWeaponList.height = 30;
				
			if(_selected)
			{
				_backgroundOverlay.graphics.beginFill(_selectedColor);
				if(_data is GrowthItem){
					if( (_data as GrowthItem).isPremium == true){
						_backgroundOverlay.graphics.beginFill(_selectedColorPremium);
					}
				}
			}
			else if(_mouseOver)
			{
				_backgroundOverlay.graphics.beginFill(_rolloverColor);
				if(_data is GrowthItem){
					if( (_data as GrowthItem).isPremium == true){
						_backgroundOverlay.graphics.beginFill(_rolloverColorPremium);
					}
				}
			}
			_backgroundOverlay.graphics.drawRect(0, 0, width-12, height);
			_backgroundOverlay.graphics.endFill();

            if(_data == null || _data == ""){
				if(pic != null){
					removeChild(pic);
					pic.visible = false;
					pic = null;
				}
				itemDescription.visible = false;
				_label.visible = false;
				if( costLabel != null){
					costLabel.visible = false;
					costRupee.visible = false;
				}
				
				return;
			} 

			if(_data is String)
			{
                _label.text = _data as String;
			}
			else if(_data.hasOwnProperty("label") && _data.label is String)
			{
				_label.text = _data.label;
			}
			else if(_data is GrowthItem)
			{
				_label.text = (_data as GrowthItem).growthItemTitle;
				_label.visible = true;
				costLabel.text = "";
				if(itemDescription.text != (_data as GrowthItem).simpleDescription){
					itemDescription.text = (_data as GrowthItem).simpleDescription;
				}
				if(itemWeaponList.text != (_data as GrowthItem).weaponListing){
					itemWeaponList.text = (_data as GrowthItem).weaponListing;
				}
				if(costLabel != null){
					if(_isPurchaseList == true){
						costLabel.visible = true;
						costLabel.text = "Cost:   "+(_data as GrowthItem).clarityPtsRequired;
					} else {
						costLabel.visible = false;
						costLabel.text = "";
					}
				}
				itemDescription.visible = true;
				//itemWeaponList.visible = true;
				
				if(pic != null){
					removeChild(pic);
					pic = null;
				}				
				if(_data is GrowthItem){
					if(_isPurchaseList == false){
						pic = new Resources.UIHangarEquippableIcon();
						addChild(pic);
						pic.x = 5;
						pic.y = 5;
					} else {
						if((_data as GrowthItem).isPremium == true){
							pic = new Resources.UIHangarPremiumcon();
							addChild(pic);
							pic.x = 5;
							pic.y = 5;
						} else {
							pic = new Resources.UIHangarStandardIcon();
							addChild(pic);
							pic.x = 5;
							pic.y = 5;						
						}
					}
				} else {
					pic = new Resources.UIHangarStandardIcon();
					addChild(pic);
					pic.x = 5;
					pic.y = 5;						
				}
				if((_data as GrowthItem).iconName != ""){
					var shipIconOverlay:* = new Resources[(_data as GrowthItem).iconName]();
					addChild(shipIconOverlay);
					shipIconOverlay.x = 5;
					shipIconOverlay.y = 5;	
					shipIconOverlay.addEventListener(MouseEvent.CLICK, mouseClick);
				}
				
				pic.visible = true;
				pic.addEventListener(MouseEvent.CLICK, mouseClick);
				
				if(currentItemIcon != null){
					currentItemIcon.removeEventListener(MouseEvent.CLICK, mouseClick);
					removeChild(currentItemIcon);
				}
				if(_isPurchaseList == true){
					currentItemIcon = new Resources.UIHangarPurchaseIcon();
				} else {
					if (PlayerStats.currentPlayerDataVo.currentPlayerEquip == (_data as GrowthItem).id ){
						currentItemIcon = new Resources.UIHangarCurrentIcon();
					} else {
						currentItemIcon = new Resources.UIHangarEquipIcon();
					}
				}
				currentItemIcon.x = 60;
				currentItemIcon.y = 20;
				addChild(currentItemIcon);
				currentItemIcon.addEventListener(MouseEvent.CLICK, mouseClick);
				
				
/*				if ( Resources[ (_data as GrowthItem).iconName ] != null){
					if(pic != null){
						removeChild(pic);
						pic = null;
					}
					pic = new Resources[ (_data as GrowthItem).iconName ]();
					pic.visible = true;
					pic.width = 45;
					pic.height = 40;
					pic.x = 5;
					pic.y = 5;		
					pic.addEventListener(MouseEvent.CLICK, mouseClick);
					addChild(pic);
				}*/
			}
			else
            {
				_label.text = _data.toString();
			}
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when the user rolls the mouse over the item. Changes the background color.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_mouseOver = true;
			invalidate();
		}
		
		/**
		 * Called when the user rolls the mouse off the item. Changes the background color.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_mouseOver = false;
			invalidate();
		}
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the string that appears in this item.
		 */
		public function set data(value:Object):void
		{
			_data = value;
			if(_data is GrowthItem){
				if ( PlayerStats.isUpgradePurchased( (_data as GrowthItem).id ) == true){
					_isPurchaseList = false;
					if( costLabel != null && costRupee != null){
						costLabel.visible = false;
						costRupee.visible = false;
					}
				} else {
					_isPurchaseList = true;
					if( costLabel != null && costRupee != null){
						costLabel.visible = true;
						costRupee.visible = true;
					}
				}
			}
			
			invalidate();
		}
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * Sets/gets whether or not this item is selected.
		 */
		public function set selected(value:Boolean):void
		{
			_selected = value;
			invalidate();
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		/**
		 * Sets/gets the default background color of list items.
		 */
		public function set defaultColor(value:uint):void
		{
			_defaultColor = value;
			invalidate();
		}
		public function get defaultColor():uint
		{
			return _defaultColor;
		}
		
		/**
		 * Sets/gets the selected background color of list items.
		 */
		public function set selectedColor(value:uint):void
		{
			_selectedColor = value;
			invalidate();
		}
		public function get selectedColor():uint
		{
			return _selectedColor;
		}
		
		/**
		 * Sets/gets the rollover background color of list items.
		 */
		public function set rolloverColor(value:uint):void
		{
			_rolloverColor = value;
			invalidate();
		}
		public function get rolloverColor():uint
		{
			return _rolloverColor;
		}
		
	}
}