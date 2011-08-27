package zachg
{
	import flash.utils.describeType;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSave;
	
	import zachg.components.maps.DamageBoostMap;
	import zachg.gameObjects.BuildingGroup;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.PopulationCenter;
	import zachg.gameObjects.Shop;
	import zachg.growthItems.GrowthItem;
	import zachg.growthItems.buildingItem.BuildingItem;
	import zachg.growthItems.buildingItem.FactoryPeopleBoostItem;
	import zachg.growthItems.buildingItem.FactoryResourceBoostItem;
	import zachg.growthItems.buildingItem.PopulationCenterPopBoostItem;
	import zachg.growthItems.buildingItem.PopulationCenterRateBoostItem;
	import zachg.growthItems.buildingItem.PopulationCenterUnitRateBoostItem;
	import zachg.growthItems.buildingItem.ShopResearchSpeedItem;
	import zachg.growthItems.buildingItem.ShopResourceBoostItem;
	import zachg.growthItems.buildingItem.ShopUnitRateBoostItem;
	import zachg.growthItems.buildingItem.VillageBotShotItem;
	import zachg.growthItems.buildingItem.VillageResourceBoostItem;
	import zachg.growthItems.buildingItem.VillageUnitRateItem;
	import zachg.growthItems.playerItem.AlgizShip;
	import zachg.growthItems.playerItem.BasicShip;
	import zachg.growthItems.playerItem.BombuShip;
	import zachg.growthItems.playerItem.FastMiner;
	import zachg.growthItems.playerItem.FuguShip;
	import zachg.growthItems.playerItem.GeboShip;
	import zachg.growthItems.playerItem.GuruShip;
	import zachg.growthItems.playerItem.KikiShip;
	import zachg.growthItems.playerItem.LaserShip;
	import zachg.growthItems.playerItem.MamiShip;
	import zachg.growthItems.playerItem.MediocreBalancedShip;
	import zachg.growthItems.playerItem.PlayerItem;
	import zachg.growthItems.playerItem.RaidhoShip;
	import zachg.growthItems.playerItem.SlowFortress;
	import zachg.growthItems.playerItem.ThurisazShip;
	import zachg.growthItems.playerItem.ThwazShip;
	import zachg.growthItems.playerItem.UruzShip;
	import zachg.states.SaveLoadState;
	import zachg.util.LevelData;
	import zachg.util.LevelDataVo;
	import zachg.util.PlayerDataVo;
	
	public class PlayerStats
	{
		public static var growthItems:Vector.<GrowthItem> = new Vector.<GrowthItem>(); 
		public static var initialized:Boolean = false;
		
		//temporary
		public static var currentPlayerClarityPoints:Number = 100;
		
		//Save/load is built in here, where all the information being saved is stored.
		public static var flxSave:FlxSave = new FlxSave(); 
		public static var isLoadedSuccessfully:Boolean = false;

		public static var saveBindName:String = "prototype1_ReindeerFlotilla_2011"
		
		public static var playerDataVos:Vector.<Object> = new Vector.<Object>();
		public static var currentPlayerDataVoIndex:int;
		
		public static var currentLevelDataVo:Object;
		
		//Even though we've got a PlayerDataVo object, we can't store that class because the SO strips the class down to just object.
		private static var _currentPlayerDataVo:Object;
		
		public static var currentLevelId:int;
		
		public static var isNewUser:Boolean = false;
		
		public function PlayerStats()
		{
			
		}
		
		public static function initializeStats():void
		{
			if(initialized == true){
				return
			}
			
			flxSave = new FlxSave();
			isLoadedSuccessfully = flxSave.bind(saveBindName);
			
			if(isLoadedSuccessfully == true){
				//identify if it's a new or returning user
				
				//only called because I can't find place to delete the cookie locally.
				//flxSave._so.clear();
				
				if(flxSave.data.playerDataVos == null){
					trace("new user");
					isNewUser = true;
					newGame();
				} else {
					trace("returning user");
					isNewUser = false;
					loadCurrentPlayerData();
				}
			} else {
				dataNotLoaded();
			}
			
			//var dummyGrowthItem:GrowthItem = ;
			//dummyGrowthItem.isEquipped = true;
			//dummyGrowthItem.isPurchased = true;
			
			initialized = true;
		}
		
		public static function setDefaultUpgradeItems():void
		{
			//setup all the possible purchasable items
			growthItems = new Vector.<GrowthItem>();
			growthItems.push(
				new BasicShip(0),
				new GuruShip(1),
				new MamiShip(2),
				new AlgizShip(3),
				new ThurisazShip(4),
				new GeboShip(5),
				new BombuShip(6),
				new KikiShip(7),
				new FuguShip(8),
				new UruzShip(9),
				new RaidhoShip(10),
				new ThwazShip(11)
			);
		}
		
		public static function newGame(id:int = -1):void
		{
			setDefaultUpgradeItems();
			var newPlayerSave:PlayerDataVo = null;
			if(id == -1){
				newPlayerSave = new PlayerDataVo();
				currentLevelDataVo = newPlayerSave.levelData[0];
				newPlayerSave.slotLocation = 0;
				playerDataVos.push(newPlayerSave);
				currentPlayerDataVoIndex = playerDataVos.length-1;
				
				//forces a save of the previous info
				currentPlayerDataVo = newPlayerSave; 
				
			} else {
				
				//find a save in the same slot and overwrite it with the new save;
				for(var i:int = 0 ; i < playerDataVos.length ; i++){
					if(playerDataVos[i].slotLocation == id){
						newPlayerSave = new PlayerDataVo();
						currentLevelDataVo = newPlayerSave.levelData[0];
						newPlayerSave.slotLocation = id;
						playerDataVos[i] = newPlayerSave;
						currentPlayerDataVoIndex = i;
						
						//forces a save of the previous info
						currentPlayerDataVo = newPlayerSave; 
					}
				}
				
				if(newPlayerSave == null){
					newPlayerSave = new PlayerDataVo();
					currentLevelDataVo = newPlayerSave.levelData[0];
					newPlayerSave.slotLocation = id;
					playerDataVos.push(newPlayerSave);
					currentPlayerDataVoIndex = playerDataVos.length-1;
					
					//forces a save of the previous info
					currentPlayerDataVo = newPlayerSave; 
				}
			}
			
			//set default player upgrades
			for (var i:int = 0 ; i < newPlayerSave.growthItemsPurchased.length; i++){
				growthItems[newPlayerSave.growthItemsPurchased[i] ].isPurchased = true;
			}

		}
		
		public static function isLevelUnlocked(levelId:int):Boolean
		{
			for( var i:int = 0 ; i < (currentPlayerDataVo.levelsUnlocked as Array).length ; i++){
				if( currentPlayerDataVo.levelsUnlocked[i] == levelId){
					return true;
				}
			}
			return false;
		}
		
		public static function unlockLevel(levelId:int):Boolean
		{
			if(levelId == -1){
				if (isLevelUnlocked(1) == false ){
					(currentPlayerDataVo.levelsUnlocked as Array).push(1);
					return true
				}
			} else if (isLevelUnlocked(levelId) == false ){
				(currentPlayerDataVo.levelsUnlocked as Array).push(levelId);
				saveCurrentPlayerData();
				return true
			}
			return false
		}
		
		public static function recordLevelPlay(levelId:int):Boolean
		{
			for( var i:int = 0 ; i < (currentPlayerDataVo.levelsPlayed as Array).length ; i++){
				if (hasLevelBeenPlayed(levelId) == false ){
					(currentPlayerDataVo.levelsPlayed as Array).push(levelId);
					saveCurrentPlayerData();
					return true
				}
			}
			return false
		}		

		public static function hasLevelBeenPlayed(levelId:int):Boolean
		{
			for( var i:int = 0 ; i < (currentPlayerDataVo.levelsPlayed as Array).length ; i++){
				if( currentPlayerDataVo.levelsPlayed[i] == levelId){
					return true;
				}
			}
			return false;
		}		

		public static function recordLevelComplete(levelId:int):Boolean
		{
			for( var i:int = 0 ; i < (currentPlayerDataVo.levelsCompleted as Array).length ; i++){
				if (hasLevelBeenCompleted(levelId) == false ){
					(currentPlayerDataVo.levelsCompleted as Array).push(levelId);
					return true
				}
			}
			if(levelId == 0 && (currentPlayerDataVo.levelsCompleted as Array).length == 0){
				(currentPlayerDataVo.levelsCompleted as Array).push(0);
			}
			return false
		}		
		
		public static function hasLevelBeenCompleted(levelId:int):Boolean
		{
			for( var i:int = 0 ; i < (currentPlayerDataVo.levelsCompleted as Array).length ; i++){
				if( currentPlayerDataVo.levelsCompleted[i] == levelId){
					return true;
				}
			}
			return false;
		}		
		
		public static function isUpgradePurchased(upgradeId:int):Boolean
		{
			var isUpgradeUnlocked:Boolean = false;
			for( var i:int = 0 ; i < growthItems.length ; i++){
				if( upgradeId == i && growthItems[i].isPurchased == true){
					return true
				}
			}
			return false;
		}		
		
		//Uses description for now, should probably check by an id of some sort instead 
		//because descriptions aren't forced to be unique 
		public static function getGrowthItemId(description:String):int
		{
			for( var i:int = 0 ; i < growthItems.length ; i++){
				if( growthItems[i].description == description){
					return i
				}
			}
			return -1;
		}
		
/*		public static function getCurrentPlayerData():Object
		{
			if(playerDataVos[currentPlayerDataVoIndex] != null){
				return playerDataVos[currentPlayerDataVoIndex]
			} else {
				trace("getCurrentPlayerData returned null, something is wrong!");
				return null				
			}
		}*/
		
		public static function saveCurrentPlayerData():void
		{
			trace("Saving");
			if((_currentPlayerDataVo.levelData as Array)[0] == null){
				trace("warning, shit just got fucked up, (_currentPlayerDataVo.levelData as Array)[0] == null ");
			}
			playerDataVos[currentPlayerDataVoIndex] = _currentPlayerDataVo;
			
			_currentPlayerDataVo.levelData[currentLevelId] = currentLevelDataVo;
			
			flxSave.data.playerDataVos = playerDataVos;
			flxSave.data.playerDataVos[currentPlayerDataVoIndex] = playerDataVos[currentPlayerDataVoIndex];
			flxSave.data.currentPlayerDataVoIndex = currentPlayerDataVoIndex;
		}

		public static function loadCurrentPlayerData(id:int = -1):void
		{
			trace("Loading");
			playerDataVos = flxSave.data.playerDataVos;
			if(id != -1){
				currentPlayerDataVoIndex = id;
			} else {
				currentPlayerDataVoIndex = flxSave.data.currentPlayerDataVoIndex;
			}
			_currentPlayerDataVo = playerDataVos[currentPlayerDataVoIndex];
			currentLevelDataVo = _currentPlayerDataVo.levelData[0];
			if((_currentPlayerDataVo.levelData as Array)[0] == null){
				trace("loaded some fucked up shit.");
			}			
			
			//set default player upgrades
			setDefaultUpgradeItems();
			for (var i:int = 0 ; i < _currentPlayerDataVo.growthItemsPurchased.length; i++){
				growthItems[_currentPlayerDataVo.growthItemsPurchased[i] ].isPurchased = true;
			}

		}
		
		public static function dataNotLoaded():void
		{
			trace("player data not loaded"); 
		}
		
		/**
		 * Return a list of all the research items the player can upgrade. 
		 * The list goes from first research item to last. 
		 * 
		 */
		public static function getResearchItemList():Vector.<PlayerItem>
		{
			var researchList:Vector.<PlayerItem> = new Vector.<PlayerItem>();
			for (var i:int = 0 ; i < growthItems.length ; i++){
				if(growthItems[i] is PlayerItem){
					if(growthItems[i].isPurchased == true){
						researchList.push(growthItems[i]);
					}
				}
			}
			return researchList
		}
		
		public static function getNumItemsPurchased():Number
		{
			var numPurchased:Number = 0;
			for (var i:int = 0 ; i < growthItems.length ; i++){
				if(growthItems[i].isPurchased == true){
					numPurchased++;
				}
			}
			return numPurchased
		}
		
		public static function getAllPlayerItems():Vector.<PlayerItem>
		{
			var playerItemList:Vector.<PlayerItem> = new Vector.<PlayerItem>();
			for (var i:int = 0 ; i < growthItems.length ; i++){
				if(growthItems[i] is PlayerItem){
					playerItemList.push(growthItems[i]);
				}
			}
			return playerItemList
		}
		
		public static function getAllGrowthItemsForBuilding(buildingClass:Class):Vector.<BuildingItem>
		{
			var buildingItemList:Vector.<BuildingItem> = new Vector.<BuildingItem>();
			for (var i:int = 0 ; i < growthItems.length ; i++){
				if(growthItems[i] is BuildingItem){
					if( (growthItems[i] as BuildingItem).buildingType == buildingClass) {
						buildingItemList.push(growthItems[i]);
					}
				}
			}
			return buildingItemList
			
		}
		
		public static function getUpgradesAtLevel(building:BuildingGroup,level:Number):void
		{
			if(building is Shop){
				
			} else if(building is Factory){
				
			} else if(building is PopulationCenter){
				
			}
		}
		
		public static function buyItem():void
		{
			
		}
		
		public static function equipItem():void
		{
			
		}

		public static function get currentPlayerDataVo():Object
		{
			return _currentPlayerDataVo;
		}

		public static function set currentPlayerDataVo(value:Object):void
		{
			_currentPlayerDataVo = value;
			saveCurrentPlayerData();
		}

		public static function generateRandomString(newLength:uint = 1, userAlphabet:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"):String{
			var alphabet:Array = userAlphabet.split("");
			var alphabetLength:int = alphabet.length;
			var randomLetters:String = "";
			for (var i:uint = 0; i < newLength; i++){
				randomLetters += alphabet[int(Math.floor(Math.random() * alphabetLength))];
			}
			return randomLetters;
		}
		
	}
}