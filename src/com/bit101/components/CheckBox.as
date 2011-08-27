/**
 * CheckBox.as
 * Keith Peters
 * version 0.9.7
 * 
 * A basic CheckBox component.
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
 
package com.bit101.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CheckBox extends Component
	{
		protected var _back:Sprite;
		protected var _button:Sprite;
		protected var _label:Label;
		protected var _labelText:String = "";
		protected var _selected:Boolean = false;
		
		protected var _backgroundDefaultImage:*;
		protected var _backgroundRolloverImage:*;
		protected var _backgroundImageDefaultPoint:Point = new Point();
		protected var _backgroundImageRolloverPoint:Point = new Point();
		protected var _fontName:String;
		protected var _fontSize:Number; 
		protected var _fontColor:uint;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this CheckBox.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param label String containing the label for this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (click in this case).
		 */
		public function CheckBox(parent:DisplayObjectContainer = null,
								 xpos:Number = 0,
								 ypos:Number =  0,
								 label:String = "",
								 defaultHandler:Function = null,
								 backgroundImageDefaultImage:*=null,
								 backgroundImageDefaultPoint:Point = null,
								 backgroundImageRolloverImage:*=null,
								 backgroundImageRolloverPoint:Point = null,
								 fontName:String = null,
								 fontSize:Number = -1,
								 fontColor:uint = (uint.MAX_VALUE-1)
		)
		{
			if(backgroundImageDefaultPoint != null){
				_backgroundImageDefaultPoint = backgroundImageDefaultPoint;
			}
			if(backgroundImageRolloverPoint != null){
				_backgroundImageRolloverPoint = backgroundImageRolloverPoint;
			}
			
			if(backgroundImageDefaultImage != null){
				if(backgroundImageDefaultImage is Class){
					_backgroundDefaultImage = new backgroundImageDefaultImage();
				} else if(backgroundImageDefaultImage is DisplayObject){
					_backgroundDefaultImage = backgroundImageDefaultImage;
				}
			}
			if(backgroundImageRolloverImage != null){
				if(backgroundImageRolloverImage is Class){
					_backgroundRolloverImage = new backgroundImageRolloverImage();
				} else if(backgroundImageRolloverImage is DisplayObject){
					_backgroundRolloverImage = backgroundImageRolloverImage;
				}
			}			
			_fontName = fontName;
			_fontSize = fontSize;
			_fontColor = fontColor;			
			
			_labelText = label;
			super(parent, xpos, ypos);
			if(defaultHandler != null)
			{
				addEventListener(MouseEvent.CLICK, defaultHandler);
			}
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
		}
		
		/**
		 * Creates the children for this component
		 */
		override protected function addChildren():void
		{
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			
			_button = new Sprite();
			_button.filters = [getShadow(1)];
			_button.visible = false;
			
			if(_backgroundRolloverImage == null && _backgroundDefaultImage == null){
				addChild(_back);
				addChild(_button);
			}
			
			if(_backgroundRolloverImage != null){
				addChild(_backgroundRolloverImage);
				_backgroundRolloverImage.x = _backgroundImageRolloverPoint.x;
				_backgroundRolloverImage.y = _backgroundImageRolloverPoint.y;
			}
			if(_backgroundDefaultImage != null){
				addChild(_backgroundDefaultImage);
				_backgroundDefaultImage.x = _backgroundImageDefaultPoint.x;
				_backgroundDefaultImage.y = _backgroundImageDefaultPoint.y;
			}
			
			_label = new Label(this, 0, 0, _labelText,_fontName,_fontSize,_fontColor);
			draw();
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(0, 0, 10, 10);
			_back.graphics.endFill();
			
			_button.graphics.clear();
			_button.graphics.beginFill(Style.BUTTON_FACE);
			_button.graphics.drawRect(2, 2, 6, 6);
			
			_label.text = _labelText;
			_label.draw();
			_label.x = 12;
			_label.y = (10 - _label.height) / 2;
			_width = _label.width + 12;
			_height = 10;
		}
		
		
		
		
		///////////////////////////////////
		// event handler
		///////////////////////////////////
		
		/**
		 * Internal click handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onClick(event:MouseEvent):void
		{
			_selected = !_selected;
			_button.visible = _selected;
			if(_backgroundRolloverImage != null && _backgroundDefaultImage != null){
				if(_selected == true){
					(_backgroundRolloverImage as DisplayObject).visible = true;
					(_backgroundDefaultImage as DisplayObject).visible = false;
				} else {
					(_backgroundRolloverImage as DisplayObject).visible = false;
					(_backgroundDefaultImage as DisplayObject).visible = true;
				}
			}					
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the label text shown on this CheckBox.
		 */
		public function set label(str:String):void
		{
			_labelText = str;
			invalidate();
		}
		public function get label():String
		{
			return _labelText;
		}
		
		/**
		 * Sets / gets the selected state of this CheckBox.
		 */
		public function set selected(s:Boolean):void
		{
			_selected = s;
			_button.visible = _selected;	
			if(_backgroundRolloverImage != null && _backgroundDefaultImage != null){
				if(_selected == true){
					(_backgroundRolloverImage as DisplayObject).visible = true;
					(_backgroundDefaultImage as DisplayObject).visible = false;
				} else {
					(_backgroundRolloverImage as DisplayObject).visible = false;
					(_backgroundDefaultImage as DisplayObject).visible = true;
				}
			}				
		}
		public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * Sets/gets whether this component will be enabled or not.
		 */
		public override function set enabled(value:Boolean):void
		{
			super.enabled = value;
			mouseChildren = false;
		}

	}
}