package com.rad.moviedatabase.vo.movies.collection
{
	import com.rad.moviedatabase.vo.movies.core.MDMovieItemCoreVO;
	import com.rad.moviedatabase.vo.movies.images.MDImageItemVO;

	public class MDCollectionVO
	{
		public var backdrop_path:String;
		public var id:int;
		public var name:String;
		public var parts:Vector.<MDMovieItemCoreVO> = new Vector.<MDMovieItemCoreVO>();
		public var backdrops:Vector.<MDImageItemVO> = new Vector.<MDImageItemVO>();
		public var posters:Vector.<MDImageItemVO> = new Vector.<MDImageItemVO>();
		
		public function MDCollectionVO()
		{
		}
	}
}