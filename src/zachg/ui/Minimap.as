package zachg.ui
{
	import com.BaseLevel;
	import com.PlayState;
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	import zachg.gameObjects.Bot;
	import zachg.gameObjects.BuildingGroup;
	
	public class Minimap extends Sprite
	{
		
		public var playerTextColor:uint = 0xFFFFFF;
		public var friendlyTextColor:uint = 0x0099FF;
		public var enemyTextColor:uint = 0xFF0000;
		
		public var mapWidth:Number = 112;
		public var mapHeight:Number = 100;
		
		public function Minimap()
		{
			super();
			
/*			var player:Label = new Label(this,0,mapHeight-35,"Player");
			var friendlyUnits:Label = new Label(this,0,mapHeight-25,"Friendly Units");
			var enemyUnits:Label = new Label(this,0,mapHeight-15,"Enemy Units");
			
			player.textField.textColor = playerTextColor;
			friendlyUnits.textField.textColor = friendlyTextColor;
			enemyUnits.textField.textColor = enemyTextColor;
*/			
			alpha = .75
			
		}
		
		public function drawMinimap():void
		{
			graphics.clear();
			
			graphics.beginFill(0,1);
			//graphics.drawRect(0,0,mapWidth,mapHeight);
			
			var playerLocation:Point = new Point( 	((FlxG.state as PlayState).player.MainHullSprite.x/ BaseLevel.boundsMaxX )*mapWidth,
													((FlxG.state as PlayState).player.MainHullSprite.y/BaseLevel.boundsMaxY )*mapHeight );
			graphics.beginFill(playerTextColor);
			graphics.drawCircle(playerLocation.x,playerLocation.y,3);
			graphics.endFill();
			
			//draw camera rectangle
			if( (FlxG.state as PlayState).isFrozen == true){
				var cameraCenterLocation:Point = new Point( 	((FlxG.state as PlayState).cameraObject).x/(BaseLevel.boundsMaxX)*mapWidth,
					((FlxG.state as PlayState).cameraObject).y/(BaseLevel.boundsMaxY)*mapHeight );
				graphics.lineStyle(2,0xFFFFFF);
				graphics.drawRect( 	cameraCenterLocation.x - ( ((FlxG.stage.stageWidth)/(BaseLevel.boundsMaxX)*mapWidth) /2),
					cameraCenterLocation.y - ( ((FlxG.stage.stageWidth/2)/(BaseLevel.boundsMaxY/2)*mapHeight) /2),
					((FlxG.stage.stageWidth)/(BaseLevel.boundsMaxX)*mapWidth),
					((FlxG.stage.stageHeight)/(BaseLevel.boundsMaxY)*mapHeight) );
				graphics.lineStyle(0,0,0);
			}
			//draw units			
			for ( var i:int = 0 ; i < (FlxG.state as PlayState).friendlyGroup.members.length; i++){
				if( ((FlxG.state as PlayState).friendlyGroup.members[i] is Bot ||
					(FlxG.state as PlayState).friendlyGroup.members[i] is BuildingGroup) &&
					((FlxG.state as PlayState).friendlyGroup.members[i] as FlxObject).dead == false ){
					var friendlyLocation:Point = new Point( 	((FlxG.state as PlayState).friendlyGroup.members[i] as FlxObject).x/(BaseLevel.boundsMaxX)*mapWidth,
																((FlxG.state as PlayState).friendlyGroup.members[i] as FlxObject).y/(BaseLevel.boundsMaxY)*mapHeight );
					graphics.beginFill(friendlyTextColor);
					if((FlxG.state as PlayState).friendlyGroup.members[i] is BuildingGroup){
						graphics.drawRect(friendlyLocation.x-3,friendlyLocation.y-3,6,6);
					} else if((FlxG.state as PlayState).friendlyGroup.members[i] is Bot){
						graphics.drawCircle(friendlyLocation.x,friendlyLocation.y,2);
					}
					graphics.endFill();
				}
				
			}

			for ( var j:int = 0 ; j < (FlxG.state as PlayState).enemyGroup.members.length; j++){
				if( ((FlxG.state as PlayState).enemyGroup.members[j] is Bot || 
					(FlxG.state as PlayState).enemyGroup.members[j] is BuildingGroup) &&
					((FlxG.state as PlayState).enemyGroup.members[j] as FlxObject).dead == false ){
					var enemyLocation:Point = new Point( 	(((FlxG.state as PlayState).enemyGroup.members[j] as FlxObject).x/BaseLevel.boundsMaxX )*mapWidth,
															(((FlxG.state as PlayState).enemyGroup.members[j] as FlxObject).y/BaseLevel.boundsMaxY )*mapHeight );
					graphics.beginFill(enemyTextColor);
					if((FlxG.state as PlayState).enemyGroup.members[j] is BuildingGroup){
						graphics.drawRect(Math.round(enemyLocation.x-3),Math.round(enemyLocation.y-3),6,6);
					} else if((FlxG.state as PlayState).enemyGroup.members[j] is Bot){
						graphics.drawCircle(enemyLocation.x,enemyLocation.y,2);
					}					
					graphics.endFill();
				}
			}
		}
	}
}