package zachg.util
{
	import zachg.growthItems.GrowthItem;

	public class PlayerDataVo extends Object
	{
		
		public var basicPlayTutorialShown:Boolean = false;
		public var hangarTutorialShown:Boolean = false;
		public var levelSelectTutorialShown:Boolean = false;
		
		public var currentPlayerName:String = "";
		public var isPlayerMale:Boolean = false;
		
		public var tutorialsShown:Array = new Array();
		
		//put default unlocked ids in here
		public var levelsUnlocked:Array = [0];//,1,2,3,8,9,10,11,12,13,14];
		public var levelsPlayed:Array = [0];
		public var levelsCompleted:Array = [];
		
		public var growthItemsPurchased:Array = [0];
		public var shipTutorialsShown:Array = new Array();
		
		public var currentCurrency:Number = 100;
		public var totalScore:Number = 0;
		public var numLevelsPlayed:Number = 0;
		
		public var currentPlayerEquip:int = 0;
		
		public var totalShotsFired:Number = 0;
		public var totalShotsHit:Number = 0;
		public var totalKills:Number = 0;
		public var totalThrustSpent:Number = 0;
		public var totalAreaMined:Number = 0;
		public var totalResourcesEarned:Number = 0;
		public var totalCashBalance:Number = 0;		
		
		public var averageShotsFired:Number = 0;
		public var averageShotsHit:Number = 0;
		public var averageThrustSpent:Number = 0;
		public var averageAreaMined:Number = 0;
		public var averageResourcesEarned:Number = 0;
		public var averageCashBalance:Number = 0;		
		
		//Note that this array needs to have a 0 for each level or else it will break something
		public var levelData:Array = [new LevelDataVo(0),
											new LevelDataVo(1),
											new LevelDataVo(2),
											new LevelDataVo(3),
											new LevelDataVo(4),
											new LevelDataVo(5),
											new LevelDataVo(6),
											new LevelDataVo(7),
											new LevelDataVo(8),
											new LevelDataVo(9),
											new LevelDataVo(10),
											new LevelDataVo(11),
											new LevelDataVo(12),
											new LevelDataVo(13),
											new LevelDataVo(14)
		];
		
		public var slotLocation:int = 0;
		
		public function PlayerDataVo()
		{
		}
	}
}