package zachg.growthItems.aiItem
{
	import com.Resources;
	
	import flash.geom.Point;
	
	import org.flixel.FlxPoint;
	
	import zachg.components.maps.Mapping;
	import zachg.components.maps.ShotGunMapping;
	import zachg.gameObjects.MiningBot;
	import zachg.growthItems.playerItem.PlayerItem;

	public class Stage2FriendlyShip extends AiItem
	{
				
		override public function setStats():void
		{
			levelShipHealth = [ 50,110,200];
			levelShipShotDamage = [10/damageDivider,16.5/damageDivider,20/damageDivider];
			levelShipShotDelay = [20*delayDivider,20*delayDivider,40*delayDivider];
			levelShipSpeed = [ new Point(1000/speedDivider,1000/speedDivider),new Point(875/speedDivider,875/speedDivider),new Point(750/speedDivider,750/speedDivider) ];
		}				
		
		public function Stage2FriendlyShip(Id:int)
		{
			super(Id);
			
			setStats();
			
			//contains image names for spritesheets and data
			levelShipNames = ["Tikki","Guru","Mami"];
			levelShipResourceCost = [10,15,20];
			villageResourceGrowth = [0.036,0.066,0.096];
			villageHealth = [450,495,900];
			
			
						
			villageGraphics = [
				Resources.VillageSmallFriendlyStage1,
				Resources.VillageMediumFriendlyStage1,
				Resources.VillageLargeFriendlyStage1
			];
			villageGraphicParams = [
				[true,true,150,72],
				[true,true,150,91],
				[true,true,150,150]
			];			
			
			levelShipWeaponParameters=
			[
				[ 
				],[
					"isSingleShotMode",false,
					"isParallelShot",true,
					"numParallelBullets",2
				],[
					"isSingleShotMode",false,
					"isFanShot",true,
					"numFanBullets",3					
				]			
			]

			
			levelShipGraphicParameters = 
			[
				[true,true,42,30,4],
				[true,true,72,49,4],
				[true,true,106,78,7]
			];
			levelShipGraphics = 
				[
					Resources.ShipSmallFriendlySet1,
					Resources.ShipMediumFriendlySet1,
					Resources.ShipBigFriendlySet1
				];

			levelTurretGraphicParameters = 
				[
					[[false,false,10,6],[] ],
					[[false,false,13,8],[] ],
					[[false,false,21,10],[] ]
				];
			levelTurretPositions =
				[
					[[-17,-13,-17,-13,8,8],[] ],
					[[-43,-40,-43,-40,8,8],[] ],
					[[-52,-61,-52,-61,8,8],[] ]
				];			
			
			levelTurretGraphics = 
				[
					[ [Resources.MiscGunSmall],[] ] ,
					[ [Resources.MiscGunMedium],[] ] ,
					[ [Resources.MiscGunLarge],[] ]
				];	
			
			smokeLocation = 
				[
					[-10,5],
					[-40,5],
					[-20,-30]
				];	
			
			shootNoise = 
				[
					["SfxEnemyWeapon00"],
					["SfxEnemyWeapon01"],
					["SfxEnemyWeapon02"]
				];
			
			shotExplode = 
				[
					[""],
					[""],
					[""]
				];	
			
			iconNames = 
				[
					"PlayerShipIconSmallFriendlySet1",
					"PlayerShipIconMediumFriendlySet1",
					"PlayerShipIconBigFriendlySet1"
				];			
		}
	}
}