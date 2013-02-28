package com.rad.moviedatabase.vo.search.list
{
	import com.rad.moviedatabase.vo.movies.lists.MDMovieListItemVO;

	public class MDSearchListVO
	{
		public var page:int;
		public var results:Vector.<MDMovieListItemVO> = new Vector.<MDMovieListItemVO>();
		public var total_pages:int;
		public var total_results:int;
		
		public function MDSearchListVO()
		{
		}
	}
}