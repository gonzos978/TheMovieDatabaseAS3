package com.rad.moviedatabase
{
	import com.rad.moviedatabase.events.MDFaultEvent;
	import com.rad.moviedatabase.events.MDImageEvent;
	import com.rad.moviedatabase.events.MDResultEvent;
	import com.rad.moviedatabase.events.constants.MDEventTypeConstants;
	import com.rad.moviedatabase.loader.MDLoader;
	import com.rad.moviedatabase.loader.MDServiceFault;
	import com.rad.moviedatabase.pool.ObjectPool;
	import com.rad.moviedatabase.settings.MDSettings;
	import com.rad.moviedatabase.settings.constants.MDBackdropSizesConstants;
	import com.rad.moviedatabase.settings.constants.MDPosterSizesConstants;
	import com.rad.moviedatabase.settings.constants.MDProfileSizesConstants;
	import com.rad.moviedatabase.user.MDUserStorage;
	import com.rad.moviedatabase.utils.MDAccountResultParser;
	import com.rad.moviedatabase.utils.MDGenreResultParser;
	import com.rad.moviedatabase.utils.MDListResultParser;
	import com.rad.moviedatabase.utils.MDMovieResultParser;
	import com.rad.moviedatabase.utils.MDPersonResultParser;
	import com.rad.moviedatabase.utils.MDSearchResultParser;
	import com.rad.moviedatabase.vo.account.MDAccountVO;
	import com.rad.moviedatabase.vo.genre.MDGenreVO;
	import com.rad.moviedatabase.vo.search.MDSearchVO;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	[Event(name="fault", type="com.rad.moviedatabase.events.MDFaultEvent")]
	
	[Event(name="tokenResult", type="com.rad.moviedatabase.events.MDResultEvent")]
	[Event(name="sessionResult", type="com.rad.moviedatabase.events.MDResultEvent")]
	[Event(name="accountResult", type="com.rad.moviedatabase.events.MDResultEvent")]
	[Event(name="genreResult", type="com.rad.moviedatabase.events.MDResultEvent")]
	[Event(name="movieResult", type="com.rad.moviedatabase.events.MDResultEvent")]
	[Event(name="listResult", type="com.rad.moviedatabase.events.MDResultEvent")]
	[Event(name="peopleResult", type="com.rad.moviedatabase.events.MDResultEvent")]
	[Event(name="searchResult", type="com.rad.moviedatabase.events.MDResultEvent")]

	
	public class MDService extends EventDispatcher
	{
		private static const MOVIE_DB_BASE_URL:String = "http://api.themoviedb.org/3/";
		
		public static const FAULT:String = "fault";
		public static const TOKEN_RESULT:String = "tokenResult";
		public static const SESSION_RESULT:String = "sessionResult";
		
		public static const ACCOUNT_RESULT:String = "accountResult";
		public static const GENRE_RESULT:String = "genreResult";
		public static const MOVIE_RESULT:String = "movieResult";
		public static const LIST_RESULT:String = "listResult";
		public static const PEOPLE_RESULT:String = "peopleResult";
		public static const SEARCH_RESULT:String = "searchResult";
		
		public var api_key:String;
		
		private var _urlLoaders:Vector.<MDLoader>;
		private var _imgLoader:Loader;
		private var _urlRequest:URLRequest;
		private var _urlVariables:URLVariables;
		private var _storage:MDUserStorage;
		private var _account:MDAccountVO;
		private var _genre:MDGenreVO;
		private var _search:MDSearchVO;
		private var _searchedId:String;
		private var _movieParser:MDMovieResultParser;
		private var _personParser:MDPersonResultParser;
		private var _genreParser:MDGenreResultParser;
		private var _listParser:MDListResultParser;
		private var _accountParser:MDAccountResultParser;
		private var _searchParser:MDSearchResultParser;
		public function MDService()
		{
			super();
			_genreParser = new MDGenreResultParser();
			_movieParser = new MDMovieResultParser();
			_personParser = new MDPersonResultParser();
			_listParser = new MDListResultParser();
			_accountParser = new MDAccountResultParser();
			_searchParser = new MDSearchResultParser();
			
			_urlVariables = new URLVariables();
			_urlRequest = new URLRequest();
			_storage = new MDUserStorage();
			_genre = new MDGenreVO();
			_account = new MDAccountVO();
			_search = new MDSearchVO();
			
			ObjectPool.fill(MDLoader, 20);
		}
		
		/////////
		// PUBLIC METHODES
		/////////

		/**
		 * 
		 * Event type: SEARCH_BY_KEYWORD
		 * 
		 */		
		public function searchByKeyword(title:String,page:uint=1):void
		{
			var url:String = MOVIE_DB_BASE_URL+"search/keyword?query="+title+"&api_key="+api_key+"&page="+page;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.SEARCH_BY_KEYWORD;
			loader.returnType = MDEventTypeConstants.SEARCH_BY_KEYWORD;
			loader.load(_urlRequest);
		}
		
		/**
		 * 
		 * Event type: SEARCH_BY_LIST
		 * 
		 */		
		public function searchByList(title:String,page:uint=1, includeAdult:Boolean = false):void
		{
			var url:String = MOVIE_DB_BASE_URL+"search/list?query="+title+"&api_key="+api_key+"&page="+page+"&include_adult="+includeAdult;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.SEARCH_BY_LIST;
			loader.returnType = MDEventTypeConstants.SEARCH_BY_LIST;
			loader.load(_urlRequest);
		}
		
		/**
		 * 
		 * Event type: SEARCH_BY_TITLE
		 * 
		 */		
		public function searchByTitle(title:String, language:String="en",page:uint=1, includeAdult:Boolean = false, year:String=""):void
		{
			var url:String = MOVIE_DB_BASE_URL+"search/movie?query="+title+"&api_key="+api_key+"&page="+page+"&include_adult="+includeAdult+"&language="+language+"&year="+year;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.SEARCH_BY_TITLE;
			loader.returnType = MDEventTypeConstants.SEARCH_BY_TITLE;
			loader.load(_urlRequest);
		}
		
		/**
		 * 
		 * Event type: SEARCH_BY_PEOPLE
		 * 
		 */	
		public function searchByPeople(name:String, page:uint=1, includeAdult:Boolean = false):void
		{
			var url:String = MOVIE_DB_BASE_URL+"search/person?query="+name+"&api_key="+api_key+"&page="+page+"&include_adult="+includeAdult;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.SEARCH_BY_PEOPLE;
			loader.returnType = MDEventTypeConstants.SEARCH_BY_PEOPLE;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: SEARCH_BY_COLLECTION
		 * 
		 */	
		public function searchByCollection(name:String, page:uint=1):void
		{
			var url:String = MOVIE_DB_BASE_URL+"search/collection?query="+name+"&api_key="+api_key+"&page="+page;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.SEARCH_BY_COLLECTION;
			loader.returnType = MDEventTypeConstants.SEARCH_BY_COLLECTION;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: SEARCH_BY_COMPANY
		 * 
		 */	
		public function searchByCompany(name:String, page:uint=1):void
		{
			var url:String = MOVIE_DB_BASE_URL+"search/company?query="+name+"&api_key="+api_key+"&page="+page;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.SEARCH_BY_COMPANY;
			loader.returnType = MDEventTypeConstants.SEARCH_BY_COMPANY;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: COLLECTION_INFO
		 * 
		 */	
		public function getCollectionInfo(id:String, language:String="en"):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"collection/"+id+"?api_key="+api_key+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.COLLECTION_INFO;
			loader.returnType = MDEventTypeConstants.COLLECTION_INFO;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: COLLECTION_IMAGES
		 * 
		 */	
		public function getCollectionImages(id:String, language:String="en"):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"collection/"+id+"?api_key="+api_key+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.COLLECTION_IMAGES;
			loader.returnType = MDEventTypeConstants.COLLECTION_IMAGES;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIE_INFO
		 * 
		 */	
		public function getMovieInfo(id:String, language:String="en"):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"movie/"+id+"?api_key="+api_key;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_INFO;
			loader.returnType = MDEventTypeConstants.MOVIE_INFO;
			loader.load(_urlRequest);	
		}
		/**
		 * 
		 * Event type: MOVIE_ALTERNATIVE_TITLES
		 * 
		 */	
		public function getAlternateMovieTitles(id:String, country:String=""):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"movie/"+id+"/alternative_titles?api_key="+api_key+"&country="+country;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_ALTERNATIVE_TITLES;
			loader.returnType = MDEventTypeConstants.MOVIE_ALTERNATIVE_TITLES;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIE_LISTS
		 * 
		 */	
		public function getMovieLists(id:String, page:uint=1, language:String="en"):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"movie/"+id+"/lists?api_key="+api_key+"&page="+page+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_LISTS;
			loader.returnType = MDEventTypeConstants.MOVIE_LISTS;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIE_CAST
		 * 
		 */	
		public function getMovieChanges(id:String, startDate:String = "1970-01-01", endDate:String = "2020-01-01"):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"movie/"+id+"/changes?api_key="+api_key;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_CHANGES;
			loader.returnType = MDEventTypeConstants.MOVIE_CHANGES;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIE_CAST
		 * 
		 */	
		public function getMovieCast(id:String):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"movie/"+id+"/casts?api_key="+api_key;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_CAST;
			loader.returnType = MDEventTypeConstants.MOVIE_CAST;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIE_IMAGES
		 * 
		 */	
		public function getMovieImages(id:String, language:String="en"):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"movie/"+id+"/images?api_key="+api_key+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_IMAGES;
			loader.returnType = MDEventTypeConstants.MOVIE_IMAGES;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIE_KEYWORDS
		 * 
		 */	
		public function getMovieKeywords(id:String):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"movie/"+id+"/keywords?api_key="+api_key;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_KEYWORDS;
			loader.returnType = MDEventTypeConstants.MOVIE_KEYWORDS;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIE_RELEASE_INFO
		 * 
		 */	
		public function getMovieReleaseInfo(id:String):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"movie/"+id+"/releases?api_key="+api_key;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_RELEASE_INFO;
			loader.returnType = MDEventTypeConstants.MOVIE_RELEASE_INFO;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIE_TRAILERS
		 * 
		 */	
		public function getMovieTrailers(id:String, language:String="en"):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"movie/"+id+"/trailers?api_key="+api_key+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_TRAILERS;
			loader.returnType = MDEventTypeConstants.MOVIE_TRAILERS;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIE_TRANSLATIONS
		 * 
		 */	
		public function getMovieTranslations(id:String):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"movie/"+id+"/translations?api_key="+api_key;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_TRANSLATIONS;
			loader.returnType = MDEventTypeConstants.MOVIE_TRANSLATIONS;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: SIMILAR_MOVIES
		 * 
		 */	
		public function getMoviesSimilar(id:String, page:uint=1, language:String="en"):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"movie/"+id+"/similar_movies?api_key="+api_key+"&page="+page+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_SIMILAR;
			loader.returnType = MDEventTypeConstants.MOVIE_SIMILAR;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: PERSON_INFO
		 * 
		 */	
		public function getPersonInfo(id:String):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"person/"+id+"?api_key="+api_key;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.PERSON_INFO;
			loader.returnType = MDEventTypeConstants.PERSON_INFO;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: PERSON_CREDITS
		 * 
		 */	
		public function getPersonCredits(id:String, language:String="en"):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"person/"+id+"/credits?api_key="+api_key+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.PERSON_CREDITS;
			loader.returnType = MDEventTypeConstants.PERSON_CREDITS;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: PERSON_IMAGES
		 * 
		 */	
		public function getPersonImages(id:String):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"person/"+id+"/images?api_key="+api_key;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.PERSON_IMAGES;
			loader.returnType = MDEventTypeConstants.PERSON_IMAGES;
			loader.load(_urlRequest);
		}
		/**
		 * GET LSIT 
		 * @param id
		 * 
		 */		
		public function getList(id:String):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"list/"+id+"?api_key="+api_key;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.LIST;
			loader.returnType = MDEventTypeConstants.LIST;
			loader.load(_urlRequest);
		}
		
		/**
		 * 
		 * Event type: MOVIE_LATEST
		 * 
		 */	
		public function getLatestMovie():void
		{
			var url:String = MOVIE_DB_BASE_URL+"movie/latest?api_key="+api_key;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_LATEST;
			loader.returnType = MDEventTypeConstants.MOVIE_LATEST;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIE_UPCOMING
		 * 
		 */	
		public function getUpcomingMovies(page:uint=1, language="en"):void
		{
			var url:String = MOVIE_DB_BASE_URL+"movie/upcoming?api_key="+api_key+"&page="+page+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_UPCOMING;
			loader.returnType = MDEventTypeConstants.MOVIE_UPCOMING;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIE_NOW_PLAYING
		 * 
		 */	
		public function getNowPlayingMovies(page:uint=1, language="en"):void
		{
			var url:String = MOVIE_DB_BASE_URL+"movie/now_playing?api_key="+api_key+"&page="+page+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_NOW_PLAYING;
			loader.returnType = MDEventTypeConstants.MOVIE_NOW_PLAYING;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIES_POPULAR
		 * 
		 */	
		public function getPopularMovies(page:uint=1):void
		{
			var url:String = MOVIE_DB_BASE_URL+"movie/popular?api_key="+api_key+"&page="+page;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_POPULAR;
			loader.returnType = MDEventTypeConstants.MOVIE_POPULAR;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: MOVIES_TOP_RATED
		 * 
		 */	
		public function getTopRatedMovies(page:uint = 1, language:String="en"):void
		{
			var url:String = MOVIE_DB_BASE_URL+"movie/top-rated?api_key="+api_key+"&page="+page+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.MOVIE_TOP_RATED;
			loader.returnType = MDEventTypeConstants.MOVIE_TOP_RATED;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: COMPANY_INFO
		 * 
		 */	
		public function getCompanyInfo(id:String):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"company/"+id+"/images?api_key="+api_key;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.COMPANY_INFO;
			loader.returnType = MDEventTypeConstants.COMPANY_INFO;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: COMPANY_MOVIES
		 * 
		 */	
		public function getCompanyMovies(id:String, page:uint=1, language:String="en"):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"company/"+id+"movies?api_key="+api_key+"&page="+page+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.COMPANY_MOVIES;
			loader.returnType = MDEventTypeConstants.COMPANY_MOVIES;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: GENRE_LIST
		 * 
		 */	
		public function getGenreList(language:String="en"):void
		{
			var url:String = MOVIE_DB_BASE_URL+"genre/list?api_key="+api_key+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.GENRE_LIST;
			loader.returnType = MDEventTypeConstants.GENRE_LIST;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: GENRE_MOVIES
		 * 
		 */	
		public function getGenreMovies(id:String, page:uint=1,language:String="en"):void
		{
			_searchedId = id;
			var url:String = MOVIE_DB_BASE_URL+"genre/"+id+"/movies?api_key="+api_key+"&page="+page+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.GENRE_MOVIES;
			loader.returnType = MDEventTypeConstants.GENRE_MOVIES;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: ACCOUNT_INFO
		 * 
		 */	
		public function getAccountInfo():void
		{
			if(!_storage.session_id) throw new Error("Make sure you call the requestSession method first!");
			var url:String = MOVIE_DB_BASE_URL+"account?api_key="+api_key+"&session_id="+_storage.session_id
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.ACCOUNT_INFO;
			loader.returnType = MDEventTypeConstants.ACCOUNT_INFO;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: ACCOUNT_SET_FAVORITE
		 * 
		 */	
		public function accountAddFavorite(accountID:String, movieID:String, isFavorite:Boolean):void
		{
			if(!_storage.account_id) throw new Error("Make sure you call the requestSession method first!");
			var requestVars:URLVariables = new URLVariables();
			requestVars.movie_id = movieID;
			requestVars.favorite = isFavorite;
			_urlRequest.data = requestVars;
			_urlRequest.method = URLRequestMethod.POST;
			
			var url:String = MOVIE_DB_BASE_URL+"account/?api_key="+api_key+"&session_id="+_storage.session_id
			_urlRequest.url = url;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.ACCOUNT_SET_FAVORITE;
			loader.returnType = MDEventTypeConstants.ACCOUNT_SET_FAVORITE;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: ACCOUNT_LISTS
		 * 
		 */	
		public function getAccountLists(accountID:String, page:uint = 1, language:String="en"):void
		{
			if(!_storage.account_id) throw new Error("Make sure you call the getAccountInfo method first!");
			var url:String = MOVIE_DB_BASE_URL+"account/"+_storage.account_id+"/lists?api_key="+api_key+"&session_id="+_storage.session_id+"&page="+page+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.ACCOUNT_LISTS;
			loader.returnType = MDEventTypeConstants.ACCOUNT_LISTS;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: ACCOUNT_FAVORITE_MOVIES
		 * 
		 */	
		public function getAccountFavoriteMovies(page:uint = 1, language:String="en"):void
		{
			if(!_storage.account_id) throw new Error("Make sure you call the getAccountInfo method first!");
			var url:String = MOVIE_DB_BASE_URL+"account/"+_storage.account_id+"/favorite_movies?api_key="+api_key+"&session_id="+_storage.session_id+"&page="+page+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.ACCOUNT_FAVORITE_MOVIES;
			loader.returnType = MDEventTypeConstants.ACCOUNT_FAVORITE_MOVIES;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: COLLECTION_INFO
		 * 
		 */	
		public function setFavoriteMovie(id:String, isFavorite:Boolean):void
		{
			if(!_storage.account_id) throw new Error("Make sure you call the getAccountInfo method first!");
			_searchedId = id;
			var o:Object = new Object();
			o.movie_id = int(id);
			o.favorite = isFavorite;
			var url:String = MOVIE_DB_BASE_URL+"account/"+_storage.account_id+"/favorite?api_key="+api_key+"&session_id="+_storage.session_id
			var hdr:URLRequestHeader = new URLRequestHeader("Content-type", "application/json");
			var hdr2:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			_urlRequest.requestHeaders.push(hdr);
			_urlRequest.requestHeaders.push(hdr2);
			_urlRequest.method = URLRequestMethod.POST;
			_urlRequest.data = JSON.stringify(o);
			_urlRequest.url = url;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.ACCOUNT_SET_FAVORITE;
			loader.returnType = MDEventTypeConstants.ACCOUNT_SET_FAVORITE;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: ACCOUNT_WATCHLIST
		 * 
		 */	
		public function getAccountWatchlist(page:uint = 1, language:String="en"):void
		{
			if(!_storage.account_id) throw new Error("Make sure you call the getAccountInfo method first!");
			var url:String = MOVIE_DB_BASE_URL+"account/"+_storage.account_id+"/movie_watchlist?api_key="+api_key+"&session_id="+_storage.session_id+"&page="+page+"&language="+language;
			_urlRequest.url = url;
			_urlRequest.method = URLRequestMethod.GET;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.ACCOUNT_WATCHLIST;
			loader.returnType = MDEventTypeConstants.ACCOUNT_WATCHLIST;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: ACCOUNT_ADD_MOVIE_WATCHLIST
		 * 
		 */	
		public function setMovieToWatchlist(id:String, isOnWatchlist:Boolean):void
		{
			if(!_storage.account_id) throw new Error("Make sure you call the getAccountInfo method first!");
			_searchedId = id;
			var o:Object = new Object();
			o.movie_id = int(id);
			o.movie_watchlist = isOnWatchlist;
			var url:String = MOVIE_DB_BASE_URL+"account/"+_storage.account_id+"/movie_watchlist?api_key="+api_key+"&session_id="+_storage.session_id;
			var hdr:URLRequestHeader = new URLRequestHeader("Content-type", "application/json");
			var hdr2:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			_urlRequest.requestHeaders.push(hdr);
			_urlRequest.requestHeaders.push(hdr2);
			_urlRequest.method = URLRequestMethod.POST;
			_urlRequest.data = JSON.stringify(o);
			_urlRequest.url = url;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.ACCOUNT_SET_WATCHLIST;
			loader.returnType = MDEventTypeConstants.ACCOUNT_SET_WATCHLIST;
			loader.load(_urlRequest);
		}
		/**
		 * 
		 * Event type: ACCOUNT_RATED_MOVIES
		 * 
		 */	
		public function getAccountRatedMovies(page:uint = 1, language:String="en"):void
		{
			if(!_storage.account_id) throw new Error("Make sure you call the getAccountInfo method first!");
			var url:String = MOVIE_DB_BASE_URL+"account/"+_storage.account_id+"/rated_movies?api_key="+api_key+"&session_id="+_storage.session_id+"&page="+page+"&language="+language;
			_urlRequest.method = URLRequestMethod.GET;
			_urlRequest.url = url;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.ACCOUNT_RATED_MOVIES;
			loader.returnType = MDEventTypeConstants.ACCOUNT_RATED_MOVIES;
			loader.load(_urlRequest);
		}
		
		
		//////////
		// IMAGES
		//////////
		
		public function getBackdropImage(backdropPath:String, backdropSize:String = MDSettings.DEFAULT_BACKDROP_SIZE):void
		{
			switch(backdropSize)
			{
				case MDBackdropSizesConstants.WIDTH_300:
				case MDBackdropSizesConstants.WIDTH_780:
				case MDBackdropSizesConstants.WIDTH_1280:
				case MDBackdropSizesConstants.ORIGINAL:
					var url:URLRequest = new URLRequest(MDSettings.BASE_URL+backdropSize+backdropPath+"?api_key="+api_key);
					if(_imgLoader)
					{
						_imgLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
						_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
						_imgLoader.close();
						_imgLoader = null;
					}
					_imgLoader = new Loader();
					_imgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress, false, 0, true);
					_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete, false, 0, true);
					_imgLoader.load(url);
					break;
					
				default:
					throw new Error("PLease use dimentions from PosterSizesConstants");
					break;
			}
		}
		
		public function getPosterImage(posterPath:String, posterSize:String = MDSettings.DEFAULT_POSTER_SIZE):void
		{
			switch(posterSize)
			{
				case MDPosterSizesConstants.WIDTH_92:
				case MDPosterSizesConstants.WIDTH_154:
				case MDPosterSizesConstants.WIDTH_185:
				case MDPosterSizesConstants.WIDTH_342:
				case MDPosterSizesConstants.WIDTH_500:
				case MDPosterSizesConstants.ORIGINAL:
					var url:URLRequest = new URLRequest(MDSettings.BASE_URL+posterSize+posterPath+"?api_key="+api_key);
					if(_imgLoader)
					{
						_imgLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
						_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
						_imgLoader.close();
						_imgLoader = null;
					}
					_imgLoader = new Loader();
					_imgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress, false, 0, true);
					_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete, false, 0, true);
					_imgLoader.load(url);
					break;
				default:
					throw new Error("PLease use dimentions from PosterSizesConstants");
					break;
			}
		}
		
		public function getProfileImage(profilePath:String, profileSize:String = MDSettings.DEFAULT_PROFILE_SIZE):void
		{
			switch(profileSize)
			{
				case MDProfileSizesConstants.WIDTH_45:
				case MDProfileSizesConstants.WIDTH_185:
				case MDProfileSizesConstants.HEIGHT_632:
				case MDProfileSizesConstants.ORIGINAL:
					var url:URLRequest = new URLRequest(MDSettings.BASE_URL+profileSize+profilePath+"?api_key="+api_key);
					if(_imgLoader)
					{
						_imgLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
						_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
						_imgLoader.close();
						_imgLoader = null;
					}
					_imgLoader = new Loader();
					_imgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress, false, 0, true);
					_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete, false, 0, true);
					_imgLoader.load(url);
					break;
				default:
					throw new Error("PLease use dimentions from ProfileSizesConstants");
					break;
			}
		}
		protected function loadProgress(event:ProgressEvent):void
		{
			dispatchEvent(new MDImageEvent(MDImageEvent.ON_PROGRESS, event.bytesLoaded, event.bytesTotal));
		}
		protected function loadComplete(event:Event):void
		{
			dispatchEvent(new MDImageEvent(MDImageEvent.ON_COMPLETE,NaN,NaN,event.target.content));
		}
		///////////
		// HANDLERS
		//////////
		private function _onLoader_ActivateHandler(event:Event):void
		{
			if(hasEventListener(event.type))
				dispatchEvent(event.clone());
		}
		
		private function _onLoader_DeactivateHandler(event:Event):void
		{
			if(hasEventListener(event.type))
				dispatchEvent(event.clone());
		}
		
		private function _onLoader_OpenHandler(event:Event):void
		{
			if(hasEventListener(event.type))
				dispatchEvent(event.clone());
		}
		
		private function _onLoader_ProgressHandler(event:ProgressEvent):void
		{
			if(hasEventListener(event.type))
				dispatchEvent(event.clone());
		}
		
		private function _onLoader_StatusHandler(event:HTTPStatusEvent):void
		{
			if(event.status != 200) trace("Status: " + event.status);
			dispatchEvent(new MDFaultEvent(MDFaultEvent.FAULT,null,event.type, event.status));
			if(hasEventListener(event.type))
				dispatchEvent(event.clone());
			var loader:MDLoader = event.target as MDLoader;
			loader.httpStatus = event.status;
		}
		
		private function _onLoader_IOErrorHandler(event:IOErrorEvent):void
		{
			trace("IO ERROR: " + event.text);
			dispatchEvent(new MDFaultEvent(MDFaultEvent.FAULT,null,event.text));
			var loader:MDLoader = event.target as MDLoader;
			_releaseUrlLoader(loader);
		}
		
		private function _onLoader_SecurityHandler(event:SecurityErrorEvent):void
		{
			trace(" SEC ERROR: " + event.text);
			dispatchEvent(new MDFaultEvent(MDFaultEvent.FAULT,null,event.text));
			var loader:MDLoader = event.target as MDLoader;
			_releaseUrlLoader(loader);
		}
		
		private function _onLoader_CompleteHandler(event:Event):void
		{
			var loader:MDLoader = event.target as MDLoader;
			if(loader.data.toString().indexOf("Unrecognized domain")>-1)
			{
				dispatchEvent(new MDFaultEvent(MDFaultEvent.FAULT, new MDServiceFault("Unknown",loader.data.toString(), "Service Request Error", loader.httpStatus)));
				return;
			}
			var results:Object;
			var data:Object = JSON.parse(loader.data);
			if(data.error)
			{
				dispatchEvent(new MDFaultEvent(MDFaultEvent.FAULT, new MDServiceFault("Unknown",data.error, "Service Request Error", loader.httpStatus)));
				return;
			}
			if(event.target.data) results = JSON.parse(event.target.data);
			parseAndDispatch(loader.returnType, results);
			_releaseUrlLoader(loader);
		}
		
		
		///////////////
		// METHODES
		//////////////
		private function _getUrlLoader(url:String):MDLoader
		{
			
			//var loader:MDLoader =  ObjectPool.get(MDLoader);
			//if(!_urlLoaders) _urlLoaders = new Vector.<MDLoader>();
			/*if(!_inUseLoaders)
				_inUseLoaders = {};*/
			
			var loader:MDLoader = ObjectPool.get(MDLoader);
			loader.addEventListener(Event.ACTIVATE, _onLoader_ActivateHandler);
			loader.addEventListener(Event.COMPLETE, _onLoader_CompleteHandler);
			loader.addEventListener(Event.DEACTIVATE, _onLoader_DeactivateHandler);
			loader.addEventListener(Event.OPEN, _onLoader_OpenHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, _onLoader_StatusHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoader_IOErrorHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, _onLoader_ProgressHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoader_SecurityHandler);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			/*if(_urlLoaders.length==0)
			{
				loader = new MDLoader();
				loader.addEventListener(Event.ACTIVATE, _onLoader_ActivateHandler);
				loader.addEventListener(Event.COMPLETE, _onLoader_CompleteHandler);
				loader.addEventListener(Event.DEACTIVATE, _onLoader_DeactivateHandler);
				loader.addEventListener(Event.OPEN, _onLoader_OpenHandler);
				loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, _onLoader_StatusHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoader_IOErrorHandler);
				loader.addEventListener(ProgressEvent.PROGRESS, _onLoader_ProgressHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoader_SecurityHandler);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
			} else {
				loader = _urlLoaders.pop();
			}
			
			loader.url = url;
			_inUseLoaders[url] = loader;*/
			
			return loader;
		}
		
		private function _releaseUrlLoader(loader:MDLoader):void
		{
			loader.removeEventListener(Event.ACTIVATE, _onLoader_ActivateHandler);
			loader.removeEventListener(Event.COMPLETE, _onLoader_CompleteHandler);
			loader.removeEventListener(Event.DEACTIVATE, _onLoader_DeactivateHandler);
			loader.removeEventListener(Event.OPEN, _onLoader_OpenHandler);
			loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, _onLoader_StatusHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, _onLoader_IOErrorHandler);
			loader.removeEventListener(ProgressEvent.PROGRESS, _onLoader_ProgressHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onLoader_SecurityHandler);
			ObjectPool.dispose(loader);
			/*_urlLoaders.push( _inUseLoaders[url] );
			delete _inUseLoaders[url];*/
		}
		
		/////////////////////
		//AUTHENTICATION
		////////////////////
		public function requestToken():void
		{
			if(!api_key) throw new Error("Make sure to set your API key!");
			var url:String = MOVIE_DB_BASE_URL+"authentication/token/new?api_key="+api_key
			_urlRequest.url = url;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.TOKEN_RESULT;
			loader.returnType = MDEventTypeConstants.TOKEN_RESULT;
			loader.load(_urlRequest);
		}
		
		public function requestAuthorization(redirectURL:String = null):void
		{
			var url:String;
			if(redirectURL)
				url = "http://www.themoviedb.org/authenticate/"+_storage.request_token+"?redirect_to="+redirectURL;
			else
				url = "http://www.themoviedb.org/authenticate/"+_storage.request_token;
			_urlRequest.url = url;
			navigateToURL(_urlRequest, "_blank");
		}
		
		public function requestSession():void
		{
			if(!_storage.request_token) throw new Error("Make sure to call the 'requestToken methode first!");
			var url:String = MOVIE_DB_BASE_URL+"authentication/session/new?api_key="+api_key+"&request_token="+_storage.request_token
			_urlRequest.url = url;
			var loader : MDLoader =  _getUrlLoader(url);
			loader.type = MDEventTypeConstants.SESSION_RESULT;
			loader.returnType = MDEventTypeConstants.SESSION_RESULT;
			loader.load(_urlRequest);
		}
		
		/////////////////////
		// GETTERS
		//////////////////////
		
		public function get storage():MDUserStorage
		{
			return _storage;
		}
		
		///////////////
		// PRIVATES
		//////////////
		
		private function parseAndDispatch(type:String, results:Object):void
		{
			switch(type)
			{
				case MDEventTypeConstants.TOKEN_RESULT:
					_storage.request_token = results["request_token"];
					dispatchEvent(new MDResultEvent(TOKEN_RESULT, type, _storage));
					break;
				case MDEventTypeConstants.SESSION_RESULT:
					_storage.session_id = results["session_id"];
					dispatchEvent(new MDResultEvent(SESSION_RESULT, type, _storage));
					break;
				case MDEventTypeConstants.ACCOUNT_INFO:
					_storage.account_id = results["id"];
					dispatchEvent(new MDResultEvent(ACCOUNT_RESULT, type, _accountParser.parseAccount(type,results)));
					break;
				case MDEventTypeConstants.ACCOUNT_LISTS:
				case MDEventTypeConstants.ACCOUNT_FAVORITE_MOVIES:
				case MDEventTypeConstants.ACCOUNT_RATED_MOVIES:
				case MDEventTypeConstants.ACCOUNT_WATCHLIST:
					results["id"] = int(_searchedId);
					dispatchEvent(new MDResultEvent(ACCOUNT_RESULT, type, _accountParser.parseAccount(type,results)));
					break;
				case MDEventTypeConstants.GENRE_LIST:
					results["id"] = int(_searchedId);
					dispatchEvent(new MDResultEvent(GENRE_RESULT, type, results));
					break;
				case MDEventTypeConstants.GENRE_MOVIES:
					dispatchEvent(new MDResultEvent(GENRE_RESULT, type, _genreParser.parseGenre(type,results)));
					break;
				case MDEventTypeConstants.LIST:
					dispatchEvent(new MDResultEvent(LIST_RESULT, type, _listParser.parseList(type,results)));
					break;
				case MDEventTypeConstants.PERSON_INFO:
				case MDEventTypeConstants.PERSON_CREDITS:
				case MDEventTypeConstants.PERSON_IMAGES:
					results['id'] = int(_searchedId);
					dispatchEvent(new MDResultEvent(MOVIE_RESULT, type, _personParser.parsePerson(type,results)));
					break;
				case MDEventTypeConstants.SEARCH_BY_COLLECTION:
				case MDEventTypeConstants.SEARCH_BY_COMPANY:
				case MDEventTypeConstants.SEARCH_BY_KEYWORD:
				case MDEventTypeConstants.SEARCH_BY_LIST:
				case MDEventTypeConstants.SEARCH_BY_PEOPLE:
				case MDEventTypeConstants.SEARCH_BY_TITLE:
					results['id'] = int(_searchedId);
					dispatchEvent(new MDResultEvent(SEARCH_RESULT, type, _searchParser.parseSearch(type,results)));
					break;
				case MDEventTypeConstants.MOVIE_ALTERNATIVE_TITLES:
				case MDEventTypeConstants.MOVIE_CAST:
				case MDEventTypeConstants.MOVIE_CHANGES:
				case MDEventTypeConstants.MOVIE_IMAGES:
				case MDEventTypeConstants.MOVIE_INFO:
				case MDEventTypeConstants.MOVIE_KEYWORDS:
				case MDEventTypeConstants.MOVIE_LATEST:
				case MDEventTypeConstants.MOVIE_LISTS:
				case MDEventTypeConstants.MOVIE_NOW_PLAYING:
				case MDEventTypeConstants.MOVIE_RELEASE_INFO:
				case MDEventTypeConstants.MOVIE_TRAILERS:
				case MDEventTypeConstants.MOVIE_TRANSLATIONS:
				case MDEventTypeConstants.MOVIE_UPCOMING:
				case MDEventTypeConstants.MOVIE_POPULAR:
				case MDEventTypeConstants.MOVIE_SIMILAR:
				case MDEventTypeConstants.MOVIE_TOP_RATED:
				case MDEventTypeConstants.COLLECTION_IMAGES:
				case MDEventTypeConstants.COLLECTION_INFO:
					results['id'] = int(_searchedId);
					dispatchEvent(new MDResultEvent(MOVIE_RESULT, type, _movieParser.parseMovie(type,results)));
					break;
				case MDEventTypeConstants.ACCOUNT_SET_WATCHLIST:
					dispatchEvent(new MDResultEvent(ACCOUNT_RESULT, type));
					break;
				
			}
		}
	}
}