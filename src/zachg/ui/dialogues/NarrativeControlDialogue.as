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
	
	public class NarrativeControlDialogue extends Sprite
	{
		public var levelEvent:LevelEvent;
		public var boxTitle:Label;
		public var textBox:Text;
		public var endNarrative:PushButton;
		public var nextNarrative:PushButton;
		public var prevNarrative:PushButton;
		
		public var skipAllNarrative:PushButton;
		
		public static var dialogueWidth:Number = 240;
		
		public function NarrativeControlDialogue()
		{
			super();
			
			graphics.beginFill(0,.5);
			graphics.drawRect(2,2,dialogueWidth-4,30-4);
						
			var border:* = new Resources.UIDialogueControlBorder();
			addChild(border);
			
			var smallButtonOnLong:* = new Resources.UISmallLongButtonBackgroundOff();
			var smallButtonRollLong:* = new Resources.UISmallLongButtonBackgroundRoll();
			var smallButtonOn:* = new Resources.UISmallButtonBackgroundOff();
			var smallButtonRoll:* = new Resources.UISmallButtonBackgroundRoll();

			nextNarrative = new PushButton(this,65+3,5+2,"Next",GameMessageController.playNextStartLevelDialogue,
				duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
				"MenuFont",15,0xffffcc);
			nextNarrative.width = 50;
			nextNarrative.height = 12;				

			prevNarrative = new PushButton(this,5+3,5+2,"Prev",GameMessageController.playPrevStartLevelDialogue,
				duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
				"MenuFont",15,0xffffcc);
			prevNarrative.width = 50;
			prevNarrative.height = 12;				
			
			skipAllNarrative = new PushButton(this,125+3,5+2,"Skip All", GameMessageController.doneDialogues,
				duplicateDisplayObject(smallButtonOnLong),null,duplicateDisplayObject(smallButtonRollLong),null,
				"MenuFont",15,0xffffcc);
			skipAllNarrative.width = 100;
			skipAllNarrative.height = 12;				
		}
	}
}
