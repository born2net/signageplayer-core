package de.danielyan.twitterAppOnly 
{
	import com.hurlant.crypto.tls.TLSSocket;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import com.hurlant.util.Base64;

	public class TwitterSocket extends EventDispatcher
	{
		
		public static var EVENT_TWITTER_READY:String="EVENT_TWITTER_READY";
		public static var EVENT_TWITTER_RESPONSE:String="EVENT_TWITTER_RESPONSE";
		
		private var _socket:TLSSocket;
		private var _isResponseValid:Boolean=false;
		private var _accessToken:String;
		private var _consumerKey:String;
		private var _consumerSecret:String;
		private var _pendingRequest:String;
		private var _output:String;
		private var _length:int;

		/** 
		 * Read more about Application-Only authentication here:
		 * https://dev.twitter.com/docs/auth/oauth#v1-1
		 * and here:
		 * https://dev.twitter.com/docs/auth/application-only-auth
		 */
		public function TwitterSocket(consumerKey:String, consumerSecret:String)
		{
			_consumerKey = consumerKey;
			_consumerSecret = consumerSecret;
			_isResponseValid = false;
			
			try
			{
				_socket = new TLSSocket();
				_socket.addEventListener(Event.CONNECT,onConnect);
				_socket.addEventListener(ProgressEvent.SOCKET_DATA,onData);
				_socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
				_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				_socket.addEventListener(Event.CLOSE, onClose);
				_socket.connect("api.twitter.com",443);
			}
			catch(e:Error)
			{
				trace(e.toString());
			}
		}
		
		/**
		 * Twitter Request url
		 * supply the url without the domain name:
		 * i.e. /1.1/statuses/user_timeline.json?count=100&screen_name=twitter 
		 */
		public function request(path:String):void
		{
			_pendingRequest = path;
			if (!_socket.connected)
			{
				_socket.connect("api.twitter.com",443);
			}
			else
			{
				sendRequest();
			}
		}
		
		private function sendRequest():void
		{
			if(_pendingRequest != null)
			{				
				var requestData:String = "GET "+_pendingRequest+" HTTP/1.1\n"+
					"Host: api.twitter.com\n"+
					"User-Agent: AS3 Twitter Lib v1.0\n" +
					"Authorization: Bearer " + _accessToken + "\n";
					"Accept-Encoding:\r\n";
				_socket.writeUTFBytes(requestData);			
				_socket.writeUTFBytes("\r\n");			
				_socket.flush();
				
				_pendingRequest = null;
			}
		}
		
		private function onClose(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function onError(event:Event):void
		{
			dispatchEvent(event);
		}		
		
		private function onConnect(event:Event):void
		{
			if (_accessToken == null)
			{
				_isResponseValid=false;
				var bearerToken:String = Base64.encode(_consumerKey + ':' + _consumerSecret);
				bearerToken = bearerToken.replace('\n','');
				
				var requestAccessToken:String = "POST /oauth2/token HTTP/1.1\n" +
					"Host: api.twitter.com\n" +
					"User-Agent: AS3 Twitter Lib v1.0\n" +
					"Authorization: Basic " + bearerToken + "\n"+ 
					"Content-Type: application/x-www-form-urlencoded;charset=UTF-8\n"+
					"Content-Length: 29\n" +
					"Accept-Encoding:\n\n" +
					"grant_type=client_credentials\n";
				_socket.writeUTFBytes(requestAccessToken);			
			}
			else if (_pendingRequest != null)
			{
				sendRequest();
			}

		}
		
		private function onData(event:ProgressEvent):void
		{
			var output:String = _socket.readUTFBytes(_socket.bytesAvailable);
			if (output.indexOf("HTTP/1.1 200 OK") != -1)
			{
				_isResponseValid = true;
				var results:Array = output.match(/content-length: (.*)/);
				_length = results[1];
				_output = "";
				return;
			}
			if (output.indexOf("HTTP/1.1 404") != -1)
			{
				trace("TwitterSocket: 404 Page not found");
			}

			if (_isResponseValid)
			{
				_length -= output.length;
				_output += output;
				if (_length <= 0)
				{
					if (_accessToken == null)
					{
						var json:Object = JSON.parse(_output);
						_accessToken = json.access_token;
						dispatchEvent(new Event(EVENT_TWITTER_READY));
					}
					else
					{
						var response:TwitterSocketEvent = new TwitterSocketEvent();					
						response.response = JSON.parse(_output);
						dispatchEvent(response);
					}
					_isResponseValid=false;
					_output = "";
				}
			}			
		}
	}
}