package com.rad.moviedatabase.utils
{
	import com.rad.moviedatabase.events.constants.MDEventTypeConstants;
	import com.rad.moviedatabase.settings.constants.MDResultConstants;
	import com.rad.moviedatabase.vo.list.MDListVO;
	import com.rad.moviedatabase.vo.movies.core.MDMovieItemCoreVO;
	import com.rad.moviedatabase.vo.movies.lists.MDMovieListsVO;

	public class MDListResultParser
	{
		//private  var _images:MDPeopleImagesVO = new MDPeopleImagesVO();
		//private  var _credits:MDCastVO = new MDCastVO();
		private static const VERBOSE:Boolean = false;
		private var _list:MDListVO;

		public function MDListResultParser()
		{
			
		}
		
		public  function parseList(type:String, result:Object):MDListVO
		{
			if(VERBOSE) trace("MD -- Parsing: "+ type + " at ID: " + result['id']);
			_list = new MDListVO();
			switch(type)
			{
				case MDEventTypeConstants.LIST:
						addList(_list, result);
					break;
			}
			return _list;
		}
		
		private  function addList(list:MDListVO, result:Object):void
		{
			addValue(list, result);
			var l:int = result["items"].length;
			var listItem:MDMovieItemCoreVO;
			if(l < 1) return;
			for (var i:int = 0; i < l; i++) 
			{
				listItem = new MDMovieItemCoreVO();
				for(var id:String in result["items"][i]) 
				{
					var val:Object = result["items"][i][id];
					if(listItem.hasOwnProperty(id))
					{
						listItem[id] = val;
					}
				}
				list.items.push(listItem);
			}
			list.id = result["id"];
			_list = list;
		}
		
		///////////////
		// PRIVATES
		///////////////
		///simple vector population
		
		private  function checkIds(currentMovieId:int, resultId:int):Boolean
		{
			return currentMovieId == resultId;
		}
		
		private  function addValue(vo:Object, result:Object):void
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
		
		
		private  function clear(vo:Object):void
		{
			if(vo.hasOwnProperty(MDResultConstants.ADULT)) vo[MDResultConstants.ADULT] = null;
			if(vo.hasOwnProperty(MDResultConstants.ALSO_KNOWN_AS)) vo[MDResultConstants.ALSO_KNOWN_AS] = null;
			if(vo.hasOwnProperty(MDResultConstants.BIOGRAPHY)) vo[MDResultConstants.BIOGRAPHY] = null;
			if(vo.hasOwnProperty(MDResultConstants.BIRTHDAY)) vo[MDResultConstants.BIRTHDAY] = null;
			if(vo.hasOwnProperty(MDResultConstants.DEATHDAY)) vo[MDResultConstants.DEATHDAY] = null;
			if(vo.hasOwnProperty(MDResultConstants.HOMEPAGE)) vo[MDResultConstants.HOMEPAGE] = null;
			if(vo.hasOwnProperty(MDResultConstants.ID)) vo[MDResultConstants.ID] = null;
			if(vo.hasOwnProperty(MDResultConstants.NAME)) vo[MDResultConstants.NAME] = null;
			if(vo.hasOwnProperty(MDResultConstants.PLACE_OF_BIRTH)) vo[MDResultConstants.PLACE_OF_BIRTH] = null;
			if(vo.hasOwnProperty(MDResultConstants.PROFILE_PATH)) vo[MDResultConstants.PROFILE_PATH] = null;
			
			if(vo.hasOwnProperty(MDResultConstants.IMAGES)) vo[MDResultConstants.IMAGES] = null;
			if(vo.hasOwnProperty(MDResultConstants.CREDITS)) vo[MDResultConstants.CREDITS] = null;
		}
	}
}