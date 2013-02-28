package com.rad.moviedatabase.vo.list
{
	import com.rad.moviedatabase.vo.movies.core.MDMovieItemCoreVO;
	

	public class MDListVO
	{
		public var created_by :String;
		public var description : String;
		public var favorite_count : int;
		public var id : String;
		public var items : Vector.<MDMovieItemCoreVO> = new Vector.<MDMovieItemCoreVO>; 
		public var item_count: int;
		public var iso_639_1 : String;
		public var name : String;
		public var poster_path : String;

		
		public function MDListVO()
		{
		}
	}
}