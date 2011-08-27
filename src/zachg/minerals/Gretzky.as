package zachg.minerals
{
	import zachg.Mineral;
	
	public class Gretzky extends Mineral
	{
		public function Gretzky()
		{
			super();
			fullName = "Gretzky"; 
			description = "Two massive circular pieces of rubber with wayne gretzky's face embedded on them.";
			imageName = "UICargoIconIron";
			rupeeValue = 9;
			resourceValue = 1;
			weight = 1;
			probability = 1-0.9;
		}
	}
}