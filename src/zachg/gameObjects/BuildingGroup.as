package zachg.gameObjects
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	import zachg.GroupGameObject;
	import zachg.components.HealthComponent;
	import zachg.components.LevelInfoComponent;
	import zachg.components.maps.Mapping;
	
	public class BuildingGroup extends GroupGameObject
	{
		
		/**
		 * measures how hard this factory attacks.
		 * 0 is friendly and defends all-out
		 * 50 is neutral and does not attack
		 * 100 is hostile and attacks all-out 
		 * 
		 */
		//TODO: make units focus on defending buildings/other units/you in addition to acttacking.
		public var aggresiveness:Number = 0;
		
		public var buildingTarget:FlxObject;		
		
		public var availableResources:Number = 100;
		
		public var levelComponent:LevelInfoComponent;
 
		public var MainHullSprite:FlxSprite;	
		
		public function BuildingGroup()
		{
			super();
			levelComponent = new LevelInfoComponent(levelUp);
			
			add(healthComponent.graphicHolder);
			add(levelComponent.graphicHolder);
		}
		
		public function findTarget(buildingGroup:FlxGroup):Boolean {return false}
		
		
		override public function update():void{ 
			super.update(); 
			healthComponent.x = MainHullSprite.x;
			healthComponent.y = MainHullSprite.y - healthComponent.spriteCanvas.height;
			if(healthComponent.currentHealth < 0){
				destroyObject();
			}
			levelComponent.x = MainHullSprite.x;
			levelComponent.y = MainHullSprite.y - healthComponent.spriteCanvas.height -levelComponent.spriteCanvas.height;			
			levelComponent.drawVisual();			
		}
		
		public function botOverlapsBuilding(bot:Bot):void
		{
//			if( 	(bot is CivilianBot) && 
//				isEnemy == bot.isEnemy ){
//				availableResources += bot.resourceValue;
//				bot.destroyObject();
//			}
		}		
		
		public function showInfo():void 
		{
		}
		
		public function levelUp(level:Number):void {}
			
		
	}
}