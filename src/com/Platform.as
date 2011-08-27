package com 
{
	import org.flixel.*;
	
	/**
	 * simple platform that can move.
	 */
	public class Platform extends FlxSprite
	{
		[Embed(source = '../../data/bloodPlatform.png')] private var ImgPlatform:Class;
		
		public var path:PathData = null;
		
		public var direction:Number = 1; // -1 or 1
		public var speed:Number = 0.2;
		//testing
		private var stopTime:Number = 0;
		
		public function Platform(X:Number,Y:Number)
		{
			super(X, Y);
			loadGraphic(ImgPlatform, true, true, 32, 32 );
			
			solid = true;
			fixed = true;
			moves = false;	// We handle movement.
		}
		
		override public function update():void
		{
			super.update();
			
			if ( stopTime > 0 )
			{
				stopTime -= FlxG.elapsed;
				return;
			}
			
			if ( path != null )
			{
				path.childAttachT += FlxG.elapsed * direction * speed;
				if ( path.childAttachT < 0 || path.childAttachT > 1 )
				{
					path.childAttachNode += direction;
					if ( path.childAttachNode >= path.nodes.length - 1 )
					{
						path.childAttachNode -= direction;
						path.childAttachT = 1;
						direction = -1;
					}
					else if ( path.childAttachNode < 0 )
					{
						path.childAttachNode -= direction;
						path.childAttachT = 0;
						direction = 1;
					}
					else
					{
						path.childAttachT -= direction;
					}
				}
				x = path.nodes[path.childAttachNode].x + path.childAttachT * (path.nodes[path.childAttachNode + 1].x - path.nodes[path.childAttachNode].x);
				y = path.nodes[path.childAttachNode].y + path.childAttachT * (path.nodes[path.childAttachNode + 1].y - path.nodes[path.childAttachNode].y);
				refreshHulls();
			}
		}
		
		public function StopMoving():void
		{
			if( stopTime <= 0)
				stopTime = 5;
		}
		
	}

}