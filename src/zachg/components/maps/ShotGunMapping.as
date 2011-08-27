package zachg.components.maps
{
	public class ShotGunMapping extends Mapping
	{
		public function ShotGunMapping()
		{
			properties.isSingleShotMode = false;
			properties.isShotGunMode = true;
			properties.shotDamage = 20;

			properties.nonSenseTest = true;
		}
	}
}