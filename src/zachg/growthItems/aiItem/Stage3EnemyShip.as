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

	public class Stage3EnemyShip extends AiItem
	{
		
		override public function setStats():void
		{
			levelShipHealth = [ 500,700,1500];		
			levelShipSpeed = [ new Point(1728/speedDivider,1728/speedDivider),new Point(1512/speedDivider,1512/speedDivider),new Point(1296/speedDivider,1296/speedDivider) ];
			levelShipShotDamage = [50/damageDivider,160/damageDivider,450/damageDivider];
			levelShipShotDelay = [5*delayDivider,2*delayDivider,10*delayDivider];
		}		
				
		public function Stage3EnemyShip(Id:int)
		{
			super(Id);
			
			
			speedDivider = 8;
			damageDivider = 6;
			delayDivider = 10;
			
			setStats();
			levelShipNames = ["Uruz","Raidho","Thwaz"];
			levelShipResourceCost = [13,21,26];
			villageResourceGrowth = [0.043,0.079,0.115];
			villageHealth = [1232,1800,2160];
					
			villageGraphics = [
				Resources.VillageSmallEnemyStage2,
				Resources.VillageMediumEnemyStage2,
				Resources.VillageLargeEnemyStage2
			];
			villageGraphicParams = [
				[true,true,150,150],
				[true,true,150,150],
				[true,true,150,150]
			];

			levelShipWeaponParameters=
				[
					[ 
						"isSingleShotMode",true,
						"isLaserMode",true,
						"laserShootColor", 0x0000FF,
						"laserThickness",3
					],[
						"isSingleShotMode",true,
					],[
						"isSingleShotMode",true,
						"bulletClass",Rocket,
						"bulletImageClass","MiscRocket3",
						"bulletImageParams",[true,true,21,5],						
						"numShotgunBullets",5,
						"shotMass",10
					]
				]
			
			levelShipGraphicParameters = 
				[
					[true,true,42,29,4],
					[true,true,69,46,4],
					[true,true,109,75,2]
				];
			
			
			levelShipGraphics = 
				[
					Resources.ShipSmallEnemySet2,
					Resources.ShipMediumEnemySet2,
					Resources.ShipBigEnemySet2
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
					[[-45,-32,-45,-32,8,8],[] ],
					[[-20,-49,-20,-49,8,8],[] ]
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
					["SfxEnemyWeapon09"],
					["SfxEnemyWeapon10"],
					["SfxEnemyWeapon11Launch"]
				];
			
			shotExplode = 
				[
					[""],
					[""],
					["SfxEnemyWeapon11Explode"]
				];	

			iconNames = 
				[
					"PlayerShipIconSmallEnemySet2",
					"PlayerShipIconMediumEnemySet2",
					"PlayerShipIconBigEnemySet2"
				];

		}
	}
}