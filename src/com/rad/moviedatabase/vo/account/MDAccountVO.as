package com.rad.moviedatabase.vo.account
{
	import com.rad.moviedatabase.vo.account.favorite_movies.MDAccountFavoriteMoviesVO;
	import com.rad.moviedatabase.vo.account.lists.MDAccountListVO;
	import com.rad.moviedatabase.vo.account.rated_movies.MDAccountRatedMoviesVO;
	import com.rad.moviedatabase.vo.account.watchlist.MDAccountMovieWatchlistVO;

	public class MDAccountVO
	{
		public var id:int;
		public var include_adult:String;
		public var iso_3166_1:String;
		public var iso_639_1:String;
		public var name:String;
		public var username:String;
		
		public var lists:MDAccountListVO;
		public var movie_watchlist:MDAccountMovieWatchlistVO;
		public var rated_movies:MDAccountRatedMoviesVO;
		public var favorite_movies:MDAccountFavoriteMoviesVO;
		
		public function MDAccountVO()
		{
		}
	}
}