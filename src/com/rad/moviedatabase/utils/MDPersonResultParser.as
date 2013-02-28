package com.rad.moviedatabase.utils
{
	import com.rad.moviedatabase.events.constants.MDEventTypeConstants;
	import com.rad.moviedatabase.settings.constants.MDResultConstants;
	import com.rad.moviedatabase.vo.movies.cast.MDCastMemberVO;
	import com.rad.moviedatabase.vo.movies.cast.MDCastVO;
	import com.rad.moviedatabase.vo.movies.cast.MDCrewMemberVO;
	import com.rad.moviedatabase.vo.movies.images.MDImageItemVO;
	import com.rad.moviedatabase.vo.people.MDPersonVO;
	import com.rad.moviedatabase.vo.people.images.MDPeopleImagesVO;

	public class MDPersonResultParser
	{
		//private  var _images:MDPeopleImagesVO = new MDPeopleImagesVO();
		//private  var _credits:MDCastVO = new MDCastVO();
		private var _person:MDPersonVO;
		private static const VERBOSE:Boolean = false;

		public function MDPersonResultParser()
		{
			
		}
		
		public  function parsePerson(type:String, result:Object):MDPersonVO
		{
			if(VERBOSE) trace("MD -- Parsing: "+ type + " at ID: " + result['id']);
			_person = new MDPersonVO();
			switch(type)
			{
				case MDEventTypeConstants.PERSON_INFO:
						addValue(_person, result);
					break;
				case MDEventTypeConstants.PERSON_CREDITS:
						addCredits(_person, result);
					break;
				case MDEventTypeConstants.PERSON_IMAGES:
						addImages(_person, result);
					break;
			}
			return _person;
		}
		
		private  function addImages(person:MDPersonVO, result:Object):void
		{
			 var _images:MDPeopleImagesVO = new MDPeopleImagesVO();
			if(_images.profiles) _images.profiles.length = 0;
			addValue(_images, result);
			_images.profiles = parseProfiles(person, result);
			_images.id = result["id"];
			if(_images.id != person.id) person.id = _images.id;
			person.images = _images;
		}	
		
		private  function parseProfiles(movie:MDPersonVO, result:Object):Vector.<MDImageItemVO>
		{
			var postL:int = result["profiles"].length;
			if(postL < 1) return null;
			var posterImage:MDImageItemVO;
			var posters:Vector.<MDImageItemVO> = new Vector.<MDImageItemVO>();
			var val:Object;
			for (var i:int = 0; i < postL; i++) 
			{
				posterImage = new MDImageItemVO();
				for(var postId:String in result["profiles"][i]) 
				{
					val = result["profiles"][i][postId];
					if(posterImage.hasOwnProperty(postId))
					{
						posterImage[postId] = val;
					}
				}
				posters.push(posterImage);
			}
			return posters;
		}
		
		private  function addCredits(person:MDPersonVO, result:Object):void
		{
			 var _credits:MDCastVO = new MDCastVO();
			_credits.cast.length = 0;
			_credits.crew.length = 0;
			addValue(person, result);
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
				_credits.cast.push(castMember);
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
				_credits.crew.push(crewMember);
			}
			_credits.id = result["id"];
			if(_credits.id != person.id) person.id = _credits.id;
			person.credits = _credits;
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