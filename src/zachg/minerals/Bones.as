package zachg.minerals
{
	import zachg.Mineral;
	
	public class Bones extends Mineral
	{
		public function Bones()
		{
			super();
			fullName = "Bones"; 
			description = "Assorted bits of bone form a rough approximation of a femur. It appears to be human-sized.";
			imageName = "UICargoIconIron";
			rupeeValue = 3;
			resourceValue = 3;
			weight = 1;
			probability = 1-0.3;
		}
	}
}