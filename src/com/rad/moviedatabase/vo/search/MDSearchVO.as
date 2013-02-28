package com.rad.moviedatabase.vo.search
{
	import com.rad.moviedatabase.vo.search.movie.MDSearchMovieVO;
	import com.rad.moviedatabase.vo.search.collection.MDSearchCollectionVO;
	import com.rad.moviedatabase.vo.search.person.MDSearchPersonVO;
	import com.rad.moviedatabase.vo.search.company.MDSearchCompanyVO;
	import com.rad.moviedatabase.vo.search.list.MDSearchListVO;
	import com.rad.moviedatabase.vo.search.keyword.MDSearchKeywordVO;

	public class MDSearchVO
	{
		public var movie:MDSearchMovieVO;
		public var collection:MDSearchCollectionVO;
		public var person:MDSearchPersonVO;
		public var company:MDSearchCompanyVO;
		public var list:MDSearchListVO;
		public var keyword:MDSearchKeywordVO;
		
		public function MDSearchVO()
		{
		}
	}
}