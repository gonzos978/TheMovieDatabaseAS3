package com.rad.moviedatabase.vo.movies
{
	import com.rad.moviedatabase.vo.movies.alternative_titles.MDAlternativeTitlesVO;
	import com.rad.moviedatabase.vo.movies.cast.MDCastVO;
	import com.rad.moviedatabase.vo.movies.changes.MDChangesVO;
	import com.rad.moviedatabase.vo.movies.core.MDMovieCoreVO;
	import com.rad.moviedatabase.vo.movies.genre.MDMovieGenreVO;
	import com.rad.moviedatabase.vo.movies.images.MDImagesVO;
	import com.rad.moviedatabase.vo.movies.keywords.MDKeywordsVO;
	import com.rad.moviedatabase.vo.movies.languages.MDSpokenLanguagesVO;
	import com.rad.moviedatabase.vo.movies.lists.MDMovieListsVO;
	import com.rad.moviedatabase.vo.movies.production_companies.MDProductionCompaniesVO;
	import com.rad.moviedatabase.vo.movies.production_countries.MDProductionCountriesVO;
	import com.rad.moviedatabase.vo.movies.releases.MDReleasesVO;
	import com.rad.moviedatabase.vo.movies.similar_movies.MDSimilarMoviesVO;
	import com.rad.moviedatabase.vo.movies.trailers.MDTrailersVO;
	import com.rad.moviedatabase.vo.movies.translations.MDTranslationsVO;
	import com.rad.moviedatabase.vo.movies.collection.MDCollectionVO;

	public class MDMovieVO
	{
		public var adult:Boolean;
		public var backdrop_path:String;
		//public var belongs_to_collection:*;
		public var budget:int;
		public var genres:MDMovieGenreVO;
		public var homepage:String;
		public var id:int = -1;
		public var imdb_id:String;
		public var overview:String;
		public var popularity:Number;
		public var poster_path:String;
		public var production_companies:MDProductionCompaniesVO;
		public var production_countries:MDProductionCountriesVO;
		public var release_date:String;
		public var revenue:int;
		public var runtime:int;
		public var spoken_languages:MDSpokenLanguagesVO;
		public var status:String;
		public var tagline:String;
		public var original_title:String;
		public var title:String;
		public var vote_average:int;
		public var vote_count:int;
		public var alternative_titles:MDAlternativeTitlesVO;
		
		public var cast:MDCastVO;
		public var images:MDImagesVO;
		public var keywords:MDKeywordsVO;
		public var releaseInfo:MDReleasesVO;
		public var trailers:MDTrailersVO;
		public var translations:MDTranslationsVO;
		public var similar_movies:MDSimilarMoviesVO;
		public var lists:MDMovieListsVO;
		public var changes:MDChangesVO;
		public var now_playing:MDMovieCoreVO;
		public var upcoming:MDMovieCoreVO;
		public var collection:MDCollectionVO;
		public var popular:MDMovieCoreVO;
		public var top_rated:MDMovieCoreVO;
		
		public function MDMovieVO()
		{
			
		}
	}
}

