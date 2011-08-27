package zachg.gameObjects
{
	import com.Resources;
	
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	import zachg.GroupGameObject;
	
	public class Crystal extends GroupGameObject
	{
		
		
		public var crystal:FlxSprite;		
		public var linkedBuildings:Array = new Array();
		
		public function Crystal(X:Number, Y:Number,
								passedWidth:Number,passedHeight:Number,
								scaleX:Number,scaleY:Number,
								boundsX:Number, boundsY:Number,
								boundsWidth:Number, boundsHeight:Number,
								imageName:String, IsEnemy:Boolean, callback:Function
		):void
		{
			super();
			x = X;
			y = Y;			
			isEnemy = IsEnemy;
			
			crystal = new CallbackSprite(0,0,hullCollision,this);
			crystal.loadGraphic(Resources[imageName], true, true, passedWidth, passedHeight );
			add(crystal);
			crystal.fixed = true;
			crystal.solid = true;
			
			healthComponent.maxHealth = 200;
			healthComponent.currentHealth = 200;
			
			healthComponent.healthBar.width = crystal.width;
			add(healthComponent.graphicHolder);
			healthComponent.currentHealth--;
		}
		
		public function hullCollision(Contact:FlxObject, Velocity:Number,collisionSide:String):void
		{}
		override public function update():void
		{
			super.update();

			healthComponent.x = x;
			healthComponent.y = y - healthComponent.spriteCanvas.height;
			if(healthComponent.currentHealth < 0){
				destroyObject();
			}			
			
			healthComponent.drawVisual();
			healthComponent.update();
		}
		
		override public function destroyObject():void
		{
			for (var i:int = 0 ; i < linkedBuildings.length ; i++){
				(linkedBuildings[i] as GroupGameObject).destroyObject();
			}
			super.destroyObject();
		}
		
	}
}