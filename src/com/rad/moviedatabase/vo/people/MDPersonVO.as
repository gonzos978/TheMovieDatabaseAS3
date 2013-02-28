package com.rad.moviedatabase.vo.people
{
	import com.rad.moviedatabase.vo.movies.cast.MDCastVO;
	import com.rad.moviedatabase.vo.people.images.MDPeopleImagesVO;

	public class MDPersonVO
	{
		public var adult:Boolean;
		public var also_known_as:Array;
		public var biography:String;
		public var birthday:String;
		public var deathday:String;
		public var homepage:String;
		public var id:int;
		public var name:String;
		public var place_of_birth:String;
		public var profile_path:String;
		
		public var credits:MDCastVO;
		public var images:MDPeopleImagesVO;

		
		public function MDPersonVO()
		{
		}
	}
}