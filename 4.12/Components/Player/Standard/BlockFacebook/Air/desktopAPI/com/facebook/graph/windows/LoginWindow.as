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
    
    import flash.display.Screen;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLLoader;
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
    public class LoginWindow extends AbstractWindow {

        /**
        * Default window width.
        *
        */
        public static var WINDOW_WIDTH:Number = 460;

        /**
        * Default window height.
        *
        */
        public static var WINDOW_HEIGHT:Number = 260;

        /**
        * @private
        *
        */
        protected var loginRequest:URLRequest;

        /**
        * @private
        *
        */
        protected var userClosedWindow:Boolean = true;

        public var loginCallback:Function;

        /**
        * Creates a new LoginWindow instance.
        * @param loginCallback Method to call when login is successful
        *
        */
        public function LoginWindow(loginCallback:Function) {
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
        * @param point (Optional) Starting point for the LoginWindow.
        * If null, the window will be centered on the current user's screen.
        *
        * @see http://developers.facebook.com/docs/authentication/desktop
        *
        */
        public function open(applicationId:String,
                            extendedPermissions:Array = null,
                            point:Point = null
                            ):void {

            loginRequest = new URLRequest(FacebookURLDefaults.AUTH_URL);
            loginRequest.method = URLRequestMethod.GET;
            loginRequest.data = formatData(applicationId, extendedPermissions);

            var mainScreen:Screen = Screen.mainScreen;
            var bounds:Rectangle;
            if (point == null) {
                bounds = new Rectangle(
                                    (mainScreen.bounds.width-WINDOW_WIDTH)/2,
                                    (mainScreen.bounds.height-WINDOW_HEIGHT)/2,
                                    WINDOW_WIDTH, WINDOW_HEIGHT
                                    );
            } else {
                bounds = new Rectangle(
                                point.x,
                                point.y,
                                WINDOW_WIDTH,
                                WINDOW_HEIGHT
                                );
            }

            super.showWindow(loginRequest, bounds);
        }

        /**
        * @private
        *
        */
        protected function formatData(applicationId:String,
                                    extendedPermissions:Array = null
                                    ):URLVariables {

            var vars:URLVariables = new URLVariables();
            vars.client_id = applicationId;
            vars.redirect_uri = FacebookURLDefaults.LOGIN_SUCCESS_URL;
            vars.display = 'popup';
            vars.type = 'user_agent';

            if (extendedPermissions != null) {
                vars.scope = extendedPermissions.join(',');
            }

            return vars;
        }

        /**
        * @private
        *
        */
        override protected function handleWindowClosed():void {
            if (userClosedWindow) {
                loginCallback(false, 'user-canceled');
            }
        }

        /**
        * @private
        *
        */
        override protected function handleLocationChange(event:Event):void {
            super.handleLocationChange(event);
			
            if (html.location.indexOf(FacebookURLDefaults.LOGIN_FAIL_URL) == 0 || html.location.indexOf(FacebookURLDefaults.LOGIN_FAIL_SECUREURL) == 0) {
                loginCallback(null, getURLVariables().error_reason);
				
				userClosedWindow =  false;
				html.stage.nativeWindow.close();
				html.removeEventListener(Event.LOCATION_CHANGE, handleLocationChange);
				
				
            } else if (html.location.indexOf (FacebookURLDefaults.LOGIN_SUCCESS_URL) == 0 || html.location.indexOf(FacebookURLDefaults.LOGIN_SUCCESS_SECUREURL) == 0) {				
                loginCallback(getURLVariables(), null);

                userClosedWindow = false;
                html.stage.nativeWindow.close();
				html.removeEventListener(Event.LOCATION_CHANGE, handleLocationChange);

            } else if (html.location.indexOf(
                FacebookURLDefaults.LOGIN_URL
                    ) == 0)
            {				
                showDistractor();
            } else if (html.location.indexOf(
				FacebookURLDefaults.AUTHORIZE_CANCEL
					) == 0)
			{
				loginCallback(false, 'user-canceled');
				html.stage.nativeWindow.close();
				html.removeEventListener(Event.LOCATION_CHANGE, handleLocationChange);
			}						
        }
    }
}
