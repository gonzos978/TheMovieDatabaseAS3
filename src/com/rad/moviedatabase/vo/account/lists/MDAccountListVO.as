package com.rad.moviedatabase.vo.account.lists
{
	public class MDAccountListVO
	{
		public var id:int;
		public var page:int;
		public var total_pages:int;
		public var total_results:int;
		public var results:Vector.<MDAccountListItemVO> = new Vector.<MDAccountListItemVO>();
		
		public function MDAccountListVO()
		{
		}
	}
}