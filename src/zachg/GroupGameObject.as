package zachg
{
	import org.flixel.FlxGroup;
	
	import zachg.components.GameComponent;
	import zachg.components.HealthComponent;
	import zachg.components.maps.Mapping;

	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;	
	
	public class GroupGameObject extends FlxGroup
	{
		public var healthComponent:HealthComponent = new HealthComponent();
		public var isEnemy:Boolean;
		
		public var isFrozen:Boolean = false;
		
		public function GroupGameObject()
		{
			super();
		}
		
		public function addComponent(component:GameComponent):void
		{
			add(component.PhysicalSprite);
		}
		
		override public function update():void{ 
			if(isFrozen == true){
				return
			}
			super.update();
		}
		
		/**
		 * removes all the stuff added onto this sprite and kills it. Does a full cleanup  
		 * 
		 */
		public function destroyObject():void{
			destroy();
			kill();
		}		
		
		public function loadPropertyMapping(mapping:Mapping):void
		{
			if (mapping == null){
				return
			}
			for (var key:* in mapping.properties)
			{
				trace(key + " = " + mapping.properties[key]);
				if( this.hasOwnProperty(key)){
					this[key] = mapping.properties[key];
				}
			}		
		}
		
		public static function copyData(source:Object, destination:Object):void {
			
			//copies data from commonly named properties and getter/setter pairs
			if((source) && (destination)) {
				
				try {
					var sourceInfo:XML = describeType(source);
					var prop:XML;
					
					for each(prop in sourceInfo.variable) {
						
						if(destination.hasOwnProperty(prop.@name)) {
							destination[prop.@name] = source[prop.@name];
						}
						
					}
					
					for each(prop in sourceInfo.accessor) {
						if(prop.@access == "readwrite") {
							if(destination.hasOwnProperty(prop.@name)) {
								destination[prop.@name] = source[prop.@name];
							}
							
						}
					}
				}
				catch (err:Object) {
					;
				}
			}
		}
	}
}