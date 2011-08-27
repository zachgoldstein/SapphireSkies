package zachg.util
{
	import com.Resources;
	import com.mauft.OggLibrary.*;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.Timer;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxU;
	
	import sound.SfxrParams;
	import sound.SfxrSynth;
	
	import zachg.states.MainMenuState;
	
	public class SoundController
	{
		public function SoundController()
		{
		}
		
		public static var initialized:Boolean = false;
		public static function initialize():void
		{
			if(initialized == true){
				return
			}
			FlxG.mute = false;
			FlxG.volume = 1;
			
			_synth = new SfxrSynth();
			
			initialized = true;
		}
		
		//	Required to replay a mod
		public static var stream:ByteArray;
		//public static var processor:ModProcessor;	
		
		public static var musicVolume:Number = .75;
		public static var currentlyPlayingMusic:OggEmbed;
		public static var isMenuMusicPlaying:Boolean = false;
		public static var isMusicPlaying:Boolean = true;
		
		public static var soundEffectVolume:Number = .5;
		public static var _synth:SfxrSynth;
		public static var isSoundEffectPlaying:Boolean = false;
		public static var soundEffectPlayList:Array = new Array();
		
		public static var soundEffectPlayPriority:Dictionary = new Dictionary();
		
		public static var masterSoundToggle:Boolean = true;
		
		//General reference vars
		public static var ButtonClick:String = "SfxMiscMenuSound";
		
		public static function setSoundEffectPriorities():void
		{
/*			soundEffectPlayPriority["SfxButton"] = 0;
			soundEffectPlayPriority["SfxCancel"] = 0;
			soundEffectPlayPriority["SfxError"] = 0;
			soundEffectPlayPriority["SfxMiscMenuSound"] = 0;
			soundEffectPlayPriority["SfxMiscMenuSound2"] = 0;
			soundEffectPlayPriority["SfxRadioStatic"] = 0;
			
			soundEffectPlayPriority["SfxFriendlyVillageDestroyed"] = 1;
			soundEffectPlayPriority["SfxEnemyVillageDestroyed"] = 1;
			
			soundEffectPlayPriority["SfxGetHit"] = 2;
			
			soundEffectPlayPriority["SfxHitEnemy"] = 3;
			soundEffectPlayPriority["SfxHitEnemyVillage"] = 3;
			
			soundEffectPlayPriority["SfxAltWeaponBadassThing"] = 4;
			soundEffectPlayPriority["SfxAltWeaponBiggerLaser"] = 4; 
			soundEffectPlayPriority["SfxAltWeaponBadassThing"] = 4;
			
			soundEffectPlayPriority["SfxShotSoftLaser"] = 5;*/
			
		}
		
		//public function cachedSounds
			
		
		/**
		 * Plays a module
		 */
		public static var songToPlayAfterFadeOut:Class;
		public static var musicFadeSpeed:Number = .5;
		public static function playSong(songToPlay:Class):void
		{
			if(masterSoundToggle == false){
				return
			}
			if(FlxG.music != null){
				if(FlxG.music.playing == true){
					FlxG.music.fadeOut(musicFadeSpeed);
					songToPlayAfterFadeOut = songToPlay;
					var timer:Timer = new Timer(musicFadeSpeed*1000,1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE,fadeInStarted,false,0,true);
					timer.start();
				} else {
					FlxG.playMusic(songToPlay,musicVolume);
					//FlxG.music.fadeIn(musicFadeSpeed)
				}
			} else {
				FlxG.playMusic(songToPlay,musicVolume);
				//FlxG.music.fadeIn(musicFadeSpeed)
			}
			
			
			//FlxG.playLoopFix(songToPlay,musicVolume,true,44100*44);
			
/*			currentlyPlayingMusic = null;
			currentlyPlayingMusic = new OggEmbed(songToPlay);
			currentlyPlayingMusic.play();
			currentlyPlayingMusic._sound_channel.soundTransform.volume = musicVolume;
			*/
			//currentlyPlayingMusic = embedTest;
		}
		
		public static function fadeInStarted(e:TimerEvent):void
		{
			FlxG.playMusic(songToPlayAfterFadeOut,musicVolume);
			//FlxG.music.fadeIn(musicFadeSpeed)
		}
		
		public static var _didWin:Boolean = false;
		public static var loopingSoundToPlay:Class;
		public static function playEndLevelMusic(didWin:Boolean = false):void
		{
			_didWin = didWin;
			FlxG.music.fadeOut(musicFadeSpeed);
			var songToPlay:Class;
			if(didWin == true){
				songToPlay = StageWonIntro
				loopingSoundToPlay = StageWonLoop;
			} else {
				songToPlay = StageLostIntro
				loopingSoundToPlay = StageLostLoop;
			}
			songToPlayAfterFadeOut = songToPlay;
			var timer:Timer = new Timer(musicFadeSpeed*1000,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,playIntroSound,false,0,true);
			timer.start();
		}
		
		public static function playIntroSound(e:TimerEvent):void
		{
			FlxG.music.loadEmbedded(songToPlayAfterFadeOut,false);
			FlxG.music.volume = musicVolume;
			FlxG.music.survive = true;
			FlxG.music.play();
			FlxG.music._channel.addEventListener(Event.SOUND_COMPLETE, playLoopingEndLevelMusic);
		}
		
		public static function playLoopingEndLevelMusic(e:Event):void
		{
			FlxG.playMusic(loopingSoundToPlay,musicVolume);
		}
		
		
		public static function pauseSong():void
		{
			if(FlxG.music != null){
				if(FlxG.music.playing == true){
					FlxG.music.pause();
					isMusicPlaying = false;
				}
			}
		}
		
		public static function resumeSong():void
		{
			if(FlxG.music != null){
				if(FlxG.music.playing == false){
					FlxG.music.play();
					isMusicPlaying = true;
				}
			}
		}
		
		public static function toggleSound(e:MouseEvent = null):void
		{
			var muteOn:Bitmap = new Resources.UIMuteOn();
			var muteOff:Bitmap = new Resources.UIMuteOff();					
			if(FlxG.mute == false){
				FlxG.mute = true
				if( (FlxG.state).muteButton != null){
					(FlxG.state).muteButton.backgroundRolloverImage = muteOff;
					(FlxG.state).muteButton.backgroundDefaultImage = muteOn;
				}
			} else {
				FlxG.mute = false;
				if( (FlxG.state).muteButton != null){
					(FlxG.state).muteButton.backgroundRolloverImage = muteOn;
					(FlxG.state).muteButton.backgroundDefaultImage = muteOff;
				}				
			}
		}
		
		public static function toggleSong(e:MouseEvent = null):void
		{
			if (isMusicPlaying == true){
				pauseSong();
			} else {
				resumeSong();
			}
		}

		public static function areSoundEffectsPlaying():Boolean
		{
			if(_synth._cachingNormal == true){
				return true
			} else {
				return false
			}
			return false
		}
		public static function queueSoundEffect(soundEffectName:String = null):void
		{
			soundEffectPlayList.push(soundEffectName);
		}
		
		public static function playSoundEffect(soundEffectName:String = null):void
		{
			if(masterSoundToggle == false || FlxG.mute == true){
				return
			}			
			if(Resources[soundEffectName] != null){
				FlxG.play(Resources[soundEffectName],soundEffectVolume);
			} else {
				trace("tried to play non-existant sfx:"+soundEffectName);
			}
			
/*			if( soundEffectName != null && Resources[soundEffectName] != null){
				if(areSoundEffectsPlaying() == false){
					loadSoundEffect(new Resources[soundEffectName]() as ByteArray);
					_synth.play();
					isSoundEffectPlaying = true;
					_synth.addEventListener(Event.SOUND_COMPLETE,soundEffectFinishedPlaying,false,0,true);
				} else {
					//queue sound here
					queueSoundEffect(soundEffectName);
				}
			}*/
		}
		
		public static function soundEffectFinishedPlaying(e:Event = null):void
		{
			isSoundEffectPlaying = false;
			
			//if sound list isn't empty, play highest priority sound, then clear the list.
			if(soundEffectPlayList.length > 0){
				var highestPriority:Number = 9999;
				var effectToPlay:String;
				for (var i:int = 0 ; i < soundEffectPlayList.length ; i++){
					if( soundEffectPlayPriority[ soundEffectPlayList[i] ] != null){
						if( soundEffectPlayPriority[ soundEffectPlayList[i] ] < highestPriority){
							highestPriority = soundEffectPlayPriority[ soundEffectPlayList[i] ];
							effectToPlay = soundEffectPlayList[i];
						}
					}
				}
				playSoundEffect(effectToPlay);
				soundEffectPlayList = new Array();
				
			}
		}
		
		/**
		 * Reads parameters from a ByteArray file
		 * Compatible with the original Sfxr files
		 * @param	file	ByteArray of settings data
		 */		
		public static function loadSoundEffect(file:ByteArray):void
		{

			file.position = 0;
			file.endian = Endian.LITTLE_ENDIAN;
			
			var version:int = file.readInt();
			
			if(version != 100 && version != 101 && version != 102) return;
			
			_synth.params.waveType = file.readInt();
			_synth.params.masterVolume = (version == 102) ? file.readFloat() : 0.5;
			
			_synth.params.startFrequency = file.readFloat();
			_synth.params.minFrequency = file.readFloat();
			_synth.params.slide = file.readFloat();
			_synth.params.deltaSlide = (version >= 101) ? file.readFloat() : 0.0;
			
			_synth.params.squareDuty = file.readFloat();
			_synth.params.dutySweep = file.readFloat();
			
			_synth.params.vibratoDepth = file.readFloat();
			_synth.params.vibratoSpeed = file.readFloat();
			var unusedVibratoDelay:Number = file.readFloat();
			
			_synth.params.attackTime = file.readFloat();
			_synth.params.sustainTime = file.readFloat();
			_synth.params.decayTime = file.readFloat();
			_synth.params.sustainPunch = file.readFloat();
			
			var unusedFilterOn:Boolean = file.readBoolean();
			_synth.params.lpFilterResonance = file.readFloat();
			_synth.params.lpFilterCutoff = file.readFloat();
			_synth.params.lpFilterCutoffSweep = file.readFloat();
			_synth.params.hpFilterCutoff = file.readFloat();
			_synth.params.hpFilterCutoffSweep = file.readFloat();
			
			_synth.params.phaserOffset = file.readFloat();
			_synth.params.phaserSweep = file.readFloat();
			
			_synth.params.repeatSpeed = file.readFloat();
			
			_synth.params.changeSpeed = (version >= 101) ? file.readFloat() : 0.0;
			_synth.params.changeAmount = (version >= 101) ? file.readFloat() : 0.0;
			
			
			_synth.params.masterVolume = (_synth.params.masterVolume * soundEffectVolume);
		}
		
		public static function setSfxVolume(value:Number):void
		{
			soundEffectVolume = value;
		}
		
		public static function setMusicVolume(value:Number):void
		{
			musicVolume = value;
			FlxG.music.volume = value;
		}
		
	}
}
