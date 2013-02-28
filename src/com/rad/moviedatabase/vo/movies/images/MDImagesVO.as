package com.rad.moviedatabase.vo.movies.images
{
	

	public class MDImagesVO
	{
		public var id:int;
		public var backdrops:Vector.<MDImageItemVO> = new Vector.<MDImageItemVO>();
		public var posters:Vector.<MDImageItemVO> = new Vector.<MDImageItemVO>();
		
		public function MDImagesVO()
		{
		}
	}
}