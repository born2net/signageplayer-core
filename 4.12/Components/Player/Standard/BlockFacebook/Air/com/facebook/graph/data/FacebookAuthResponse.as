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

    /**
    * VO to hold information about the
    * current logged in user and their auth response.
    *
    */
    public class FacebookAuthResponse {

        /**
        * The current user's ID.
        *
        */
        public var uid:String;

        /**
        * The date this authResponse will expire.
        *
        */
        public var expireDate:Date;

        /**
        * OAuth 2.0 access token for Facebook graph services.
        *
        */
        public var accessToken:String;
		
		/**
		 * Oauth string with the current signed request. http://developers.facebook.com/docs/authentication/signed_request/
		 *
		 */
		public var signedRequest:String;

        /**
        * Creates a new FacebookAuthResponse.
        *
        */
        public function FacebookAuthResponse() {

        }

        /**
        * Populates the authResponse data from a decoded JSON object.
        *
        */
        public function fromJSON(result:Object):void {
            if (result != null) {
				expireDate = new Date();
				expireDate.setTime(expireDate.time + result.expiresIn * 1000);
                accessToken = result.access_token || result.accessToken;
				signedRequest = result.signedRequest;
                uid = result.userID;
            }
        }

       /**
       * Provides the string value of this instance.
       *
       */
        public function toString():String {
            return '[userId:' + uid + ']';
        }
    }
}
