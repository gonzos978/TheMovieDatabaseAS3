package com.rad.moviedatabase.vo.account.favorite_movies
{
	import com.rad.moviedatabase.vo.movies.core.MDMovieItemCoreVO;
	
	

	public class MDAccountFavoriteMoviesVO
	{
		public var id:int;
		public var pages:int;
		public var total_pages:int;
		public var total_results:int;
		public var results:Vector.<MDMovieItemCoreVO> = new Vector.<MDMovieItemCoreVO>();
		
		public function MDAccountFavoriteMoviesVO()
		{
		}
	}
}