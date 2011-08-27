package zachg.util
{
	public class LevelDataVo extends Object
	{
		//put default unlocked ids in here
		public var shotsFired:Number = 0;
		public var shotsHit:Number = 0;
		public var kills:Number = 0;
		
		public var thrustSpent:Number = 0;
		public var areaMined:Number = 0;
		public var resourcesEarned:Number = 0;
		
		public var cashBalance:Number = 0;
		
		public var levelHighscore:Number = 0;

		public var levelId:Number = -1;
		
		public function LevelDataVo(index:Number = -1)
		{
			levelId = index;
		}
	}
}