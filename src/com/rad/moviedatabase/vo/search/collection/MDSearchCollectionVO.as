package com.rad.moviedatabase.vo.search.collection
{
	import com.rad.moviedatabase.vo.movies.core.MDMovieItemCoreVO;

	public class MDSearchCollectionVO
	{
		public var page:int;
		public var total_pages:int;
		public var total_results:int;
		public var results:Vector.<MDMovieItemCoreVO> = new Vector.<MDMovieItemCoreVO>();
		
		public function MDSearchCollectionVO()
		{
		}
	}
}