package com.rad.moviedatabase.vo.movies.keywords
{
	import com.rad.moviedatabase.vo.movies.core.MDCoreVO;

	public class MDKeywordsVO
	{
		public var id:int;
		public var keywords:Vector.<MDCoreVO> = new Vector.<MDCoreVO>();
		
		public function MDKeywordsVO()
		{
		}
	}
}