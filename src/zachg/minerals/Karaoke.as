package zachg.minerals
{
	import zachg.Mineral;
	
	public class Karaoke extends Mineral
	{
		public function Karaoke()
		{
			super();
			fullName = "A Classic Arcade Machine"; 
			description = "This classic games machine would be sure to boost morale, however it doesn't seem to run on rupee's! Maybe the village Shamen can divine the nature of these 'quarters'";
			imageName = "UICargoIconArcade";
			rupeeValue = 8;
			resourceValue = 3;
			weight = 1;
			probability = .2;
		}
	}
}