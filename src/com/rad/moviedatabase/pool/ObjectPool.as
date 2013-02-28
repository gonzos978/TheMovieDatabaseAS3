package com.rad.moviedatabase.pool {
	import flash.utils.Dictionary;

	/**
	 * @author ian
	 */
	public final class ObjectPool {
		
		/**
		 * ObjectPool - generic pool of object pools that handles different class types 
		 */
		 
		/**
		 * _pools 
		 */
		private static var _pools : Dictionary = new Dictionary();
		
		/**
		 * getPool - return existing pool or create a new one
		 * 
		 * @param clazz 
		 * 
		 * @return Array
		 */
		private static function getPool(clazz : Class) : Array {
			return clazz in _pools ? _pools[clazz] : _pools[clazz] = [];
		}
		
		/**
		 * get an object from the pool or create a new one of empty 
		 * 
		 * @param clazz 
		 * 
		 * @return Object
		 */
		public static function get(clazz : Class) : * {
			var pool : Array = getPool(clazz);
			if ( pool.length > 0 ) {
				return pool.pop();
			} else {
				return new clazz();
			}
		}
		
		/**
		 * dispose - put it back for reuse 
		 * 
		 * @param object 
		 * 
		 * @return void
		 */
		public static function dispose(object : Object) : void {
			var type : Class = object.constructor as Class;
			var pool : Array = getPool(type);
			pool[pool.length] = object;
		}
		
		/**
		 * fill - pre-fill the object pool with instances 
		 * 
		 * @param clazz 
		 * @param count 
		 * 
		 * @return void
		 */
		public static function fill(clazz : Class, count: uint) : void {
			var pool : Array = getPool(clazz);
			while ( pool.length < count ) {
				pool[pool.length] = new clazz();
			}
		}
		
		/**
		 * empty - discard all the pools
		 * 
		 * @return void
		 */
		public static function empty() : void {
			_pools = new Dictionary();
		}
		
		/**
		 * pools - get the pools dict 
		 */
		public static function get pools() : Dictionary {
			return _pools;
		}
	}
}