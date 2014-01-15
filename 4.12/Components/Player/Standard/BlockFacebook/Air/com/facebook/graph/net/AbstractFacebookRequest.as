/*
Copyright (c) 2010, Adobe Systems Incorporated
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of Adobe Systems Incorporated nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.facebook.graph.net {
	
	import com.adobe.images.PNGEncoder;
	//import com.adobe.serialization.json.JSON;
	import com.facebook.graph.utils.PostRequest;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	/**
	 * Base class used when making requests to the graph API.
	 */
	public class AbstractFacebookRequest {
		
		/**
		 * @private
		 */
		protected var urlLoader:URLLoader;
		
		/**
		 * @private
		 */
		protected var urlRequest:URLRequest;
		
		/**
		 * @private
		 */
		protected var _rawResult:String;
		
		/**
		 * @private
		 *
		 */
		protected var _data:Object;
		
		/**
		 * @private
		 *
		 */
		protected var _success:Boolean;
		
		/**
		 * @private
		 *
		 */
		protected var _url:String;
		
		/**
		 * @private
		 *
		 */
		protected var _requestMethod:String;
		
		/**
		 * @private
		 *
		 */
		protected var _callback:Function;
		
		/**
		 * Instantiates a new FacebookRequest.
		 *
		 * @param url The URL to request data from.
		 * Usually will be https://graph.facebook.com.
		 * @param requestMethod The URLRequestMethod
		 * to be used for this request.
		 * <ul>
		 *	<li>GET for retrieving data (Default)</li>
		 * 	<li>POST for publishing data</li>
		 * 	<li>DELETE for deleting objects (AIR only)</li>
		 * </ul>
		 * @param callback Method to call when this request is complete.
		 * The signaure of the handler must be callback(request:FacebookRequest);
		 * Where request will be a reference to this request.
		 */
		public function AbstractFacebookRequest():void {
			
		}
		
		/**
		 * Returns the un-parsed result from Facebook.
		 * Usually this will be a JSON formatted string.
		 *
		 */
		public function get rawResult():String {
			return _rawResult;
		}
		
		/**
		 * Returns true if this request was successful,
		 * or false if an error occurred.
		 * If success == true, the data property will be the corresponding
		 * decoded JSON data returned from facebook.
		 *
		 * If success == false, the data property will either be the error
		 * from Facebook, or the related ErrorEvent.
		 *
		 */
		public function get success():Boolean {
			return _success;
		}
		
		/**
		 * Any resulting data returned from Facebook.
		 * @see #success
		 *
		 */
		public function get data():Object {
			return _data;
		}
		
		public function callURL(callback:Function, url:String = "", locale:String = null):void {			
			_callback = callback;
			urlRequest = new URLRequest(url.length ? url : _url);
			
			if (locale) {
				var data:URLVariables = new URLVariables();
				data.locale = locale;
				urlRequest.data = data;
			}
			loadURLLoader();
		}
		
		public function set successCallback(value:Function):void {
			_callback = value;
		}
		
		protected function isValueFile(value:Object):Boolean {
			return (value is FileReference || value is Bitmap || value is BitmapData || value is ByteArray);
		}
		
		protected function objectToURLVariables(values:Object):URLVariables {
			var urlVars:URLVariables = new URLVariables();
			if (values == null) {
				return urlVars;
			}
			
			for (var n:String in values) {
				urlVars[n] = values[n];
			}
			
			return urlVars;
		}
		
		/**
		 * Cancels the current request.
		 */
		public function close():void {
			if (urlLoader != null) {
				urlLoader.removeEventListener(
					Event.COMPLETE,
					handleURLLoaderComplete
				);
				
				urlLoader.removeEventListener(
					IOErrorEvent.IO_ERROR,
					handleURLLoaderIOError
				);
				
				urlLoader.removeEventListener(
					SecurityErrorEvent.SECURITY_ERROR,
					handleURLLoaderSecurityError
				);
				
				try {
					urlLoader.close();
				} catch (e:*) { }
				
				urlLoader = null;
			}
		}
		
		/**
		 * @private
		 *
		 */
		protected function loadURLLoader():void {
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleURLLoaderComplete, false, 0, false);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleURLLoaderIOError, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleURLLoaderSecurityError, false, 0, true);
			urlLoader.load(urlRequest);
		}
		
		/**
		 * @private
		 *
		 */
		protected function handleURLLoaderComplete(event:Event):void {
			handleDataLoad(urlLoader.data);
		}
		
		/**
		 * @private
		 *
		 */
		protected function handleDataLoad(result:Object, dispatchCompleteEvent:Boolean = true):void {
			
			_rawResult = result as String;
			_success = true;
			
			try {
				_data = JSON.parse(_rawResult); // decode
			} catch (e:*) {
				_data = _rawResult;
				_success = false;
			}
			
			handleDataReady();
			
			if (dispatchCompleteEvent) {
				dispatchComplete();
			}
		}
		
		/**
		 * @private
		 * 
		 * Called after the loaded data is parsed but before complete is dispatched
		 */
		protected function handleDataReady():void {
			
		}
		
		/**
		 * @private
		 *
		 */
		protected function dispatchComplete():void {
			if (_callback != null) { _callback(this); }
			close();
		}
		
		/**
		 * @private
		 * Facebook will return a 500 Internal ServerError
		 * when a Graph request fails,
		 * with JSON data attached explaining the error.
		 */
		protected function handleURLLoaderIOError(event:IOErrorEvent):void {
			_success = false;
			_rawResult = (event.target as URLLoader).data;
			
			if (_rawResult != '') {
				try {
					_data = JSON.parse(_rawResult); // decode
				} catch (e:*) {
					_data = {type:'Exception', message:_rawResult};
				}
			} else {
				_data = event;
			}
			
			dispatchComplete();
		}
		
		/**
		 * @private
		 */
		protected function handleURLLoaderSecurityError(event:SecurityErrorEvent):void {
			_success = false;
			_rawResult = (event.target as URLLoader).data;
			
			try {
				_data = JSON.parse((event.target as URLLoader).data); // decode
			} catch (e:*) {
				_data = event;
			}
			
			dispatchComplete();
		}
		
		protected function extractFileData(values:Object):Object {
			if (values == null) { return null; }
			
			//Check to see if there is a file we can upload.
			var fileData:Object;
			if (isValueFile(values)) {
				fileData = values;
			} else if (values != null) {
				for (var n:String in values) {
					if (isValueFile(values[n])) {
						fileData = values[n];
						delete values[n];
						break;
					}
				}
			}
			
			return fileData;
		}
		
		protected function createUploadFileRequest(fileData:Object, values:Object = null):PostRequest {
			var post:PostRequest = new PostRequest();
			
			//Write the primitive values first, if they exist
			if (values) {
				for (var n:String in values) {
					post.writePostData(n, values[n]);
				}
			}
			
			//If we have a Bitmap, extract its BitmapData for upload.
			if (fileData is Bitmap) {
				fileData = (fileData as Bitmap).bitmapData;
			}
			
			if (fileData is ByteArray) {
				//If we have a ByteArray, upload as is.
				post.writeFileData(values.fileName,
					fileData as ByteArray,
					values.contentType
				);
				
			} else if (fileData is BitmapData) {
				//If we have a BitmapData, create a ByteArray, then upload.
				var ba:ByteArray = PNGEncoder.encode(fileData as BitmapData);
				post.writeFileData(values.fileName, ba, 'image/png');
			}
			
			post.close();
			urlRequest.contentType =
				'multipart/form-data; boundary='
				+ post.boundary;
			
			return post;
		}
		
		/**
		 * @return Returns the current request URL
		 * and any parameters being used.
		 *
		 */
		public function toString():String {
			return urlRequest.url + (urlRequest.data == null? '':'?' + unescape(urlRequest.data.toString()));
		}
	}
}