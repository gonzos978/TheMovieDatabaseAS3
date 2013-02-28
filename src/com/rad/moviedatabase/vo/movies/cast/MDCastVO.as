package com.rad.moviedatabase.vo.movies.cast
{
	public class MDCastVO
	{
		public var id:int;
		public var cast:Vector.<MDCastMemberVO> = new Vector.<MDCastMemberVO>();
		public var crew:Vector.<MDCrewMemberVO> = new Vector.<MDCrewMemberVO>();
		
		public function MDCastVO()
		{
		}
	}
}