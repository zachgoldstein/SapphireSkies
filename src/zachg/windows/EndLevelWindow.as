package zachg.windows
{
	import com.GlobalVariables;
	import com.PlayState;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.flixel.FlxG;
	
	import zachg.PlayerStats;
	import zachg.growthItems.playerItem.PlayerItem;
	import zachg.states.LevelSelectionState;
	import zachg.util.EffectController;
	import zachg.util.PlayerDataVo;
	
	public class EndLevelWindow extends Sprite
	{
		
		public var background:Window;
		public var closeButton:PushButton;
		
		public var closeCallBack:Function
		
		public var restartLevelButton:PushButton;
		public var chooseLevelButton:PushButton;
		
		public var winLoseText:Label;
		
		public var performanceLabel:Label;
		public var shotsFiredHitLabel:Label;
		public var accruacyLabel:Label;
		public var thrustSpentLabel:Label;
		public var areaMinedLabel:Label;
		public var resourcesMined:Label; 
		
		public var didWin:Boolean = false;
		public var levelEndExplanation:String = "";
		
		//TODO: re-work whole class to handle more than 3 items
		
		public function EndLevelWindow(CloseCallBack:Function = null)
		{
			super();
			closeCallBack = CloseCallBack
			
			background = new Window(this,0,0,"End of Level");
			background.width = 200;
			background.height = 165;
			background.draggable = false;
			
			winLoseText = new Label(this,background.width/2 - 108/2,25,"");
			restartLevelButton = new PushButton(this,background.width - 80,140,"Restart Level",close);
			restartLevelButton.width = 75;
			chooseLevelButton = new PushButton(this,5,140,"Select Level",selectLevel);
			chooseLevelButton.width = 75;
						
			//Only called at start of level
			PlayerStats.currentPlayerDataVo.currentPlayerClarityPoints += (FlxG.state as PlayState).player.levelComponent.totalExperience;
			PlayerStats.saveCurrentPlayerData();
			
			performanceLabel = new Label(this,10,35,"You performed at a "+ratePerformance()+ " level \n"
													+" and earned "+(FlxG.state as PlayState).player.levelComponent.totalExperience+" clarity pts");
			shotsFiredHitLabel = new Label(this,10,60,PlayerStats.currentLevelDataVo.shotsHit+"/"+PlayerStats.currentLevelDataVo.shotsFired+" bullets connected"); 
			
			var accuracy:Number = Math.round(PlayerStats.currentLevelDataVo.shotsHit/PlayerStats.currentLevelDataVo.shotsFired * 100);
			accruacyLabel = new Label(this,10,75,accuracy+"% firing accuracy");
			thrustSpentLabel = new Label(this,10,90,PlayerStats.currentLevelDataVo.thrustSpent+" thrust spent");
			areaMinedLabel = new Label(this,10,105,PlayerStats.currentLevelDataVo.areaMined+" area mined");
			resourcesMined = new Label(this,10,120,PlayerStats.currentLevelDataVo.resourcesEarned+" resources given to villages");
			
		}
		
		public function ratePerformance():String
		{
			var accuracy:Number = Math.round(PlayerStats.currentLevelDataVo.shotsHit/PlayerStats.currentLevelDataVo.shotsFired * 100);
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
			
			return "F"
		}
		
		public function close(e:MouseEvent):void
		{
			closeCallBack(e);
		}
		
		public function selectLevel(e:MouseEvent):void
		{
			FlxG.state = new LevelSelectionState();
		}
		
		//Gets called after a level finishes
		public function refresh():void
		{
			if(didWin == true){
				winLoseText.text = "You Won "+levelEndExplanation+"!"
			} else {
				winLoseText.text = "You Lose "+levelEndExplanation+"!"
			}
			
			PlayerStats.currentPlayerDataVo.currentPlayerClarityPoints += (FlxG.state as PlayState).player.levelComponent.totalExperience;
			PlayerStats.currentPlayerDataVo.totalScore += (FlxG.state as PlayState).player.levelComponent.totalExperience;
			
			if( PlayerStats.currentLevelDataVo.levelHighscore < (FlxG.state as PlayState).player.levelComponent.totalExperience){
				PlayerStats.currentLevelDataVo.levelHighscore = (FlxG.state as PlayState).player.levelComponent.totalExperience
			}
			PlayerStats.saveCurrentPlayerData();
			
			shotsFiredHitLabel.text = PlayerStats.currentLevelDataVo.shotsHit+"/"+PlayerStats.currentLevelDataVo.shotsFired+" bullets connected"; 
			var accuracy:Number = Math.round(PlayerStats.currentLevelDataVo.shotsHit/PlayerStats.currentLevelDataVo.shotsFired * 100);
			accruacyLabel.text = accuracy+"% firing accuracy";
			thrustSpentLabel.text = PlayerStats.currentLevelDataVo.thrustSpent+" thrust spent";
			areaMinedLabel.text = PlayerStats.currentLevelDataVo.areaMined+" area mined";
			resourcesMined.text = PlayerStats.currentLevelDataVo.resourcesEarned+" resources given to villages";
			
			performanceLabel.text = "You performed at a "+ratePerformance()+ " level \n"
				+" and earned "+(FlxG.state as PlayState).player.levelComponent.totalExperience+" clarity pts";
		}
	}
}