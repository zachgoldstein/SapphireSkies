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

	public class Stage4FriendlyShip extends AiItem
	{
		
		override public function setStats():void
		{
			levelShipHealth = [ 500,700,1500];
			levelShipSpeed = [ new Point(1728/speedDivider,1728/speedDivider),new Point(1512/speedDivider,1512/speedDivider),new Point(1296/speedDivider,1296/speedDivider) ];
			levelShipShotDamage = [50/damageDivider,210/damageDivider,450/damageDivider];
			levelShipShotDelay = [5*delayDivider,2*delayDivider,10*delayDivider];
		}		
				
		public function Stage4FriendlyShip(Id:int)
		{
			super(Id);
			
			setStats();
			
			levelShipNames = ["Bombu","Kik","Fugu"];
			levelShipHealth = [250,500,1000];
			levelShipSpeed = [ new Point(1440/speedDivider,1440/speedDivider),new Point(1260/speedDivider,1260/speedDivider),new Point(1080/speedDivider,1080/speedDivider) ];
			levelShipShotDamage = [16.66/damageDivider,150/damageDivider,60/damageDivider];
			levelShipShotDelay = [5*delayDivider,30*delayDivider,40*delayDivider];
			levelShipResourceCost = [12,19,24];
			villageResourceGrowth = [0.052,0.095,0.138];
			villageHealth = [3375,4500,5400];
			
			villageGraphics = [
				Resources.VillageSmallFriendlyStage2,
				Resources.VillageMediumFriendlyStage2,
				Resources.VillageLargeFriendlyStage2
			];
			villageGraphicParams = [
				[true,true,150,150],
				[true,true,150,150],
				[true,true,150,150]
			];
			
			levelShipWeaponParameters=
				[
					[ 
						"isSingleShotMode",false,
						"isParallelShot",true,
						"numParallelBullets",3
					],[
						"isSingleShotMode",true,
						"isLaserMode",true
					],[
						"isSingleShotMode",false,
						"isFanShot",true,
						"numFanBullets",5,
						"shotMass",10
					]
				]

			levelShipGraphicParameters = 
				[
					[true,true,42,27,4],
					[true,true,72,44,4],
					[true,true,103,78,6]
				];
			
			levelShipGraphics = 
				[
					Resources.ShipSmallFriendlySet2,
					Resources.ShipMediumFriendlySet2,
					Resources.ShipBigFriendlySet2
				];
			
			levelTurretGraphicParameters = 
				[
					[[false,false,10,6],[] ],
					[[false,false,13,8],[] ],
					[[false,false,21,10],[] ]
				];
			levelTurretPositions =
				[
					[[-17,-9,-17,-9,8,8],[] ],
					[[-48,-17,-48,-17,8,8],[] ],
					[[-89,-24,-89,-24,8,8],[] ]
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
					["SfxEnemyWeapon06"],
					["SfxEnemyWeapon07"],
					["SfxEnemyWeapon08"]
				];
			
			shotExplode = 
				[
					[""],
					[""],
					[""]
				];
			
			iconNames = 
				[
					"PlayerShipIconSmallFriendlySet2",
					"PlayerShipIconMediumFriendlySet2",
					"PlayerShipIconBigFriendlySet2"
				];			
				
		}
	}
}