package com.rad.moviedatabase.vo.people.images
{
	import com.rad.moviedatabase.vo.movies.images.MDImageItemVO;

	public class MDPeopleImagesVO
	{
		public var id:int;
		public var profiles:Vector.<MDImageItemVO> = new Vector.<MDImageItemVO>();
		
		public function MDPeopleImagesVO()
		{
		}
	}
}