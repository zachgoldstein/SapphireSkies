package zachg.ui
{
	import com.bit101.components.Label;
	
	import flash.display.Sprite;
	
	public class MoneyDisplay extends Sprite
	{
		public function MoneyDisplay()
		{
			super();
			setMoney("0");
			//width = 150;
		}
		
		public var activeMoneyDigits:Array = new Array();
		public var digitSpacing:Number = 12;
		
		public function setMoney(value:String):void
		{
			if(value == "NaN"){
				trace("Fuck");
				return
			}
			if (activeMoneyDigits.length > 0){
				for( var i:int = 0 ; i < activeMoneyDigits.length ; i++){
					removeChild(activeMoneyDigits[i]);
				}
			}
			activeMoneyDigits = new Array();
			var rewardString:String = ""+value;
			if(rewardString.length < 9){
				var numCharsToAdd:Number = 9-rewardString.length;
				for( var i:int = 0 ; i < numCharsToAdd ; i++){
					rewardString = (0+rewardString.slice());
				}
			}
			
			for( var i:int = 0 ; i < rewardString.length ; i++){
				var moneyDigit:Label = new Label(this,i*digitSpacing,0,rewardString.charAt(i),"MenuFont", 20, 0x000000);
				activeMoneyDigits.push(moneyDigit);
			}
			
		}
	}
}