package zachg.growthItems.aiItem
{
	import flash.utils.Dictionary;

	public class AiItem extends Object
	{

		public var healthDivider:Number = 2;
		public var speedDivider:Number = 8;
		public var damageDivider:Number = 8;
		public var delayDivider:Number = 4;
		
		public var id:int = -1;
		public var objectLevel:Number = 0;
		
		public var levelShipGraphics:Array;
		public var levelShipGraphicParameters:Array;
		public var numFrames:int = 4;
		
		public var levelTurretGraphicParameters:Array;
		
		public var smokeLocation:Array;
		public var shootNoise:Array;
		public var shotExplode:Array;
		
		//Array containing definitions for lasers, rockets, parallel/fan shots, etc
		public var levelShipWeaponParameters:Array;
		
		//X,Y turret relative to ship, then X,Y of rotational center relative to turret. 
		public var levelTurretPositions:Array;
		
		//Ship level -> Ship Turrets -> Ship graphic
		public var levelTurretGraphics:Array;
		
		public var levelShipShotDamage:Array;
		
		public var levelShipShotDelay:Array;
		
		public var levelShipSpeed:Array;
		
		public var levelShipHealth:Array;
		
		public var levelShipResourceCost:Array;
		
		public var levelShipNames:Array;
		
		public var villageGraphics:Array;
		public var villageGraphicParams:Array;
		
		public var villageResourceGrowth:Array;
		public var villageHealth:Array = [10,10,10];
		
		public var iconNames:Array;
		
		public function AiItem(Id:int = -1)
		{
			id = Id;
		}
		
		public function setStats():void {}
	}
}