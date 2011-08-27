package zachg.ui.dialogues
{
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.Window;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.flixel.FlxG;
	
	import zachg.PlayerStats;
	import zachg.ui.MoneyDisplay;
	import zachg.util.LevelData;

	public class LevelInfoDialogue extends Sprite
	{
		
		public var descriptionText:Text;
		public var startLevelButton:PushButton;
		public var levelTiteLabel:Label;
		public var levelStatusLabel:Label;
		public var levelScoreLabel:Label;
		public var levelRewardLabel:Label;
		public var levelRewardDislay:MoneyDisplay;
		
		public var levelClassName:Class;
		public var mouseClickCallback:Function
		
		public var levelId:int;
		
		public var highScore:Number;
		public var levelReward:Number;
		
		public var islevelUnlocked:Boolean;
		public var hasBeenPlayed:Boolean;
		public var hasBeenCompleted:Boolean;
		public var location:Point;
		
		public var description:String;
		public var title:String;
		
		public var hangarOn:* = new Resources.UIHangarOn();
		public var hangarOff:* = new Resources.UIHangarOff();
		public var hangarRoll:* = new Resources.UIHangarRoll();
		public var hintIcon:*;
		
		public function LevelInfoDialogue(levelIndex:int = -1,callBackMouseClick:Function = null)
		{
			super();
			
			mouseClickCallback = callBackMouseClick;
			levelId = levelIndex;
			
			levelTiteLabel = new Label(this,0,0,"","MenuFont", 15, 0xf7f7ed);
			levelStatusLabel = new Label(this,220,0,"","MenuFont", 15, 0xf0652c);
			
			descriptionText = new Text(this,0,15,"","system",8,0xf7f7ed,false);
			
			descriptionText.editable = false;
			descriptionText.selectable = false;
			descriptionText.width = 280;
			descriptionText.height = 115;
			
			hintIcon = new Resources.UITutorialIcon();
			addChild(hintIcon);
			hintIcon.x = 0;
			hintIcon.y = 0;			
			
			var levelRewardLabel:Label = new Label(this,25,124,"Reward:","MenuFont", 15, 0xf0652c);
			
			levelRewardDislay = new MoneyDisplay();
			levelRewardDislay.x = 95;
			levelRewardDislay.y = 122;
			addChild(levelRewardDislay);
			var rupee:* = new Resources.UIRupeeLarge();
			rupee.x = 82;
			rupee.y = 126;
			addChild(rupee);
			
			disableStartLevel();
			
			setLevel(levelIndex);
			
			
		}
		
		public function disableStartLevel():void
		{
			startLevelButton = new PushButton(this,76,150,"",startLevel,hangarOff);
			startLevelButton.enabled = false;
		}
		public function enableStartLevel():void
		{
			startLevelButton = new PushButton(this,76,150,"",startLevel,hangarOn,null,hangarRoll,null);
		}
		
		public function setLevel(level:Number):void
		{
			levelId = level;
			if(level != -1){
				hintIcon.visible = false;
				islevelUnlocked = PlayerStats.isLevelUnlocked(level);
				hasBeenPlayed = PlayerStats.hasLevelBeenCompleted(level);
				hasBeenCompleted = PlayerStats.hasLevelBeenCompleted(level);
				
				if( islevelUnlocked == true ){
					if(hasBeenPlayed == false){
						levelStatusLabel.text = "New!";
					} else if(hasBeenCompleted == true){
						levelStatusLabel.text = "Completed";
					}
					
					title ="Mission: "+ LevelData.LevelTitles[level]; 
					description = LevelData.LevelDescriptions[level]; 
					levelClassName = LevelData.LevelClassNames[level];
					highScore = PlayerStats.currentPlayerDataVo.levelData[level].levelHighscore;
					levelReward = LevelData.LevelCreationData[level][7];
					enableStartLevel();
				} else {
					levelStatusLabel.text = "Locked";
					title = "Locked mission: '" + LevelData.LevelTitles[level] + "'"; 
					description = ""; 
					levelClassName = null
					highScore = 0;
					levelReward = 0;
				}
			} else {
				hintIcon.visible = true;
				title = "         Level Not Selected"; 
				description = "         Use the arrows to change the selected island region. If a region is unlocked, several radar pings will appear. Clicking on these pings will select a level. Clicking the hangar button will then start deployment."; 
				levelClassName = null
				highScore = 0;
				levelReward = 0;
				islevelUnlocked = false;
				disableStartLevel();
			}
			
			levelTiteLabel.text = title;
			descriptionText.text = description;
			levelRewardDislay.setMoney(String(levelReward))
			
			if(islevelUnlocked == false){
				startLevelButton.enabled = false;
			} else {
				startLevelButton.enabled = true;
			}
			
		}
		
		private function startLevel(e:MouseEvent):void
		{
			if(levelId != -1){
				PlayerStats.currentLevelId = levelId;
				PlayerStats.currentLevelDataVo = PlayerStats.currentPlayerDataVo.levelData[levelId];
					
				PlayerStats.currentLevelDataVo.levelId = levelId;
				mouseClickCallback(null);
			}
		}
		
	}
}