package com.rad.moviedatabase.settings
{
	import com.rad.moviedatabase.settings.constants.MDBackdropSizesConstants;
	import com.rad.moviedatabase.settings.constants.MDPosterSizesConstants;
	import com.rad.moviedatabase.settings.constants.MDProfileSizesConstants;

	public class MDSettings
	{
		public static const BASE_URL:String = "http://cf2.imgobject.com/t/p/";	
		
		public static const DEFAULT_BACKDROP_SIZE:String = MDBackdropSizesConstants.WIDTH_780;
		public static const DEFAULT_POSTER_SIZE:String = MDPosterSizesConstants.WIDTH_500;
		public static const DEFAULT_PROFILE_SIZE:String = MDProfileSizesConstants.WIDTH_185;
		
		public var backdrop_size:String;
		public var poster_size:String;
		public var profile_size:String;
		
		public function MDSettings()
		{
			
		}
	}
}