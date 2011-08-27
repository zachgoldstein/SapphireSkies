package zachg.ui
{
	import Playtomic.*;
	
	import com.Resources;
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.senocular.display.duplicateDisplayObject;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flixel.FlxG;
	
	import zachg.PlayerStats;
	
	public class NameInputDialogue extends Sprite
	{
		public var boxTitle:Label;
		
		public var textBox:Label;
		public var nameInput:InputText;
		public var nameInputtedFunctionCall:Function;
		public var message:String = "Greetings stranger! To whom am I speaking?"

		public var checkBoxMale:CheckBox;
		public var checkBoxFemale:CheckBox;
		public var confirmError:Label;
			
		public var typeWriterTimer:Timer;
		public var charCounter:int = 0;
		public var typeWriterSpeed:Number = 3
		public var clickBlocker:Sprite;
			
		public function NameInputDialogue(callback:Function)
		{
			super();
			FlxG._game.useDefaultHotKeys = false;
			nameInputtedFunctionCall = callback;
			
			clickBlocker = new Sprite();
			clickBlocker.graphics.beginFill(0xFFFFFF,.25);
			clickBlocker.graphics.drawRect(0,0,FlxG.stage.stageWidth,FlxG.stage.stageHeight);
			FlxG.state.addChild(clickBlocker);			
			
			graphics.beginFill(0,.5);
			graphics.drawRect(-3,-3,100,100);
			
			var portrait:* = new Resources.CharacterVenison();
			addChild(portrait);
			portrait.x = -3;
			portrait.y = -3;
			
			var portraitBackground:* = new Resources.UIDialoguesPortraitBackground();
			addChild(portraitBackground);
			portraitBackground.x = -6;
			portraitBackground.y = -6;
			
			graphics.beginFill(0,.5);
			graphics.drawRect(portraitBackground.x + portraitBackground.width,portraitBackground.y,300,100);
			
			var textBackground:* = new Resources.UIDialoguesBackground();
			addChild(textBackground);
			textBackground.x = portraitBackground.x + portraitBackground.width;
			textBackground.y = portraitBackground.y;
			
			textBox = new Label(this,120,0,"","MenuFont",15,0xffffcc);
			textBox.width = 375 - 120;
			textBox.height = 20;

			var inputText:* = new Resources.UIInputNameTextfield();
			
			nameInput = new InputText(this,120,textBox.y + 20 + 10,"Mr. Pink",unPause,
				inputText,null,"system",8,0xffffcc
			);
			nameInput.width = 220;
			nameInput.maxChars = 38;
			
			var checkBoxOn:* = new Resources.UICheckboxOn();
			var checkBoxOff:* = new Resources.UICheckboxOff();
			var checkBoxRoll:* = new Resources.UICheckboxRoll();
			
			checkBoxMale = new CheckBox(this,nameInput.x,nameInput.y + 25,"Male",checkBoxClicked,
				duplicateDisplayObject(checkBoxOn),new Point(0,-5),duplicateDisplayObject(checkBoxOff),new Point(0,-5),
				"system",8,0xffffcc);
			checkBoxMale.tag = 1;
			
			checkBoxFemale = new CheckBox(this,nameInput.x + 50,nameInput.y + 25,"Female",checkBoxClicked,
				duplicateDisplayObject(checkBoxOn),new Point(0,-5),duplicateDisplayObject(checkBoxOff),new Point(0,-5),
				"system",8,0xffffcc);
			checkBoxFemale.tag = 0;
			

			var smallButtonOn:* = new Resources.UISmallLongButtonBackgroundOff();
			var smallButtonRoll:* = new Resources.UISmallLongButtonBackgroundRoll();			
			
			var confirmNameButton:PushButton = new PushButton(this,(375-20)/2 - 60,100-30,"Confirm",endNameInput,
				duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
				"MenuFont",15,0xffffcc);
			confirmNameButton.width = 100;
			confirmNameButton.height = 11;	

			confirmError = new Label(this,(375-20)/2 + 60,100-30,"","system",8,0xf0652c);			
			
			typeWriterTimer = new Timer(typeWriterSpeed,0);
			typeWriterTimer.addEventListener(TimerEvent.TIMER,typeWriterEffect);
			typeWriterTimer.start();
			
			(FlxG.state).addChild(this);
			
			x = Math.round(FlxG.stage.stageWidth/2 - width/2);
			y = Math.round(FlxG.stage.stageHeight/2 - height/2);
		}
		
		public function unPause(e:Event):void
		{
			//FlxG.pause = false;
		}
		
		public function typeWriterEffect(e:TimerEvent):void
		{
			if(charCounter < message.length){
				if(charCounter != 0){
					textBox.text = textBox.text.slice(0, charCounter);
				}
				
				textBox.text += message.slice(charCounter,charCounter+1);
				//narrative.textBox.text += PlayerStats.generateRandomString(6);
				charCounter++;
			} else {
				typeWriterTimer.stop();
				textBox.text = textBox.text.slice(0, charCounter);
				typeWriterTimer.removeEventListener(TimerEvent.TIMER,typeWriterEffect);
				charCounter = 0;
			}
		}
		
		public function checkBoxClicked(e:Event = null):void
		{
			var doSelectMale:Boolean;
			
			if( (e.currentTarget as CheckBox).tag == 0){
				if ((e.currentTarget as CheckBox).selected == true){
					doSelectMale = false;
				} else {
					doSelectMale = true;
				}
			} else if ( (e.currentTarget as CheckBox).tag == 1){
				if ((e.currentTarget as CheckBox).selected == true){
					doSelectMale = true;
				} else {
					doSelectMale = false;
				}
			}
			
			if(doSelectMale == true){
				checkBoxFemale.selected = false;
				checkBoxMale.selected = true;
			} else {
				checkBoxFemale.selected = true;
				checkBoxMale.selected = false;
			}
		}
		
		public function endNameInput(e:Event = null):void
		{
			if(checkBoxMale.selected == false && checkBoxFemale.selected == false){
				confirmError.text = "Select a gender to continue";
			} else {
				(FlxG.state).removeChild(this);
				if( checkBoxFemale.selected == true){
					PlayerStats.currentPlayerDataVo.isPlayerMale = false; 
				} else {
					PlayerStats.currentPlayerDataVo.isPlayerMale = true;
				}
				PlayerStats.currentPlayerDataVo.currentPlayerName = nameInput.text;
				PlayerStats.saveCurrentPlayerData();
				
				Log.CustomMetric("playerInputtedName");
				if(PlayerStats.currentPlayerDataVo.isPlayerMale == true){
					Log.CustomMetric("playerIsMale");
				} else {
					Log.CustomMetric("playerIsFemale");
				}
				
				nameInputtedFunctionCall();
				FlxG.state.removeChild(clickBlocker);
			}
		}
	}
}