package com.rad.moviedatabase.vo.movies.core
{
	public class MDMovieCoreVO
	{
		public var page:int;
		public var total_pages:int;
		public var total_results:int;
		public var results:Vector.<MDMovieItemCoreVO> = new Vector.<MDMovieItemCoreVO>();
		
		public function MDMovieCoreVO()
		{
		}
	}
}