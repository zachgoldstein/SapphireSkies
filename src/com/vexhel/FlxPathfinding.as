package com.vexhel
{
	import com.PlayState;
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.generalrelativity.thread.GreenThread;
	import org.generalrelativity.thread.IRunnable;
	import org.generalrelativity.thread.process.AbstractProcess;
	
	import zachg.util.PathFindingProcess;

	/**
	 * ...
	 * @author Vexhel
	 * Heavily modified by Zach Goldstein (added distanceToCollidableTiles,tileSimplificationAmount);
	 */
	public class FlxPathfinding {
		private var _map:FlxTilemap;
		private var _nodes:Dictionary = new Dictionary();
		private var _open:Array;
		private var _closed:Array;
		
		//we use int (instead of Number) to get better performance
		private const COST_ORTHOGONAL:int = 10;
		private const COST_DIAGONAL:int = 14
			
		private var simplifiedMapWith:int
		private var simplifiedMapHeight:int 
		
		public var allowDiagonal:Boolean = true;
		public function FlxPathfinding(tilemap:FlxTilemap) {
			setMap(tilemap)
		}
		
		/**
		 * When we've got a large tilemap, we need to simplify the map
		 * and subdivide it into larger chunks to make it faster to compute the path.
		 * each unit = tiles squared in new size. so 3 = 9 total original tiles.
		 */
		public var tileSimplificationAmount:int = 5;
		
		/**
		 * used to make an unwalkable zone around areas that're unwalkable. 
		 */
		public var distanceToCollidableTiles:Number = 1;
		
		/**
		 * Setting to true creates an overlay of what's walkable and what's not for the pathfinding. 
		 * Useful for visually checking if the pathfinding is setup correctly with your tilemap. 
		 */
		public var showDebugTiles:Boolean = false;
		
		public function setMap(tilemap:FlxTilemap):void {
			_map = tilemap; 
			//initialize the node structure
			_nodes = new Dictionary();
			
			simplifiedMapWith = int(_map.widthInTiles/tileSimplificationAmount);
			simplifiedMapHeight = int(_map.heightInTiles/tileSimplificationAmount);
			
			for (var i:int = 0; i < tilemap.totalTiles; i++) {
				var col:int = i - (Math.floor(i/tilemap.widthInTiles)*tilemap.widthInTiles);
				var row:int = Math.floor(i/tilemap.widthInTiles);
				var scaledDownCol:int = int(col/tileSimplificationAmount);
				var scaledDownRow:int = int(row/tileSimplificationAmount);
				
				if(col%tileSimplificationAmount != 0 || row%tileSimplificationAmount != 0){//tileSimplificationAmount){
					continue
				}
				
				
				//tile is walkable if all the tiles in the zone are walkable
				//var isTileWalkable:Boolean = (_map.getTileByIndex(i) < _map.collideIndex);
				var isTileWalkable:Boolean = true;
				//var isTileWalkable:Boolean = _map.getTileByIndex(i) < _map.collideIndex;
				
				for ( var j:int = 0 ; j < (tileSimplificationAmount*tileSimplificationAmount) ; j++ ){
					if(isTileWalkable == true){
						var rowSimplification:int = row + Math.floor(j/(tileSimplificationAmount));
						var colSimplification:int = col + j%tileSimplificationAmount;
						var indexToCheck:int = int(colSimplification + (rowSimplification * (_map.widthInTiles)));
						if( _map.getTileByIndex(indexToCheck) < _map.collideIndex){
						} else {
							isTileWalkable = false;
						}
					}
				
					if(isTileWalkable == true){
						walkableZoneLabel:
						//cols
						for ( var k:int = 0; k < (1+distanceToCollidableTiles*2); k++){
							var walkZoneColToTest:Number = colSimplification - distanceToCollidableTiles + k;
							//rows
							for ( var l:int = 0; l < (1+distanceToCollidableTiles*2); l++){
								var walkZoneRowToTest = rowSimplification - distanceToCollidableTiles + l;
								var indexToCheck:int = int(walkZoneColToTest + (walkZoneRowToTest * (_map.widthInTiles)));								
								//var indexToCheck:int = i + (k-j) + (l*_map.widthInTiles) - (j*_map.widthInTiles);
								if(indexToCheck > 0 && indexToCheck < tilemap.totalTiles && walkZoneRowToTest > 0 && walkZoneColToTest > 0){
									if( (_map.getTileByIndex(indexToCheck) < _map.collideIndex) ){
										//trace("shite");
									} else {
										isTileWalkable = false;
										break walkableZoneLabel;
									}
								}
							}
						}
					}
				}
				
				if(showDebugTiles == true){
					var dummyTile:FlxSprite = new FlxSprite(int(i % (_map.widthInTiles))*16,
						int(i / (_map.widthInTiles))*16);
					if(isTileWalkable == true){
						dummyTile.createGraphic(16*tileSimplificationAmount,16*tileSimplificationAmount,0xffffffff);
					} else {
						dummyTile.createGraphic(16*tileSimplificationAmount,16*tileSimplificationAmount,0xff000000);					
					}
					
					dummyTile.alpha = .5;
					dummyTile.solid = false;
	
					(FlxG.state as PlayState).effectDisplays.add(dummyTile);
				}

				_nodes[scaledDownCol+","+scaledDownRow] = new FlxPathfindingNode(scaledDownCol, scaledDownRow, isTileWalkable);
			}
		}

		//given a start and an end points, returns an array of points representing the shortest path (if any) between them
		public function findPath(startPoint:Point, endPoint:Point):Array {
			_open = [];
			_closed = [];
			for each (var value:FlxPathfindingNode in _nodes) {
				value.parent = null;				
			}			
			var start:FlxPathfindingNode = getNodeAt(startPoint.x, startPoint.y);
			var end:FlxPathfindingNode = getNodeAt(endPoint.x, endPoint.y);
			_open.push(start);
			start.g = 0;
			start.h = calcDistance(start, end);
			start.f = start.h;	
			
			while (_open.length > 0) {				
				var f:int = int.MAX_VALUE;
				var currentNode:FlxPathfindingNode;
				//choose the node with the lesser cost f
				for (var i:int = 0; i < _open.length; i++) { 
					if (_open[i].f < f) {
						currentNode = _open[i];
						f = currentNode.f;
					}
				}
				//we arrived at the end node, so we finish
				if (currentNode == end) {
					return rebuildPath(currentNode);
				}
				//we visited this node, so we can remove it from open and add it to closed
				_open.splice(_open.indexOf(currentNode), 1);
				_closed.push(currentNode);
				//do stuff with the neighbors of the current node
				for each (var n:FlxPathfindingNode in getNeighbors(currentNode)) {
					//skip nodes that has already been visited
					if (_closed.indexOf(n) > -1) {
						continue;
					}
					var g:int = currentNode.g + n.cost;
					if (_open.indexOf(n) == -1) {
						_open.push(n);
						n.parent = currentNode;
						n.g = g;					//path travelled so far
						n.h = calcDistance(n, end); //estimated path to goal
						n.f = n.g + n.h;
					} else if (g < n.g) {
						n.parent = currentNode;
						n.g = g;
						n.h = calcDistance(n, end);
						n.f = n.g + n.h;
					}
				}
			}
			//no path can be found
			var min:int = int.MAX_VALUE;
			var nearestNode:FlxPathfindingNode;
			//find the reachable node that is nearer to the goal
			for each(var c:FlxPathfindingNode in _closed) {
				var dist:Number = calcDistance(c, end);
				if (dist < min) {
					min = dist;
					nearestNode = c;
				}
			}
			return rebuildPath(nearestNode); //returns the path to the node nearest to the goal
		}
		
		
		public function getNodeAt(x:int, y:int):FlxPathfindingNode {
			return _nodes[x+","+y];
		}
		
		//returns an array from a linked list of nodes
		private function rebuildPath(end:FlxPathfindingNode):Array {
			var path:Array = new Array();
			if (end == null) {
				return path;
			}
			var n:FlxPathfindingNode = end;
			while (n.parent != null) {
				path.push(new Point(n.x, n.y));
				n = n.parent;
			}
			return path.reverse();
		}
		
		private function getNeighbors(node:FlxPathfindingNode):Array {
			var x:int = node.x;
			var y:int = node.y;
			var currentNode:FlxPathfindingNode;
			var neighbors:Array = new Array(8);
			if (x > 0) {
				currentNode = getNodeAt(x - 1, y);
				if (currentNode.walkable) {
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			}
			if (x < (_map.widthInTiles/tileSimplificationAmount) - 1) {
				currentNode = getNodeAt(x + 1, y);
				if (currentNode.walkable) {
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			} 
			if (y > 0) {
				currentNode = getNodeAt(x, y - 1);
				if (currentNode.walkable) {
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			}
			if (y < (_map.heightInTiles/tileSimplificationAmount) - 1) {
				currentNode = getNodeAt(x, y + 1);
				if (currentNode.walkable) {
					currentNode.cost = COST_ORTHOGONAL;
					neighbors.push(currentNode);
				}
			}
			if (allowDiagonal){
				if (x > 0 && y > 0) {
					currentNode = getNodeAt(x - 1, y - 1);
					if (currentNode.walkable && getNodeAt(x - 1, y).walkable && getNodeAt(x, y - 1).walkable) {
						currentNode.cost = COST_DIAGONAL;
						neighbors.push(currentNode);
					}
				}
				if (x < (_map.widthInTiles/tileSimplificationAmount) - 1 && y > 0) {
					currentNode = getNodeAt(x + 1, y - 1);
					if (currentNode.walkable && getNodeAt(x + 1, y).walkable && getNodeAt(x, y - 1).walkable) {
						currentNode.cost = COST_DIAGONAL;
						neighbors.push(currentNode);
					}
				}
				if (x > 0 && y < (_map.heightInTiles/tileSimplificationAmount) - 1) {
					currentNode = getNodeAt(x - 1, y + 1);
					if (currentNode.walkable && getNodeAt(x - 1, y).walkable && getNodeAt(x, y + 1).walkable) {
						currentNode.cost = COST_DIAGONAL;
						neighbors.push(currentNode);
					}
				}
				if (x < (_map.widthInTiles/tileSimplificationAmount) - 1 && y < (_map.heightInTiles/tileSimplificationAmount) - 1) {
					currentNode = getNodeAt(x + 1, y + 1);
					if (currentNode.walkable && getNodeAt(x + 1, y).walkable && getNodeAt(x, y + 1).walkable) {
						currentNode.cost = COST_DIAGONAL;
						neighbors.push(currentNode);
					}
				}
			}
			return neighbors;
		}
		
		//cheap way to calculate an approximate distance between two nodes
		private function calcDistance(start:FlxPathfindingNode, end:FlxPathfindingNode):int {
			if (start.x > end.x) {
				if (start.y > end.y) {
					return (start.x - end.x) + (start.y - end.y);
				} else {
					return (start.x - end.x) + (end.y - start.y);
				}
			} else {
				if (start.y > end.y) {
					return (end.x - start.x) + (start.y - end.y);
				} else {
					return (end.x - start.x) + (end.y - start.y);
				}
			}
		}
		
		//not sure which one is faster, have to do some test
		/*private function calcDistance2(start:FlxPathfindingNode, end:FlxPathfindingNode):int {
			return Math.abs(n1.x-n2.x)+Math.abs(n1.y-n2.y);
		}*/
		
		

	}
}