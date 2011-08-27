package zachg.minerals
{
	import zachg.Mineral;
	
	public class Iron extends Mineral
	{
		public function Iron()
		{
			super();
			fullName = "Iron Ore"; 
			//description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ut mauris vel ante suscipit pellentesque. Proin quis massa erat, sed malesuada nulla. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur nec nisl diam, sed facilisis massa. Donec porta dui a magna porttitor tincidunt. Ut libero arcu, imperdiet in vehicula et, lacinia a mauris. Fusce vulputate viverra aliquam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Quisque vel arcu risus, sed dignissim lacus. Quisque in nibh nulla. Nulla ultrices convallis volutpat. In hac habitasse platea dictumst";
			description = "This valuable iron ore can be alloyed with refined Mormite to create tough lightweight ship hulls your freedom fighting efforts.";
			imageName = "UICargoIconIron";
			rupeeValue = 5;
			resourceValue = 5;
			weight = 20;
			probability = 0.5;
		}
	}
}