package zachg.util.levelEvents
{
	import com.PlayState;
	import com.Resources;
	import com.Trigger;
	import com.adobe.utils.StringUtil;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxU;
	import org.flixel.data.FlxPause;
	
	import zachg.PlayerStats;
	import zachg.ui.dialogues.NarrativeDialogue;
	import zachg.util.GameMessageController;
	import zachg.util.SoundController;

	public class NarrativeTrigger extends LevelEvent
	{
		
		public var isInitialNarrative:Boolean = false;
		public var message:String;
		public var characterName:String;
		
		public var imageName:String;
		public var delay:Number;
		
		public var narrative:NarrativeDialogue;

		public var typeWriterTimer:Timer;
		public var charCounter:int = 0;
		public var typeWriterSpeed:Number = 3
			
		public var textShown:Boolean = false;
		
		public function NarrativeTrigger(Message:String, CharacterName:String, ImageName:String, Delay:Number = 2000) 
		{
			characterName = CharacterName;
			message = Message;
			imageName = ImageName;
			delay = Delay;
		}

		override public function start():void 
		{
			SoundController.playSoundEffect("SfxDialogueText");
			startedPlaying = true;
			finishedPlaying = false;
			message = StringUtil.replace(message,"!Max!",PlayerStats.currentPlayerDataVo.currentPlayerName);
			message = StringUtil.replace(message,"!MAX!",(PlayerStats.currentPlayerDataVo.currentPlayerName as String).toUpperCase() );
			charCounter = 0;
			
			if(imageName == "Player" && PlayerStats.currentPlayerDataVo.isPlayerMale == true){
				narrative = new NarrativeDialogue(this, "", characterName, Resources.CharacterMainMale);
			} else if (imageName == "Player" && PlayerStats.currentPlayerDataVo.isPlayerMale == false){
				narrative = new NarrativeDialogue(this, "", characterName, Resources.CharacterMainFemale);
			} else {
				narrative = new NarrativeDialogue(this, "", characterName, Resources[imageName]);
			}
			narrative.textBox.text = "";
			
			typeWriterTimer = new Timer(typeWriterSpeed,0);
			typeWriterTimer.addEventListener(TimerEvent.TIMER,typeWriterEffect);
			typeWriterTimer.start();
			
			if(FlxG.state  is PlayState){
				(FlxG.state as PlayState).gameInterface.addChild(narrative);
			}
		}
		
		public function typeWriterEffect(e:TimerEvent):void
		{
			if(charCounter < message.length){
				if(charCounter != 0){
					narrative.textBox.text = narrative.textBox.text.slice(0, charCounter);
				}
				
				narrative.textBox.text += message.slice(charCounter,charCounter+1);
				//narrative.textBox.text += PlayerStats.generateRandomString(6);
				charCounter++;
			} else {
				typeWriterTimer.stop();
				narrative.textBox.text = narrative.textBox.text.slice(0, charCounter);
				typeWriterTimer.removeEventListener(TimerEvent.TIMER,typeWriterEffect);
				charCounter = 0;
			}
			
		}
		
		override public function end(e:MouseEvent = null):void 
		{
			finishedPlaying = true;
			startedPlaying = false;
			if(FlxG.state  is PlayState){
				if(narrative != null){
					narrative.textBox.text = "";
					(FlxG.state as PlayState).gameInterface.removeChild(narrative);
				}
			}			
		}

		override public function showText(e:MouseEvent = null):void 
		{
			if( typeWriterTimer != null){
				typeWriterTimer.stop();
				typeWriterTimer.removeEventListener(TimerEvent.TIMER,typeWriterEffect);
			}
			if( narrative != null){
				narrative.textBox.text = message;
			}
			if(e != null){
				GameMessageController.playNextStartLevelDialogue();
			}
			textShown = true;
		}
		
	}
}