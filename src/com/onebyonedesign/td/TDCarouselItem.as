package com.onebyonedesign.td {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 3D items for OBO_3DCarousel class
	 * @author Devon O.
	 */
	public class TDCarouselItem extends Sprite {
		
		private var _radius:Number;
		private var _radians:Number;
		private var _angle:Number;
		private var _focalLength:int;
		private var _orgZPos:Number;
		private var _orgYPos:Number;
		public var _data:BitmapData;
		public var scaleRatio:Number;
		public var stageReferenceId:Number;
		
		private var _zpos:Number;
		
		public function TDCarouselItem(image:DisplayObject):void {
			_data = new BitmapData(image.width, image.height, true, 0x00FFFFFF);
			_data.draw(image);
			var bmp:Bitmap = new Bitmap(_data, "auto", true);
			bmp.x -= bmp.width * .5;
			bmp.y -= bmp.height * .5;
			updateDisplay();
			addChild(bmp);
		}
		
		internal function updateDisplay():void {
			var angle:Number = _angle + _radians;
			var xpos:Number = Math.cos(angle) * _radius;
			_zpos = _orgZPos + Math.sin(angle) * _radius;
			scaleRatio = _focalLength / (_focalLength + _zpos);
			x = xpos * scaleRatio;
			y = _orgYPos * scaleRatio;
			scaleX = scaleY = scaleRatio;
		}
		
		internal function get angle():Number { return _angle; }
		
		internal function set angle(value:Number):void {
			_angle = value;
		}
		
		internal function get radius():Number { return _radius; }
		
		internal function set radius(value:Number):void {
			_radius = value;
		}
		
		internal function get focalLength():int { return _focalLength; }
		
		internal function set focalLength(value:int):void {
			_focalLength = value;
		}
		
		internal function get radians():Number { return _radians; }
		
		internal function set radians(value:Number):void {
			_radians = value;
		}
		
		// must remain public for Array.sortOn() method in OBO_3DCarousel instance.
		public function get zpos():Number { return _zpos; }
		
		public function set zpos(value:Number):void {
			_orgZPos = value;
		}
		
		internal function set ypos(value:Number):void {
			_orgYPos = value;
		}
		
		internal function get data():BitmapData { return _data; }
	}
}