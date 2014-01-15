package de.danielyan.twitterAppOnly 
{
	import flash.events.Event;

	public class TwitterSocketEvent extends Event
	{
		public var response:Object;
		
		public function TwitterSocketEvent()
		{
			super(TwitterSocket.EVENT_TWITTER_RESPONSE);
		}
		
	}
}