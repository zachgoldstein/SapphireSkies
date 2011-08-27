package zachg.components
{
	import com.GlobalVariables;
	
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	import zachg.gameObjects.CallbackSprite;

	public class MovementComponent extends GameComponent
	{
		
		public var moveObjectTarget:FlxObject;
		public var moveLocationTarget:FlxPoint;
		public var moveSpeed:Number = 10;
		
		public var targetStopRange:Number = 200; 
		public var thrustForce:Point = new Point(100,100);
		
		public var isAir:Boolean = false;
		public var isGround:Boolean = true;
		
		public var isIdling:Boolean = false;
		
		public var goDirectlyToTarget:Boolean = false;
		
		public var randomizeDirection:Boolean = false;
		public var randomLocationDistance:Point = new Point(200,200);
		public var randomLocation:Point;
		public var chooseRandomPointDelay:int = 3;
		public var chooseRandomPointCounter:int = 10;
		
		public function MovementComponent(CallbackFunction:Function=null,rootObject:FlxObject=null)
		{
			super(CallbackFunction);
			hullSprite = new CallbackSprite(0,0,hullCollided,rootObject);
			PhysicalSprite = new CallbackSprite(0,0,null,rootObject);
			PhysicalSprite.acceleration.y = GlobalVariables.gravityAcceleration.y;
			
		}
		
		override public function update():void
		{
			super.update();
			if(isAir == true){
				airMovement();
			} else if(isGround == true){
				groundMovement();
			}

			if(randomizeDirection == true){
				chooseRandomPointTarget();
				chooseRandomPointCounter++;
			}
			
			hullSprite.x = PhysicalSprite.x;
			hullSprite.y = PhysicalSprite.y;
		}
		
		public function chooseRandomPointTarget():void
		{
			if(chooseRandomPointCounter > chooseRandomPointDelay){
				moveObjectTarget = null;
				moveLocationTarget = new FlxPoint( 
					(hullSprite.x + PhysicalSprite.velocity.x/2) + Math.random()*randomLocationDistance.x - randomLocationDistance.x/2,
					(hullSprite.y + PhysicalSprite.velocity.y/2) + Math.random()*randomLocationDistance.y - randomLocationDistance.y/2);
				chooseRandomPointCounter = 0;
			}
			
		}
		
		public function hullCollided(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{
			PhysicalSprite.x = hullSprite.x;
			PhysicalSprite.y = hullSprite.y;
			callbackFunction(Contact, Velocity,collisionSide);
		}
		
		public function stopMoving():void
		{
			PhysicalSprite.velocity.x = 0;
			PhysicalSprite.velocity.y = 0;
		}
		
		public var idleDistance:Number = 10;
		public function idle():void
		{
			PhysicalSprite.velocity.x += (Math.random() -.5)*idleDistance;
			PhysicalSprite.velocity.y += (Math.random() -.5)*idleDistance;			
		}
		
		
		public var rotateSpeedMultiplier:Number = 15;
		public var friction:Number = 0.95;
		public var avoiding:Boolean = false;
		private var targetAngle:Number;		
		public function airMovement():void
		{
			var dx:Number;
			var dy:Number;
			if(moveObjectTarget != null){
				dx = moveObjectTarget.x - (PhysicalSprite.x + PhysicalSprite.width/2);
				dy = moveObjectTarget.y - (PhysicalSprite.y + PhysicalSprite.height/2);
			} else if(moveLocationTarget != null){
				dx = moveLocationTarget.x - (PhysicalSprite.x + PhysicalSprite.width/2);
				dy = moveLocationTarget.y - (PhysicalSprite.y + PhysicalSprite.height/2);
			} else {
				dx = FlxG.mouse.x - (PhysicalSprite.x + PhysicalSprite.width/2);
				dy = FlxG.mouse.y - (PhysicalSprite.y + PhysicalSprite.height/2);				
			}
			var distance:Number = Math.sqrt(dx*dx+dy*dy);
			if(goDirectlyToTarget == false){
				if(distance < targetStopRange){
					idle();
					isIdling = true;
					return
				} else {
					isIdling = false;
				}
			}
				
			targetAngle = (Math.atan2(dy, dx) * 57.295) - PhysicalSprite.angle;
			var delta:Number = PhysicalSprite.maxAngular * FlxG.elapsed;
			if (avoiding) targetAngle += 180;
			if (targetAngle < -180) targetAngle += 360; // shortest route
			if (targetAngle > 180) targetAngle -= 360;
			if (targetAngle > delta) targetAngle = delta; // cap turn speed
			else if (targetAngle < -delta) targetAngle = delta;
			PhysicalSprite.angularVelocity = targetAngle*rotateSpeedMultiplier;			
			
			//sometimes angle gets fucked, reset angular velocity in this situation
			if(targetAngle >= delta){
				PhysicalSprite.angularVelocity = 0
				PhysicalSprite.angle = 0;
				PhysicalSprite.x += 2;
				targetAngle--;
			}
			
			var cosa:Number = Math.cos(PhysicalSprite.angle*(Math.PI/180));
			var sina:Number = Math.sin(PhysicalSprite.angle*(Math.PI/180));
			PhysicalSprite.velocity.x += (cosa * thrustForce.x) * FlxG.elapsed;
			PhysicalSprite.velocity.y += (sina * thrustForce.y) * FlxG.elapsed;
			if (PhysicalSprite.velocity.x > PhysicalSprite.maxThrust) PhysicalSprite.velocity.x = PhysicalSprite.maxThrust; // cap
			else if (PhysicalSprite.velocity.x < -PhysicalSprite.maxThrust) PhysicalSprite.velocity.x = -PhysicalSprite.maxThrust;
			if (PhysicalSprite.velocity.y > PhysicalSprite.maxThrust) PhysicalSprite.velocity.y = PhysicalSprite.maxThrust;
			else if (PhysicalSprite.velocity.y < -PhysicalSprite.maxThrust) PhysicalSprite.velocity.y = -PhysicalSprite.maxThrust;
			PhysicalSprite.velocity.x *= friction;
			PhysicalSprite.velocity.y *= friction;
		}
		
		public function quickSetCorrectRotation():void
		{
			var dx:Number;
			var dy:Number;
			if(moveObjectTarget != null){
				dx = moveObjectTarget.x - (PhysicalSprite.x + PhysicalSprite.width/2);
				dy = moveObjectTarget.y - (PhysicalSprite.y + PhysicalSprite.height/2);
			} else if(moveLocationTarget != null){
				dx = moveLocationTarget.x - (PhysicalSprite.x + PhysicalSprite.width/2);
				dy = moveLocationTarget.y - (PhysicalSprite.y + PhysicalSprite.height/2);
			} else {
				dx = FlxG.mouse.x - (PhysicalSprite.x + PhysicalSprite.width/2);
				dy = FlxG.mouse.y - (PhysicalSprite.y + PhysicalSprite.height/2);				
			}
			PhysicalSprite.angle = (Math.atan2(dy, dx) * 57.295) - PhysicalSprite.angle;
		}

		public function groundMovement():void
		{
			//Ground based movement (only sideways movement and jumping)
			if(moveObjectTarget != null && moveObjectTarget.dead != true){
				//Note that the 15 is the hard-coded half width of what we expect our target to be in this case.  
				if(Math.abs(PhysicalSprite.x - (moveObjectTarget.x + 15) ) < targetStopRange){
					PhysicalSprite.velocity.x = 0;
				} else {
					if(PhysicalSprite.x < moveObjectTarget.x){
						PhysicalSprite.velocity.x = moveSpeed;
						PhysicalSprite.facing = FlxSprite.RIGHT;
					} else {
						PhysicalSprite.velocity.x = -moveSpeed;
						PhysicalSprite.facing = FlxSprite.LEFT;
					}
				}
			} else if(moveLocationTarget != null){
				//not sure if this bit works
				if(PhysicalSprite.x < moveLocationTarget.x){
					PhysicalSprite.velocity.x = moveSpeed;
				} else {
					PhysicalSprite.velocity.x = -moveSpeed;
				}
			} else {
				if(PhysicalSprite.facing == FlxSprite.RIGHT){
					PhysicalSprite.velocity.x = moveSpeed;
				} else {
					PhysicalSprite.velocity.x = -moveSpeed;
				}
			}
		}
	}
}