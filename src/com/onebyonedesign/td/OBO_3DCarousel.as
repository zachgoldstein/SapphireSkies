package com.onebyonedesign.td {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	/**
	 * Creates a 3D Carousel when you add images (DisplayObjects) to an instance using the addItem() method.
	 * @author Devon O.
	 */
	
	public class OBO_3DCarousel extends Sprite {
		
		private var _imageList:XMLList;
		private var _angleStep:Number;
		private var _fl:Number;
		
		public var _items:Array = [];
		private var _currentLoaded:int = 0;
		private var _blur:BlurFilter = new BlurFilter(0, 0, 2);
		
		private var _zRotation:Number;
		private var _targetRotation:Number;
		private var _numItems:int;
		private var _radius:Number;
		private var _zpos:Number;
		
		private var _useBlur:Boolean = false;
		
		public function OBO_3DCarousel(focalLength:int = 800, radius:int = 300, zpos:Number = 0):void {
			_fl = focalLength;
			_radius = radius;
			_zpos = zpos;
		}
		
		public function get zRotation():Number { return _zRotation; }
		
		public function set zRotation(value:Number):void {
			_zRotation = value;
		}
		
		public function get targetRotation():Number { return _targetRotation; }
		
		public function set targetRotation(value:Number):void {
			_targetRotation = value;
		}
		
		public function get zpos():Number { return _zpos; }
		
		public function set zpos(value:Number):void {
			var i:int = _items.length;
			while (i--) {
				_items[i].zpos = value;
				_items[i].updateDisplay();
			}
			_zpos = value;
		}
		
		public function get radius():Number { return _radius; }
		
		public function set radius(value:Number):void {
			var i:int = _items.length;
			while (i--) {
				_items[i].radius = value;
				_items[i].updateDisplay();
			}
			_radius = value;
		}
		
		public function get useBlur():Boolean { return _useBlur; }
		
		public function set useBlur(value:Boolean):void {
			_useBlur = value;
		}
		
		// READ-ONLY
		public function get numItems():int { return _numItems; }
		
		public function addItem(image:DisplayObject):void {
			_numItems = _items.length + 1;
			_targetRotation = -(90 - (360 / _numItems));
			_zRotation = _targetRotation;
			_angleStep = (2 * Math.PI) / _numItems;
			var item:TDCarouselItem = new TDCarouselItem(image);
			_items.push(item);
			var i:int = _items.length;
			while (i--) {
				var ci:TDCarouselItem = _items[i];
				ci.radius = _radius;
				ci.radians = _zRotation * Math.PI / 180;
				ci.angle = _angleStep * i;
				ci.focalLength = _fl;
				ci.zpos = _zpos;
				ci.ypos = y;
				ci.updateDisplay();
			}
			addChild(item);
			
			// if at least one item, go ahead and init the sucker
			if (_numItems == 1) initCarousel();
		}
		
		public function kill():void {
			removeEventListener(Event.ENTER_FRAME, frameHandler);
			var i:int = _items.length;
			while (i--) {
				var ci:TDCarouselItem = _items[i];
				ci.data.dispose();
				removeChild(ci);
				ci = null;
			}
		}
		
		private function initCarousel():void {
			addEventListener(Event.ENTER_FRAME, frameHandler);
		}
		
		private function frameHandler(event:Event):void {
			var rads:Number = _zRotation * Math.PI / 180;
			_items.sortOn("zpos", Array.NUMERIC);
			var i:int = _items.length;
			while (i--) {
				var item:TDCarouselItem = _items[i];
				item.radians = rads;
				if (_useBlur) {
					if (!isNaN(item.zpos)){
						// play with this blur amount - to taste
						_blur.blurX = _blur.blurY = int(((item.zpos - _zpos) + 100) / 40);
						item.filters = [_blur];
					}
				}
				item.updateDisplay();
				// need better z sorting
				addChild(item);
			}
		}
	}
}