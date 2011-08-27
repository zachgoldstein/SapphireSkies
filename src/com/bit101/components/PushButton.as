/**
 * PushButton.as
 * Keith Peters
 * version 0.9.7
 * 
 * A basic button component with a label.
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

	public class PushButton extends Component
	{
		protected var _back:Sprite;
		protected var _face:Sprite;
		public var _label:Label;
		protected var _labelText:String = "";
		protected var _over:Boolean = false;
		protected var _down:Boolean = false;
		protected var _selected:Boolean = false;
		protected var _toggle:Boolean = false;
		
		public var _backgroundDefaultImage:*;
		public var _backgroundRolloverImage:*;
		protected var _backgroundImageDefaultPoint:Point = new Point();
		protected var _backgroundImageRolloverPoint:Point = new Point();
		protected var _fontName:String;
		protected var _fontSize:Number; 
		protected var _fontColor:uint;
		protected var _showBackground:Boolean = true;
		
		public var _backgroundColor:uint = Style.BACKGROUND;
		public var _faceColor:uint = Style.BUTTON_FACE;
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this PushButton.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param label The string to use for the initial label of this component.
 		 * @param defaultHandler The event handling function to handle the default event for this component (click in this case).
		 */
		public function PushButton(parent:DisplayObjectContainer = null,
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
								   fontColor:uint = (uint.MAX_VALUE-1),
								   showBackground:Boolean = false
		)
		{
			_showBackground = showBackground;
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
			super(parent, xpos, ypos);
			if(defaultHandler != null)
			{
				addEventListener(MouseEvent.CLICK, defaultHandler);
			}
			this.label = label;
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			buttonMode = true;
			useHandCursor = true;
			setSize(100, 20);
		}
		
		/**
		 * forces init again
		 */
		public function initForce():void
		{
			init();
		}		
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_back = new Sprite();
			_back.mouseEnabled = false;
			_face = new Sprite();
			_face.mouseEnabled = false;
			_back.filters = [getShadow(2, true)];
			
			_face.filters = [getShadow(1)];
			_face.x = 1;
			_face.y = 1;
			
			if(_backgroundRolloverImage == null && _backgroundDefaultImage == null && _showBackground == true){
				addChild(_back);
				addChild(_face);
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
			
			_label = new Label(null,0,0,"",_fontName,_fontSize,_fontColor);
			addChild(_label);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
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
			_back.graphics.beginFill(_backgroundColor);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();
			
			_face.graphics.clear();
			_face.graphics.beginFill(_faceColor);
			_face.graphics.drawRect(0, 0, _width - 2, _height - 2);
			_face.graphics.endFill();
			
			if(_backgroundRolloverImage != null && _backgroundDefaultImage != null){
				if(_over == true){
					(_backgroundRolloverImage as DisplayObject).visible = true;
					(_backgroundDefaultImage as DisplayObject).visible = false;
				} else {
					(_backgroundRolloverImage as DisplayObject).visible = false;
					(_backgroundDefaultImage as DisplayObject).visible = true;
				}
			}
			
			_label.text = _labelText;
			_label.autoSize = true;
			_label.draw();
			if(_label.width > _width - 4)
			{
				_label.autoSize = false;
				_label.width = _width - 4;
			}
			else
			{
				_label.autoSize = true;
			}
			_label.draw();
			_label.move(_width / 2 - _label.width / 2, _height / 2 - _label.height / 2);
			
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseOver handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			draw();
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			if(!_down)
			{
				_face.filters = [getShadow(1)];
			}
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			draw();
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoDown(event:MouseEvent):void
		{
			_down = true;
			_face.filters = [getShadow(1, true)];
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		/**
		 * Internal mouseUp handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoUp(event:MouseEvent):void
		{
			if(_toggle  && _over)
			{
				_selected = !_selected;
			}
			_down = _selected;
			_face.filters = [getShadow(1, _selected)];
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the label text shown on this Pushbutton.
		 */
		public function set label(str:String):void
		{
			_labelText = str;
			draw();
		}
		public function get label():String
		{
			return _labelText;
		}
		
		public function set selected(value:Boolean):void
		{
			if(!_toggle)
			{
				value = false;
			}
			
			_selected = value;
			_down = _selected;
			_face.filters = [getShadow(1, _selected)];
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set toggle(value:Boolean):void
		{
			_toggle = value;
		}
		public function get toggle():Boolean
		{
			return _toggle;
		}

		public function get backgroundDefaultImage():*
		{
			return _backgroundDefaultImage;
		}

		public function set backgroundDefaultImage(value:*):void
		{
			removeChild(_backgroundDefaultImage);
			_backgroundDefaultImage = value;
			_backgroundDefaultImage.x = _backgroundImageDefaultPoint.x;
			_backgroundDefaultImage.y = _backgroundImageDefaultPoint.y;
			addChild(_backgroundDefaultImage);			
		}

		public function get backgroundRolloverImage():*
		{
			return _backgroundRolloverImage;
		}

		public function set backgroundRolloverImage(value:*):void
		{
			removeChild(_backgroundRolloverImage);
			_backgroundRolloverImage = value;
			_backgroundRolloverImage.x = _backgroundImageRolloverPoint.x;
			_backgroundRolloverImage.y = _backgroundImageRolloverPoint.y;
			addChild(_backgroundRolloverImage);
			
		}
		
		
	}
}