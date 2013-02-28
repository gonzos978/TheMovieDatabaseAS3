package com.rad.moviedatabase.utils
{
	import com.rad.moviedatabase.events.constants.MDEventTypeConstants;
	import com.rad.moviedatabase.vo.genre.MDGenreVO;
	import com.rad.moviedatabase.vo.movies.core.MDMovieItemCoreVO;

	public class MDGenreResultParser
	{
		private static const VERBOSE:Boolean = false;
		private var _genre:MDGenreVO;

		public function MDGenreResultParser()
		{
		}
		
		public function parseGenre(type:String, result:Object):MDGenreVO
		{
			_genre = new MDGenreVO();
			if(VERBOSE)trace("MD -- Parsing: "+ type+ " - Genres id: " + result["id"]);
			_genre.id = result['id'];
			switch(type)
			{
				case MDEventTypeConstants.GENRE_MOVIES:
					addGenreMovieList(_genre, result);
					break;
			}
			return _genre;
		}
		
		private  function addGenreMovieList(genres:MDGenreVO, result:Object):void
		{
			addValue(genres, result);
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
				genres.results.push(item);
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
	}
}