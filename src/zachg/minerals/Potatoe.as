package zachg.minerals
{
	import zachg.Mineral;
	
	public class Potatoe extends Mineral
	{
		public function Potatoe()
		{
			super();
			fullName = "A Potato"; 
			description = "This radioactive delacacy thrills the tastebuds in a way no other food-relic can. You'll never taste anything quite like it.";
			imageName = "UICargoIconPotato";
			rupeeValue = 2;
			resourceValue = 5;
			weight = 1;
			probability = .2;
		}
	}
}