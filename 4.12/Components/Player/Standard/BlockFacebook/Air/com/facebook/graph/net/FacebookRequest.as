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
	
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

    /**
    * Main class to send requests to the Facebook API.
    */
    public class FacebookRequest extends AbstractFacebookRequest {
		
		/**
		 * @private
		 */
		protected var fileReference:FileReference;
		
		public function FacebookRequest():void {
			super();
		}
		
		/**
		 * Makes a request to the Facebook Graph API.
		 */
		public function call(url:String, requestMethod:String = 'GET', callback:Function = null, values:* = null):void {
			
			_url = url;
			_requestMethod = requestMethod;
			_callback = callback;
			
			var requestUrl:String = url;
			
			urlRequest = new URLRequest(requestUrl);
			urlRequest.method = _requestMethod;
			
			//If there are no user defined values, just send the request as is.
			if (values == null) {
				loadURLLoader();
				return;
			}
			
			var fileData:Object = extractFileData(values);
			//There is no fileData, so just send it off.
			if (fileData == null) {
				urlRequest.data = objectToURLVariables(values);
				loadURLLoader();
				return;
			}
			
			//If the fileData is a FileReference, let it handle this request.
			if (fileData is FileReference) {
				urlRequest.data = objectToURLVariables(values);
				urlRequest.method = URLRequestMethod.POST;
				
				fileReference = fileData as FileReference;
				fileReference.addEventListener(
					DataEvent.UPLOAD_COMPLETE_DATA,
					handleFileReferenceData,
					false, 0, true
				);
				
				fileReference.addEventListener(
					IOErrorEvent.IO_ERROR,
					handelFileReferenceError,
					false, 0, false
				);
				
				fileReference.addEventListener(
					SecurityErrorEvent.SECURITY_ERROR,
					handelFileReferenceError,
					false, 0, false
				);
				
				fileReference.upload(urlRequest);
				return;
			}
			
			urlRequest.data = createUploadFileRequest(fileData, values).getPostData();
			urlRequest.method = URLRequestMethod.POST;
			
			loadURLLoader();
		}
		
		override public function close():void {
			super.close();
			
			if (fileReference != null) {
				fileReference.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, handleFileReferenceData);
				fileReference.removeEventListener(IOErrorEvent.IO_ERROR, handelFileReferenceError);
				fileReference.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handelFileReferenceError);
				
				try {
					fileReference.cancel();
				} catch (e:*) { }
				
				fileReference = null;
			}
		}
		
		/**
		 * @private
		 *
		 */
		protected function handleFileReferenceData(event:DataEvent):void {
			handleDataLoad(event.data);
		}
		
		/**
		 * @private
		 *
		 */
		protected function handelFileReferenceError(event:ErrorEvent):void {
			_success = false;
			_data = event;
			
			dispatchComplete();
		}
		
	}

}
