package com.rad.moviedatabase.loader
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MDLoader extends URLLoader
	{
		public var url:String;
		public var type:String;
		public var httpStatus:int;
		public var returnType:String;
	}
}