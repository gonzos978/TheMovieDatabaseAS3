package com.rad.moviedatabase.vo.movies.now_playing
{
	import com.rad.moviedatabase.vo.movies.core.MDMovieCoreVO;

	public class MDNowPlayingVO
	{
		public var page:int;
		public var total_pages:int;
		public var total_results:int;
		public var results:Vector.<MDMovieCoreVO> = new Vector.<MDMovieCoreVO>();
		
		public function MDNowPlayingVO()
		{
		}
	}
}