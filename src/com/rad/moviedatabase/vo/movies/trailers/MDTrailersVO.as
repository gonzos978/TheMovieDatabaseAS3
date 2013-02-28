package com.rad.moviedatabase.vo.movies.trailers
{

	public class MDTrailersVO
	{
		public var id:int;
		public var quicktime:Vector.<MDTrailerItemVO> = new Vector.<MDTrailerItemVO>();
		public var youtube:Vector.<MDTrailerItemVO> = new Vector.<MDTrailerItemVO>();
		
		public function MDTrailersVO()
		{
		}
	}
}