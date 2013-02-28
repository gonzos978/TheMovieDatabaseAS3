package com.rad.moviedatabase.events
{
	import flash.events.Event;
	
	public class MDResultEvent extends Event
	{
		public static const TOKEN_RESULT:String = "tokenResult";
		public static const SESSION_RESULT:String = "sessionResult";

		public static const ACCOUNT_RESULT:String = "accountResult";
		public static const GENRE_RESULT:String = "genreResult";
		public static const MOVIE_RESULT:String = "movieResult";
		public static const LIST_RESULT:String = "listResult";
		public static const PEOPLE_RESULT:String = "peopleResult";
		public static const SEARCH_RESULT:String = "searchResult";

		private var _result:Object;
		private var _eventType:String;
		
		public function MDResultEvent(type:String, eventType:String, result:Object = null)
		{
			super(type,bubbles, cancelable);
			_result = result;
			_eventType = eventType;
		}
		
		public function get eventType():String
		{
			return _eventType;
		}

		public function get result():Object
		{
			return _result;
		}
		
		override public function clone():Event
		{
			return new MDResultEvent(type, eventType, result);
		}
	}
}