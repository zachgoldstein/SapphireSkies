/**
 *@example
 * new Noise({width:300, height:300, targetObj:new target_instance()})
 *@author François Perreault (http://www.fperreault.ca)
**/

/* This is beautiful code, and I made none of it.  
 	The man above, François, is the wizard behind this awesome glitchy madness.
	This is old-school. You don't really know what hell is going on, and there's not a 
	single comment. It's just magic.
	Respect.
*/

package zachg.util 
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;	
	
	public class Noise extends MovieClip{

		private var _width			:Number
		private var _height			:Number
		private var _nbChannel		:Number = 3
		private var _level			:Number = 1
		private var _levelX			:Number = 200
		private var _levelY			:Number = 5
		private var _curveX			:Number = 3
		
		private var target			:MovieClip
		private var video_noise		:Sprite
		private var bitmap_noise	:Sprite
		
		private var bmp0			:BitmapData
		private var bmp1			:BitmapData
		private var bmp2			:BitmapData
		
		private var w				:Number = .20;
		private var v				:Number = 0
		private var aX				:Array = new Array(Math.random() + 1, Math.random() + 1, Math.random() + 1);
		private var bX				:Array = new Array(0, 0, 0);
		private var p1				:Array = new Array(new Point(0, 0), new Point(0, 0), new Point(0, 0));
		private var p0				:Point = new Point(0, 0)
		
		private var _isPaused		:Boolean = true
		
		public function Noise(params:*) {
			trace("noise created");							
			setup(params)
			addEventListener(Event.ADDED_TO_STAGE, init)
			addEventListener(Event.REMOVED_FROM_STAGE, destroy)
		}
		
		private function setup(params:*):void {
			trace("noise setup start,params "+params.targetObj);			
			_width = params.width
			_height = params.height
			target = params.targetObj
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0,0,_width,_height);
			trace("noise setup end");
		}
		private var initCount:int = 0;
		public function init(evt:Event=null):void {
			if(initCount<1){
								trace("noise init:"+initCount);	
								initCount++;
				video_noise = new Sprite()
				video_noise.addChild(bitmap_noise = new Sprite())
				addChild(video_noise)
				bitmap_noise.addChild(target)
				bitmap_noise.mouseEnabled = false
				createBitmap()
				resizeStage()
				stage.addEventListener(Event.RESIZE, resizeStage)
			}
			
		}
		private function destroy(evt:Event):void {
			PAUSE()
			bmp0.dispose()
			bmp1.dispose()
			removeEventListener(Event.ADDED_TO_STAGE, init)
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy)
			stage.removeEventListener(Event.RESIZE, resizeStage)
		}
		
		private function createBitmap():void {
			bmp0 = new BitmapData(_width, _height)
			bmp1 = bmp2 = bmp0.clone();

			for (var i:int = 1; i < _nbChannel;i++ ) {
				var bm:Bitmap = new Bitmap(this['bmp'+i], 'auto', true)
				bm.name = 'bm' + i
				bm.visible = false
				bitmap_noise.addChild(bm)
			}
		}
		private function update(evt:Event):void {			
			bmp0.draw(target);
			bmp1 = bmp0.clone();
			
			var point:Number = _nbChannel;
			while (point--){
				if (aX[point] >= 1){
					--aX[point];
					bX[point] = Math.random()/(_level);
				}
				aX[point] = aX[point] + bX[point];
				p1[point].x = Math.ceil(Math.sin(aX[point] * 6) * bX[point] * _levelX/10) ;
			}
			var x:Number = (Math.abs(p1[0].x) + Math.abs(p1[1].x) + Math.abs(p1[2].x)+10 ) / _curveX;
			point = _height;
		  
			while (point--){
				var curve:Number = Math.sin(point / _height * (Math.random() / 8 + 1) * w * 6) * w * x * x;
				bmp1.copyPixels(bmp0, new Rectangle(curve, point, width - curve, 1), new Point(0, point));
			} 
			
			if (x >2) w = Math.random() * 2;
			if (w < .8){
				var color:Number = x * x * x * 2;
				bmp1.merge(bmp1, bmp1.rect, p0, color, color, color, 0);
			}
			if (Math.random() < _levelY/10) v = 10;
			if (v > 1000) v = 0;
			if (v > 0){
				v = v + 45;
				v = v % _height;
				var cloneBmp:BitmapData = bmp1.clone(); 
				bmp1.copyPixels(cloneBmp, new Rectangle(0, 0, _width, v), new Point(0, _height - v));
				bmp1.copyPixels(cloneBmp, new Rectangle(0, v, _width, _height - v), new Point(0, 0));
			}
			bmp2.copyChannel(bmp1, bmp1.rect, p1[0], 1, 1);
			bmp2.copyChannel(bmp1, bmp1.rect, p1[1], 2, 2);
			bmp2.copyChannel(bmp1, bmp1.rect, p1[2], 4, 4);
		}
		private function resizeStage(evt:Event = null):void {
			var dWidth:Number = stage.stageWidth / _width
			var dHeight:Number = stage.stageHeight /  _height
			var dScaleBack:Number = dHeight > dWidth ? (dHeight) : (dWidth);
			video_noise.scaleX = video_noise.scaleY = dScaleBack
		}
		
		public function START():void {
			_isPaused = false
			addEventListener(Event.ENTER_FRAME, update)
			for (var i:int = 1; i < _nbChannel;i++ ) {
				var bm:* = bitmap_noise.getChildByName('bm'+i)
				bm.visible = true
			}
		}
		public function PAUSE():void {
			_isPaused = true
			removeEventListener(Event.ENTER_FRAME, update)
		}
		public function PAUSE_CLEAR():void{
			PAUSE();
			for (var i:int = 1; i < _nbChannel;i++ ) {
				var bm:* = bitmap_noise.getChildByName('bm'+i)
				bm.visible = false
			}	
		}
		
		public function set LEVEL($valeur:Number):void {
			_level = $valeur
		}
		public function set LEVELX($valeur:Number):void {
			_levelX = $valeur
		}
		public function set LEVELY($valeur:Number):void {
			_levelY = $valeur
		}
		public function set CURVEX($valeur:Number):void {
			_curveX = $valeur
		}
		public function get IS_PAUSED():Boolean {
			return _isPaused
		}
	}
}