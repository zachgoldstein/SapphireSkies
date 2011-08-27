package zachg.util
{
	public class TileData
	{
		public function TileData()
		{
		}
		
		public static var SpecialTileMapping:Array = [];
		
		//holds info regarding what tiles are around each tile. 
		//So if a tile can only be there if there's something to the right, this holds that data 
		//positions: "topLeft, left, bottomLeft, bottom, bottomRight, Right, topRight, top
		
		//goes [tile links,if multi-tile[id of other tile,relative position],ischangable,id]
		public static var basicTileData:Array = [
			[[],false,0],
			["right","left","bottom",[],false,1],
			["right","left","bottom",[],false,2],
			["bottom","left",[],false,3],
			[,[],false,4],
			["left",[],false,5],
			["left", "bottom", "right", "top",[7,"right"],true,6],
			["left", "bottom", "right", "top",[6,"left"],true,7],
			
			["right","top","bottom",[],false,8],
			["left", "bottom", "right", "top",[],true,9],
			["left", "bottom", "right", "top",[],true,10],
			["left","top","bottom",[],false,11],
			["left","top","right",[],false,12],
			["right",[],false,13],
			["left", "bottom", "right", "top",[15,"right",22,"bottom"],true,14],
			["left", "bottom", "right", "top",[14,"left",23,"bottom"],true,15],
			
			["right","top","bottom",[],false,16],
			["left", "bottom", "right", "top",[25,"bottom"],true,17],
			["left", "bottom", "right", "top",[],true,18],
			["left","top","bottom",[],false,19],
			["right","top","bottom",[],false,20],
			["left","top","bottom",[],false,21],
			["left", "bottom", "right", "top",[23,"right",14,"top"],true,22],
			["left", "bottom", "right", "top",[22,"left",15,"top"],true,23],
			
			["right","top","bottom",[32,"bottom"],false,24],
			["left", "bottom", "right", "top",[17,"top"],true,25],
			["left", "bottom", "right", "top",[],true,26],
			["left","top","bottom",[35,"bottom"],false,27],
			["left","right",[],false,28],
			["right","top","bottom",[],false,29],
			["left","top","bottom",[],false,30],
			["top",[],false,31],
			
			["top","right",[24,"top"],false,32],
			["left","top","right",[],false,33],
			["left","top","right",[],false,34],
			["top","left",[27,"top"],false,35],
			["bottom","right",[],false,36],
			["bottom","top",[],false,37],
			["right","top",[],false,38],
			["left","top",[],false,39],
			
			["bottom",[],false,40]
		];			
	}
}