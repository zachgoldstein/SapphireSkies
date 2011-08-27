package zachg.states
{
	import Playtomic.*;
	
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.senocular.display.duplicateDisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	import zachg.PlayerStats;
	import zachg.growthItems.GrowthItem;
	import zachg.growthItems.buildingItem.BuildingItem;
	import zachg.growthItems.playerItem.PlayerItem;
	import zachg.ui.MoneyDisplay;
	import zachg.ui.dialogues.EquipItemDisplay;
	import zachg.util.GameMessageController;
	import zachg.util.LevelData;
	import zachg.util.PlayerDataVo;
	import zachg.util.SoundController;
	import zachg.windows.GrowthItemDisplay;
	
	public class StatsState extends FlxState
	{
	
		//TODO: extend to support more than the current screen of items.
		
		public var growthItems:Vector.<GrowthItem> = new Vector.<GrowthItem>();
		
		public var title:Label;
		
		public var isEndLevel:Boolean = false;
		public var didWin:Boolean = false; 
		public var levelPerformanceObject:Object;
		public var endLevelReason:String;
		
		public var smallButtonOn:*
		public var smallButtonOff:*		
			
		public var _previousState:FlxState;			
				
		public function StatsState(_isEndLevel:Boolean, _endLevelReason:String = "",_didWin:Boolean = false, _levelPerformanceObject:Object = null)
		{
			super();
			didWin = _didWin;
			isEndLevel = _isEndLevel;
			endLevelReason = _endLevelReason;
			levelPerformanceObject = _levelPerformanceObject
		}
		
		override public function create():void
		{			
			FlxG.mouse.hide();
			flash.ui.Mouse.show();
			
			//check for win game
			if( isEndLevel == true &&
				PlayerStats.currentLevelDataVo.levelId == (LevelData.LevelCreationData.length-1) &&
				didWin == true){

				var background:* = new Resources.UIGameOverBackground();
				addChild(background);
				
				var statsMain:* = new Resources.UIGameOverMain();
				addChild(statsMain);					
				
				smallButtonOn = new Resources.UIGameOverButtonOver();
				smallButtonOff = new Resources.UIGameOverButton();	
				
				var statsDisplay:Text = new Text(this,97,154,"","system",8,0xf7f7ed,false);
				statsDisplay.editable = false;
				statsDisplay.selectable = false;
				statsDisplay.width = 388;
				statsDisplay.height = 280;	
				
				statsDisplay.text = 
				"Climbing above the choking clouds that blanket the lower world, you reach the clean, rarefied air of your island homes. With you, the tattered remnants of the rebel task force return to the mother ship and a hero’s welcome. The party is in full swing, good food and drink are consumed with abandon and the battle weary crews watch the bright colours of the fireworks bursting in the night sky. \n \n"+
					
				"Your efforts have made you a hero in the eyes of the islanders, who hail you as "+finalPerformanceRating()+". You posses an astonishing  personal fortune of "+Math.round(PlayerStats.currentPlayerDataVo.totalCashBalance)+" rupees and a devastatingly powerful fleet of "+(PlayerStats.currentPlayerDataVo.growthItemsPurchased as Array).length+" personal ships. Your skill in battle is legendary and "+PlayerStats.currentPlayerDataVo.totalKills+" downed enemies are credited to your name. Finally your donation of "+Math.round(PlayerStats.currentPlayerDataVo.totalResourcesEarned)+" resources to friendly villages has made you popular amongst the people, who see you as both wise and generous. \n \n "+
						
				"Something is wrong though, you see the people around you with unclouded eyes, for the first time in what seems like weeks. Some dance, in apparent rapture around meaningless  totems, crafted from assorted twigs, stones and rusted metal. Others stand chanting, vacant eyed and burn the crystal, safir with incence in great braziers, welded to the deck. The swaying and blank stares of these strange few unsettles you and the sweet smoke stings your eyes, reminding you of your ship’s engine rooms. \n \n"+
							
				"Gaia is silent, and without the voice whispering it’s reassurances your mind dwells on the nature of your victory. You question your own methods and motives. The last pleas of EXCS haunt you, will  the machine’s claims of a dire future for humanity prove true?";				
				
			} else {
				
				var background:* = new Resources.BackgroundStage1();
				background.x = -700;
				background.y = -915;
				addChild(background);
				
				var cloudLeft:* = new Resources.UICloud3();
				cloudLeft.x = 110;
				cloudLeft.y = 0;
				addChild(cloudLeft);			
				
				var cloudMiddle:* = new Resources.UICloud2();
				cloudMiddle.x = 276;
				cloudMiddle.y = 81;
				addChild(cloudMiddle);
				
				var cloudRight:* = new Resources.UICloud1();
				cloudRight.x = 345;
				cloudRight.y = 42;
				addChild(cloudRight);			
				
				var statsMain:* = new Resources.UIStats();
				addChild(statsMain);	
				
				smallButtonOn = new Resources.UIButtonOnSmall();
				smallButtonOff = new Resources.UIButtonOffSmall();	
				
				var fromDescription:Label = new Label(this,145,193,"","MenuFont", 30, 0xf7f7ed);
				fromDescription.autoSize = false;
				fromDescription.width = 300;
				var textFrmt:TextFormat = fromDescription.textField.getTextFormat();
				textFrmt.align = TextFormatAlign.CENTER;
				fromDescription.textField.defaultTextFormat = textFrmt;
				
				var results:Text = new Text(this,168,235,"","MenuFont", 20, 0xf7f7ed,false);
				results.editable = false;
				results.selectable = false;
				results.width = 260;
				results.height = 70;
				
				var statsDisplay:Text = new Text(this,168,280,"","system",8,0xf7f7ed,false);
				statsDisplay.editable = false;
				statsDisplay.selectable = false;
				statsDisplay.width = 260;
				statsDisplay.height = 150;				

			}
			
			growthItems = new Vector.<GrowthItem>();
			
			growthItems = PlayerStats.growthItems;
			
			
			var muteOn:Bitmap = new Resources.UIMuteOn();
			var muteOff:Bitmap = new Resources.UIMuteOff();
			if(FlxG.mute == true){
				muteButton = new PushButton(this, FlxG.stage.stageWidth - 25, 5, "",SoundController.toggleSound,muteOn,null,muteOff,null);
			} else {
				muteButton = new PushButton(this, FlxG.stage.stageWidth - 25, 5, "",SoundController.toggleSound,muteOff,null,muteOn,null);
			}
			
			var helpOn:Bitmap = new Resources.UIHelpOn();
			var helpOff:Bitmap = new Resources.UIHelpOff();
			var helpButton:PushButton = new PushButton(this, FlxG.stage.stageWidth - 40, 5, "",GameMessageController.showMiniHelpWindow,helpOn,null,helpOff,null);			
			
			var levelRewardDislay:MoneyDisplay = new MoneyDisplay();
			levelRewardDislay.x = 19;
			levelRewardDislay.y = 3;
			addChild(levelRewardDislay);
			levelRewardDislay.setMoney( String(Math.round(PlayerStats.currentPlayerDataVo.currentCurrency)) );
			var rupee:* = new Resources.UIRupeeLarge();
			rupee.x = 7;
			rupee.y = 7;
			addChild(rupee);			
			
			var backButtonBackground:* = new Resources.UIBackButton();
			backButtonBackground.y = 385;
			backButtonBackground.x = 5;
			addChild(backButtonBackground);
			var backButton:PushButton = new PushButton(this, -7, FlxG.stage.stageHeight - 46, "Menu",goBack,
				duplicateDisplayObject(smallButtonOff),new Point(18,-17), duplicateDisplayObject(smallButtonOn),new Point(18,-17),
				"MenuFont", 30, 0xf7f7ed);
			backButton.width = 100;
			backButton.height = 12;			

			if(isEndLevel == true){
				var retryButtonBackground:* = new Resources.UIRetryBack();
				retryButtonBackground.x = 600-127;
				retryButtonBackground.y = 450-47;
				addChild(retryButtonBackground);
				var retryButton:PushButton = new PushButton(this, FlxG.stage.stageWidth - 107 , FlxG.stage.stageHeight - 42, "Retry",restart,
					duplicateDisplayObject(smallButtonOff),new Point(-3,5), duplicateDisplayObject(smallButtonOn),new Point(-3,5),
					"MenuFont", 30, 0xf7f7ed);
				retryButton.width = 100;
				retryButton.height = 12;
			} else {
				if(SoundController.isMenuMusicPlaying != true){
					SoundController.playSong(MusicMainMenu);
					SoundController.isMenuMusicPlaying = true;
				}
				
				if(retryButton != null){
					retryButton.enabled = false;
				}
			}
			
			if(isEndLevel == true){
				var loggingLevelTite:String = "I"+PlayerStats.currentLevelDataVo.levelId+" "+LevelData.LevelTitles[PlayerStats.currentLevelDataVo.levelId];
				Log.LevelCounterMetric("FinishedLevel", loggingLevelTite);
				Log.ForceSend();
				//LevelData.LevelTitles[PlayerStats.currentLevelDataVo.levelId]+" I"+PlayerStats.currentLevelDataVo.levelId
				
				if(didWin == true){
					fromDescription.text = "You Won ";
					results.text = endLevelReason + "! You earned the $"+ Math.round(LevelData.LevelCreationData[PlayerStats.currentLevelId][7])+" rupee reward";			
				} else {
					fromDescription.text = "You Lose ";
					results.text = endLevelReason + "!";
				}
				
				if(GlobalVariables.cheatsUsed == false){
					Log.LevelAverageMetric(
						"CashAtLevelStart",
						loggingLevelTite,
						PlayerStats.currentPlayerDataVo.currentCurrency
					);
				}
				
				if(levelPerformanceObject.cashBalance < 0 || didWin == false){levelPerformanceObject.cashBalance = 0};
				//unlock levels and give rewards
				PlayerStats.recordLevelPlay(PlayerStats.currentLevelId);
				if(didWin == true){
					PlayerStats.unlockLevel(LevelData.LevelCreationData[PlayerStats.currentLevelId][10]);
					PlayerStats.recordLevelComplete(PlayerStats.currentLevelId);
					levelPerformanceObject.cashBalance += LevelData.LevelCreationData[PlayerStats.currentLevelId][7]					
				}
				
				PlayerStats.currentPlayerDataVo.currentCurrency += levelPerformanceObject.cashBalance;
				if(GlobalVariables.cheatsUsed == false){
					Log.LevelAverageMetric("CashEarned",loggingLevelTite,levelPerformanceObject.cashBalance);
					Log.LevelAverageMetric(
						"CashAtLevelEnd",
						loggingLevelTite,
						PlayerStats.currentPlayerDataVo.currentCurrency
					);
				}
				Log.LevelAverageMetric("kills", loggingLevelTite, levelPerformanceObject.kills);
				Log.LevelAverageMetric("shotsFired", loggingLevelTite, levelPerformanceObject.shotsFired);
				Log.LevelAverageMetric("shotsAccuracy", loggingLevelTite, (levelPerformanceObject.shotsHit/levelPerformanceObject.shotsFired) * 100);
				Log.LevelAverageMetric("shotsHit", loggingLevelTite, levelPerformanceObject.shotsHit);
				Log.LevelAverageMetric("distanceTravelled", loggingLevelTite, levelPerformanceObject.thrustSpent);
				Log.LevelAverageMetric("areaMined", loggingLevelTite, levelPerformanceObject.areaMined);
				Log.LevelAverageMetric("resourcesGivenToVillages", loggingLevelTite, levelPerformanceObject.resourcesEarned);
				Log.ForceSend();
					
				PlayerStats.currentPlayerDataVo.numLevelsPlayed++;
				findNewAverage();
				findNewTotals();
				PlayerStats.saveCurrentPlayerData();				
				
				var accuracy:Number = Math.round(levelPerformanceObject.shotsHit/levelPerformanceObject.shotsFired * 100);
				
				if(statsDisplay != null && levelPerformanceObject != null){
					statsDisplay.text = 
						"You performed at a "+ratePerformance(false)+ " rating "+" and earned "+Math.round(levelPerformanceObject.cashBalance) + " Rupees during the mission \n \n " +
						"In total, " + levelPerformanceObject.shotsFired+" shots have been fired, "+levelPerformanceObject.shotsHit+" of which connected with an enemy \n \n "+
						"You've comsumed " + levelPerformanceObject.thrustSpent+" gallons of fuel \n \n "+
						"You've mined " + levelPerformanceObject.areaMined+" square meters of earth \n \n "+
						"You've also been kind enough to provide " + levelPerformanceObject.resourcesEarned+" resources to friendly villages \n \n " +
						"Overall, you earned "+Math.round(levelPerformanceObject.cashBalance) +" Rupees during that mission";
				}
			} else {
				Log.CustomMetric("ViewedStats");
				fromDescription.text = "Statistics";
				results.text = "During your adventures, the following has occured:";
				
				statsDisplay.text =
					"You performed at a "+ratePerformance(true)+ " rating overall "+" and earned "+PlayerStats.currentPlayerDataVo.averageCashBalance + " Rupees during each level on average \n \n " +
					"In total, "+PlayerStats.currentPlayerDataVo.totalShotsFired+" shots have been fired, "+PlayerStats.currentPlayerDataVo.totalShotsHit+" of which connected with an enemy \n \n "+
					"You've comsumed " +PlayerStats.currentPlayerDataVo.totalThrustSpent+" gallons of fuel \n \n "+
					"You've mined " +PlayerStats.currentPlayerDataVo.totalAreaMined+" square meters of earth \n \n "+
					"You've also been kind enough to provide " +PlayerStats.currentPlayerDataVo.totalResourcesEarned+" resources to friendly villages \n \n " +
					"Overall, you're net worth is "+Math.round(PlayerStats.currentPlayerDataVo.totalCashBalance) +" Rupees";
			}
			
			//var levelSelect:PushButton = new PushButton(this, this.width- 110, this.height - 25, "Select Level",selectLevel);
			transitionIn();
		}		
		
		public function refresh():void
		{
			//FlxG.state = new EquipState();			
		}
		
		private function selectLevel(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(selectLevelTransitionFinished);
		}		
		private function selectLevelTransitionFinished(e:MouseEvent = null):void
		{
			FlxG.state = new LevelSelectionState();
		}
		
		public function findNewAverage():void
		{
			PlayerStats.currentPlayerDataVo.averageShotsFired = Math.round( (levelPerformanceObject.shotsFired + PlayerStats.currentPlayerDataVo.averageShotsFired)/PlayerStats.currentPlayerDataVo.numLevelsPlayed); 
			PlayerStats.currentPlayerDataVo.averageShotsHit = Math.round( (levelPerformanceObject.shotsHit + PlayerStats.currentPlayerDataVo.averageShotsHit)/PlayerStats.currentPlayerDataVo.numLevelsPlayed);
			PlayerStats.currentPlayerDataVo.averageThrustSpent = Math.round( (levelPerformanceObject.thrustSpent + PlayerStats.currentPlayerDataVo.averageThrustSpent)/PlayerStats.currentPlayerDataVo.numLevelsPlayed);
			PlayerStats.currentPlayerDataVo.averageAreaMined = Math.round( (levelPerformanceObject.areaMined + PlayerStats.currentPlayerDataVo.averageAreaMined)/PlayerStats.currentPlayerDataVo.numLevelsPlayed);
			PlayerStats.currentPlayerDataVo.averageResourcesEarned = Math.round( (levelPerformanceObject.resourcesEarned + PlayerStats.currentPlayerDataVo.averageResourcesEarned)/PlayerStats.currentPlayerDataVo.numLevelsPlayed);
			PlayerStats.currentPlayerDataVo.averageCashBalance = Math.round( (levelPerformanceObject.cashBalance + PlayerStats.currentPlayerDataVo.averageCashBalance)/PlayerStats.currentPlayerDataVo.numLevelsPlayed);
		}
		
		public function findNewTotals():void
		{
			PlayerStats.currentPlayerDataVo.totalShotsFired += levelPerformanceObject.shotsFired; 
			PlayerStats.currentPlayerDataVo.totalShotsHit += levelPerformanceObject.shotsHit;
			PlayerStats.currentPlayerDataVo.totalThrustSpent += levelPerformanceObject.thrustSpent;
			PlayerStats.currentPlayerDataVo.totalAreaMined += levelPerformanceObject.areaMined;
			PlayerStats.currentPlayerDataVo.totalResourcesEarned += levelPerformanceObject.resourcesEarned;
			PlayerStats.currentPlayerDataVo.totalCashBalance += levelPerformanceObject.cashBalance;
			PlayerStats.currentPlayerDataVo.totalKills += levelPerformanceObject.kills;
		}
		
		public function ratePerformance(isOverallAverage:Boolean):String
		{
			var accuracy:Number;
			if(isOverallAverage == false && levelPerformanceObject != null){
				accuracy = Math.round(levelPerformanceObject.shotsFired/levelPerformanceObject.shotsHit * 100);
			} else {
				accuracy = Math.round(PlayerStats.currentPlayerDataVo.totalShotsFired/PlayerStats.currentPlayerDataVo.totalShotsHit * 100);
			}
			if(accuracy < 50){
				return "D"
			} else if(accuracy < 75){
				return "C"
			} else if(accuracy < 85){
				return "B"
			} else if(accuracy < 95){
				return "A"
			} else if(accuracy < 150){
				return "A+"
			}
			
			return "D-"
		}	
		
		public function finalPerformanceRating():String
		{			
			var accuracy:Number = Math.round(PlayerStats.currentPlayerDataVo.totalShotsFired/PlayerStats.currentPlayerDataVo.totalShotsHit * 100);
		
			if(accuracy < 50){
				return "a Sky Master"
			} else if(accuracy < 75){
				return "a Sky Lord"
			} else if(accuracy < 85){
				return "the Hammer of EXCS"
			} else if(accuracy < 95){
				return "the Cloud Dancer"
			} else if(accuracy < 150){
				return "the Thunder Dragon"
			}
			
			return "a Super Ace"			
		}
		
		private function goBack(e:MouseEvent):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			transitionOut(selectLevelTransitionFinished);
		}		

		private function restart(e:MouseEvent = null):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			FlxG.state = new PlayState(null);
			if(isEndLevel == false){
			}
		}				

		private function transitionIn():void
		{
			var transitionHolder:Sprite = new Sprite();
			
			var whiteOut:Sprite = new Sprite();
			whiteOut.graphics.beginFill(0xf9f8ec,1);
			whiteOut.graphics.drawRect(0,0,FlxG.stage.stageWidth, FlxG.stage.stageHeight);
			transitionHolder.addChild(whiteOut);
			
			var gameLogo:* = new Resources.UISapphireSkiesLogoLarge();
			gameLogo.x = Math.round(FlxG.stage.stageWidth/2 - gameLogo.width/2); 
			gameLogo.y = Math.round(FlxG.stage.stageHeight/2 - gameLogo.height/2);
			whiteOut.addChild(gameLogo);			
			
			var transitionIn:* = new Resources.UITransitionRight();
			transitionIn.x = whiteOut.width - 15;
			var blur:BlurFilter =new BlurFilter(25,5,2);
			transitionIn.filters = [blur];
			transitionHolder.addChild(transitionIn);
			addChild(transitionHolder);
			//.75
			var myTween:GTween = new GTween(transitionHolder, .5, {x:(-transitionHolder.width)}, {ease:Linear.easeNone});
			//myTween.addEventListener("complete",animationFinished,false,0,true);
		}
		
		private var finishedCallback:Function;
		private function transitionOut(callbackMethod:Function):void
		{			
			SoundController.playSoundEffect("SfxScreenTransition");
			
			finishedCallback = callbackMethod;
			
			var transitionHolder:Sprite = new Sprite();
			
			var whiteOut:Sprite = new Sprite();
			whiteOut.graphics.beginFill(0xf9f8ec,1);
			whiteOut.graphics.drawRect(0,0,FlxG.stage.stageWidth+15, FlxG.stage.stageHeight);
			transitionHolder.addChild(whiteOut);
			
			var gameLogo:* = new Resources.UISapphireSkiesLogoLarge();
			gameLogo.x = Math.round(FlxG.stage.stageWidth/2 - gameLogo.width/2); 
			gameLogo.y = Math.round(FlxG.stage.stageHeight/2 - gameLogo.height/2);
			whiteOut.addChild(gameLogo);
			
			var transitionOut:* = new Resources.UITransitionLeft();
			transitionOut.x = stage.stageWidth;
			var blur:BlurFilter =new BlurFilter(25,5,2);
			transitionOut.filters = [blur];
			transitionHolder.addChild(transitionOut);
			transitionOut.x = 0;
			whiteOut.x = transitionOut.width-15;
			transitionHolder.x = FlxG.stage.stageWidth;
			addChild(transitionHolder);
			
			var myTween:GTween = new GTween(transitionHolder, .5, {x:(-transitionOut.width)}, {ease:Linear.easeNone});
			myTween.addEventListener("complete",animatedOut,false,0,true);
		}
		
		private function animatedOut(e:Event = null):void
		{
			finishedCallback();
		}
		
	}
}