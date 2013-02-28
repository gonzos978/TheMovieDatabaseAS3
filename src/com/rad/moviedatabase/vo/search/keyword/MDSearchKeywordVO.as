package com.rad.moviedatabase.vo.search.keyword
{
	import com.rad.moviedatabase.vo.movies.core.MDCoreVO;
	

	public class MDSearchKeywordVO
	{
		public var page:int;
		public var total_pages:int;
		public var total_results:int;
		public var results:Vector.<MDCoreVO> = new Vector.<MDCoreVO>();
		
		public function MDSearchKeywordVO()
		{
		}
	}
}