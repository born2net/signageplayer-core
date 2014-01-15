package com.codeofdoom.events
{
	import com.google.maps.overlays.Marker;
	
	import flash.events.Event;

	public class InfoWindowClosedEvent extends Event
	{
		public static const NAME:String = "com.codeofdoom.events.InfoWindowClosedEvent";
		private var _inputName:String;
		private var _marker:Marker;
		public function InfoWindowClosedEvent(inputName:String)
		{
			_inputName = inputName;
			super(NAME);
		}
		
		public function get inputName():String{
			return _inputName;
		}
		public function set marker(marker:Marker):void{
			_marker = marker;
		}
		public function get marker():Marker{
			return _marker;
		}
		
		
	}
}