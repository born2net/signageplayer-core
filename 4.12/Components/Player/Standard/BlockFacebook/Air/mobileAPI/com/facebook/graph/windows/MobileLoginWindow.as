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
package com.facebook.graph.windows {

	import com.facebook.graph.core.FacebookURLDefaults;
	import com.facebook.graph.utils.FacebookDataUtils;
	
	import flash.desktop.NativeApplication;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * Displays a new NativeWindow that allows the current user to login to
	 * Facebook. The login process found at:
	 * http://developers.facebook.com/docs/authentication/desktop,
	 * will be handled by this class.
	 *
	 */
	public class MobileLoginWindow extends Sprite {


		protected var loginRequest:URLRequest;
		protected var userClosedWindow:Boolean = true;
		private var webView:StageWebView;

		public var loginCallback:Function;

		/**
		 * Creates a new LoginWindow instance.
		 * @param loginCallback Method to call when login is successful
		 *
		 */
		public function MobileLoginWindow(loginCallback:Function) {
			this.loginCallback = loginCallback;
			super();
		}

		/**
		 * Opens a new login window, pointing to the Facebook authorization
		 * page (https://graph.facebook.com/oauth/authorize).
		 *
		 * @param applicationId Current ID of the application being used.
		 * @param extendedPermissions (Optional) List of extended permissions
		 * to ask the user for after login.
		 * @param display (Optional) The display type for the OAuth dialog. "wap" for older mobile browsers,
		 * "touch" for smartphones. The Default is "touch".
		 *
		 * @see http://developers.facebook.com/docs/guides/mobile/ 
		 *
		 */
		public function open(applicationId:String,
							 webView:StageWebView,
							 extendedPermissions:Array = null, 
							 display:String='touch'
		):void {

			this.webView = webView;

			loginRequest = new URLRequest();
			loginRequest.method = URLRequestMethod.GET;
			loginRequest.url = FacebookURLDefaults.AUTH_URL +"?"+ formatData(applicationId, display, extendedPermissions);

			showWindow(loginRequest);
		}


		protected function showWindow(req:URLRequest):void {

			webView.addEventListener(
				Event.COMPLETE,
				handleLocationChange,
				false, 0, true
			);
			webView.addEventListener(
				LocationChangeEvent.LOCATION_CHANGE,
				handleLocationChange,
				false, 0, true
			);
			
			webView.loadURL(req.url);
		}

		protected function formatData(applicationId:String,
									  display:String,
									  extendedPermissions:Array = null									  
		):URLVariables {

			var vars:URLVariables = new URLVariables();
			vars.client_id = applicationId;
			vars.redirect_uri = FacebookURLDefaults.LOGIN_SUCCESS_URL;
			vars.display = display;
			vars.type = 'user_agent';

			if (extendedPermissions != null) {
				vars.scope = extendedPermissions.join(',');
			}
			
			return vars;
		}

		protected function handleLocationChange(event:Event):void
		{
			var location:String = webView.location;
			if (location.indexOf(FacebookURLDefaults.LOGIN_FAIL_URL) == 0 || location.indexOf(FacebookURLDefaults.LOGIN_FAIL_SECUREURL) == 0)
			{
				webView.removeEventListener(Event.COMPLETE, handleLocationChange);
				webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, handleLocationChange);
				loginCallback(null, FacebookDataUtils.getURLVariables(location).error_reason);
				userClosedWindow =  false;
				webView.dispose();
				webView=null;
			}

			else if (location.indexOf(FacebookURLDefaults.LOGIN_SUCCESS_URL) == 0 || location.indexOf(FacebookURLDefaults.LOGIN_SUCCESS_SECUREURL) == 0)
			{
				webView.removeEventListener(Event.COMPLETE, handleLocationChange);
				webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, handleLocationChange);
				loginCallback(FacebookDataUtils.getURLVariables(location), null);
				
				userClosedWindow =  false;
				webView.dispose();
				webView=null;
			}
		}
	}
}
