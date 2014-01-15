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

package com.facebook.graph.data {
	
	import com.facebook.graph.core.FacebookLimits;
	
	/**
	 * Helper class used to format batch API requests.
	 * @see https://developers.facebook.com/docs/reference/api/batch/
	 * 
	 * To use this request pass it to Facebook.batchRequest(), or to FacebookDesktop.batchRequest(),
	 * Internally the request will be formatted to a proper Facebook batch request.
	 * On success (or error), the resulting data will be serialized into native flash objects.
	 * 
	 */
	public class Batch {
		
		/**
		 * @private
		 *
		 */
		protected var _requests:Array;
		
		public function Batch() {
			_requests = [];
		}
		
		/**
		 * Returns the current list of BatchItems to be sent to facebook.
		 * 
		 */
		public function get requests():Array {
			return _requests;
		}
		
		/**
		 * Adds a new request to this Batch operation.
		 * Facebook limits you to a maximum of 20 requests per batch operation.
		 * 
		 * For details look at:
		 * @see https://developers.facebook.com/docs/reference/api/batch/
		 * 
		 * @param relativeURL The method to be called on the graph api.
		 * @param callback The function to call after the API has parsed the result from facebook.
		 * 	**Note: there will also be another callback issued when the entire operation is done.
		 * 
		 * @param params Object of values to pass with this api call.
		 * @param requestMethod URLRequestMethod used when facebook executes this command.
		 * 
		 */
		public function add(relativeURL:String,
							callback:Function = null,
							params:* = null,
							requestMethod:String = 'GET'):void {
			if (_requests.length == FacebookLimits.BATCH_REQUESTS) {
				throw new Error('Facebook limits you to ' + FacebookLimits.BATCH_REQUESTS + ' requests in a single batch.');
			}
			
			_requests.push(new BatchItem(relativeURL, callback, params, requestMethod));
		}
		
	}
}