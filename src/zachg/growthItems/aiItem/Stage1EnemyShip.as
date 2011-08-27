package zachg.growthItems.aiItem
{
	import com.Resources;
	
	import flash.geom.Point;
	
	import org.flixel.FlxPoint;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.MiningBot;
	import zachg.gameObjects.Rocket;
	import zachg.growthItems.playerItem.PlayerItem;

	public class Stage1EnemyShip extends AiItem
	{
				
		override public function setStats():void
		{
			levelShipHealth = [ 70/healthDivider,150/healthDivider,300/healthDivider];		
			levelShipSpeed = [ new Point(1200/speedDivider,1200/speedDivider),new Point(1050/speedDivider,1050/speedDivider),new Point(900/speedDivider,900/speedDivider) ];
			levelShipShotDamage = [7/damageDivider,45/damageDivider,18/damageDivider];
			levelShipShotDelay = [10*delayDivider,30*delayDivider,40*delayDivider];
		}				
		
		public function Stage1EnemyShip(Id:int)
		{
			super(Id);
			
			setStats();
			
			//contains image names for spritesheets and data
			levelShipNames = ["Algiz","Thurisaz","Gebo"];
			levelShipResourceCost = [11,17,22];
			villageResourceGrowth = [0.03,0.055,0.08];
			villageHealth = [100,150,200];
			
			villageGraphics = [
					Resources.VillageSmallEnemyStage1,
					Resources.VillageMediumEnemyStage1,
					Resources.VillageLargeEnemyStage1
			];
			villageGraphicParams = [
				[true,true,150,102],
				[true,true,150,105],
				[true,true,150,150]
			];
			
			levelShipWeaponParameters=
			[
				[ 
					"isSingleShotMode",false,
					"isParallelShot",true,
					"numParallelBullets",2,
					"shotMass",5
				],[
					"bulletClass",Rocket,
					"bulletImageClass","MiscRocket1",
					"bulletImageParams",[true,true,12,5],
					"shotMass",50,
					"isSingleShotMode",true
				],[
					"isSingleShotMode",false,
					"isShotGunMode",true,
					"numShotgunBullets",5,
					"bulletClass",Rocket,
					"bulletImageClass","MiscRocket2",
					"bulletImageParams",[true,true,16,5],
					"shotMass",25
				]
			]
				
			levelShipGraphicParameters = 
			[
				[true,true,40,28,4],
				[true,true,72,49,4],
				[true,true,111,80,5]
			];

			
			levelShipGraphics = 
				[
					Resources.ShipSmallEnemySet1,
					Resources.ShipMediumEnemySet1,
					Resources.ShipBigEnemySet1
				];
			
			levelTurretGraphicParameters = 
				[
					[[false,false,10,6],[] ],
					[[false,false,13,8],[] ],
					[[false,false,21,10],[] ]
				];
			levelTurretPositions =
				[
					[[-28,-22,-28,-22,8,8],[] ],
					[[-45,-13,-45,-13,8,8],[] ],
					[[-51,-34,-51,-34,8,8],[] ]
				];			
			
			levelTurretGraphics = 
				[
					[ [Resources.MiscGunSmall],[] ] ,
					[ [Resources.MiscGunMedium],[] ] ,
					[ [Resources.MiscGunLarge],[] ]
				];	
			smokeLocation = 
				[
					[0,15],
					[0,-30],
					[40,-25]
				];			
			shootNoise = 
				[
					["SfxEnemyWeapon03"],
					["SfxEnemyWeapon04Launch"],
					["SfxEnemyWeapon05Launch"]
				];
			
			shotExplode = 
				[
					[""],
					["SfxEnemyWeapon04Explode"],
					["SfxEnemyWeapon05Explode"]
				];	

			iconNames = 
				[
					"PlayerShipIconSmallEnemySet1",
					"PlayerShipIconMediumEnemySet1",
					"PlayerShipIconBigEnemySet1"
				];
			
			
		}
	}
}