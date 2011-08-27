package zachg.windows
{
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.Window;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.flixel.FlxG;
	
	import zachg.PlayerStats;
	import zachg.growthItems.playerItem.PlayerItem;
	
	public class TutorialWindow extends Sprite
	{
		public var closeCallBack:Function;
		
		public var background:Window;
		public var closeButton:PushButton;
		public var nextButton:PushButton;
		public var videoDescription:Text;
		
		public var videoArray:Array = new Array();
		
		public var videoDescriptions:Array = new Array();
	
		public var currentVideo:MovieClip = new MovieClip();
				
		public var currentInstruction:Number = 0;
		
		public function TutorialWindow(CloseCallBack:Function = null)
		{
			super();
			closeCallBack = CloseCallBack
			
//			videoArray = [ 	new Resources.IslandsVid(),
//							new Resources.MovementVid(),
//							new Resources.ShootingVid(), 
//							new Resources.MiningVid(),
//							new Resources.CrystalsVid()
//							];
//			videoDescriptions = [	"Defend the village on the left, attack the village on the right. " +
//									"You win if you destroy the enemy village on the right, and lose if the village on the left is destroyed.",
//									
//									"Use the WASD or arrow keys to move around the ship. Mousing over units shows their health and level." ,
//									
//									"Use the mouse to aim the gun, and click or press space to shoot.",
//									
//									"The village needs resources to start building units, mine minerals from the islands to give the village" +
//									" resources. Do this by landing on an island and pressing down. \n" +
//									"Once you've mined minerals, move the ship to the same position as the friendly village to give the village" +
//									" mineral resources.",
//									
//									"You can also destroy a village by blowing up the crystal below it. These crystals keep the island in the air, " +
//									"destroying them causes the island to fall to the earth. \n" +
//									"Mine below an island to move away the earth around it, then shoot the crystal until it blows up. \n " +
//									"Good Luck! Don't forget to buy upgrades (button in level selection screen) if you get stuck.",
//									];
									
			background = new Window(this,0,0,"Tutorial");
			background.width = 300;
			background.height = 420;
			background.draggable = false;
			closeButton = new PushButton(this,105,3,"Skip",close);
			closeButton.width = 50;
			closeButton.height = 14;
			
			currentVideo = videoArray[currentInstruction];
			addChild(currentVideo);
			currentVideo.play();
			
			currentVideo.x = 300/2 - currentVideo.width/2;
			currentVideo.y = 35;
			
			videoDescription = new Text(this,300/2 - 250/2,currentVideo.y + currentVideo.height + 5,"");
			videoDescription.text = videoDescriptions[currentInstruction];
			videoDescription.editable = false;
			videoDescription.width = 250;
			videoDescription.height = 100;
			
			nextButton = new PushButton(this,300/2 - 100/2,videoDescription.y + 100 + 5,"Next",nextInstruction)

		}
		
		public function nextInstruction(e:MouseEvent):void
		{
			currentInstruction++;
			if(currentInstruction >= videoArray.length){
				close();
			} else{
				removeChild(currentVideo);
				currentVideo = videoArray[currentInstruction];
				addChild(currentVideo);
				currentVideo.x = 300/2 - currentVideo.width/2;
				currentVideo.y = 35;	
				currentVideo.play();
				
				videoDescription.y = currentVideo.y + currentVideo.height + 5
				nextButton.y = 	videoDescription.y + 100 + 5;
				
				videoDescription.text = videoDescriptions[currentInstruction];
				
				if(currentInstruction == videoArray.length - 1){
					nextButton.label = "Start Game";
				}
			}			
		}
		
		public function close(e:MouseEvent = null):void
		{
			closeCallBack();
		}
		
		public function refresh():void
		{
		}
	}
}