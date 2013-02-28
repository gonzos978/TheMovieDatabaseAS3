package com.rad.moviedatabase.vo.search.company
{
	public class MDSearchCompanyVO
	{
		public var page:int;
		public var total_pages:int;
		public var total_results:int;
		public var results:Vector.<MDSearchCompanyItemVO> = new Vector.<MDSearchCompanyItemVO>();
		
		public function MDSearchCompanyVO()
		{
		}
	}
}