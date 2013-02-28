package com.rad.moviedatabase.utils
{
	import com.rad.moviedatabase.events.constants.MDEventTypeConstants;
	import com.rad.moviedatabase.settings.constants.MDResultConstants;
	import com.rad.moviedatabase.vo.movies.core.MDCoreVO;
	import com.rad.moviedatabase.vo.movies.core.MDMovieItemCoreVO;
	import com.rad.moviedatabase.vo.movies.lists.MDMovieListItemVO;
	import com.rad.moviedatabase.vo.search.MDSearchVO;
	import com.rad.moviedatabase.vo.search.collection.MDSearchCollectionVO;
	import com.rad.moviedatabase.vo.search.company.MDSearchCompanyItemVO;
	import com.rad.moviedatabase.vo.search.company.MDSearchCompanyVO;
	import com.rad.moviedatabase.vo.search.keyword.MDSearchKeywordVO;
	import com.rad.moviedatabase.vo.search.list.MDSearchListVO;
	import com.rad.moviedatabase.vo.search.movie.MDSearchMovieVO;
	import com.rad.moviedatabase.vo.search.person.MDSearchPersonItemVO;
	import com.rad.moviedatabase.vo.search.person.MDSearchPersonVO;

	public class MDSearchResultParser
	{
		//private static var _movie:MDSearchMovieVO = new MDSearchMovieVO();
		//private static var _collection:MDSearchCollectionVO = new MDSearchCollectionVO();
		//private static var _person:MDSearchPersonVO = new MDSearchPersonVO();
		//private static var _company:MDSearchCompanyVO = new MDSearchCompanyVO();
		//private static var _list:MDSearchListVO = new MDSearchListVO();
		//private static var _keyword:MDSearchKeywordVO = new MDSearchKeywordVO();
		
		private var _search:MDSearchVO;
		
		public function MDSearchResultParser()
		{
			
		}
		
		public function parseSearch(type:String, result:Object):MDSearchVO
		{
			_search = new MDSearchVO();
			switch(type)
			{
				case MDEventTypeConstants.SEARCH_BY_TITLE:
					addMovie(_search, result);
					break;
				case MDEventTypeConstants.SEARCH_BY_COLLECTION:
					addCollection(_search, result);
					break;
				case MDEventTypeConstants.SEARCH_BY_PEOPLE:
					addPerson(_search, result);
					break;
				case MDEventTypeConstants.SEARCH_BY_COMPANY:
					addCompany(_search, result);
					break;
				case MDEventTypeConstants.SEARCH_BY_LIST:
					addList(_search, result);
					break;
				case MDEventTypeConstants.SEARCH_BY_KEYWORD:
					addKeyword(_search, result);
					break;
			}
			return _search;
		}
		
		private function addKeyword(search:MDSearchVO, result:Object):void
		{
			var _keyword:MDSearchKeywordVO = new MDSearchKeywordVO();
			addValue(_keyword, result);
			var l:int = result["results"].length;
			var item:MDCoreVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				item = new MDCoreVO();
				for(var id:String in result["results"][i]) 
				{
					var val:Object = result["results"][i][id];
					if(item.hasOwnProperty(id))
					{
						item[id] = val;
					}
				}
				_keyword.results.push(item);
			}
			search.keyword = _keyword;
		}
		
		private function addList(search:MDSearchVO, result:Object):void
		{
			var _list:MDSearchListVO = new MDSearchListVO();
			addValue(_list, result);
			var l:int = result["results"].length;
			var item:MDMovieListItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				item = new MDMovieListItemVO();
				for(var id:String in result["results"][i]) 
				{
					var val:Object = result["results"][i][id];
					if(item.hasOwnProperty(id))
					{
						item[id] = val;
					}
				}
				_list.results.push(item);
			}
			search.list = _list;
		}	
		
		private function addCompany(search:MDSearchVO, result:Object):void
		{
			var _company:MDSearchCompanyVO = new MDSearchCompanyVO();
			addValue(_company, result);
			var l:int = result["results"].length;
			var item:MDSearchCompanyItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				item = new MDSearchCompanyItemVO();
				for(var id:String in result["results"][i]) 
				{
					var val:Object = result["results"][i][id];
					if(item.hasOwnProperty(id))
					{
						item[id] = val;
					}
				}
				_company.results.push(item);
			}
			search.company = _company;
		}	
		
		private function addPerson(search:MDSearchVO, result:Object):void
		{
			var _person:MDSearchPersonVO = new MDSearchPersonVO();
			addValue(_person, result);
			var l:int = result["results"].length;
			var item:MDSearchPersonItemVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				item = new MDSearchPersonItemVO();
				for(var id:String in result["results"][i]) 
				{
					var val:Object = result["results"][i][id];
					if(item.hasOwnProperty(id))
					{
						item[id] = val;
					}
				}
				_person.results.push(item);
			}
			search.person = _person;
		}	
		
		private function addCollection(search:MDSearchVO, result:Object):void
		{
			var _collection:MDSearchCollectionVO = new MDSearchCollectionVO();
			addValue(_collection, result);
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
				_collection.results.push(item);
			}
			search.collection = _collection;
		}		
		
		
		private function addMovie(search:MDSearchVO, result:Object):void
		{
			 var _movie:MDSearchMovieVO = new MDSearchMovieVO();
			addValue(_movie, result);
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
				_movie.results.push(item);
			}
			search.movie = _movie;
		}	
		
		
		///////////////
		// PRIVATES
		///////////////
		///simple vector population
		
		private function checkIds(currentMovieId:int, resultId:int):Boolean
		{
			return currentMovieId == resultId;
		}
		
		private function addValue(vo:Object, result:Object):void
		{
			for(var j:String in result) {
				var value:Object = result[j];
				switch(typeof value)
				{
					case "string":
					case "boolean":
					case "number":
					case "array":
						if(vo.hasOwnProperty(j))
						{
							vo[j] = value;
						}
						break;
				}
			}
		}
		
		
		private function clear(vo:Object):void
		{
			if(vo.hasOwnProperty(MDResultConstants.MOVIE)) vo[MDResultConstants.MOVIE] = null;
			if(vo.hasOwnProperty(MDResultConstants.COLLECTION)) vo[MDResultConstants.COLLECTION] = null;
			if(vo.hasOwnProperty(MDResultConstants.PERSON)) vo[MDResultConstants.PERSON] = null;
			if(vo.hasOwnProperty(MDResultConstants.LIST)) vo[MDResultConstants.LIST] = null;
			if(vo.hasOwnProperty(MDResultConstants.COMPANY)) vo[MDResultConstants.COMPANY] = null;
			if(vo.hasOwnProperty(MDResultConstants.KEYWORD)) vo[MDResultConstants.KEYWORD] = null;
		}
	}
}