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
	import com.facebook.graph.core.FacebookURLDefaults;
	import com.facebook.graph.data.Batch;
	import com.facebook.graph.data.BatchItem;
	import com.facebook.graph.utils.PostRequest;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	/**
	 * Formats and sends off a batch request to facebook
	 * @see com.facebook.graph.data.Batch
	 * 
	 */
	public class FacebookBatchRequest extends AbstractFacebookRequest {
		
		/**
		 * @private
		 *
		 */
		protected var _params:Object;

		/**
		 * @private
		 *
		 */
		protected var _relativeURL:String;

		/**
		 * @private
		 *
		 */
		protected var _fileData:Object;

		/**
		 * @private
		 *
		 */
		protected var _accessToken:String;
		
		/**
		 * @private
		 *
		 */
		protected var _batch:Batch;
		
		public function FacebookBatchRequest(batch:Batch, completeCallback:Function = null) {
			_batch = batch;
			_callback = completeCallback;
		}
		
		/**
		 * Called by AbstractFacebook to send a new batch request to facebook.
		 * 
		 * @param accessToken The current access token is use by the API.
		 * 
		 */
		public function call(accessToken:String):void {
			_accessToken = accessToken;
			
			urlRequest = new URLRequest(FacebookURLDefaults.GRAPH_URL);
			urlRequest.method = URLRequestMethod.POST;
			
			var formatted:Array = [];
			var files:Array = [];
			var hasFiles:Boolean = false;
			
			var requests:Array = _batch.requests;
			
			var l:uint = requests.length;
			for (var i:uint=0;i<l;i++) {
				var request:BatchItem = requests[i];
				var fileData:Object = this.extractFileData(request.params);
				var params:Object = {method:request.requestMethod, relative_url:request.relativeURL};
				
				if (request.params) {
					if (request.params['contentType'] != undefined) {
						params.contentType = request.params['contentType'];
					}
					var urlVars:String = this.objectToURLVariables(request.params).toString();
					if (request.requestMethod == URLRequestMethod.GET || request.requestMethod.toUpperCase() == "DELETE") {
						params.relative_url += "?" + urlVars;
					} else {
						params.body = urlVars;
					}
				}
				
				formatted.push(params);
				
				if (fileData) {
					files.push(fileData);
					params.attached_files = request.params.fileName == null?'file'+i:request.params.fileName;
					hasFiles = true;
				} else {
					files.push(null);
				}
			}
			
			//No files, just make a normal request
			if (!hasFiles) {
				var requestVars:URLVariables = new URLVariables();
				requestVars.access_token = accessToken;
				requestVars.batch = JSON.stringify(formatted); // encode
				
				urlRequest.data = requestVars;
				
				loadURLLoader();
			} else { //We have atleast one file, create a PostRequest and send it off.
				sendPostRequest(formatted, files);
			}
		}
		
		protected function sendPostRequest(requests:Array, files:Array):void {
			var post:PostRequest = new PostRequest();
			post.writePostData('access_token', _accessToken);
			post.writePostData('batch', JSON.stringify(requests)); // encode
			
			var l:uint = requests.length;
			
			for (var i:uint=0;i<l;i++) {
				var values:Object = requests[i];
				
				//See if this request has a file
				var fileData:Object = files[i];
				if (fileData) {
					//If we have a Bitmap, extract its BitmapData for upload.
					if (fileData is Bitmap) {
						fileData = (fileData as Bitmap).bitmapData;
					}
					
					if (fileData is ByteArray) {
						//If we have a ByteArray, upload as is.
						post.writeFileData(values.attached_files, fileData as ByteArray, values.contentType);
					} else if (fileData is BitmapData) {
						//If we have a BitmapData, create a ByteArray, then upload.
						var ba:ByteArray = PNGEncoder.encode(fileData as BitmapData);
						post.writeFileData(values.attached_files, ba, 'image/png');
					}
				}
			}
			
			post.close();
			
			urlRequest.contentType = 'multipart/form-data; boundary=' + post.boundary;
			urlRequest.data = post.getPostData();
			
			loadURLLoader();
		}
		
		override protected function handleDataReady():void {
			var results:Array = _data as Array;
			var l:uint = results.length;
			
			for (var i:uint=0;i<l;i++) {
				//We need to decode the nested body data before passing it back.
				var body:Object = JSON.parse(_data[i].body); // decode
				_data[i].body = body;
				
				//If this batch has its own callback, call it now, and pass the data to it.
				if ((_batch.requests[i] as BatchItem).callback != null) {
					(_batch.requests[i] as BatchItem).callback(_data[i]);
				}
			}
		}
	}
}