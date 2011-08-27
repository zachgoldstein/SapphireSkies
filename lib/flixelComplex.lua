

groups = DAME.GetGroups()
groupCount = as3.tolua(groups.length) -1

DAME.SetFloatPrecision(3)

tab1 = "\t"
tab2 = "\t\t"
tab3 = "\t\t\t"
tab4 = "\t\t\t\t"
tab5 = "\t\t\t\t\t"

-- slow to call as3.tolua many times so do as much as can in one go and store to a lua variable instead.
exportOnlyCSV = as3.tolua(VALUE_ExportOnlyCSV)
flixelPackage = as3.tolua(VALUE_FlixelPackage)
baseClassName = as3.tolua(VALUE_BaseClass)
as3Dir = as3.tolua(VALUE_AS3Dir)
tileMapClass = as3.tolua(VALUE_TileMapClass)
GamePackage = as3.tolua(VALUE_GamePackage)
csvDir = as3.tolua(VALUE_CSVDir)
importsText = as3.tolua(VALUE_Imports)

-- This is the file for the map base class
baseFileText = "";
fileText = "";

pathLayers = {}

containsBoxData = false
containsCircleData = false
containsTextData = false
containsPaths = false

------------------------
-- TILEMAP GENERATION
------------------------
function exportMapCSV( mapLayer, layerFileName )
	-- get the raw mapdata. To change format, modify the strings passed in (rowPrefix,rowSuffix,columnPrefix,columnSeparator,columnSuffix)
	mapText = as3.tolua(DAME.ConvertMapToText(mapLayer,"","\n","",",",""))
	DAME.WriteFile(csvDir.."/"..layerFileName, mapText );
end

------------------------
-- PATH GENERATION
------------------------

-- This will store the path along with a name so when we call a get it will output the value between the first : and the last %
-- Here it will be paths[i]. When we later call %getparent% on any attached avatar it will output paths[i].
pathText = "%store:paths[%counter:paths%]%"
pathText = pathText.."%counter++:paths%" -- This line will actually incremement the counter.

lineNodeText = "new FlxPoint(%nodex%, %nodey%)"
splineNodeText = "{ pos:new FlxPoint(%nodex%, %nodey%), tan1:new FlxPoint(%tan1x%, %tan1y%), tan2:new FlxPoint(-(%tan2x%), -(%tan2y%)) }"

propertiesString = "generateProperties( %%proploop%%"
	propertiesString = propertiesString.."{ name:\"%propname%\", value:%propvaluestring% }, "
propertiesString = propertiesString.."%%proploopend%%null )"

local groupPropTypes = as3.toobject({ String="String", Int="int", Float="Number", Boolean="Boolean" })

linkAssignText = "%%if link%%"
	linkAssignText = linkAssignText.."linkedObjectDictionary[%linkid%] = "
linkAssignText = linkAssignText.."%%endiflink%%"
needCallbackText = "%%if link%%, true %%endiflink%%"


function generatePaths( )
	for i,v in ipairs(pathLayers) do	
		containsPaths = true
		fileText = fileText..tab2.."public function addPathsForLayer"..pathLayers[i][3].."(onAddCallback:Function = null):void\n"
		fileText = fileText..tab2.."{\n"
		fileText = fileText..tab3.."var pathobj:PathData;\n\n"

		linesText = pathText..tab3.."pathobj = new PathData( [ %nodelist% \n"..tab3.."], %isclosed%, false, "..pathLayers[i][3].."Group );\n"
		linesText = linesText..tab3.."paths.push(pathobj);\n"

		linesText = linesText..tab3..linkAssignText.."callbackNewData( pathobj, onAddCallback, "..pathLayers[i][3].."Group, "..propertiesString..needCallbackText.." );\n\n"
		
		fileText = fileText..as3.tolua(DAME.CreateTextForPaths(pathLayers[i][2], linesText, lineNodeText, linesText, splineNodeText, ",\n"..tab4))
		fileText = fileText..tab2.."}\n\n"
	end
end

-------------------------------------
-- SHAPE and TEXTBOX GENERATION
-------------------------------------

function generateShapes( )
	for i,v in ipairs(shapeLayers) do	
		groupname = shapeLayers[i][3].."Group"

		
		textboxText = tab3..linkAssignText.."callbackNewData(new TextData(%xpos%, %ypos%, %width%, %height%, %degrees%, \"%text%\",\"%font%\", %size%, 0x%color%, \"%align%\"), onAddCallback, "..groupname..", "..propertiesString..needCallbackText.." ) ;\n"
		
		fileText = fileText..tab2.."public function addShapesForLayer"..shapeLayers[i][3].."(onAddCallback:Function = null):void\n"
		fileText = fileText..tab2.."{\n"
		fileText = fileText..tab3.."var obj:Object;\n\n"
		
		boxText = tab3.."obj = new BoxData(%xpos%, %ypos%, %degrees%, %width%, %height%, "..groupname.." );\n"
		boxText = boxText..tab3.."shapes.push(obj);\n"
		boxText = boxText..tab3..linkAssignText.."callbackNewData( obj, onAddCallback, "..groupname..", "..propertiesString..needCallbackText.." );\n"

		circleText = tab3.."obj = new CircleData(%xpos%, %ypos%, %radius%, "..groupname.." );\n"
		circleText = circleText..tab3.."shapes.push(obj);\n"
		circleText = circleText..tab3..linkAssignText.."callbackNewData( obj, onAddCallback, "..groupname..", "..propertiesString..needCallbackText..");\n"

		shapeText = as3.tolua(DAME.CreateTextForShapes(shapeLayers[i][2], circleText, boxText, textboxText ))
		fileText = fileText..shapeText
		fileText = fileText..tab2.."}\n\n"
		
		if string.find(shapeText, "BoxData") ~= nil then
			containsBoxData = true
		end
		if string.find(shapeText, "CircleData") ~= nil then
			containsCircleData = true
		end
		if containsTextData == false and string.find(shapeText, "TextData") ~= nil then
			containsTextData = true
		end
	end
end

------------------------
-- BASE CLASS
------------------------
if exportOnlyCSV == false then	
	baseFileText = "//Code generated with DAME. http://www.dambots.com\n\n"
	baseFileText = baseFileText.."package "..GamePackage.."\n"
	baseFileText = baseFileText.."{\n"
	baseFileText = baseFileText..tab1.."import "..flixelPackage..".*;\n"
	
	baseFileText = baseFileText..tab1.."import flash.utils.Dictionary;\n"
	baseFileText = baseFileText..tab1.."public class "..baseClassName.."\n"
	baseFileText = baseFileText..tab1.."{\n"
	baseFileText = baseFileText..tab2.."// The masterLayer contains every single object in this group making it easy to empty the level.\n"
	baseFileText = baseFileText..tab2.."public var masterLayer:FlxGroup = new FlxGroup;\n\n"
	baseFileText = baseFileText..tab2.."// This group contains all the tilemaps specified to use collisions.\n"
	baseFileText = baseFileText..tab2.."public var hitTilemaps:FlxGroup = new FlxGroup;\n\n"
	baseFileText = baseFileText..tab2.."public static var boundsMinX:int;\n"
	baseFileText = baseFileText..tab2.."public static var boundsMinY:int;\n"
	baseFileText = baseFileText..tab2.."public static var boundsMaxX:int;\n"
	baseFileText = baseFileText..tab2.."public static var boundsMaxY:int;\n\n"
	baseFileText = baseFileText..tab2.."public var bgColor:uint = 0;\n"
	baseFileText = baseFileText..tab2.."public var paths:Array = [];\t// Array of PathData\n"
	baseFileText = baseFileText..tab2.."public var shapes:Array = [];\t//Array of ShapeData.\n"
	baseFileText = baseFileText..tab2.."public static var linkedObjectDictionary:Dictionary = new Dictionary;\n\n"
	baseFileText = baseFileText..tab2.."public function "..baseClassName.."() { }\n\n"
	baseFileText = baseFileText..tab2.."// Expects callback function to be callback(newobj:Object,layer:FlxGroup,level:BaseLevel,properties:Array)\n"
	baseFileText = baseFileText..tab2.."public function createObjects(onAddCallback:Function = null):void { }\n\n"
	
	baseFileText = baseFileText..tab2.."public function addTilemap( mapClass:Class, imageClass:Class, x:Number, y:Number, tileWidth:uint, tileHeight:uint, scrollX:Number, scrollY:Number, hits:Boolean, collideIdx:uint, drawIdx:uint, properties:Array, onAddCallback:Function = null ):"..tileMapClass.."\n"
	baseFileText = baseFileText..tab2.."{\n"
	baseFileText = baseFileText..tab3.."var map:"..tileMapClass.." = new "..tileMapClass..";\n"
	baseFileText = baseFileText..tab3.."map.collideIndex = collideIdx;\n"
	baseFileText = baseFileText..tab3.."map.drawIndex = drawIdx;\n"
	baseFileText = baseFileText..tab3.."map.loadMap( new mapClass, imageClass, tileWidth, tileHeight );\n"
	baseFileText = baseFileText..tab3.."map.x = x;\n"
	baseFileText = baseFileText..tab3.."map.y = y;\n"
	baseFileText = baseFileText..tab3.."map.scrollFactor.x = scrollX;\n"
	baseFileText = baseFileText..tab3.."map.scrollFactor.y = scrollY;\n"
	baseFileText = baseFileText..tab3.."if ( hits )\n"
	baseFileText = baseFileText..tab4.."hitTilemaps.add(map);\n"
	baseFileText = baseFileText..tab3.."if(onAddCallback != null)\n"
	baseFileText = baseFileText..tab4.."onAddCallback(map, null, this, properties);\n"
	baseFileText = baseFileText..tab3.."return map;\n"
	baseFileText = baseFileText..tab2.."}\n\n"
	
	baseFileText = baseFileText..tab2.."public function addSpriteToLayer(passedObj:FlxObject, type:Class, layer:FlxGroup, x:Number, y:Number, angle:Number, flipped:Boolean = false, scaleX:Number = 1, scaleY:Number = 1, properties:Array = null, onAddCallback:Function = null):FlxObject\n"
	baseFileText = baseFileText..tab2.."{\n"
	baseFileText = baseFileText..tab3.."if( passedObj == null )\n"
	baseFileText = baseFileText..tab4.."passedObj = new type(x, y);\n"
	baseFileText = baseFileText..tab3.."if(passedObj is FlxSprite){\n"
	baseFileText = baseFileText..tab4.."var obj:FlxSprite = passedObj as FlxSprite;\n"
	baseFileText = baseFileText..tab4.."obj.x += obj.offset.x;\n"
	baseFileText = baseFileText..tab4.."obj.y += obj.offset.y;\n"
	baseFileText = baseFileText..tab4.."obj.angle = angle;\n"
	baseFileText = baseFileText..tab4.."// Only override the facing value if the class didn't change it from the default.\n"					
	baseFileText = baseFileText..tab4.."if( obj.facing == FlxSprite.RIGHT )\n"
	baseFileText = baseFileText..tab5.."obj.facing = flipped ? FlxSprite.LEFT : FlxSprite.RIGHT;\n"
	baseFileText = baseFileText..tab4.."if ( scaleX != 1 || scaleY != 1 )\n"
	baseFileText = baseFileText..tab4.."{\n"
	baseFileText = baseFileText..tab5.."obj.scale.x = scaleX;\n"
	baseFileText = baseFileText..tab5.."obj.scale.y = scaleY;\n"
	baseFileText = baseFileText..tab5.."obj.width *= scaleX;\n"
	baseFileText = baseFileText..tab5.."obj.height *= scaleY;\n"
	baseFileText = baseFileText..tab5.."// Adjust the offset, in case it was already set.\n"
	baseFileText = baseFileText..tab5.."var newFrameWidth:Number = obj.frameWidth * scaleX;\n"
	baseFileText = baseFileText..tab5.."var newFrameHeight:Number = obj.frameHeight * scaleY;\n"
	baseFileText = baseFileText..tab5.."var hullOffsetX:Number = obj.offset.x * scaleX;\n"
	baseFileText = baseFileText..tab5.."var hullOffsetY:Number = obj.offset.y * scaleY;\n"
	baseFileText = baseFileText..tab5.."obj.offset.x -= (newFrameWidth- obj.frameWidth) / 2;\n"
	baseFileText = baseFileText..tab5.."obj.offset.y -= (newFrameHeight - obj.frameHeight) / 2;\n"
	baseFileText = baseFileText..tab5.."// Refresh the collision hulls. If your object moves and you have an offset you should override refreshHulls so that hullOffset is always added.\n"
	baseFileText = baseFileText..tab5.."obj.colHullX.x = obj.colHullY.x = obj.x + hullOffsetX;\n"
	baseFileText = baseFileText..tab5.."obj.colHullX.y = obj.colHullY.y = obj.y + hullOffsetY;\n"
	baseFileText = baseFileText..tab5.."obj.colHullX.width = obj.colHullY.width = obj.width;\n"
	baseFileText = baseFileText..tab5.."obj.colHullX.height = obj.colHullY.height = obj.height;\n"
	baseFileText = baseFileText..tab4.."}\n"
	baseFileText = baseFileText..tab4.."layer.add(obj,true);\n"
	baseFileText = baseFileText..tab4.."callbackNewData(obj, onAddCallback, layer, properties, false);\n"
	baseFileText = baseFileText..tab4.."return obj;\n"
	baseFileText = baseFileText..tab3.."} else if(passedObj is FlxGroup){\n"
	baseFileText = baseFileText..tab4.."layer.add(passedObj,true);\n"
	baseFileText = baseFileText..tab4.."callbackNewData(passedObj, onAddCallback, layer, properties, false);\n"
	baseFileText = baseFileText..tab4.."return passedObj;\n"
	baseFileText = baseFileText..tab3.."}\n"
	baseFileText = baseFileText..tab3.."return null\n"
	baseFileText = baseFileText..tab2.."}\n"	

	baseFileText = baseFileText..tab2.."public function addTextToLayer(textdata:TextData, layer:FlxGroup, embed:Boolean, properties:Array, onAddCallback:Function ):FlxText\n"
	baseFileText = baseFileText..tab2.."{\n"
	baseFileText = baseFileText..tab3.."var textobj:FlxText = new FlxText(textdata.x, textdata.y, textdata.width, textdata.text, embed);\n"
	baseFileText = baseFileText..tab3.."textobj.setFormat(textdata.fontName, textdata.size, textdata.color, textdata.alignment);\n"
	baseFileText = baseFileText..tab3.."addSpriteToLayer(textobj, FlxText, layer , 0, 0, textdata.angle, false, 1, 1, properties, onAddCallback );\n"
	baseFileText = baseFileText..tab3.."textobj.height = textdata.height;\n"
	baseFileText = baseFileText..tab3.."textobj.origin.x = textobj.width * 0.5;\n"
	baseFileText = baseFileText..tab3.."textobj.origin.y = textobj.height * 0.5;\n"
	baseFileText = baseFileText..tab3.."return textobj;\n"
	baseFileText = baseFileText..tab2.."}\n\n"
	
	baseFileText = baseFileText..tab2.."protected function callbackNewData(data:Object, onAddCallback:Function, layer:FlxGroup, properties:Array, needsReturnData:Boolean = false):Object\n"
	baseFileText = baseFileText..tab2.."{\n"
	baseFileText = baseFileText..tab3.."if(onAddCallback != null)\n"
	baseFileText = baseFileText..tab3.."{\n"
	baseFileText = baseFileText..tab4.."var newData:Object = onAddCallback(data, layer, this, properties);\n"
	baseFileText = baseFileText..tab4.."if( newData != null )\n"
	baseFileText = baseFileText..tab5.."data = newData;\n"
	baseFileText = baseFileText..tab4.."else if ( needsReturnData )\n"
	baseFileText = baseFileText..tab5.."trace(\"Error: callback needs to return either the object passed in or a new object to set up links correctly.\");\n"
	baseFileText = baseFileText..tab3.."}\n"
	baseFileText = baseFileText..tab3.."return data;\n"
	baseFileText = baseFileText..tab2.."}\n\n"
	
	baseFileText = baseFileText..tab2.."protected function generateProperties( ... arguments ):Array\n"
	baseFileText = baseFileText..tab2.."{\n"
	baseFileText = baseFileText..tab3.."var properties:Array = [];\n"
	baseFileText = baseFileText..tab3.."if ( arguments.length )\n"
	baseFileText = baseFileText..tab3.."{\n"
	baseFileText = baseFileText..tab4.."var i:uint = arguments.length - 1;\n"
	baseFileText = baseFileText..tab4.."while(i--)\n"
	baseFileText = baseFileText..tab4.."{\n"
	baseFileText = baseFileText..tab5.."properties.push( arguments[i] );\n"
	baseFileText = baseFileText..tab4.."}\n"
	baseFileText = baseFileText..tab3.."}\n"
	baseFileText = baseFileText..tab3.."return properties;\n"
	baseFileText = baseFileText..tab2.."}\n\n"
	
	baseFileText = baseFileText..tab2.."public function createLink( objectFrom:Object, target:Object, onAddCallback:Function, properties:Array ):void\n"
	baseFileText = baseFileText..tab2.."{\n"
	baseFileText = baseFileText..tab3.."var link:ObjectLink = new ObjectLink( objectFrom, target );\n"
	baseFileText = baseFileText..tab3.."callbackNewData(link, onAddCallback, null, properties);\n"
	baseFileText = baseFileText..tab2.."}\n\n"
	
	baseFileText = baseFileText..tab1.."}\n"	-- end class
	baseFileText = baseFileText.."}\n"		-- end package
	DAME.WriteFile(as3Dir.."/"..baseClassName..".as", baseFileText )
end

------------------------
-- GROUP CLASSES
------------------------
for groupIndex = 0,groupCount do

	maps = {}
	spriteLayers = {}
	shapeLayers = {}
	pathLayers = {}
	imageLayers = {}
	masterLayerAddText = ""
	stageAddText = ""
	
	group = groups[groupIndex]
	groupName = as3.tolua(group.name)
	groupName = string.gsub(groupName, " ", "_")
	
	DAME.ResetCounters()
	
	
	layerCount = as3.tolua(group.children.length) - 1
	
	-- This is the file for the map group class.
	fileText = "//Code generated with DAME. http://www.dambots.com\n\n"
	fileText = fileText.."package "..GamePackage.."\n"
	fileText = fileText.."{\n"
	fileText = fileText..tab1.."import "..flixelPackage..".*;\n"
	fileText = fileText..tab1.."import zachg.*;\n"
	fileText = fileText..tab1.."import zachg.components.*;\n"
	fileText = fileText..tab1.."import zachg.gameObjects.*;\n"
	
	if # importsText > 0 then
		fileText = fileText..tab1.."// Custom imports:\n"..importsText.."\n"
	end
	fileText = fileText..tab1.."public class Level_"..groupName.." extends "..baseClassName.."\n"
	fileText = fileText..tab1.."{\n"
	fileText = fileText..tab2.."//Embedded media...\n"
	
	-- Go through each layer and store some tables for the different layer types.
	for layerIndex = 0,layerCount do
		layer = group.children[layerIndex]
		isMap = as3.tolua(layer.map)~=nil
		layerName = as3.tolua(layer.name)
		layerName = string.gsub(layerName, " ", "_")
		if isMap == true then
			mapFileName = "mapCSV_"..groupName.."_"..layerName..".csv"
			-- Generate the map file.
			exportMapCSV( layer, mapFileName )
			
			-- This needs to be done here so it maintains the layer visibility ordering.
			if exportOnlyCSV == false then
				table.insert(maps,{layer,layerName})
				-- For maps just generate the Embeds needed at the top of the class.
				fileText = fileText..tab2.."[Embed(source=\""..as3.tolua(DAME.GetRelativePath(as3Dir, csvDir.."/"..mapFileName)).."\", mimeType=\"application/octet-stream\")] public var CSV_"..layerName..":Class;\n"
				fileText = fileText..tab2.."[Embed(source=\""..as3.tolua(DAME.GetRelativePath(as3Dir, layer.imageFile)).."\")] public var Img_"..layerName..":Class;\n"
				masterLayerAddText = masterLayerAddText..tab3.."masterLayer.add(layer"..layerName..");\n"
			end

		elseif exportOnlyCSV == false then
			if as3.tolua(layer.IsSpriteLayer()) == true then
				table.insert( spriteLayers,{groupName,layer,layerName})
				masterLayerAddText = masterLayerAddText..tab3.."masterLayer.add("..layerName.."Group);\n"
				masterLayerAddText = masterLayerAddText..tab3..layerName.."Group.scrollFactor.x = "..string.format("%.6f",as3.tolua(layer.xScroll))..";\n"
				masterLayerAddText = masterLayerAddText..tab3..layerName.."Group.scrollFactor.y = "..string.format("%.6f",as3.tolua(layer.yScroll))..";\n"
				stageAddText = stageAddText..tab3.."addSpritesForLayer"..layerName.."(onAddCallback);\n"
			elseif as3.tolua(layer.IsShapeLayer()) == true then
				table.insert(shapeLayers,{groupName,layer,layerName})
				masterLayerAddText = masterLayerAddText..tab3.."masterLayer.add("..layerName.."Group);\n"
				masterLayerAddText = masterLayerAddText..tab3..layerName.."Group.scrollFactor.x = "..string.format("%.6f",as3.tolua(layer.xScroll))..";\n"
				masterLayerAddText = masterLayerAddText..tab3..layerName.."Group.scrollFactor.y = "..string.format("%.6f",as3.tolua(layer.yScroll))..";\n"
				
			elseif as3.tolua(layer.IsPathLayer()) == true then
				table.insert(pathLayers,{groupName,layer,layerName})
				masterLayerAddText = masterLayerAddText..tab3.."masterLayer.add("..layerName.."Group);\n"
				masterLayerAddText = masterLayerAddText..tab3..layerName.."Group.scrollFactor.x = "..string.format("%.6f",as3.tolua(layer.xScroll))..";\n"
				masterLayerAddText = masterLayerAddText..tab3..layerName.."Group.scrollFactor.y = "..string.format("%.6f",as3.tolua(layer.yScroll))..";\n"
			elseif as3.tolua(layer.IsImageLayer()) == true then
				table.insert(imageLayers,{groupName,layer,layerName})
				masterLayerAddText = masterLayerAddText..tab3.."masterLayer.add("..layerName..");\n"
			end
		end
	end

	-- Generate the actual text for the derived class file.
	
	if exportOnlyCSV == false then

		------------------------------------
		-- VARIABLE DECLARATIONS
		-------------------------------------
		fileText = fileText.."\n"
		
		if # maps > 0 then
			fileText = fileText..tab2.."//Tilemaps\n"
			for i,v in ipairs(maps) do
				fileText = fileText..tab2.."public var layer"..maps[i][2]..":"..tileMapClass..";\n"
			end
			fileText = fileText.."\n"
		end
		
		if # spriteLayers > 0 then
			fileText = fileText..tab2.."//Sprites\n"
			for i,v in ipairs(spriteLayers) do
				fileText = fileText..tab2.."public var "..spriteLayers[i][3].."Group:FlxGroup = new FlxGroup;\n"
			end
			fileText = fileText.."\n"
		end
		
		if # shapeLayers > 0 then
			fileText = fileText..tab2.."//Shapes\n"
			for i,v in ipairs(shapeLayers) do
				fileText = fileText..tab2.."public var "..shapeLayers[i][3].."Group:FlxGroup = new FlxGroup;\n"
			end
			fileText = fileText.."\n"
		end
		
		if # pathLayers > 0 then
			fileText = fileText..tab2.."//Paths\n"
			for i,v in ipairs(pathLayers) do
				fileText = fileText..tab2.."public var "..pathLayers[i][3].."Group:FlxGroup = new FlxGroup;\n"
			end
			fileText = fileText.."\n"
		end

		if # imageLayers > 0 then
			fileText = fileText..tab2.."//Images\n"
			for i,v in ipairs(imageLayers) do
				fileText = fileText..tab2.."public var "..imageLayers[i][3]..":ImageLayer;\n"
			end
			fileText = fileText.."\n"
		end
				
		groupPropertiesString = "%%proploop%%"..tab2.."public var %propnamefriendly%:%proptype% = %propvaluestring%;\n%%proploopend%%"
		
		fileText = fileText..tab2.."//Properties\n"
		fileText = fileText..as3.tolua(DAME.GetTextForProperties( groupPropertiesString, group.properties, groupPropTypes )).."\n"
		
		fileText = fileText.."\n"
		fileText = fileText..tab2.."public function Level_"..groupName.."(addToStage:Boolean = true, onAddCallback:Function = null)\n"
		fileText = fileText..tab2.."{\n"
		fileText = fileText..tab3.."// Generate maps.\n"
		
		fileText = fileText..tab3.."var properties:Array = [];\n\n"
		
		minx = 9999999
		miny = 9999999
		maxx = -9999999
		maxy = -9999999
		-- Create the tilemaps.
		for i,v in ipairs(maps) do
			layerName = maps[i][2]
			layer = maps[i][1]
			
			x = as3.tolua(layer.map.x)
			y = as3.tolua(layer.map.y)
			width = as3.tolua(layer.map.width)
			height = as3.tolua(layer.map.height)
			xscroll = as3.tolua(layer.xScroll)
			yscroll = as3.tolua(layer.yScroll)
			hasHitsString = ""
			if as3.tolua(layer.HasHits) == true then
				hasHitsString = "true"
			else
				hasHitsString = "false"
			end
			
			fileText = fileText..tab3.."properties = "..as3.tolua(DAME.GetTextForProperties( propertiesString, layer.properties ))..";\n"
			fileText = fileText..tab3.."layer"..layerName.." = addTilemap( CSV_"..layerName..", Img_"..layerName..", "..string.format("%.3f",x)..", "..string.format("%.3f",y)..", "..as3.tolua(layer.map.tileWidth)..", "..as3.tolua(layer.map.tileHeight)..", "..string.format("%.3f",xscroll)..", "..string.format("%.3f",yscroll)..", "..hasHitsString..", "..as3.tolua(layer.map.collideIndex)..", "..as3.tolua(layer.map.drawIndex)..", properties, onAddCallback );\n"

			-- Only set the bounds based on maps whose scroll factor is the same as the player's.
			if xscroll == 1 and yscroll == 1 then
				if x < minx then minx = x end
				if y < miny then miny = y end
				if x + width > maxx then maxx = x + width end
				if y + height > maxy then maxy = y + height end
			end
			
		end
		
		------------------
		-- IMAGES.
		------------------
		
		fileText = fileText.."\n"..tab3.."//Create image layer objects\n"
		for i,v in ipairs(imageLayers) do
			fileText = fileText..tab3..imageLayers[i][3].."= new ImageLayer( "..as3.tolua(DAME.CreateTextForImageLayer(imageLayers[i][2],"%xpos%, %ypos%, %scrollx%, %scrolly%", null))..",'"..imageLayers[i][3].."');\n"
		end
				
		------------------
		-- MASTER GROUP.
		------------------
		
		fileText = fileText.."\n"..tab3.."//Add layers to the master group in correct order.\n"
		fileText = fileText..masterLayerAddText.."\n";
		
		fileText = fileText..tab3.."if ( addToStage )\n"
		fileText = fileText..tab4.."createObjects(onAddCallback);\n\n"
		
		fileText = fileText..tab3.."boundsMinX = "..minx..";\n"
		fileText = fileText..tab3.."boundsMinY = "..miny..";\n"
		fileText = fileText..tab3.."boundsMaxX = "..maxx..";\n"
		fileText = fileText..tab3.."boundsMaxY = "..maxy..";\n"
		
		fileText = fileText..tab3.."bgColor = "..as3.tolua(DAME.GetBackgroundColor())..";\n"
		
		fileText = fileText..tab2.."}\n\n"	-- end constructor
		
		---------------
		-- OBJECTS
		---------------
		-- One function for each layer.
		
		fileText = fileText..tab2.."override public function createObjects(onAddCallback:Function = null):void\n"
		fileText = fileText..tab2.."{\n"
		-- Must add the paths before the sprites as the sprites index into the paths array.
		for i,v in ipairs(pathLayers) do
			fileText = fileText..tab3.."addPathsForLayer"..pathLayers[i][3].."(onAddCallback);\n"
		end
		for i,v in ipairs(shapeLayers) do
			fileText = fileText..tab3.."addShapesForLayer"..shapeLayers[i][3].."(onAddCallback);\n"
		end
		fileText = fileText..stageAddText
		fileText = fileText..tab3.."generateObjectLinks(onAddCallback);\n"
		fileText = fileText..tab3.."FlxG.state.add(masterLayer);\n"
		fileText = fileText..tab2.."}\n\n"
		
		-- Create the paths first so that sprites can reference them if any are attached.
		
		generatePaths()
		generateShapes()
		
		-- create the sprites.
		
		for i,v in ipairs(spriteLayers) do
			
			creationText = tab3..linkAssignText
			creationText = creationText.."%%if parent%%"
				creationText = creationText.."%getparent%.childSprite = "
			creationText = creationText.."%%endifparent%%"
			creationText = creationText.."addSpriteToLayer(%constructor:null%, %class%, "..spriteLayers[i][3].."Group , %xpos%, %ypos%, %degrees%, %flipped%, %scalex%, %scaley%, "..propertiesString..", onAddCallback );//%name%\n" 
			creationText = creationText.."%%if parent%%"
				creationText = creationText..tab3.."%getparent%.childAttachNode = %attachedsegment%;\n"
				creationText = creationText..tab3.."%getparent%.childAttachT = %attachedsegment_t%;\n"
			creationText = creationText.."%%endifparent%%"
			
			fileText = fileText..tab2.."public function addSpritesForLayer"..spriteLayers[i][3].."(onAddCallback:Function = null):void\n"
			fileText = fileText..tab2.."{\n"
		
			fileText = fileText..as3.tolua(DAME.CreateTextForSprites(spriteLayers[i][2],creationText,"Avatar"))
			fileText = fileText..tab2.."}\n\n"
		end
		
		-- Create the links between objects.
		
		fileText = fileText..tab2.."public function generateObjectLinks(onAddCallback:Function = null):void\n"
		fileText = fileText..tab2.."{\n"
		linkText = tab3.."createLink(linkedObjectDictionary[%linkfromid%], linkedObjectDictionary[%linktoid%], onAddCallback, "..propertiesString.." );\n"
		fileText = fileText..as3.tolua(DAME.GetTextForLinks(linkText,group))
		fileText = fileText..tab2.."}\n"
		
		fileText = fileText.."\n"
		fileText = fileText..tab1.."}\n"	-- end class
		fileText = fileText.."}\n"		-- end package
		
		
			
		-- Save the file!
		
		DAME.WriteFile(as3Dir.."/Level_"..groupName..".as", fileText )
		
	end
end

-- Create any extra required classes.
-- must be done last after the parser has gone through.

if exportOnlyCSV == false then

	--if containsTextData == true then
		textfile = "package "..GamePackage.."\n"
		textfile = textfile.."{\n"
		textfile = textfile..tab1.."public class TextData\n"
		textfile = textfile..tab1.."{\n"
		textfile = textfile..tab2.."public var x:Number;\n"
		textfile = textfile..tab2.."public var y:Number;\n"
		textfile = textfile..tab2.."public var width:uint;\n"
		textfile = textfile..tab2.."public var height:uint;\n"
		textfile = textfile..tab2.."public var angle:Number;\n"
		textfile = textfile..tab2.."public var text:String;\n"
		textfile = textfile..tab2.."public var fontName:String;\n"
		textfile = textfile..tab2.."public var size:uint;\n"
		textfile = textfile..tab2.."public var color:uint;\n"
		textfile = textfile..tab2.."public var alignment:String;\n\n"
		textfile = textfile..tab2.."public function TextData( X:Number, Y:Number, Width:uint, Height:uint, Angle:Number, Text:String, FontName:String, Size:uint, Color:uint, Alignment:String )\n"
		textfile = textfile..tab2.."{\n"
		textfile = textfile..tab3.."x = X;\n"
		textfile = textfile..tab3.."y = Y;\n"
		textfile = textfile..tab3.."width = Width;\n"
		textfile = textfile..tab3.."height = Height;\n"
		textfile = textfile..tab3.."angle = Angle;\n"
		textfile = textfile..tab3.."text = Text;\n"
		textfile = textfile..tab3.."fontName = FontName;\n"
		textfile = textfile..tab3.."size = Size;\n"
		textfile = textfile..tab3.."color = Color;\n"
		textfile = textfile..tab3.."alignment = Alignment;\n"
		textfile = textfile..tab2.."}\n"
		textfile = textfile..tab1.."}\n"
		textfile = textfile.."}\n"
		
		DAME.WriteFile(as3Dir.."/TextData.as", textfile )
	--end
	
	if containsPaths == true then
		textfile = "package "..GamePackage.."\n"
		textfile = textfile.."{\n"
		textfile = textfile..tab1.."import "..flixelPackage..".FlxGroup;\n"
		textfile = textfile..tab1.."import "..flixelPackage..".FlxSprite;\n\n"
		textfile = textfile..tab1.."public class PathData\n"
		textfile = textfile..tab1.."{\n"
		textfile = textfile..tab2.."public var nodes:Array;\n"
		textfile = textfile..tab2.."public var isClosed:Boolean;\n"
		textfile = textfile..tab2.."public var isSpline:Boolean;\n"
		textfile = textfile..tab2.."public var layer:FlxGroup;\n\n"
		textfile = textfile..tab2.."// These values are only set if there is an attachment.\n"
		textfile = textfile..tab2.."public var childSprite:FlxSprite = null;\n"
		textfile = textfile..tab2.."public var childAttachNode:int = 0;\n"
		textfile = textfile..tab2.."public var childAttachT:Number = 0;\t// position of child between attachNode and next node.(0-1)\n\n"
		textfile = textfile..tab2.."public function PathData( Nodes:Array, Closed:Boolean, Spline:Boolean, Layer:FlxGroup )\n"
		textfile = textfile..tab2.."{\n"
		textfile = textfile..tab3.."nodes = Nodes;\n"
		textfile = textfile..tab3.."isClosed = Closed;\n"
		textfile = textfile..tab3.."isSpline = Spline;\n"
		textfile = textfile..tab3.."layer = Layer;\n"
		textfile = textfile..tab2.."}\n"
		textfile = textfile..tab1.."}\n"
		textfile = textfile.."}\n"
		
		DAME.WriteFile(as3Dir.."/PathData.as", textfile )
		
	end
	
	if containsBoxData == true or containsCircleData == true then
		textfile = "package "..GamePackage.."\n"
		textfile = textfile.."{\n"
		textfile = textfile..tab1.."import "..flixelPackage..".FlxGroup;\n\n"
		textfile = textfile..tab1.."public class ShapeData\n"
		textfile = textfile..tab1.."{\n"
		textfile = textfile..tab2.."public var x:Number;\n"
		textfile = textfile..tab2.."public var y:Number;\n"
		textfile = textfile..tab2.."public var group:FlxGroup;\n\n"
		textfile = textfile..tab2.."public function ShapeData(X:Number, Y:Number, Group:FlxGroup )\n"
		textfile = textfile..tab2.."{\n"
		textfile = textfile..tab3.."x = X;\n"
		textfile = textfile..tab3.."y = Y;\n"
		textfile = textfile..tab3.."group = Group;\n"
		textfile = textfile..tab2.."}\n"
		textfile = textfile..tab1.."}\n"
		textfile = textfile.."}\n"
		
		DAME.WriteFile(as3Dir.."/ShapeData.as", textfile )
	end
	
	if containsBoxData == true then
		textfile = "package "..GamePackage.."\n"
		textfile = textfile.."{\n"
		textfile = textfile..tab1.."import "..flixelPackage..".FlxGroup;\n\n"
		textfile = textfile..tab1.."public class BoxData extends ShapeData\n"
		textfile = textfile..tab1.."{\n"
		textfile = textfile..tab2.."public var angle:Number;\n"
		textfile = textfile..tab2.."public var width:uint;\n"
		textfile = textfile..tab2.."public var height:uint;\n\n"
		textfile = textfile..tab2.."public function BoxData( X:Number, Y:Number, Angle:Number, Width:uint, Height:uint, Group:FlxGroup ) \n"
		textfile = textfile..tab2.."{\n"
		textfile = textfile..tab3.."super(X, Y, Group);\n"
		textfile = textfile..tab3.."angle = Angle;\n"
		textfile = textfile..tab3.."width = Width;\n"
		textfile = textfile..tab3.."height = Height;\n"
		textfile = textfile..tab2.."}\n"
		textfile = textfile..tab1.."}\n"
		textfile = textfile.."}\n"
		
		DAME.WriteFile(as3Dir.."/BoxData.as", textfile )
	end
	
	if containsCircleData == true then
		textfile = "package "..GamePackage.."\n"
		textfile = textfile.."{\n"
		textfile = textfile..tab1.."import "..flixelPackage..".FlxGroup;\n\n"
		textfile = textfile..tab1.."public class CircleData extends ShapeData\n"
		textfile = textfile..tab1.."{\n"
		textfile = textfile..tab2.."public var radius:Number;\n\n"
		textfile = textfile..tab2.."public function CircleData( X:Number, Y:Number, Radius:Number, Group:FlxGroup )\n"
		textfile = textfile..tab2.."{\n"
		textfile = textfile..tab3.."super(X, Y, Group);\n"
		textfile = textfile..tab3.."radius = Radius;\n"
		textfile = textfile..tab2.."}\n"
		textfile = textfile..tab1.."}\n"
		textfile = textfile.."}\n"
		
		DAME.WriteFile(as3Dir.."/CircleData.as", textfile )
	end
	
	textfile = "package "..GamePackage.."\n"
	textfile = textfile.."{\n"
	textfile = textfile..tab1.."public class ObjectLink\n"
	textfile = textfile..tab1.."{\n"
	textfile = textfile..tab2.."public var fromObject:Object;\n"
	textfile = textfile..tab2.."public var toObject:Object;\n"
	textfile = textfile..tab2.."public function ObjectLink(from:Object, to:Object)\n"
	textfile = textfile..tab2.."{\n"
	textfile = textfile..tab3.."fromObject = from;\n"
	textfile = textfile..tab3.."toObject = to;\n"
	textfile = textfile..tab2.."}\n"
	textfile = textfile..tab1.."}\n"
	textfile = textfile.."}\n"
	DAME.WriteFile(as3Dir.."/ObjectLink.as", textfile )
end

	textfile = "package "..GamePackage.."\n"
	textfile = textfile.."{\n"
	textfile = textfile..tab1.."import org.flixel.FlxPoint;\n"
	textfile = textfile..tab1.."import org.flixel.FlxSprite;\n"

	textfile = textfile..tab1.."/**\n"
	textfile = textfile..tab1.." * NOTE that the name of the image layer within the DAME editor has to correspond to the\n"
	textfile = textfile..tab1.." * embed Class name.\n"
	textfile = textfile..tab1.." *  \n"
	textfile = textfile..tab1.." * @author zachgoldstein\n"
	textfile = textfile..tab1.." *  \n"
	textfile = textfile..tab1.." */ \n"
	
	textfile = textfile..tab1.."public class ImageLayer extends FlxSprite"
	textfile = textfile..tab1.."{\n"
	textfile = textfile..tab2.."public function ImageLayer(X:Number,Y:Number,scrollX:Number,scrollY:Number, embedName:String)\n"
	textfile = textfile..tab2.."{\n"
	textfile = textfile..tab3.."super(X,Y);\n"
	textfile = textfile..tab3.."x = X;\n"
	textfile = textfile..tab3.."y = Y;\n"
	textfile = textfile..tab3.."if(Resources[embedName] != null){;\n"
	textfile = textfile..tab4.."loadGraphic(Resources[embedName],false,false);\n"			
	textfile = textfile..tab3.."}\n"
	textfile = textfile..tab3.."scrollFactor = new FlxPoint(scrollX,scrollY);\n"		
	textfile = textfile..tab2.."}\n"
	textfile = textfile..tab1.."}\n"
	textfile = textfile.."}\n"
	DAME.WriteFile(as3Dir.."/ImageLayer.as", textfile )

return 1
