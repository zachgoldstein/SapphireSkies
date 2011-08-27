package org.flixel.data
{
	//import com.PlayState;
	//import com.bit101.components.InputText;
	//import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.flixel.FlxG;
	import org.flixel.FlxMonitor;
	
	//import zachg.PlayerStats;
	//import zachg.util.SoundController;

	/**
	 * Contains all the logic for the developer console.
	 * This class is automatically created by FlxGame.
	 */
	public class FlxConsole extends Sprite
	{
		public var mtrUpdate:FlxMonitor;
		public var mtrRender:FlxMonitor;
		public var mtrTotal:FlxMonitor;
		
		/**
		 * @private
		 */
		public const MAX_CONSOLE_LINES:uint = 256;
		/**
		 * @private
		 */
		public var _console:Sprite;
		/**
		 * @private
		 */
		public var _text:TextField;
		/**
		 * @private
		 */
		public var _fpsDisplay:TextField;
		/**
		 * @private
		 */
		public var _extraDisplay:TextField;
		/**
		 * @private
		 */
		public var _curFPS:uint;
		/**
		 * @private
		 */
		public var _lines:Array;
		/**
		 * @private
		 */
		public var _Y:Number;
		/**
		 * @private
		 */
		public var _YT:Number;
		/**
		 * @private
		 */
		public var _bx:int;
		/**
		 * @private
		 */
		public var _by:int;
		/**
		 * @private
		 */
		public var _byt:int;
		
		/**
		 * Constructor
		 * 
		 * @param	X		X position of the console
		 * @param	Y		Y position of the console
		 * @param	Zoom	The game's zoom level
		 */
		public function FlxConsole(X:uint,Y:uint,Zoom:uint)
		{
			super();
			
			visible = false;
			x = X*Zoom;
			_by = Y*Zoom;
			_byt = _by - FlxG.height*Zoom;
			_YT = _Y = y = _byt;
			var tmp:Bitmap = new Bitmap(new BitmapData(FlxG.width*Zoom,FlxG.height*Zoom,true,0x7F000000));
			addChild(tmp);
			
			mtrUpdate = new FlxMonitor(8);
			mtrRender = new FlxMonitor(8);
			mtrTotal = new FlxMonitor(8);

			_text = new TextField();
			_text.width = tmp.width;
			_text.height = tmp.height;
			_text.multiline = true;
			_text.wordWrap = true;
			_text.embedFonts = true;
			_text.selectable = false;
			_text.antiAliasType = AntiAliasType.NORMAL;
			_text.gridFitType = GridFitType.PIXEL;
			_text.defaultTextFormat = new TextFormat("system",8,0xffffff);
			addChild(_text);

			_fpsDisplay = new TextField();
			_fpsDisplay.width = 100;
			_fpsDisplay.x = tmp.width-100;
			_fpsDisplay.height = 20;
			_fpsDisplay.multiline = true;
			_fpsDisplay.wordWrap = true;
			_fpsDisplay.embedFonts = true;
			_fpsDisplay.selectable = false;
			_fpsDisplay.antiAliasType = AntiAliasType.NORMAL;
			_fpsDisplay.gridFitType = GridFitType.PIXEL;
			_fpsDisplay.defaultTextFormat = new TextFormat("system",16,0xffffff,true,null,null,null,null,"right");
			addChild(_fpsDisplay);
			
			_extraDisplay = new TextField();
			_extraDisplay.width = 100;
			_extraDisplay.x = tmp.width-100;
			_extraDisplay.height = 64;
			_extraDisplay.y = 20;
			_extraDisplay.alpha = 0.5;
			_extraDisplay.multiline = true;
			_extraDisplay.wordWrap = true;
			_extraDisplay.embedFonts = true;
			_extraDisplay.selectable = false;
			_extraDisplay.antiAliasType = AntiAliasType.NORMAL;
			_extraDisplay.gridFitType = GridFitType.PIXEL;
			_extraDisplay.defaultTextFormat = new TextFormat("system",8,0xffffff,true,null,null,null,null,"right");
			addChild(_extraDisplay);
			
			_lines = new Array();
			
			//textInput = new InputText(this,0,tmp.height - 20,"Input commands here");
			//textInput.width = tmp.width - 110;
			//textInput.height = 15;
			
			//textInputPushButton = new PushButton(this,tmp.width - 100,tmp.height - 20,"Execute (or hit enter)",enterCommand);
			//textInputPushButton.height = 15;
		}
/*		
		public var textInput:InputText;
		public var textInputPushButton:PushButton;
		public function enterCommand(e:Event = null):void
		{
			var data:Array = textInput.text.split(" ");
			var validCommand:Boolean = false;
			if (checkForCommand("changeMusicVolume",changeMusicVolume, Number, data) == true) {validCommand = true};
			if (checkForCommand("changeSfxVolume",changeSfxVolume,Number, data) == true) {validCommand = true};
			if (checkForCommand("badassMode",badassMode,Boolean, data) == true) {validCommand = true};
			if (checkForCommand("changeWeaponPower",changeWeaponPower,Number, data) == true) {validCommand = true};
			if (checkForCommand("endLevel",endLevel,Boolean, data) == true) {validCommand = true};
			
			
			if(validCommand == false){
				log("invalid input... sucka");	
			}
		}
		
		public function checkForCommand(commandName:String,functionCall:Function, inputType:Class, data:Array):Boolean
		{
			if( data[0] == commandName){
				if(inputType == Number){
					if( isNaN(Number(data[1])) ) {
						return false
					} else {
						functionCall(data[1]);
						return true
					}
				} else if (inputType == Boolean){
					if( data[1] == "true" || data[1] == "false" ){
						functionCall(data[1]);
						return true						
					} else {
						return false
					}
				}
			}
			return false
		}
		
		public static var oldHealth:Number = -1;
		public static var oldMaxHealth:Number = -1;
		public static var badassToggled:Boolean = false;
		public function badassMode(isOn:Boolean):void
		{
			if( FlxG.state is PlayState){
				if(isOn == true){
					badassToggled = true;
					oldHealth = (FlxG.state as PlayState).player.healthComponent.currentHealth;
					oldMaxHealth = (FlxG.state as PlayState).player.healthComponent.maxHealth;
					(FlxG.state as PlayState).player.healthComponent.maxHealth = 9999999999;
					(FlxG.state as PlayState).player.healthComponent.currentHealth = 9999999999;
					log("Hello, ladies, look at your ship, now back to me, now back at your ship, now back to me. YOUR SHIP IS NOW BADASS.");
				} else {
					if(badassToggled == true){
						(FlxG.state as PlayState).player.healthComponent.maxHealth = oldHealth;
						(FlxG.state as PlayState).player.healthComponent.currentHealth = oldMaxHealth;
					}
					log("ship turned all wimpy again. how normal of you.");
				}
			} else {
				log("dummy, you can only toggle this when you're playing :)");
			}
		}
		
		public function changeWeaponPower(power:Number):void
		{
			if( FlxG.state is PlayState){
				(FlxG.state as PlayState).player.gunComponent.shotDamage = power;
				log("Your weapon now has "+power+" units of arbitrary awesomness");
			} else {
				log("dummy, you can only toggle this when you're playing :)");
			}
		}
		
		public function endLevel(didWin:Boolean):void
		{
			if( FlxG.state is PlayState){
				log("We have a WIIINNNNNAR");
				if(didWin == true){
					(FlxG.state as PlayState).winLevel("HOMEBOY USED SOME CHEATS TO WIN... tricky tricky.");
				} else {
					(FlxG.state as PlayState).winLevel("HOMEBOY USED SOME CHEATS TO LOSE... tricky tricky.");
				}
				//log("He’s climbing in your windows");
				//log("He’s snatchin your people up");
			} else {
				log("dummy, you can only toggle this when you're playing :)");
			}
		}
		
		public function unlockLevel(levelToUnlock:Number):void
		{
			(PlayerStats.currentPlayerDataVo.levelsUnlocked as Array).push(levelToUnlock);
			log("Yousa unlocka level "+levelToUnlock);
		}

		public function changeMusicVolume(amount:Number):void
		{
			SoundController.musicVolume = amount;
			if( SoundController.currentlyPlayingMusic != null){
				var newSoundTransform:SoundTransform = SoundController.currentlyPlayingMusic._sound_channel.soundTransform;
				newSoundTransform.volume = amount;
				SoundController.currentlyPlayingMusic._sound_channel.soundTransform = newSoundTransform;
			}
			log("muzak level is now:"+amount);
		}

		public function changeSfxVolume(amount:Number):void
		{
			SoundController.soundEffectVolume = amount;
			log("SFX supercharged to :"+amount+" fake decibels of wicked");			
		}		
*/		
		/**
		 * Logs data to the developer console
		 * 
		 * @param	Text	The text that you wanted to write to the console
		 */
		public function log(Text:String):void
		{
			if(Text == null)
				Text = "NULL";
			trace(Text);
			_lines.push(Text);
			if(_lines.length > MAX_CONSOLE_LINES)
			{
				_lines.shift();
				var newText:String = "";
				for(var i:uint = 0; i < _lines.length; i++)
					newText += _lines[i]+"\n";
				_text.text = newText;
			}
			else
				_text.appendText(Text+"\n");
			_text.scrollV = _text.height;
		}
		
		/**
		 * Shows/hides the console.
		 */
		public function toggle():void
		{
			if(_YT == _by){
				_YT = _byt;
/*				if( FlxG.state is PlayState){
					if ( ( FlxG.state as PlayState).isFrozen == true){
						( FlxG.state as PlayState).doChangeFrozenState = true;
					}
				}				
*/			}
			else
			{
				_YT = _by;
				visible = true;
/*				if( FlxG.state is PlayState){
					if ( ( FlxG.state as PlayState).isFrozen == false){
						( FlxG.state as PlayState).doChangeFrozenState = true;
					}
				}
*/			}
		}
		
		/**
		 * Updates and/or animates the dev console.
		 */
		public function update():void
		{
			var total:Number = mtrTotal.average();
			_fpsDisplay.text = uint(1000/total) + " fps";
			var up:uint = mtrUpdate.average();
			var rn:uint = mtrRender.average();
			var fx:uint = up+rn;
			var tt:uint = uint(total);
			_extraDisplay.text = up + "ms update\n" + rn + "ms render\n" + fx + "ms flixel\n" + (tt-fx) + "ms flash\n" + tt + "ms total";
			
			if(_Y < _YT)
				_Y += FlxG.height*10*FlxG.elapsed;
			else if(_Y > _YT)
				_Y -= FlxG.height*10*FlxG.elapsed;
			if(_Y > _by)
				_Y = _by;
			else if(_Y < _byt)
			{
				_Y = _byt;
				visible = false;
			}
			y = Math.floor(_Y);
			
			if(FlxG.keys.justPressed("ENTER") == true){
				//enterCommand();
			}
		}
	}
}