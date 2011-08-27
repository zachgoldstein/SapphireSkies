package zachg.util
{
	import com.PlayState;
	import com.bit101.components.PushButton;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.easing.Sine;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	
	import zachg.PlayerStats;
	import zachg.ui.HelpDialogue;
	import zachg.ui.NameInputDialogue;
	import zachg.ui.TipDialogue;
	import zachg.ui.dialogues.NarrativeControlDialogue;
	import zachg.ui.dialogues.NarrativeDialogue;
	import zachg.util.levelEvents.NarrativeTrigger;

	public class GameMessageController
	{
		public function GameMessageController(){}
		
		public static var dialogueTimer:Timer;
		public static var currentDialogueIndex:Number = 0;
		
		public static var topDialoguePoint:FlxPoint = new FlxPoint(10,100);
		public static var bottomDialoguePoint:FlxPoint = new FlxPoint(FlxG.stage.stageWidth - NarrativeDialogue.dialogueWidth - 10,275);
		public static var currentDialoguePosition:Number = 0;
		
		public static var skipAllTextButton:PushButton;
		
		public static var isPlayingStartDialogues:Boolean = false;
		public static var dialoguesFinishedCallback:Function;
		public static var dialoguesFinishedCallbackParams:Array;
		public static var currentDialogues:Array;
		
		public static var dialogueDelayMultiplier:Number = 60;
		public static var dialogueDelayAfterFinish:Number = 40;
		public static var narrativeControl:NarrativeControlDialogue;
		
		public static function playLevelDialogues(dialogues:Array, DialoguesFinishedCallback:Function, params:Array = null):void
		{
			dialoguesFinishedCallback = DialoguesFinishedCallback;
			currentDialogues = dialogues;
			dialoguesFinishedCallbackParams = params;
				
			clickBlocker = new Sprite();
			clickBlocker.graphics.beginFill(0xFFFFFF,.25);
			clickBlocker.graphics.drawRect(0,0,FlxG.stage.stageWidth,FlxG.stage.stageHeight);
			clickBlocker.x = 0;
			
			(FlxG.state as PlayState).gameInterface.addChild(clickBlocker);			
			
			if( (currentDialogues[PlayerStats.currentLevelId] as Array).length != 0){
				var delay:Number;
				if ( (currentDialogues[PlayerStats.currentLevelId][0] as NarrativeTrigger).delay != -1){
					delay = (currentDialogues[PlayerStats.currentLevelId][0] as NarrativeTrigger).delay + dialogueDelayAfterFinish;
				} else {
					delay = (currentDialogues[PlayerStats.currentLevelId][0] as NarrativeTrigger).message.length * dialogueDelayMultiplier + dialogueDelayAfterFinish;
				}
				
				
				//dialogueTimer = new Timer(delay,1);
				//dialogueTimer.addEventListener(TimerEvent.TIMER_COMPLETE,playNextStartLevelDialogue,false,0,true);
				//dialogueTimer.start();
				
				var trigger:NarrativeTrigger = (currentDialogues[PlayerStats.currentLevelId][0] as NarrativeTrigger); 
				
				trigger.start();
				
				currentDialoguePosition = 1;
				trigger.narrative.y = topDialoguePoint.y;
				trigger.narrative.alpha = 0;
				trigger.narrative.x = topDialoguePoint.x - 25;
				var myTween:GTween = new GTween(trigger.narrative, .5, {x:topDialoguePoint.x, alpha:1}, {ease:Sine.easeIn});
				//playNextStartLevelDialogue();
				//skipAllTextButton = new PushButton((FlxG.state as PlayState).gameInterface,FlxG.stage.stageWidth/2-50,75,"Skip Dialogue",doneDialogues);
				
				narrativeControl = new NarrativeControlDialogue();
				(FlxG.state as PlayState).gameInterface.addChild(narrativeControl);
				narrativeControl.x = FlxG.stage.stageWidth/2 - narrativeControl.width/2;
				narrativeControl.y = FlxG.stage.stageHeight/2 - narrativeControl.height/2;
				
			} else {
				doneDialogues();
			}
		}
		
		public static function doneDialogues(e:MouseEvent = null):void
		{
			if( (currentDialogues[PlayerStats.currentLevelId] as Array).length != 0){
				for (var i:int = 0 ; i < (currentDialogues[PlayerStats.currentLevelId] as Array).length ; i++){
					var currentNarrative:NarrativeTrigger = (currentDialogues[PlayerStats.currentLevelId][i] as NarrativeTrigger);
					if(currentNarrative.textShown == false){
						currentNarrative.showText();
					}
					
					if(currentNarrative.startedPlaying == true && currentNarrative.finishedPlaying == false){
						currentNarrative.end();
					}
					
					currentNarrative.startedPlaying = false;
					currentNarrative.finishedPlaying = false;
				}
				//dialogueTimer.stop();
				//dialogueTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,playNextStartLevelDialogue);
				//(FlxG.state as PlayState).gameInterface.removeChild(skipAllTextButton);
				(FlxG.state as PlayState).gameInterface.removeChild(narrativeControl);
			}
			currentDialogueIndex = 0;
			(FlxG.state as PlayState).gameInterface.removeChild(clickBlocker);
			dialoguesFinishedCallback(dialoguesFinishedCallbackParams);
		}
		
		public static function playPrevStartLevelDialogue(e:Event = null):void
		{
			if( currentDialogueIndex > -1){
				for(var i:int = 0 ; i < (currentDialogues[PlayerStats.currentLevelId] as Array).length ; i++){
					if( ( currentDialogues[PlayerStats.currentLevelId][i] as NarrativeTrigger).startedPlaying == true){
						if(currentDialogueIndex != i){
							( currentDialogues[PlayerStats.currentLevelId][i] as NarrativeTrigger).end();
						}
					}
				}
				( currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex] as NarrativeTrigger).showText();
				currentDialogueIndex--;
			}
			
			//dialogueTimer.stop();
			
			if( currentDialogueIndex > -1){
				var delay:Number;
				if ( (currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex] as NarrativeTrigger).delay != -1){
					delay = (currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex] as NarrativeTrigger).delay;
				} else {
					delay = (currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex] as NarrativeTrigger).message.length * dialogueDelayMultiplier;
				}
				//dialogueTimer.delay = delay
				
				var lastTrigger:NarrativeTrigger = ( currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex+1] as NarrativeTrigger);
				var trigger:NarrativeTrigger = ( currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex] as NarrativeTrigger);
				trigger.start();
				//lastTrigger.end();
				//dialogueTimer.reset();
				//dialogueTimer.start();
				
				if(	currentDialoguePosition == 1 ){
					currentDialoguePosition = 2;
					trigger.narrative.y = bottomDialoguePoint.y;
					trigger.narrative.x = bottomDialoguePoint.x;
					trigger.narrative.x += 25;
				} else {
					currentDialoguePosition = 1;
					trigger.narrative.y = topDialoguePoint.y;
					trigger.narrative.x = topDialoguePoint.x;
					trigger.narrative.x -= 25;
				}
				
				trigger.narrative.alpha = 0;
				
				if(currentDialogueIndex < 2){
					if(currentDialoguePosition == 1){
						var myTween:GTween = new GTween(trigger.narrative, .5, {x:(trigger.narrative.x + 25 ), alpha:1}, {ease:Sine.easeIn});
					} else {
						var myTween:GTween = new GTween(trigger.narrative, .5, {x:(trigger.narrative.x - 25 ), alpha:1}, {ease:Sine.easeIn});						
					}
				} else {
					trigger.narrative.alpha = 1;
					if(currentDialoguePosition == 1){
						trigger.narrative.x += 25;
					} else {
						trigger.narrative.x -= 25;						
					}
				}
				narrativeControl.nextNarrative.label = "Next";
			}		
		}
		
		public static function playNextStartLevelDialogue(e:Event = null):void
		{
			if( (currentDialogues[PlayerStats.currentLevelId] as Array).length > 0){
				if(currentDialogueIndex < 0){
					currentDialogueIndex = 0;
				}
				
				for(var i:int = 0 ; i < (currentDialogues[PlayerStats.currentLevelId] as Array).length ; i++){
					if( ( currentDialogues[PlayerStats.currentLevelId][i] as NarrativeTrigger).startedPlaying == true){
						if(currentDialogueIndex != i){
							( currentDialogues[PlayerStats.currentLevelId][i] as NarrativeTrigger).end();
						}
					}
				}
				( currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex] as NarrativeTrigger).showText();
			} else {
				( currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex] as NarrativeTrigger).showText();
			}
			
			currentDialogueIndex++;
			//dialogueTimer.stop();
			if(currentDialogueIndex < 0){
				currentDialogueIndex = 1;
			}
			
			if( currentDialogueIndex >= ( currentDialogues[PlayerStats.currentLevelId] as Array).length){
				doneDialogues();
			} else {
				var delay:Number;
				if ( (currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex] as NarrativeTrigger).delay != -1){
					delay = (currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex] as NarrativeTrigger).delay;
				} else {
					delay = (currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex] as NarrativeTrigger).message.length * dialogueDelayMultiplier;
				}
				//dialogueTimer.delay = delay
					
				var lastTrigger:NarrativeTrigger = ( currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex-1] as NarrativeTrigger);
				var trigger:NarrativeTrigger = ( currentDialogues[PlayerStats.currentLevelId][currentDialogueIndex] as NarrativeTrigger);
				trigger.start();
				//dialogueTimer.reset();
				//dialogueTimer.start();
				
				if(	currentDialoguePosition == 1 ){
					currentDialoguePosition = 2;
					trigger.narrative.y = bottomDialoguePoint.y;
					trigger.narrative.x = bottomDialoguePoint.x;
					trigger.narrative.x += 25;
				} else {
					currentDialoguePosition = 1;
					trigger.narrative.y = topDialoguePoint.y;
					trigger.narrative.x = topDialoguePoint.x;
					trigger.narrative.x -= 25;
				}
				
				trigger.narrative.alpha = 0;
				
				
				if(currentDialogueIndex < 2){
					if(currentDialoguePosition == 1){
						var myTween:GTween = new GTween(trigger.narrative, .5, {x:(trigger.narrative.x + 25 ), alpha:1}, {ease:Sine.easeIn});
					} else {
						var myTween:GTween = new GTween(trigger.narrative, .5, {x:(trigger.narrative.x - 25 ), alpha:1}, {ease:Sine.easeIn});						
					}
				} else {
					trigger.narrative.alpha = 1;
					if(currentDialoguePosition == 1){
						trigger.narrative.x += 25;
					} else {
						trigger.narrative.x -= 25;						
					}
				}
				
				if(currentDialogueIndex == (currentDialogues[PlayerStats.currentLevelId] as Array).length-1){
					narrativeControl.nextNarrative.label = "Play";
				} else {
					narrativeControl.nextNarrative.label = "Next";
				}
			}
		}
		
		public static function stopAllDialogues():void
		{
			//dialogueTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,playNextStartLevelDialogue);
		}
		
		public static var currentTipsToShow:Array = new Array();
		public static var currentTipShown:int = 0;
		public static var clickBlocker:Sprite;
		public static var tipsFinishedCallback:Function;
		public static var unPauseAtEnd:Boolean = true;
		public static function showTutorialTips(messages:Array = null, images:Array = null, positions:Array = null, UnPauseAtEnd:Boolean = true, finishedCallback:Function = null):void
		{
			unPauseAtEnd = UnPauseAtEnd;
			if(messages == null){
				if( tipsFinishedCallback != null){
					tipsFinishedCallback();
				}
				return
			}
			tipsFinishedCallback = finishedCallback;
			if(FlxG.state is PlayState){
				if( (FlxG.state as PlayState).isFrozen == false){
					(FlxG.state as PlayState).doChangeFrozenState = true;
				}
			}
			clickBlocker = new Sprite();
			clickBlocker.graphics.beginFill(0xFFFFFF,.25);
			clickBlocker.graphics.drawRect(0,0,FlxG.stage.stageWidth,FlxG.stage.stageHeight);
			clickBlocker.x = 0;
			
			if((FlxG.state is PlayState)){
				(FlxG.state as PlayState).gameInterface.addChild(clickBlocker);
			} else {
				(FlxG.state).addChild(clickBlocker);
			}
			
			for ( var i:int = 0 ; i < messages.length ; i++){
				var newTip:TipDialogue = new TipDialogue(-1,messages[i],images[i],positions[i],showNextTip);
				currentTipsToShow.push(newTip);
			}
			(currentTipsToShow[0] as TipDialogue).showTip();
			
		}
		
		public static function showNextTip():void
		{
			currentTipShown++;
			if(currentTipShown < currentTipsToShow.length){
				(currentTipsToShow[currentTipShown] as TipDialogue).showTip();
			} else {
				finishedShowingTips();
			}
		}
		
		public static function finishedShowingTips():void
		{
			currentTipsToShow = new Array();
			if(FlxG.state is PlayState){
				if( (FlxG.state as PlayState).isFrozen == true && unPauseAtEnd == true){
					(FlxG.state as PlayState).doChangeFrozenState = true;
				}
				(FlxG.state as PlayState).gameInterface.removeChild(clickBlocker);
			} else {
				(FlxG.state).removeChild(clickBlocker);
			}
			if( tipsFinishedCallback != null){
				tipsFinishedCallback();
			} else {
				tipsFinishedCallback = null;
			}
			currentTipShown = 0;
		}
		
		public static var nameInputtedCallback:Function;
		public static function showNameInputWindow(callBackFunction:Function):void
		{
			nameInputtedCallback = callBackFunction;
			var nameInputWindow:NameInputDialogue = new NameInputDialogue(nameInputtedCallback);
			
		}
		
		public static var helpWindow:HelpDialogue;
		public static function showMiniHelpWindow(e:Event = null):void
		{
			clickBlocker = new Sprite();
			clickBlocker.graphics.beginFill(0xFFFFFF,.25);
			clickBlocker.graphics.drawRect(0,0,FlxG.stage.stageWidth,FlxG.stage.stageHeight);
			
			helpWindow = new HelpDialogue();
			helpWindow.x = Math.round(600/2 - 475/2);
			helpWindow.y = Math.round(450/2 - 325/2);
			
			if((FlxG.state is PlayState)){
				(FlxG.state as PlayState).gameInterface.addChild(clickBlocker);
				(FlxG.state as PlayState).addChild( helpWindow );
			} else {
				FlxG.state.addChild(clickBlocker);
				FlxG.state.addChild( helpWindow );
			}
			if ( (FlxG.state as PlayState).isFrozen == false){
				(FlxG.state as PlayState).stageMoveEnabled = false;
				(FlxG.state as PlayState).doChangeFrozenState = true;
			}			
		}
		
		public static function removeMiniHelpWindow(e:Event = null):void
		{			
			if((FlxG.state is PlayState)){
				(FlxG.state as PlayState).gameInterface.removeChild(clickBlocker);
				(FlxG.state as PlayState).removeChild( helpWindow );
			} else {
				FlxG.state.removeChild(clickBlocker);
				FlxG.state.removeChild( helpWindow );
			}			
			if ( (FlxG.state as PlayState).isFrozen == true){
				(FlxG.state as PlayState).stageMoveEnabled = true;
				(FlxG.state as PlayState).doChangeFrozenState = true;
			}			
			
		}
		
		
		
	}
}