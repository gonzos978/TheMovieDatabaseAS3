package com.rad.moviedatabase.utils
{
	import com.rad.moviedatabase.events.constants.MDEventTypeConstants;
	import com.rad.moviedatabase.settings.constants.MDResultConstants;
	import com.rad.moviedatabase.vo.account.lists.MDAccountListItemVO;
	import com.rad.moviedatabase.vo.movies.MDMovieVO;
	import com.rad.moviedatabase.vo.movies.alternative_titles.MDAlternativeTitleItemVO;
	import com.rad.moviedatabase.vo.movies.alternative_titles.MDAlternativeTitlesVO;
	import com.rad.moviedatabase.vo.movies.cast.MDCastMemberVO;
	import com.rad.moviedatabase.vo.movies.cast.MDCastVO;
	import com.rad.moviedatabase.vo.movies.cast.MDCrewMemberVO;
	import com.rad.moviedatabase.vo.movies.changes.MDChangesItemVO;
	import com.rad.moviedatabase.vo.movies.changes.MDChangesVO;
	import com.rad.moviedatabase.vo.movies.collection.MDCollectionVO;
	import com.rad.moviedatabase.vo.movies.core.MDCoreVO;
	import com.rad.moviedatabase.vo.movies.core.MDMovieCoreVO;
	import com.rad.moviedatabase.vo.movies.core.MDMovieItemCoreVO;
	import com.rad.moviedatabase.vo.movies.genre.MDGenreItemVO;
	import com.rad.moviedatabase.vo.movies.genre.MDMovieGenreVO;
	import com.rad.moviedatabase.vo.movies.images.MDImageItemVO;
	import com.rad.moviedatabase.vo.movies.images.MDImagesVO;
	import com.rad.moviedatabase.vo.movies.keywords.MDKeywordsVO;
	import com.rad.moviedatabase.vo.movies.languages.MDSpokenLanguageItemVO;
	import com.rad.moviedatabase.vo.movies.languages.MDSpokenLanguagesVO;
	import com.rad.moviedatabase.vo.movies.lists.MDMovieListItemVO;
	import com.rad.moviedatabase.vo.movies.lists.MDMovieListsVO;
	import com.rad.moviedatabase.vo.movies.production_companies.MDProductionCompaniesVO;
	import com.rad.moviedatabase.vo.movies.production_countries.MDProductionCountriesVO;
	import com.rad.moviedatabase.vo.movies.production_countries.MDProductionCountryItemVO;
	import com.rad.moviedatabase.vo.movies.releases.MDReleasesItemVO;
	import com.rad.moviedatabase.vo.movies.releases.MDReleasesVO;
	import com.rad.moviedatabase.vo.movies.similar_movies.MDSimilarMovieItemVO;
	import com.rad.moviedatabase.vo.movies.similar_movies.MDSimilarMoviesVO;
	import com.rad.moviedatabase.vo.movies.trailers.MDTrailerItemVO;
	import com.rad.moviedatabase.vo.movies.trailers.MDTrailersVO;
	import com.rad.moviedatabase.vo.movies.translations.MDTranslationItemVO;
	import com.rad.moviedatabase.vo.movies.translations.MDTranslationsVO;
	
	public class MDMovieResultParser
	{
		//private var _productionCompanies:MDProductionCompaniesVO = new MDProductionCompaniesVO();
		//private var _productionCountries:MDProductionCountriesVO = new MDProductionCountriesVO();
		//private var _spokenLanguages:MDSpokenLanguagesVO = new MDSpokenLanguagesVO();
		//private var _alternateTitles:MDAlternativeTitlesVO = new MDAlternativeTitlesVO();
		//private var _cast:MDCastVO = new MDCastVO();
		//private var _images:MDImagesVO= new MDImagesVO();
		//private var _keywords:MDKeywordsVO= new MDKeywordsVO();
		//private var _releaseInfo:MDReleasesVO= new MDReleasesVO();
		//private var _trailers:MDTrailersVO= new MDTrailersVO();
		//private var _translations:MDTranslationsVO= new MDTranslationsVO();
		//private var _similarMovies:MDSimilarMoviesVO= new MDSimilarMoviesVO();
		//private var _lists:MDListsVO= new MDListsVO();
		//private var _changes:MDChangesVO= new MDChangesVO();
		//private var _nowPlaying:MDMovieCoreVO= new MDMovieCoreVO();
		//private var _upcoming:MDMovieCoreVO= new MDMovieCoreVO();
		//private var _popular:MDMovieCoreVO= new MDMovieCoreVO();
		//private var _topRated:MDMovieCoreVO= new MDMovieCoreVO();
		//private var _collectionInfo:MDCollectionVO= new MDCollectionVO();
		private static const VERBOSE:Boolean = false;
		private var _movie:MDMovieVO;
		
		public function MDMovieResultParser()
		{
			
		}
		
		public function parseMovie(type:String, result:Object):MDMovieVO
		{
			_movie = new MDMovieVO();
			if(VERBOSE) trace("MD -- Parsing: "+ type+ " - Movies id: " + result["id"]);
			_movie.id = result['id'];
			switch(type)
			{
				case MDEventTypeConstants.MOVIE_LATEST:
				case MDEventTypeConstants.MOVIE_INFO:
					for(var id:String in result) {
						var value:Object = result[id];
						checkTypes(_movie, value, id);
					}
					break;
				case MDEventTypeConstants.MOVIE_ALTERNATIVE_TITLES:
					addAlternateMovieTitles(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_CAST:
					addCast(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_IMAGES:
					addImages(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_KEYWORDS:
					addKeywords(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_RELEASE_INFO:
					addReleaseInfo(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_TRAILERS:
					addTrailers(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_TRANSLATIONS:
					addTranslations(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_SIMILAR:
					addSimilar(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_LISTS:
					addList(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_CHANGES:
					addChanges(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_NOW_PLAYING:
					addNowPlaying(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_UPCOMING:
					addUpcoming(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_POPULAR:
					addPopular(_movie, result);
					break;
				case MDEventTypeConstants.MOVIE_TOP_RATED:
					addTopRated(_movie, result);
					break;
				case MDEventTypeConstants.COLLECTION_INFO:
					addCollection(_movie, result);
					break;
				case MDEventTypeConstants.COLLECTION_IMAGES:
					addCollectionImages(_movie, result);
					break;
			}
			return _movie;
		}
		
		
		
		
		///////////////
		// PRIVATES
		///////////////
		///simple vector population
		
		private function addCollectionImages(movie:MDMovieVO, result:Object):void
		{
			var _collectionInfo:MDCollectionVO= new MDCollectionVO();
			_collectionInfo.backdrops.length = 0;
			_collectionInfo.posters.length = 0;
			addValue(_collectionInfo, result);
			_collectionInfo.backdrops = parseBackdrops(movie, result);
			_collectionInfo.posters = parsePosters(movie, result);
			_collectionInfo.id = result["id"];
			if(_collectionInfo.id != movie.id) movie.id = _collectionInfo.id;
			movie.collection = _collectionInfo;
		}	
		///simple vector population
		
		private function addCollection(movie:MDMovieVO, result:Object):void
		{
			var _collectionInfo:MDCollectionVO= new MDCollectionVO();
			_collectionInfo.parts.length = 0;
			var l:int = result["parts"].length;
			var item:MDMovieItemCoreVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				item = new MDMovieItemCoreVO();
				for(var id:String in result["parts"][i]) 
				{
					var val:Object = result["parts"][i][id];
					if(item.hasOwnProperty(id))
					{
						item[id] = val;
					}
				}
				_collectionInfo.parts.push(item);
			}
			movie.collection = _collectionInfo;
		}	
		
		///simple vector population
		
		private  function addTopRated(movie:MDMovieVO, result:Object):void
		{
			var _topRated:MDMovieCoreVO= new MDMovieCoreVO();
			_topRated.results.length = 0;
			addValue(_topRated, result);
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
				_topRated.results.push(item);
			}
			movie.top_rated = _topRated;
		}	
		
		private  function addPopular(movie:MDMovieVO, result:Object):void
		{
			var _popular:MDMovieCoreVO= new MDMovieCoreVO();
			_popular.results.length = 0;
			addValue(_popular, result);
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
				_popular.results.push(item);
			}
			movie.popular = _popular;
		}
		private  function addUpcoming(movie:MDMovieVO, result:Object):void
		{
			var _upcoming:MDMovieCoreVO= new MDMovieCoreVO();
			_upcoming.results.length = 0;
			addValue(_upcoming, result);
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
				_upcoming.results.push(item);
			}
			movie.upcoming = _upcoming;
		}
		/// called specically
		private  function addNowPlaying(movie:MDMovieVO, result:Object):void
		{
			var _nowPlaying:MDMovieCoreVO= new MDMovieCoreVO();
			_nowPlaying.results.length = 0;
			addValue(_nowPlaying, result);
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
				_nowPlaying.results.push(item);
			}
			movie.now_playing = _nowPlaying;
		}
		
		/// called specically
		private  function addChanges(movie:MDMovieVO, result:Object):void
		{
			var _changes:MDChangesVO= new MDChangesVO();
			_changes.changes.length = 0;
			addValue(_changes, result);
			var l:int = result["changes"].length;
			var item:MDChangesItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				item = new MDChangesItemVO();
				for(var id:String in result["changes"][i]) 
				{
					var val:Object = result["changes"][i][id];
					if(item.hasOwnProperty(id))
					{
						item[id] = val;
					}
				}
				_changes.changes.push(item);
			}
			_changes.id = result["id"];
			if(_changes.id != movie.id) movie.id = _changes.id;
			movie.changes = _changes;
		}
		/// called specically
		private  function addList(movie:MDMovieVO, result:Object):void
		{
			var _list:MDMovieListsVO = new MDMovieListsVO();
			addValue(_list, result);
			var l:int = result["results"].length;
			var listItem:MDMovieListItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				listItem = new MDMovieListItemVO();
				for(var id:String in result["results"][i]) 
				{
					var val:Object = result["results"][i][id];
					if(listItem.hasOwnProperty(id))
					{
						listItem[id] = val;
					}
				}
				_list.results.push(listItem);
			}
			_list.id = result["id"];
			_list.page = result["page"];
			_list.total_pages = result["total_pages"];
			_list.total_results = result["total_results"];
			if(_list.id != movie.id) movie.id = _list.id;
			movie.lists = _list;
		}
		/// called specically
		private  function addSimilar(movie:MDMovieVO, result:Object):void
		{
			var _similarMovies:MDSimilarMoviesVO = new MDSimilarMoviesVO();
			_similarMovies.results.length = 0;
			addValue(_similarMovies, result);
			var l:int = result["results"].length;
			var similar:MDSimilarMovieItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				similar = new MDSimilarMovieItemVO();
				for(var id:String in result["results"][i]) 
				{
					var val:Object = result["results"][i][id];
					if(similar.hasOwnProperty(id))
					{
						similar[id] = val;
					}
				}
				_similarMovies.results.push(similar);
			}
			_similarMovies.id = result["id"];
			_similarMovies.page = result["page"];
			_similarMovies.total_pages = result["total_pages"];
			_similarMovies.total_results = result["total_results"];
			if(_similarMovies.id != movie.id) movie.id = _similarMovies.id;
			movie.similar_movies = _similarMovies;
		}
		
		/// called specically
		private  function addTranslations(movie:MDMovieVO, result:Object):void
		{
			var _translations:MDTranslationsVO= new MDTranslationsVO();
			_translations.translations.length = 0;
			addValue(_translations, result);
			var l:int = result["translations"].length;
			var translation:MDTranslationItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				translation = new MDTranslationItemVO();
				for(var id:String in result["translations"][i]) 
				{
					var val:Object = result["translations"][i][id];
					if(translation.hasOwnProperty(id))
					{
						translation[id] = val;
					}
				}
				_translations.translations.push(translation);
			}
			_translations.id = result["id"];
			if(_translations.id != movie.id) movie.id = _translations.id;
			movie.translations = _translations;
		}
		
		/// called specically
		private  function addTrailers(movie:MDMovieVO, result:Object):void
		{
			var _trailers:MDTrailersVO= new MDTrailersVO();
			_trailers.quicktime.length = 0;
			_trailers.youtube.length = 0;
			addValue(_trailers, result);
			_trailers.quicktime = parseTrailers("quicktime",movie, result);
			_trailers.youtube = parseTrailers("youtube",movie, result);
			_trailers.id = result["id"];
			if(_trailers.id != movie.id) movie.id = _trailers.id;
			movie.trailers = _trailers;
		}
		
		private  function parseTrailers(mediaType:String, movie:MDMovieVO, result:Object):Vector.<MDTrailerItemVO>
		{
			var l:int = result[mediaType].length;
			if(l < 1) return null;
			var item:MDTrailerItemVO;
			var media:Vector.<MDTrailerItemVO> = new Vector.<MDTrailerItemVO>();
			var val:Object;
			for (var i:int = 0; i < l; i++) 
			{
				item = new MDTrailerItemVO();
				for(var mediaId:String in result[mediaType][i]) 
				{
					val = result[mediaType][i][mediaId];
					if(item.hasOwnProperty(mediaId))
					{
						item[mediaId] = val;
					}
				}
				media.push(item);
			}
			return media;
		}
		/// called specically
		private  function addReleaseInfo(movie:MDMovieVO, result:Object):void
		{
			var _releaseInfo:MDReleasesVO= new MDReleasesVO();
			_releaseInfo.countries.length = 0;
			addValue(_releaseInfo, result);
			var l:int = result["countries"].length;
			var release:MDReleasesItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				release = new MDReleasesItemVO();
				for(var id:String in result["countries"][i]) 
				{
					var val:Object = result["countries"][i][id];
					if(release.hasOwnProperty(id))
					{
						release[id] = val;
					}
				}
				_releaseInfo.countries.push(release);
			}
			_releaseInfo.id = result["id"];
			if(_releaseInfo.id != movie.id) movie.id = _releaseInfo.id;
			movie.releaseInfo = _releaseInfo;
		}
		/// called specically
		private  function addKeywords(movie:MDMovieVO, result:Object):void
		{
			var _keywords:MDKeywordsVO= new MDKeywordsVO();
			_keywords.keywords.length = 0;
			addValue(_keywords, result);
			var l:int = result["keywords"].length;
			var keyword:MDCoreVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				keyword = new MDCoreVO();
				for(var id:String in result["keywords"][i]) 
				{
					var val:Object = result["keywords"][i][id];
					if(keyword.hasOwnProperty(id))
					{
						keyword[id] = val;
					}
				}
				_keywords.keywords.push(keyword);
			}
			_keywords.id = result["id"];
			if(_keywords.id != movie.id) movie.id = _keywords.id;
			movie.keywords = _keywords;
		}
		
		/// called specically
		private  function addImages(movie:MDMovieVO, result:Object):void
		{
			var _images:MDImagesVO= new MDImagesVO();
			if(_images.backdrops) _images.backdrops.length = 0;
			if(_images.posters) _images.posters.length = 0;
			addValue(_images, result);
			_images.backdrops = parseBackdrops(movie, result);
			_images.posters = parsePosters(movie, result);
			_images.id = result["id"];
			if(_images.id != movie.id) movie.id = _images.id;
			movie.images = _images;
		}	
		
		private  function parsePosters(movie:MDMovieVO, result:Object):Vector.<MDImageItemVO>
		{
			var postL:int = result["posters"].length;
			if(postL < 1) return null;
			var posterImage:MDImageItemVO;
			var posters:Vector.<MDImageItemVO> = new Vector.<MDImageItemVO>();
			var val:Object;
			for (var i:int = 0; i < postL; i++) 
			{
				posterImage = new MDImageItemVO();
				for(var postId:String in result["posters"][i]) 
				{
					val = result["posters"][i][postId];
					if(posterImage.hasOwnProperty(postId))
					{
						posterImage[postId] = val;
					}
				}
				posters.push(posterImage);
			}
			return posters;
		}
		
		private  function parseBackdrops(movie:MDMovieVO, result:Object):Vector.<MDImageItemVO>
		{
			var backL:int = result["backdrops"].length;
			if(backL < 1) return null;
			var backdropImage:MDImageItemVO;
			var backdrops:Vector.<MDImageItemVO> = new Vector.<MDImageItemVO>();
			var val:Object;
			for (var i:int = 0; i < backL; i++) 
			{
				backdropImage = new MDImageItemVO();
				for(var backId:String in result["backdrops"][i]) 
				{
					val = result["backdrops"][i][backId];
					if(backdropImage.hasOwnProperty(backId))
					{
						backdropImage[backId] = val;
					}
				}
				backdrops.push(backdropImage);
			}
			return backdrops;
		}
		
		
		/// called specically
		private  function addCast(movie:MDMovieVO, result:Object):void
		{
			var _cast:MDCastVO = new MDCastVO();
			_cast.cast.length = 0;
			_cast.crew.length = 0;
			addValue(_cast, result);
			var castL:int = result["cast"].length;
			var crewL:int = result["crew"].length;
			var castMember:MDCastMemberVO;
			var crewMember:MDCrewMemberVO;
			var val:Object;
			for (var i:int = 0; i < castL; i++) 
			{
				castMember = new MDCastMemberVO();
				for(var castId:String in result["cast"][i]) 
				{
					val = result["cast"][i][castId];
					if(castMember.hasOwnProperty(castId))
					{
						castMember[castId] = val;
					}
				}
				_cast.cast.push(castMember);
			}
			
			for (var j:int = 0; j < crewL; j++) 
			{
				crewMember = new MDCrewMemberVO();
				for(var crewId:String in result["crew"][j]) 
				{
					val = result["crew"][j][crewId];
					if(crewMember.hasOwnProperty(crewId))
					{
						crewMember[crewId] = val;
					}
				}
				_cast.crew.push(crewMember);
			}
			_cast.id = result["id"];
			if(_cast.id != movie.id) movie.id = _cast.id;
			movie.cast = _cast;
		}		
		
		/// called specically
		private  function addAlternateMovieTitles(movie:MDMovieVO, result:Object):void
		{
			var _alternateTitles:MDAlternativeTitlesVO = new MDAlternativeTitlesVO();
			addValue(_alternateTitles, result);
			var l:int = result["titles"].length;
			var altTitle:MDAlternativeTitleItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				altTitle = new MDAlternativeTitleItemVO();
				for(var id:String in result["titles"][i]) 
				{
					var val:Object = result["titles"][i][id];
					if(altTitle.hasOwnProperty(id))
					{
						altTitle[id] = val;
					}
				}
				_alternateTitles.titles.push(altTitle);
			}
			_alternateTitles.id = result["id"];
			if(_alternateTitles.id != movie.id) movie.id = _alternateTitles.id;
			movie.alternative_titles = _alternateTitles;
		}
		
		// called through movieInfo
		private  function addProductionCompanies(movie:MDMovieVO, result:Object):void
		{
			var _productionCompanies:MDProductionCompaniesVO = new MDProductionCompaniesVO();
			addValue(_productionCompanies, result);
			var l:int = result.length;
			var prodItem:MDCoreVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				prodItem = new MDCoreVO();
				for(var id:String in result[i]) 
				{
					var val:Object = result[i][id];
					if(prodItem.hasOwnProperty(id))
					{
						prodItem[id] = val;
					}
				}
				_productionCompanies.production_companies.push(prodItem);
			}
			movie.production_companies = _productionCompanies;
		}
		
		private  function addProductionCountries(movie:MDMovieVO, result:Object):void
		{
			var _productionCountries:MDProductionCountriesVO = new MDProductionCountriesVO();
			addValue(_productionCountries, result);
			var l:int = result.length;
			var prodItem:MDProductionCountryItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				prodItem = new MDProductionCountryItemVO();
				for(var id:String in result[i]) 
				{
					var val:Object = result[i][id];
					if(prodItem.hasOwnProperty(id))
					{
						prodItem[id] = val;
					}
				}
				_productionCountries.production_countries.push(prodItem);
			}
			movie.production_countries = _productionCountries;
		}
		
		private  function addGendres(movie:MDMovieVO, result:Object):void
		{
			var _genres:MDMovieGenreVO = new MDMovieGenreVO();
			addValue(_genres, result);
			var l:int = result.length;
			var genreItem:MDGenreItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				genreItem = new MDGenreItemVO();
				for(var id:String in result[i]) 
				{
					var val:Object = result[i][id];
					if(genreItem.hasOwnProperty(id))
					{
						genreItem[id] = val;
					}
				}
				_genres.genres.push(genreItem);
			}
			movie.genres = _genres;
		}
		
		private  function addSpokenLanguages(movie:MDMovieVO, result:Object):void
		{
			var _spokenLanguages:MDSpokenLanguagesVO = new MDSpokenLanguagesVO();
			_spokenLanguages.spoken_languages.length = 0;
			addValue(_spokenLanguages, result);
			var l:int = result.length;
			var langItem:MDSpokenLanguageItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				langItem = new MDSpokenLanguageItemVO();
				for(var id:String in result[i]) 
				{
					var val:Object = result[i][id];
					if(langItem.hasOwnProperty(id))
					{
						langItem[id] = val;
					}
				}
				_spokenLanguages.spoken_languages.push(langItem);
			}
			movie.spoken_languages = _spokenLanguages;
		}
		
		///////
		// CHECKS
		///////
		
		private  function checkIds(currentMovieId:int, resultId:int):Boolean
		{
			if(currentMovieId == -1) return true;
			return currentMovieId == resultId;
		}
		
		private  function checkTypes(movie:MDMovieVO, value:Object, id:String):void
		{
			switch(typeof value)
			{
				case "string":
				case "boolean":
				case "number":
					if(movie.hasOwnProperty(id))
					{
						movie[id] = value;
					}
					break;
				case "object":
				case "array":
					switch(id)
					{
						case MDResultConstants.GENRES:
							addGendres(movie, value);
							break;
						case MDResultConstants.SPOKEN_LANGUAGES:
							addSpokenLanguages(movie, value);
							break;
						case MDResultConstants.PRODUCTION_COMPANIES:
							addProductionCompanies(movie, value);
							break;
						case MDResultConstants.PRODUCTION_COUNTRIES:
							addProductionCountries(movie, value);
							break;
						case MDResultConstants.BELONGS_TO_COLLECTION:
							//trace(id);
							break;
					}
					break;
			}
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
		
		private  function clear(vo:Object, clearAll:Boolean = false):void
		{
			//if(vo.hasOwnProperty(ResultConstants.ADULT)) trace(vo[ResultConstants.ADULT]);
			if(clearAll)
			{
				if(vo.hasOwnProperty(MDResultConstants.CAST)) vo[MDResultConstants.CAST] = null;
				if(vo.hasOwnProperty(MDResultConstants.ALTERNATIVE_TITLES)) vo[MDResultConstants.ALTERNATIVE_TITLES] = null;
				if(vo.hasOwnProperty(MDResultConstants.IMAGES)) vo[MDResultConstants.IMAGES] = null;
				if(vo.hasOwnProperty(MDResultConstants.KEYWORDS)) vo[MDResultConstants.KEYWORDS] = null;
				if(vo.hasOwnProperty(MDResultConstants.TRAILERS)) vo[MDResultConstants.TRAILERS] = null;
				if(vo.hasOwnProperty(MDResultConstants.RELEASE_INFO)) vo[MDResultConstants.RELEASE_INFO] = null;
				if(vo.hasOwnProperty(MDResultConstants.TRANSLATIONS)) vo[MDResultConstants.TRANSLATIONS] = null;
				if(vo.hasOwnProperty(MDResultConstants.SIMILAR_MOVIES)) vo[MDResultConstants.SIMILAR_MOVIES] = null;
				if(vo.hasOwnProperty(MDResultConstants.LISTS)) vo[MDResultConstants.LISTS] = null;
				if(vo.hasOwnProperty(MDResultConstants.CHANGES)) vo[MDResultConstants.CHANGES] = null;
				if(vo.hasOwnProperty(MDResultConstants.NOW_PLAYING)) vo[MDResultConstants.NOW_PLAYING] = null;
				if(vo.hasOwnProperty(MDResultConstants.UPCOMING)) vo[MDResultConstants.UPCOMING] = null;
				if(vo.hasOwnProperty(MDResultConstants.POPULAR)) vo[MDResultConstants.POPULAR] = null;
				if(vo.hasOwnProperty(MDResultConstants.COLLECTION)) vo[MDResultConstants.COLLECTION] = null;
				if(vo.hasOwnProperty(MDResultConstants.TOP_RATED)) vo[MDResultConstants.TOP_RATED] = null;
			}
			
			if(vo.hasOwnProperty(MDResultConstants.BACKDROP_PATH)) vo[MDResultConstants.BACKDROP_PATH] = null;
			if(vo.hasOwnProperty(MDResultConstants.BELONGS_TO_COLLECTION)) vo[MDResultConstants.BACKDROP_PATH] = null;
			if(vo.hasOwnProperty(MDResultConstants.BUDGET)) vo[MDResultConstants.BUDGET] = null;
			if(vo.hasOwnProperty(MDResultConstants.GENRES)) vo[MDResultConstants.GENRES] = null;
			if(vo.hasOwnProperty(MDResultConstants.HOMEPAGE)) vo[MDResultConstants.HOMEPAGE] = null;
			if(vo.hasOwnProperty(MDResultConstants.ID)) vo[MDResultConstants.ID] = null;
			if(vo.hasOwnProperty(MDResultConstants.IMDB_ID)) vo[MDResultConstants.IMDB_ID] = null;
			if(vo.hasOwnProperty(MDResultConstants.ORIGINAL_TITLE)) vo[MDResultConstants.ORIGINAL_TITLE] = null;
			if(vo.hasOwnProperty(MDResultConstants.OVERVIEW)) vo[MDResultConstants.OVERVIEW] = null;
			if(vo.hasOwnProperty(MDResultConstants.POPULARITY)) vo[MDResultConstants.POPULARITY] = null;
			if(vo.hasOwnProperty(MDResultConstants.POSTER_PATH)) vo[MDResultConstants.POSTER_PATH] = null;
			if(vo.hasOwnProperty(MDResultConstants.PRODUCTION_COMPANIES)) vo[MDResultConstants.PRODUCTION_COMPANIES] = null;
			if(vo.hasOwnProperty(MDResultConstants.PRODUCTION_COUNTRIES)) vo[MDResultConstants.PRODUCTION_COUNTRIES] = null;
			if(vo.hasOwnProperty(MDResultConstants.RELEASE_DATE)) vo[MDResultConstants.RELEASE_DATE] = null;
			if(vo.hasOwnProperty(MDResultConstants.REVENUE)) vo[MDResultConstants.REVENUE] = null;
			if(vo.hasOwnProperty(MDResultConstants.RUNTIME)) vo[MDResultConstants.RUNTIME] = null;
			if(vo.hasOwnProperty(MDResultConstants.SPOKEN_LANGUAGES)) vo[MDResultConstants.SPOKEN_LANGUAGES] = null;
			if(vo.hasOwnProperty(MDResultConstants.STATUS)) vo[MDResultConstants.STATUS] = null;
			if(vo.hasOwnProperty(MDResultConstants.TAGLINE)) vo[MDResultConstants.TAGLINE] = null;
			if(vo.hasOwnProperty(MDResultConstants.TITLE)) vo[MDResultConstants.TITLE] = null;
			if(vo.hasOwnProperty(MDResultConstants.VOTE_AVERAGE)) vo[MDResultConstants.VOTE_AVERAGE] = null;
			if(vo.hasOwnProperty(MDResultConstants.VOTE_COUNT)) vo[MDResultConstants.VOTE_COUNT] = null;
		}
	}
}

