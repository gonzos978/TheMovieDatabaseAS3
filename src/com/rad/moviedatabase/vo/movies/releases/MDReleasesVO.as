package com.rad.moviedatabase.vo.movies.releases
{

	public class MDReleasesVO
	{
		
		public var id:int;
		public var countries:Vector.<MDReleasesItemVO> = new Vector.<MDReleasesItemVO>();
		
		public function MDReleasesVO()
		{
		}
	}
}