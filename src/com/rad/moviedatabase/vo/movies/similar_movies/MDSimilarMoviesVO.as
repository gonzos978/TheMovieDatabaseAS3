package com.rad.moviedatabase.vo.movies.similar_movies
{

	public class MDSimilarMoviesVO
	{
		public var id:int;
		public var page:int;
		public var total_pages:int;
		public var total_results:int;
		public var results:Vector.<MDSimilarMovieItemVO> = new Vector.<MDSimilarMovieItemVO>();
		
		public function MDSimilarMoviesVO()
		{
		}
	}
}