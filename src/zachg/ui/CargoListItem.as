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
	
	import zachg.Mineral;
	import zachg.growthItems.GrowthItem;
	
	public class CargoListItem extends Component
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
		protected var pic:*;
		protected var rupeeValue:Label;
		protected var resourceValue:Label;
		protected var smallRupee:* = new Resources.UICargoSmallRupee();
		protected var smallResourceIcon:* = new Resources.UICargoSmallResource();
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ListItem.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param data The string to display as a label or object with a label property.
		 */
		public function CargoListItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Object = null)
		{
			_data = data;
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
			
			_label = new Label();
			itemDescription = new Text(this,29,2,"","system",8, 0xFFFFFF,false);
			itemDescription.selectable = false;
			itemDescription.editable = false;
			itemDescription.visible = false;
			itemDescription.text = "Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing";
			itemDescription.addEventListener(MouseEvent.CLICK, mouseClick);
			itemDescription.height = 30;
			
			rupeeValue = new Label(this,36,30,"","system",8,0xFFFFFF);
			resourceValue  = new Label(this,136,30,"","system",8,0xFFFFFF);
			addChild(smallRupee);
			addChild(smallResourceIcon);
			smallRupee.x = 30;
			smallRupee.y = 30;
			smallResourceIcon.x = 130;
			smallResourceIcon.y = 30;
			
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

			itemDescription.width = width - 40;

			_backgroundOverlay.graphics.beginFill(_defaultColor);
			if(_selected)
			{
				_backgroundOverlay.graphics.beginFill(_selectedColor);
				if(_data is Mineral){
					if( (_data as Mineral).isSpecial == true){
						_backgroundOverlay.graphics.beginFill(_selectedColorPremium);
					}
				}
			}
			else if(_mouseOver)
			{
				_backgroundOverlay.graphics.beginFill(_rolloverColor);
				if(_data is Mineral){
					if( (_data as Mineral).isSpecial == true){
						_backgroundOverlay.graphics.beginFill(_rolloverColorPremium);
					}
				}
			}
			_backgroundOverlay.graphics.drawRect(0, 0,  Math.round(width-12), Math.round(height)-3);
			_backgroundOverlay.graphics.endFill();

            if(_data == null || _data == ""){
				if(pic != null){
					removeChild(pic);
					pic.visible = false;
					pic = null;
				}
				itemDescription.visible = false;
				_label.visible = false;
				
				rupeeValue.visible = false;
				resourceValue.visible = false;
				smallRupee.visible = false;
				smallResourceIcon.visible = false;				
				
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
			else if(_data is Mineral)
			{
				_label.visible = true;
				itemDescription.text = (_data as Mineral).fullName + " - " + (_data as Mineral).description;
				
				itemDescription.visible = true;

				rupeeValue.text = "Rupee Value: " + (_data as Mineral).rupeeValue;
				resourceValue.text = "Resource Value: " + (_data as Mineral).resourceValue;
				rupeeValue.visible = true;
				resourceValue.visible = true;
				smallRupee.visible = true;
				smallResourceIcon.visible = true;				
				
				if(pic != null){
					removeChild(pic);
					pic = null;
				}				
				if(_data is Mineral){
					pic = new Resources[ (_data as Mineral).imageName ]();
					addChild(pic);
					pic.x = 3;
					pic.y = 3;
				}
				pic.visible = true;
				pic.addEventListener(MouseEvent.CLICK, mouseClick);
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