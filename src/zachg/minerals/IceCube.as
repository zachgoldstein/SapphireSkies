package zachg.minerals
{
	import zachg.Mineral;
	
	public class IceCube extends Mineral
	{
		public function IceCube()
		{
			super();
			fullName = "Ice Cube's AK"; 
			description = "A Kalashnikov and a doo-rag are frozen in stone. Ice Cube is scrawled into the side. The safety is on.";
			imageName = "UICargoIconCube";
			rupeeValue = 10;
			resourceValue = 1;
			weight = 1;
			probability = .15;
		}
	}
}