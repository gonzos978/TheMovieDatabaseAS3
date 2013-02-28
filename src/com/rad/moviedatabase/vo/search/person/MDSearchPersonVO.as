package com.rad.moviedatabase.vo.search.person
{
	public class MDSearchPersonVO
	{
		public var page:int
		public var total_pages:int;
		public var total_results:int;
		public var results:Vector.<MDSearchPersonItemVO> = new Vector.<MDSearchPersonItemVO>();
		
		public function MDSearchPersonVO()
		{
		}
	}
}