package com
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{		
		private var _move_speed:int = 400;
		private var _jump_power:int = 350;   
		private const MAX_ENERGY:Number = 2;
		private var energy:Number = MAX_ENERGY;
		private var energyWaitTimer:Number = 0;
		
		public function Player(X:Number, Y:Number,
							   passedWidth:Number,passedHeight:Number,
							   scaleX:Number,scaleY:Number,
							   boundsX:Number, boundsY:Number,
							   boundsWidth:Number, boundsHeight:Number,
							   imageName:String):void 
		{
			super(X, Y);
			loadGraphic(Resources[imageName], true, true, passedWidth, passedHeight );
			maxVelocity.x = 400;
			maxVelocity.y = 400;
			//Set the player health
			health = 10;
			//Gravity
			acceleration.y = 220;			
			//Friction
			drag.x = 300;
			//bounding box tweaks
			width = boundsWidth;
			height = boundsHeight;
			offset.x = 0;
			offset.y = 4;
			
			addAnimation("jump", [0, 1], 10);
			addAnimation("move", [0, 1], 10);	// For now move is same anim as jump.
			addAnimation("fall", [2, 3], 10);
			addAnimation("idle", [4, 5], 2);			
		}
		
		override public function update():void 
		{
			if ( FlxG.keys.LEFT )
			{
				facing = LEFT;
				velocity.x -= _move_speed * FlxG.elapsed;
			}
			else if (FlxG.keys.RIGHT )
			{
				facing = RIGHT;
				velocity.x += _move_speed * FlxG.elapsed;		
			}
			
			if (FlxG.keys.X)
			{
				velocity.y -= _jump_power * FlxG.elapsed;
				energy -= FlxG.elapsed;
				if ( energy <= 0 )
				{
					energyWaitTimer = 0.2;
				}
			}
			else
			{
				if ( energyWaitTimer > 0 )
				{
					energyWaitTimer -= FlxG.elapsed;
				}
				else
				{
					energy = Math.min( energy + FlxG.elapsed, MAX_ENERGY );
				}
			}
			
			if (velocity.y < 0)
			{
				play("jump");// Check old flixel and new flixel in case I fixed the play anim code if you're already playing.
			}
			else
			{
				if ( velocity.y > 0 )
				{
					play("fall");
				}
				else if (velocity.x == 0)
				{
					play("idle");
				}
				else
				{
					play("move");
				}
			}
			
			super.update();
			
			
		}
	
		
	}

}