package zachg.components.maps
{
	import flash.geom.Point;

	public class SpeedBoostMap extends Mapping
	{
		public function SpeedBoostMap()
		{
			properties.thrustForce = new Point(2000,2000);
		}
	}
}