package com.rad.moviedatabase.vo.movies.lists
{
	public class MDMovieListsVO
	{
		public var id:int;
		public var page:int;
		public var results:Vector.<MDMovieListItemVO>
		public var total_pages:int;
		public var total_results:int;
		
		public function MDMovieListsVO()
		{
			
		}
	}
}