package zachg.ui
{
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.senocular.display.duplicateDisplayObject;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import org.flixel.FlxG;
	
	import zachg.PlayerStats;
	import zachg.util.GameMessageController;
	import zachg.util.SoundController;
	
	public class HelpDialogue extends Sprite
	{
		
		public var messageText:Text
		
		public var currentTutorialGraphics:Array = [
			new Resources.GameTutorialsBig1(),
			new Resources.GameTutorialsBig2(),
			new Resources.GameTutorialsBig3(),
			new Resources.GameTutorialsBig4(),
			new Resources.GameTutorialsBig5()
		];
		public var currentTutorialGraphic:*;
		public var currentTutorialTip:int = 0;
		
		
		public function HelpDialogue()
		{
			super();

			var currentWidth:Number = 475;
			var currentHeight:Number = 325;
			
			graphics.beginFill(0,.5);
			graphics.drawRect(0,0,475,325);
			
			var tipBackground:* = new Resources.UIQuickTutorialBackground();
			addChild(tipBackground);
				
			var smallButtonOn:* = new Resources.UISmallLongButtonBackgroundOff();
			var smallButtonRoll:* = new Resources.UISmallLongButtonBackgroundRoll();			
			
			var nextButton:PushButton = new PushButton(this,Math.round((currentWidth)/2 - 100/2 + 60),currentHeight-25,"Next Tip",showNextTutorialTip,
				duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
				"MenuFont",15,0xffffcc);
			nextButton.width = 100;
			nextButton.height = 13;	

			var prevButton:PushButton = new PushButton(this,Math.round((currentWidth)/2 - 100/2 - 60),currentHeight-25,"Prev Tip",showPrevTutorialTip,
				duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
				"MenuFont",15,0xffffcc);
			prevButton.width = 100;
			prevButton.height = 13;	
			
			var smallCloseButtonOn:* = new Resources.UISmallButtonBackgroundOff();
			var smallCloseButtonRoll:* = new Resources.UISmallButtonBackgroundRoll();			
			
			var closeButton:PushButton = new PushButton(this,currentWidth-60,5,"Close",closeWindow,
				duplicateDisplayObject(smallCloseButtonOn),null,duplicateDisplayObject(smallCloseButtonRoll),null,
				"MenuFont",15,0xffffcc);
			closeButton.width = 50;
			closeButton.height = 11;	

			var forumButton:PushButton = new PushButton(this,10,5,"Report Bug",goToForum,
				duplicateDisplayObject(smallButtonOn),null,duplicateDisplayObject(smallButtonRoll),null,
				"MenuFont",15,0xffffcc);
			forumButton.width = 100;
			forumButton.height = 11;	
			
			currentTutorialGraphic = currentTutorialGraphics[0];
			addChild(currentTutorialGraphic);
			currentTutorialGraphic.x = 13;
			currentTutorialGraphic.y = 35;			
			
/*			messageText = new Text(this,10,30,tutorialTips[currentTutorialTip],"MenuFont",25,0xFFFFFF,false);
			messageText.width = 230;
			messageText.height = 190;
			var textFrmt:TextFormat = messageText.textField.getTextFormat();
			textFrmt.align = TextFormatAlign.CENTER;
			messageText.textField.defaultTextFormat = textFrmt;
			
			messageText.selectable = false;
			messageText.editable = false;
*/			
		}
		
		public function showNextTutorialTip(e:Event):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			currentTutorialTip++;
			if(currentTutorialTip > (currentTutorialGraphics.length-1)){
				currentTutorialTip = currentTutorialTip%(currentTutorialGraphics.length-1);
			}
			
			removeChild(currentTutorialGraphic)
			currentTutorialGraphic = currentTutorialGraphics[currentTutorialTip];
			addChild(currentTutorialGraphic);
			currentTutorialGraphic.x = 13;
			currentTutorialGraphic.y = 35;			
			
		}
		
		public function showPrevTutorialTip(e:Event):void
		{
			SoundController.playSoundEffect("SfxButtonPress");
			if( currentTutorialTip <= 0 ){
				currentTutorialTip += currentTutorialGraphics.length-1;
			}
			currentTutorialTip--;
			
			removeChild(currentTutorialGraphic)
			currentTutorialGraphic = currentTutorialGraphics[currentTutorialTip];
			addChild(currentTutorialGraphic);
			currentTutorialGraphic.x = 13;
			currentTutorialGraphic.y = 35;			
			
		}

		
		public function closeWindow(e:Event = null):void
		{
			GameMessageController.removeMiniHelpWindow();
		}
		
		public function goToForum(e:Event = null):void
		{
			gotoUrl("http://www.reindeerflotilla.net/forum/viewforum.php?f=6");
		}
		
		public function gotoUrl(url:String):void {
			//var url:String = "http://www.example.com/";
			var request:URLRequest = new URLRequest(url);
			try { 
				navigateToURL(request, '_blank');
			} catch (e:Error) {
				trace("Error occurred!");
			}
		}		
		
	}
}