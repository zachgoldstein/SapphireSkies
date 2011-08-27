package zachg.util
{
	import com.vexhel.FlxPathfindingNode;
	
	import flash.geom.Point;
	
	import org.flixel.FlxTilemap;
	import org.generalrelativity.thread.process.AbstractProcess;
	
	public class PathFindingProcess extends AbstractProcess
	{
		public function PathFindingProcess(startPoint:Point, endPoint:Point, map:FlxTilemap, nodes:Array, arrayFoundMethod:Function, isSelfManaging:Boolean=false)
		{
			super(isSelfManaging);
			_startPoint = startPoint;
			_endPoint = endPoint;
			callbackMethod = arrayFoundMethod;
			_map = map;
			_nodes = nodes;
		}

		public var _startPoint:Point;
		public var _endPoint:Point;
		public var callbackMethod:Function;
		
		private var _map:FlxTilemap;
		private var _nodes:Array;
		private var _open:Array;
		private var _closed:Array;
		
		//we use int (instead of Number) to get better performance
		private const COST_ORTHOGONAL:int = 10;
		private const COST_DIAGONAL:int = 14
		
		public var allowDiagonal:Boolean = true;		
		
		override public function runAndManage(allocation:int):void
		{
			var arrayToReturn:Array = findPath(_startPoint,_endPoint);
			callbackMethod(arrayToReturn);
			terminate();
		}
		
		private function end() : void {
			terminate();
		}
		
		//given a start and an end points, returns an array of points representing the shortest path (if any) between them
		public function findPath(startPoint:Point, endPoint:Point):Array {
			_open = [];
			_closed = [];
			for (var i:int = 0; i < _nodes.length; i++) {
				_nodes[i].parent = null;
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
			return _nodes[x + y * _map.widthInTiles];
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
			if (x < _map.widthInTiles - 1) {
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
			if (y < _map.heightInTiles - 1) {
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
				if (x < _map.widthInTiles - 1 && y > 0) {
					currentNode = getNodeAt(x + 1, y - 1);
					if (currentNode.walkable && getNodeAt(x + 1, y).walkable && getNodeAt(x, y - 1).walkable) {
						currentNode.cost = COST_DIAGONAL;
						neighbors.push(currentNode);
					}
				}
				if (x > 0 && y < _map.heightInTiles - 1) {
					currentNode = getNodeAt(x - 1, y + 1);
					if (currentNode.walkable && getNodeAt(x - 1, y).walkable && getNodeAt(x, y + 1).walkable) {
						currentNode.cost = COST_DIAGONAL;
						neighbors.push(currentNode);
					}
				}
				if (x < _map.widthInTiles - 1 && y < _map.heightInTiles - 1) {
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