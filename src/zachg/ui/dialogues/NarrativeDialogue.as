package zachg.ui.dialogues
{
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.senocular.display.duplicateDisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import zachg.PlayerStats;
	import zachg.util.GameMessageController;
	import zachg.util.levelEvents.LevelEvent;
	
	public class NarrativeDialogue extends Sprite
	{
		public var levelEvent:LevelEvent;
		public var boxTitle:Label;
		public var textBox:Text;
		public var endNarrative:PushButton;
		
		public var skipAllNarrative:PushButton;
		
		public static var dialogueWidth:Number = 375;
		
		public function NarrativeDialogue( passedLevelEvent:LevelEvent, message:String, characterName:String, imageClass:Class)
		{
			super();
			levelEvent = passedLevelEvent;
			
			
			graphics.beginFill(0,.5);
			graphics.drawRect(-3,-3,100,100);
			
			if(imageClass != null){
				var portrait:* = new imageClass();
				addChild(portrait);
				portrait.x = -3;
				portrait.y = -3;
			}

			var portraitBackground:* = new Resources.UIDialoguesPortraitBackground();
			addChild(portraitBackground);
			portraitBackground.x = -6;
			portraitBackground.y = -6;

			graphics.beginFill(0,.5);
			graphics.drawRect(portraitBackground.x + portraitBackground.width + 3,portraitBackground.y + 3,300-6,100-6);
			
			var textBackground:* = new Resources.UIDialoguesBackground();
			addChild(textBackground);
			textBackground.x = portraitBackground.x + portraitBackground.width;
			textBackground.y = portraitBackground.y;
			
			if(characterName == "Player"){
				characterName = PlayerStats.currentPlayerDataVo.currentPlayerName;
			}			
			boxTitle = new Label(this,120,0,characterName,"MenuFont",17,0xffffcc);
			
			textBox = new Text(this,120,20,message,"system",8,0xffffcc,false);
			textBox.editable = false;
			textBox.selectable = false;
			textBox.width = dialogueWidth - 120;
			textBox.height = 100-20-15;
			
			var smallButtonOn:* = new Resources.UISmallLongButtonBackgroundOff();
			var smallButtonRoll:* = new Resources.UISmallLongButtonBackgroundRoll();
			
/*			endNarrative = new PushButton(this,(dialogueWidth-20)/2 - 60,100-30,"Show Text",levelEvent.showText,
				duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
				"MenuFont",15,0xffffcc);
			endNarrative.width = 100;
			endNarrative.height = 12;				

			skipAllNarrative = new PushButton(this,(dialogueWidth-20)/2 + 60,100-30,"Skip All", GameMessageController.doneDialogues,
				duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
				"MenuFont",15,0xffffcc);
			skipAllNarrative.width = 100;
			skipAllNarrative.height = 12;	*/			
		
		}
	}
}
