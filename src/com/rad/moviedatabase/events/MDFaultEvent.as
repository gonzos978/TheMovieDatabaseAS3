package com.rad.moviedatabase.events
{
	import com.rad.moviedatabase.loader.MDServiceFault;
	
	import flash.events.Event;

	public class MDFaultEvent extends Event
	{
	
		public static const FAULT:String = "fault";

		private var _fault:com.rad.moviedatabase.loader.MDServiceFault;
	
		public function get fault():MDServiceFault{ return _fault; }

		private var _serviceType:String;
		
		private var _data:Object;
	
		public function get serviceType():String { return _serviceType; }
		
		public function get data():Object { return _data; }
	
		public function MDFaultEvent(type:String, fault:MDServiceFault = null, serviceType:String = null, data:Object = null)
		{
			super(type);
			_fault = fault;
			_serviceType = serviceType;
			_data = data;
		}

		override public function clone():Event
		{
			return new MDFaultEvent(type, fault, serviceType, data);
		}

	}
}