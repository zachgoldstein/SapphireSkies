package zachg.windows
{
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.flixel.FlxG;
	
	import zachg.Mineral;
	import zachg.PlayerStats;
	import zachg.growthItems.playerItem.PlayerItem;
	import zachg.ui.CargoList;
	
	public class CargoWindow extends Sprite
	{
		
		public var background:Window;
		public var closeButton:PushButton;
		public var dumpAllButton:PushButton;
		
		public var closeCallBack:Function
		
		public var currentMineralValue:Label;
		public var cargoUsageLabel:Label;
		private var totalShownMineralValue:Number;
		
		public var cargoLabel:Label; 
		public var mineralListTitle:Label;
		public var mineralsList:CargoList;
		
		public var warningLabel1:Label;
		public var warningLabel2:Label;
		
		private var currentShownMinerals:Vector.<Mineral> = new Vector.<Mineral>();
		
		//TODO: re-work whole class to handle grahics for each item
		
		public function CargoWindow(CloseCallBack:Function = null)
		{
			super();
			closeCallBack = CloseCallBack
				
			var backgroundFiller:Sprite = new Sprite();
			backgroundFiller.graphics.beginFill(0x000000,.65);
			backgroundFiller.graphics.drawRect(2,2,388,421);
			addChild(backgroundFiller);
			
			var backgroundBorder:* = new Resources.UICargoBorder();
			addChild(backgroundBorder);
			
			var cargoTitle:Label = new Label(this,5,5,"Cargo","MenuFont",20,0xFFFFFF);
			cargoUsageLabel = new Label(this,5,25,"","system",8,0xFFFFFF);
			cargoUsageLabel.text = (FlxG.state as PlayState).player.currentPlayerMinerals.length + "/" + (FlxG.state as PlayState).player.cargoSizeLimit + " of cargo space used";
			currentMineralValue = new Label(this,265,25,"Total Cargo Value: ","system",8,0xFFFFFF);
			
			mineralsList = new CargoList(this,2,43);
			mineralsList.width = 384;
			mineralsList.height = 350;
			mineralsList._scrollbar._backgroundColor = 0x2b331e;
			mineralsList._scrollbar._barBackgroundColor = 0x9ca065;
			mineralsList._scrollbar._arrowBackgroundColor = 0xa0a064;
			mineralsList._scrollbar._arrowColor = 0xece8dc;
			mineralsList._scrollbar.initForce();			
			
			closeButton = new PushButton(this,0,410,"Close",close,null,null,null,null,"system",8,0xFFFFFF);
			closeButton.width = 50;
			closeButton.height = 14;

			dumpAllButton = new PushButton(this,328,410,"Dump All",dumpAll,null,null,null,null,"system",8,0xFFFFFF);
			dumpAllButton.width = 50;
			dumpAllButton.height = 14;			
			
			warningLabel1 = new Label(this,5,390,"Move your ship to a friendly village to sell your cargo","system",8,0xFFFFFF);
		}
		
		public function setList():void
		{
			currentShownMinerals = (FlxG.state as PlayState).player.currentPlayerMinerals;
			var listData:Array = new Array();
			var totalValue:Number = 0;
			for(var i:int = 0 ; i < currentShownMinerals.length ; i++){
				listData.push(currentShownMinerals[i].fullName + " with value " + currentShownMinerals[i].rupeeValue);
				totalValue += currentShownMinerals[i].rupeeValue;
			}
			totalShownMineralValue = totalValue;
			currentMineralValue.text = "Total Cargo Value: "+totalValue;
			cargoUsageLabel.text = (FlxG.state as PlayState).player.currentPlayerMinerals.length + "/" + (FlxG.state as PlayState).player.cargoSizeLimit + " of cargo space used";
			mineralsList.items = currentShownMinerals;
			mineralsList.draw();
		}		
		
		public function close(e:MouseEvent):void
		{
			closeCallBack();
		}
		
		public function dumpAll(e:MouseEvent):void
		{
			(FlxG.state as PlayState).player.currentPlayerMinerals = new Vector.<Mineral>();
			setList();
		}
	}
}