package zachg.util
{
	import com.GlobalVariables;
	import com.PlayState;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import net.hires.Stats;
	
	import org.flixel.FlxG;
	import org.flixel.FlxMonitor;
	import org.flixel.data.FlxConsole;
	
	import zachg.PlayerStats;
	import zachg.util.SoundController;
	
	/**
	 * Contains all the logic for the developer console.
	 * This class is automatically created by FlxGame.
	 */
	public class CustomConsole extends FlxConsole
	{
		/**
		 * Constructor
		 * 
		 * @param	X		X position of the console
		 * @param	Y		Y position of the console
		 * @param	Zoom	The game's zoom level
		 */
		public function CustomConsole(X:uint,Y:uint,Zoom:uint)
		{
			super(0,0,1);
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
			
			var stats:Stats = new Stats();
			stats.x = tmp.width-stats.width;
			stats.y = _fpsDisplay.height;
			addChild(stats);
			
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
			
			textInput = new InputText(this,0,tmp.height - 20,"Input commands here",null,null,null,"system",8,0x000000,true);
			textInput.width = tmp.width - 110;
			textInput.height = 15;
			textInput.maxChars = 150;
			
			textInputPushButton = new PushButton(this,tmp.width - 100,tmp.height - 20,"Execute (or hit enter)",enterCommand,null,null,null,null,"system",8,0x000000,true);
			textInputPushButton.height = 15;
		}
		
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
			if (checkForCommand("giveMoney",giveMoney,Number, data) == true) {validCommand = true};
			if (checkForCommand("unlockLevel",unlockLevel,Number, data) == true) {validCommand = true};
			if (checkForCommand("help",showHelp,null, data) == true) {validCommand = true};
			if (checkForCommand("giveMeEverything",giveMeEverything,null, data) == true) {validCommand = true};
			if (checkForCommand("resetSaves",resetSaves,null, data) == true) {validCommand = true};
			
			
			if(validCommand == false){
				log("invalid input... sucka");	
			} else {
				GlobalVariables.cheatsUsed = true;
			}
		}
		
		public function checkForCommand(commandName:String,functionCall:Function, inputType:Class, data:Array):Boolean
		{
			if( data[0] == commandName){
					if(inputType == null){
						functionCall();
					} else if(inputType == Number){
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

		public function showHelp():void
		{
			log("////////////////////////////////////////////////////////////////////////////////////");
			log("CHEATER!!!!!!" );
			log("No seriously, if you've got the time, just play through without cheats. It's sorta more fun that way" );
			log("If you reeeeeallly wanna cheat though...." );
			log("Here's the different commands you can use:" );
			log("This is the syntax: 'commandName InputVariable', what it does " );
			log("");
			log(" 'badassMode true/false' This command is like a shot of rambo into your ship's ass. It gives you tons of health "  );
			log(" 'changeWeaponPower #' Makes your weapon do # damage each time it collides with a poor baddie "  );
			log(" 'giveMoney #' Give you # dollars for doing nothing. It's like you shook a money tree."  );
			log(" 'endLevel true/false' Ends the level, with true being a win and false being a loss"  );
			log(" 'unlockLevel #' Magically unlocks a level for you to play"  );			
			log(" 'changeMusicVolume #' sets the music volume"  );
			log(" 'changeSfxVolume #' sets the sfx volume"  );
			log(" 'giveMeEverything' unlocks all ships and levels"  );
			log(" 'resetSaves' clears all player data"  );
			
			log("");
			log(" NOTE: if a command doesn't seem to work, try moving to a different area of the menus and then back"  );
			log("////////////////////////////////////////////////////////////////////////////////////");
		}		
		
		public function giveMeEverything():void
		{
			for (var i:int = 0 ; i < LevelData.LevelCreationData.length ; i ++ ){
				unlockLevel(i);
			}
			for (var i:int = 0 ; i < PlayerStats.growthItems.length ; i++ ){
				(PlayerStats.currentPlayerDataVo.growthItemsPurchased as Array).push(i);
			}			
			PlayerStats.saveCurrentPlayerData();
			log("YOU ARE NOW A GOD...... everything is now unlocked");
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
		
		public function giveMoney(money:Number):void
		{
			PlayerStats.currentPlayerDataVo.currentCurrency += money;
			PlayerStats.saveCurrentPlayerData();
			log("You are now $"+money+" richer" );
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
			PlayerStats.saveCurrentPlayerData();
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
		
		public function resetSaves():void
		{
			log("Player saves cleared");
			PlayerStats.flxSave._so.clear();
		}		
		
		/**
		 * Logs data to the developer console
		 * 
		 * @param	Text	The text that you wanted to write to the console
		 */
		override public function log(Text:String):void
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
		override public function toggle():void
		{
			if(_YT == _by){
				_YT = _byt;
				if( FlxG.state is PlayState){
					if ( ( FlxG.state as PlayState).isFrozen == true){
						( FlxG.state as PlayState).doChangeFrozenState = true;
					}
				}				
			}
			else
			{
				_YT = _by;
				visible = true;
				if( FlxG.state is PlayState){
					if ( ( FlxG.state as PlayState).isFrozen == false){
						( FlxG.state as PlayState).doChangeFrozenState = true;
					}
				}
			}
		}
		
		/**
		 * Updates and/or animates the dev console.
		 */
		override public function update():void
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
				enterCommand();
			}
		}
	}
}