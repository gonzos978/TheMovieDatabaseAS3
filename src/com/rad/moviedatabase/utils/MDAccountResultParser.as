package com.rad.moviedatabase.utils
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.rad.moviedatabase.events.constants.MDEventTypeConstants;
	import com.rad.moviedatabase.settings.constants.MDResultConstants;
	import com.rad.moviedatabase.vo.account.MDAccountVO;
	import com.rad.moviedatabase.vo.account.favorite_movies.MDAccountFavoriteMoviesVO;
	import com.rad.moviedatabase.vo.account.lists.MDAccountListItemVO;
	import com.rad.moviedatabase.vo.account.lists.MDAccountListVO;
	import com.rad.moviedatabase.vo.account.rated_movies.MDAccountRatedMoviesVO;
	import com.rad.moviedatabase.vo.account.watchlist.MDAccountMovieWatchlistVO;
	import com.rad.moviedatabase.vo.movies.MDMovieVO;
	import com.rad.moviedatabase.vo.movies.core.MDMovieItemCoreVO;

	public class MDAccountResultParser
	{
		//private static var _lists:MDAccountListVO = new MDAccountListVO();
		//private static var _favoriteMovies:MDAccountFavoriteMoviesVO = new MDAccountFavoriteMoviesVO();
		//private static var _ratedMovies:MDAccountRatedMoviesVO = new MDAccountRatedMoviesVO();
		//private static var _movieWacthlist:MDAccountMovieWatchlistVO = new MDAccountMovieWatchlistVO();
		private static const VERBOSE:Boolean = false;
		private var _account:MDAccountVO;
		
		public function MDAccountResultParser()
		{
			
		}
		public function parseAccount(type:String, result:Object):MDAccountVO
		{
			_account = new MDAccountVO();
			switch(type)
			{
				case MDEventTypeConstants.ACCOUNT_INFO:
						addInfo(_account, result);
					break;
				case MDEventTypeConstants.ACCOUNT_LISTS:
						addLists(_account, result);
					break;
				case MDEventTypeConstants.ACCOUNT_FAVORITE_MOVIES:
						addFavorites(_account, result);
					break;
				case MDEventTypeConstants.ACCOUNT_RATED_MOVIES:
						addRated(_account, result);
					break;
				case MDEventTypeConstants.ACCOUNT_WATCHLIST:
						addWatchlist(_account, result);
					break;
			}
			return _account;
		}
		
		private function addWatchlist(account:MDAccountVO, result:Object):void
		{
			var _movieWacthlist:MDAccountMovieWatchlistVO = new MDAccountMovieWatchlistVO();
			addValue(_movieWacthlist, result);
			var l:int = result["results"].length;
			var item:MDMovieItemCoreVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				item = new MDMovieItemCoreVO();
				for(var id:String in result["results"][i]) 
				{
					var val:Object = result["results"][i][id];
					if(item.hasOwnProperty(id))
					{
						item[id] = val;
					}
				}
				_movieWacthlist.results.push(item);
			}
			_movieWacthlist.id = result["id"];
			if(_movieWacthlist.id != account.id) account.id = _movieWacthlist.id;
			account.movie_watchlist = _movieWacthlist;
		}
		
		private function addRated(account:MDAccountVO, result:Object):void
		{
			var _ratedMovies:MDAccountRatedMoviesVO = new MDAccountRatedMoviesVO();
			addValue(_ratedMovies, result);
			var l:int = result["results"].length;
			var item:MDMovieItemCoreVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				item = new MDMovieItemCoreVO();
				for(var id:String in result["results"][i]) 
				{
					var val:Object = result["results"][i][id];
					if(item.hasOwnProperty(id))
					{
						item[id] = val;
					}
				}
				_ratedMovies.results.push(item);
			}
			_ratedMovies.id = result["id"];
			if(_ratedMovies.id != account.id) account.id = _ratedMovies.id;
			account.rated_movies = _ratedMovies;
		}
		
		private function addFavorites(account:MDAccountVO, result:Object):void
		{
			var _favoriteMovies:MDAccountFavoriteMoviesVO = new MDAccountFavoriteMoviesVO();
			addValue(_favoriteMovies, result);
			var l:int = result["results"].length;
			var item:MDMovieItemCoreVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				item = new MDMovieItemCoreVO();
				for(var id:String in result["results"][i]) 
				{
					var val:Object = result["results"][i][id];
					if(item.hasOwnProperty(id))
					{
						item[id] = val;
					}
				}
				_favoriteMovies.results.push(item);
			}
			_favoriteMovies.id = result["id"];
			if(_favoriteMovies.id != account.id) account.id = _favoriteMovies.id;
			account.favorite_movies = _favoriteMovies;
		}
		
		private function addLists(account:MDAccountVO, result:Object):void
		{
			var _lists:MDAccountListVO = new MDAccountListVO();
			addValue(_lists, result);
			var l:int = result["results"].length;
			var item:MDAccountListItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				item = new MDAccountListItemVO();
				for(var id:String in result["results"][i]) 
				{
					var val:Object = result["results"][i][id];
					if(item.hasOwnProperty(id))
					{
						item[id] = val;
					}
				}
				_lists.results.push(item);
			}
			_lists.id = result["id"];
			if(_lists.id != account.id) account.id = _lists.id;
			account.lists = _lists;
		}
		
		private function addInfo(account:MDAccountVO, result:Object):void
		{
			addValue(account, result);
		}		
			
		
		
		///////////////
		// PRIVATES
		///////////////
		///simple vector population
		
		private function checkIds(currentMovieId:int, resultId:int):Boolean
		{
			return currentMovieId == resultId;
		}
		
		private  function addValue(vo:Object, result:Object):void
		{
			for(var id:String in result) {
				var value:Object = result[id];
				switch(typeof value)
				{
					case "string":
					case "boolean":
					case "number":
						if(vo.hasOwnProperty(id))
						{
							vo[id] = value;
						}
						break;
				}
			}
		}
		private function clear(vo:Object):void
		{
			if(vo.hasOwnProperty(MDResultConstants.RATED_MOVIES)) vo[MDResultConstants.RATED_MOVIES] = null;
			if(vo.hasOwnProperty(MDResultConstants.FAVORITE_MOVIES)) vo[MDResultConstants.FAVORITE_MOVIES] = null;
			if(vo.hasOwnProperty(MDResultConstants.MOVIE_WATCHLIST)) vo[MDResultConstants.MOVIE_WATCHLIST] = null;
			if(vo.hasOwnProperty(MDResultConstants.ISO_3166_1)) vo[MDResultConstants.ISO_3166_1] = null;
			if(vo.hasOwnProperty(MDResultConstants.INCLUDE_ADULT)) vo[MDResultConstants.INCLUDE_ADULT] = null;
			if(vo.hasOwnProperty(MDResultConstants.USERNAME)) vo[MDResultConstants.USERNAME] = null;
			if(vo.hasOwnProperty(MDResultConstants.ISO_639_1)) vo[MDResultConstants.ISO_639_1] = null;
			
			if(vo.hasOwnProperty(MDResultConstants.LISTS)) vo[MDResultConstants.LISTS] = null;
			if(vo.hasOwnProperty(MDResultConstants.FAVORITE_MOVIES)) vo[MDResultConstants.FAVORITE_MOVIES] = null;
			if(vo.hasOwnProperty(MDResultConstants.RATED_MOVIES)) vo[MDResultConstants.RATED_MOVIES] = null;
			if(vo.hasOwnProperty(MDResultConstants.MOVIE_WATCHLIST)) vo[MDResultConstants.MOVIE_WATCHLIST] = null;
		}
	}
}