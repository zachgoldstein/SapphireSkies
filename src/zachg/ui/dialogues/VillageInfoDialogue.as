package zachg.ui.dialogues
{
	
	import com.GlobalVariables;
	import com.PlayState;
	import com.Resources;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.Window;
	import com.senocular.display.duplicateDisplayObject;
	import com.senocular.ui.VirtualMouse;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.ID3Info;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	import zachg.Mineral;
	import zachg.PlayerStats;
	import zachg.components.GameComponent;
	import zachg.gameObjects.BuildingGroup;
	import zachg.gameObjects.CallbackSprite;
	import zachg.gameObjects.Factory;
	import zachg.gameObjects.Shop;
	import zachg.gameObjects.Village;
	import zachg.util.LevelData;
	import zachg.util.VillageInfoGenerator;

	public class VillageInfoDialogue extends GameComponent 
	{
		
		public var graphicHolder:CallbackSprite;
		public var spriteCanvas:Sprite
				
		//public var windowBackground:Window;
		
		public var mineralListTitle:Label;
		public var mineralsList:List;
		public var sellAllMinerals:PushButton;
		
		public var x:Number;
		public var y:Number;
		
		protected var _pixels:BitmapData;
		
		public var showComponent:Boolean = true;
		
		public var cursor:VirtualMouse
		
		private var currentShownMinerals:Vector.<Mineral> = new Vector.<Mineral>();
		private var totalShownMineralValue:Number;
		
		public function VillageInfoDialogue(CallbackFunction:Function=null,RootObject:FlxObject=null)
		{
			super(CallbackFunction);
			rootObject = RootObject;
			spriteCanvas = new Sprite();
			//Hack. The visibility is on to enable mouse events on the sprite. 
			//We don't want it actually visible though, so we place it way out of range of the stage.
			spriteCanvas.visible = true;
			FlxG.stage.addChild(spriteCanvas);
			spriteCanvas.x = 1000;
			setupComponents();
			
			graphicHolder = new CallbackSprite();
			graphicHolder.visible = false;
			graphicHolder.solid = false;
			
			update();
		}
		
		private var villageName:Label;
		private var villagePopulation:Label;
		private var villagePopulationToNextLevel:ProgressBar;
		private var villageHealth:Label;
		private var villageHealthBar:ProgressBar;
		private var villageResources:Label;
		private var botCreationLabel:Label;
		private var botCreationCostLabel:Label;
		
		private var checkBoxTitle:Label;
		private var addTargetButton:PushButton;
		private var productionRateSlider:HSlider;
		private var productionRateTitleLabel:Label;
		private var productionRateLabel:Label;
		
		private var productionProgress:ProgressBar;
		private var productionProgressLabel:Label;
		
		private var deploymentOptions:Array = new Array();
		private var currentSelectedOption:int = -1;
		
		private function setupComponents():void{
			
/*			windowBackground = new Window(spriteCanvas,0,0,(rootObject as Village).villageName );
			windowBackground.width = 200;
			windowBackground.draggable = false;
*/			
			var backgroundHeight:Number;
			if ((rootObject as Village).isEnemy == false) {
				backgroundHeight = 210 + LevelData.LevelCreationData[PlayerStats.currentLevelId][1] * 23;
				var backgroundFiller:Sprite = new Sprite();
				backgroundFiller.graphics.beginFill(0x3399cc,0.75);
				backgroundFiller.graphics.drawRect(0,0,205,backgroundHeight);
				spriteCanvas.addChild(backgroundFiller);
				backgroundFiller.y = 23;
				
				var friendlyTopBackground:* = new Resources.UIGameFriendlyVillageBorderTop();
				var friendlyBottomBackground:* = new Resources.UIGameFriendlyVillageBorderBottom();
				friendlyTopBackground.y = 23;
				friendlyBottomBackground.y = 3 + LevelData.LevelCreationData[PlayerStats.currentLevelId][1] * 25;
				spriteCanvas.addChild(friendlyBottomBackground);
				spriteCanvas.addChild(friendlyTopBackground);
				
			} else{
				backgroundHeight = 154+19;
				var backgroundFiller:Sprite = new Sprite();
				backgroundFiller.graphics.beginFill(0xff6666,0.75);
				backgroundFiller.graphics.drawRect(0,0,205,backgroundHeight);
				spriteCanvas.addChild(backgroundFiller);
				backgroundFiller.y = 23;
				
				var enemyBackground:* = new Resources.UIGameEnemyVillageBorderTop();
				enemyBackground.y = 20;
				spriteCanvas.addChild(enemyBackground);

			}

			setTierIcon();
			
			villageName = new Label(spriteCanvas, 5,30, (rootObject as Village).villageName,"MenuFont",20, 0xffffff);
			villageName.autoSize = false;
			villageName.width = 200;
			var textFrmt:TextFormat = villageName.textField.getTextFormat();
			textFrmt.align = TextFormatAlign.CENTER;
			villageName.textField.defaultTextFormat = textFrmt;
			
			villageHealth = new Label(spriteCanvas,20,55,"","MenuFont",15,0xffffff);
			villagePopulation = new Label(spriteCanvas, 110,55,"","MenuFont",15,0xffffff);
			villageHealthBar = new ProgressBar(spriteCanvas,20,75);
			villageHealthBar.width = 75;
			villagePopulationToNextLevel = new ProgressBar(spriteCanvas,110,75);
			villagePopulationToNextLevel.width = 75;
			
			var healthIcon:* = new Resources.UIGameHPIcon();
			healthIcon.x = 6;
			healthIcon.y = 59;
			spriteCanvas.addChild(healthIcon);
			var peopleIcon:* = new Resources.UIGamePopIcon();
			peopleIcon.x = 95;
			peopleIcon.y = 58;
			spriteCanvas.addChild(peopleIcon);
			var resourcesIcon:* = new Resources.UIGameResourceIcon();
			resourcesIcon.x = 114;
			resourcesIcon.y = 123;
			spriteCanvas.addChild(resourcesIcon);
			
			var divider:* = new Resources.UIDivider();
			var topDivider:DisplayObject = duplicateDisplayObject(divider); 
			spriteCanvas.addChild(topDivider );
			topDivider.x = 20
			topDivider.y = 90;
			
			var production:Label = new Label(spriteCanvas,15,100,"Production","MenuFont",18,0xffffff);
			botCreationLabel = new Label(spriteCanvas, 15, 120, "Unit: ","system",8,0xffffff);
			botCreationCostLabel = new Label(spriteCanvas, 15, 130, "Cost: ","system",8,0xffffff);
			villageResources = new Label(spriteCanvas, 127,120,"","MenuFont",15,0xffffff);

			var unitBuildProgressLabel:Label = new Label(spriteCanvas, 60,146,"Build Progress: ","system",8,0xffffff);
			productionProgress = new ProgressBar(spriteCanvas, 60,158);
			productionProgressLabel = new Label(spriteCanvas,150,156,"0%","system",8,0xffffff);			
			
			var standardIcon:* = new Resources.UIHangarStandardIcon();
			spriteCanvas.addChild(standardIcon);
			standardIcon.x = 15;
			standardIcon.y = 150;						
			
			var shipIconOverlay:* = new Resources[ (rootObject as Village).aiItem.iconNames[(rootObject as Village).levelComponent.currentLevel] ]();
			
			//var shipIconOverlay:* = new Resources.UIHangarDefaultShipIcon()
			spriteCanvas.addChild(shipIconOverlay);
			shipIconOverlay.x = 15;
			shipIconOverlay.y = 150;
			
			if ((rootObject as Village).isEnemy == false) {
				var middleDivider:DisplayObject = duplicateDisplayObject(divider); 
				spriteCanvas.addChild(middleDivider);
				middleDivider.x = 20
				middleDivider.y = 195;
				
				var productionRateTitle:Label = new Label(spriteCanvas,60,167,"Production Rate","system",8,0xffffff);
				productionRateTitleLabel = new Label(spriteCanvas,150,178,"100%","system",8,0xffffff);
				
				var sliderBackground:* = new Resources.UIGameSliderOn();
				var sliderHandle:* = new Resources.UIGameVillageDeploymentSlider();
				
				productionRateSlider = new HSlider(spriteCanvas, 60, 180,sliderBackground,null,sliderHandle,null,productionRateChanged);
				productionRateSlider.width = 88;
				productionRateSlider.minimum = 0;
				productionRateSlider.maximum = 100;
				productionRateSlider.value = 100;
				
				//windowBackground.height = 190;
			} else {

				//windowBackground.height = 175;
			}

			productionProgress.width = 85;
			productionProgress.maximum = (rootObject as Village).botCreationDelay;
			productionProgress.value = (rootObject as Village).lastBotCreationCounter;

			if(cursor == null){
				cursor = new VirtualMouse( (FlxG.stage) ,0,0);
			}
			
			
			//OLD:
			//We need to go right into the level data b/c at creation, that's the only place to find that.
/*			if(LevelData.LevelCreationData[PlayerStats.currentLevelId][1] > 1 && (rootObject as Village).isEnemy == false ){
				checkBoxTitle = new Label(spriteCanvas,5,180,"Select a village below before adding a target:");
				addTargetButton = new PushButton(spriteCanvas,55,
					checkBoxTitle.y + LevelData.LevelCreationData[PlayerStats.currentLevelId][1]*20,
					"Add Target",addTargetButtonPress);
				addTargetButton.enabled = false;
				//windowBackground.height = addTargetButton.y + 25;				
			}*/

		}
		
		private function productionRateChanged(e:Event):void
		{
			(rootObject as Village).productionRate = productionRateSlider.value
			productionRateTitleLabel.text = Math.round(productionRateSlider.value) + "%";
		}
		
		private function islandDeploymentChanged(e:Event):void
		{
			for( var i:int ; i < deploymentPercentageDisplays.length ; i++){
				if( (deploymentPercentageDisplays[i] as Label).tag == (e.currentTarget as HSlider).tag ){
					(deploymentPercentageDisplays[i] as Label).text = String( Math.round((e.currentTarget as HSlider).value) ) + "%";
					(rootObject as Village).buildingTargetUIIndicators[i].percentageUnitsSentHere = (e.currentTarget as HSlider).value;
				} 
			}
			
		}
		
		public var createTargetDesignations:Boolean = false;
		public var deploymentPercentageDisplays:Array = new Array();
		override public function update():void
		{
			super.update();
			if(this.spriteCanvas.height > 2000){
				trace("wtf");
			}
			//required to do this in the update because the stage is not set when object calls constructor
			if(cursor == null){
				cursor = new VirtualMouse( (FlxG.stage) ,0,0);
			}
			
			//Creates the UI for the targets to the dialogue
			if(createTargetDesignations == false &&
				(FlxG.state as PlayState).enemyBuildings.members.length > 0 &&
				(rootObject as Village).isEnemy == false ){
				createTargetDesignations = true;
				buildTargetOptions();
				
				var deisgnateTargetsTitle:Label = new Label(spriteCanvas,15,205,"Designate Targets","MenuFont",20,0xffffff);

				deploymentPercentageDisplays = new Array();
				for ( var i:int = 0 ; i < targetOptions.length ; i++ ){
					
					var villageControlIndividualSectionHeight:Number = 25;
					var villageName:Label = new Label(spriteCanvas,20,227+i*villageControlIndividualSectionHeight,
						(rootObject as Village).buildingTargetUIIndicators[i].nameOfLocation
						,"system",8,0xffffff);
					
					var sliderBackground:* = new Resources.UIGameSliderOn();
					var sliderHandle:* = new Resources.UIGameVillageDeploymentSlider();					
					var islandSlider:HSlider = new HSlider(spriteCanvas, 20, 240+i*(villageControlIndividualSectionHeight)
						,sliderBackground,null,sliderHandle,null,islandDeploymentChanged);
					islandSlider.tag = targetOptionIds[i];
					islandSlider.width = 88;
					islandSlider.maximum = 100;
					islandSlider.value = Math.round(100/targetOptions.length);
					var productionRateAmount:Label = new Label(spriteCanvas,20+95,240+i*(villageControlIndividualSectionHeight)
						,islandSlider.value+"%","system",8,0xffffff);
					productionRateAmount.tag = targetOptionIds[i];
					
					deploymentPercentageDisplays.push(productionRateAmount);
				}							
			}
				
			
			if(showComponent == true){
				var mousePositionOnComponent:Point = new Point(FlxG.mouse.x - graphicHolder.x,FlxG.mouse.y - graphicHolder.y);				

				//Hack so that mouse events that are on this region trigger stuff on the sprite
				if( (mousePositionOnComponent.x > 0 && mousePositionOnComponent.x < graphicHolder.width) &&
					(mousePositionOnComponent.y > 0 && mousePositionOnComponent.y < graphicHolder.height) ){
					FlxG.stage.setChildIndex(spriteCanvas,FlxG.stage.numChildren - 1);
					cursor.x = mousePositionOnComponent.x + 1000;
					cursor.y = mousePositionOnComponent.y;
					if(FlxG.mouse.justPressed() == true){
						cursor.press();
					} else if (FlxG.mouse.justReleased() == true){
						cursor.release();						
					} else if(FlxG.mouse.pressed() == true){
						cursor.press();
					} else if(FlxG.mouse.pressed() == false){
						cursor.release();
					}
				}
				
				graphicHolder.visible = true;
				graphicHolder.x = x;
				graphicHolder.y = y;
				
				if(rootObject is Village){
					setTierIcon();
					
					botCreationLabel.text = "Unit: "+(rootObject as Village).aiItem.levelShipNames[(rootObject as Village).levelComponent.currentLevel];
					botCreationCostLabel.text = "Cost: "+(rootObject as Village).aiItem.levelShipResourceCost[(rootObject as Village).levelComponent.currentLevel];
					
					var productionProgressPercentage:Number =  Math.round( ((rootObject as Village).lastBotCreationCounter / (rootObject as Village).botCreationDelay ) * 100);
					productionProgressLabel.text = productionProgressPercentage + " %";
					productionProgress.maximum = (rootObject as Village).botCreationDelay;
					productionProgress.value = (rootObject as Village).lastBotCreationCounter;
					
					if(productionRateTitleLabel != null){
						productionRateTitleLabel.text = String(Math.round((rootObject as Village).productionRate)) + "%";
					}
					villagePopulation.text = Math.round((rootObject as Village).villagePopulation) +
						"/"+(rootObject as Village).villageMaxPopulation;
					villagePopulationToNextLevel.maximum = (rootObject as Village).villageMaxPopulation;
					villagePopulationToNextLevel.value = ((rootObject as Village).villagePopulation + Math.round((rootObject as Village).levelComponent.totalExperience  ) ); 					
					villageHealth.text = Math.round((rootObject as Village).healthComponent.currentHealth)+"/"+Math.round((rootObject as Village).healthComponent.maxHealth);			
					villageHealthBar.maximum = (rootObject as Village).healthComponent.maxHealth;
					villageHealthBar.value = (rootObject as Village).healthComponent.currentHealth;
					villageResources.text = Math.round((rootObject as Village).availableResources) + "/" + (rootObject as Village).villageResourceGrowth;
					
					//Only need this if we're doing specific targetting:
					/*
					buildTargetOptions();
					if(targetOptions.length > 0 && (rootObject as Village).isEnemy == false){ 
						if(deploymentOptions.length != targetOptions.length){
							//remove all
							for ( var i:int = 0 ; i < deploymentOptions.length ; i++ ){
								if(deploymentOptions[i] != null){
									spriteCanvas.removeChild(deploymentOptions[i]);
								}
							}
							deploymentOptions = new Array();
							//add new stuff in
							for ( var i:int = 0 ; i < targetOptions.length ; i++ ){
								var checkbox:CheckBox = new CheckBox(spriteCanvas,30,checkBoxTitle.y+15+(i*15),targetOptions[i],selectSomething);
								checkbox.tag = i;
								deploymentOptions.push(checkbox)
							}							
						}
					} else {
						//remove all
						for ( var i:int = 0 ; i < deploymentOptions.length ; i++ ){
							if(deploymentOptions[i] != null){
								spriteCanvas.removeChild(deploymentOptions[i]);
							}
						}
						deploymentOptions = new Array();
						if(addTargetButton != null){
							addTargetButton.enabled = false;
						}
					}		
					
					*/
				}
				drawVisual();
			} else {
				graphicHolder.visible = false;
			}
		}
		
		public var villageIcon:DisplayObject;
		private function setTierIcon():void
		{
			if(villageIcon != null){
				spriteCanvas.removeChild(villageIcon);
			}			
			if ((rootObject as Village).isEnemy == false) {
				if( (rootObject as Village).levelComponent.currentLevel == 0){
					villageIcon = new Resources.UIGameFriendlyVillage1Icon();
				} else if( (rootObject as Village).levelComponent.currentLevel == 1){
					villageIcon = new Resources.UIGameFriendlyVillage2Icon();
				} else if( (rootObject as Village).levelComponent.currentLevel == 2){
					villageIcon = new Resources.UIGameFriendlyVillage3Icon();
				}
								
			} else {
				if( (rootObject as Village).levelComponent.currentLevel == 0){
					villageIcon = new Resources.UIGameEnemyVillage1Icon();
				} else if( (rootObject as Village).levelComponent.currentLevel == 1){
					villageIcon = new Resources.UIGameEnemyVillage2Icon();
				} else if( (rootObject as Village).levelComponent.currentLevel == 2){
					villageIcon = new Resources.UIGameEnemyVillage3Icon();
				}				
			}
			villageIcon.x = 10;
			villageIcon.y = 0;
			spriteCanvas.addChild(villageIcon);
		}
				
		private function setList():void
		{
			currentShownMinerals = (FlxG.state as PlayState).player.currentPlayerMinerals;
			var listData:Array = new Array();
			var totalValue:Number = 0;
			for(var i:int = 0 ; i < currentShownMinerals.length ; i++){
				listData.push(currentShownMinerals[i].fullName + " with value " + currentShownMinerals[i].rupeeValue);
				totalValue += currentShownMinerals[i].rupeeValue;
			}
			totalShownMineralValue = totalValue;
			//mineralsList.items = listData;
		}
		
		public function drawVisual():void
		{
			graphicHolder.createGraphic(spriteCanvas.width, spriteCanvas.height);
			var bitmapData:BitmapData = new BitmapData(spriteCanvas.width, spriteCanvas.height, true, 0x00FFFFFF);
			var mat:Matrix = new Matrix();
			bitmapData.draw(spriteCanvas);
			graphicHolder.pixels.copyPixels(bitmapData,new Rectangle(0,0,spriteCanvas.width, spriteCanvas.height),new Point());

			graphicHolder.createGraphic(spriteCanvas.width, spriteCanvas.height);
			var bitmapData:BitmapData = new BitmapData(spriteCanvas.width, spriteCanvas.height, true, 0x00FFFFFF);
			var mat:Matrix = new Matrix();
			bitmapData.draw(spriteCanvas);
			graphicHolder.pixels.copyPixels(bitmapData,new Rectangle(0,0,spriteCanvas.width, spriteCanvas.height),new Point());
		
		}
		
		public function sellAll(e:MouseEvent=null):Number
		{
			if(rootObject is Village){
				setList();
				var totalValue:Number = 0;
				for(var i:int = 0 ; i < currentShownMinerals.length ; i++){
					totalValue += currentShownMinerals[i].resourceValue;
				}
				(rootObject as Village).availableResources += totalValue;
				PlayerStats.currentLevelDataVo.cashBalance += Math.round(totalShownMineralValue); 
				var valueToReturn:Number = Math.round(totalShownMineralValue);
				if(totalShownMineralValue > 0){
					(rootObject as Village).levelComponent.currentExperience += 50;
				}
				(FlxG.state as PlayState).player.currentPlayerMinerals = new Vector.<Mineral>();
				return valueToReturn;
			}
			return 0;
		}
		
		
		private var targetOptions:Array = new Array();
		private var targetOptionIds:Array = new Array();
		public function buildTargetOptions():void
		{			
			targetOptionIds = new Array();
			targetOptions = new Array();
			//List item for all islands
			for (var j:int = 0 ; j < (FlxG.state as PlayState).enemyBuildings.members.length ; j++){
				var targetToAdd:Village = ((FlxG.state as PlayState).enemyBuildings.members[j] as Village);  
				(rootObject as Village).addTarget( 
					new FlxPoint( targetToAdd.x + targetToAdd.width/2,targetToAdd.y + targetToAdd.height/2),
					targetToAdd.id,
					targetToAdd.villageName
				);					
				targetOptions.push( ((FlxG.state as PlayState).enemyBuildings.members[j] as Village).villageName );
				targetOptionIds.push(j);
			};			
			
			//Specific targetting
			/*
			//only enemies b/c only friendlies even get the option to target shit.
			for(var i:int = 0 ; i < (FlxG.state as PlayState).enemyBuildings.members.length ; i++ ){
				
				
				var alreadyTargeted:Boolean = false;
				for (var j:int = 0 ; j < (rootObject as Village).buildingTargetUIIndicators.length ; j++){
					if ( (rootObject as Village).buildingTargetUIIndicators[j].id  ==  ((FlxG.state as PlayState).enemyBuildings.members[i] as Village).id){
						alreadyTargeted = true;
					}
				}
				if(alreadyTargeted == false){
					targetOptions.push( ((FlxG.state as PlayState).enemyBuildings.members[i] as Village).villageName );
					targetOptionIds.push(i);
				}
				
			}
				*/
		}
		
		public function selectSomething(e:Event):void
		{
			if( (e.currentTarget as CheckBox).selected == true){
				currentSelectedOption = (e.currentTarget as CheckBox).tag
				for ( var i:int = 0 ; i < deploymentOptions.length ; i++ ){
					if( (deploymentOptions[i] as CheckBox).tag != currentSelectedOption) {
						(deploymentOptions[i] as CheckBox).selected = false
					} 
				}
				addTargetButton.enabled = true;
			} else {
				currentSelectedOption = -1;
				addTargetButton.enabled = false;
			}
		}
		
		
		public function addTargetButtonPress(e:MouseEvent = null):void
		{
			if(currentSelectedOption != -1){
				var targetToAdd:Village = ((FlxG.state as PlayState).enemyBuildings.members[targetOptionIds[currentSelectedOption]] as Village);  
				(rootObject as Village).addTarget( 
					new FlxPoint( targetToAdd.x + targetToAdd.width/2,targetToAdd.y + targetToAdd.height/2),
					targetToAdd.id,
					targetToAdd.villageName
				);
				addTargetButton.enabled = false;
			}
		}
	}
}