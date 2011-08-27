package zachg.growthItems
{
	import org.flixel.FlxPoint;

	public class GrowthItem extends Object
	{
		
		public var description:String = "";
		public var simpleDescription:String = "";
		public var weaponListing:String = "";
		public var isEquipped:Boolean = false;
		public var isPurchased:Boolean = false;
		public var isPremium:Boolean = false;
		public var iconName:String = "";

		public var shipGraphic:String = "";
		public var shipGraphicParameters:Array = new Array();
		public var turretGraphic:String = "";
		public var turretGraphicParameters:Array = new Array();
		public var turretOffsetRight:FlxPoint;
		public var turretOffsetLeft:FlxPoint;
		public var shipColorTint:uint = 0xFFFF00;
		
		public var id:int = -1;
		
		public var clarityPtsRequired:Number = 10;
		/**
		 * Deprecated use clarity pts instead
		 */
		public var playerXPRequired:Number = 10;
		public var growthItemTitle:String = "";
		
		public function GrowthItem(Id:int = -1)
		{
			id = Id;
		}
	}
}