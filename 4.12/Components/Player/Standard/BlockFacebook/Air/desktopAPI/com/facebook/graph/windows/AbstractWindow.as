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

  import com.facebook.graph.controls.Distractor;

  import flash.display.NativeWindowInitOptions;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.NativeWindowBoundsEvent;
  import flash.geom.Rectangle;
  import flash.html.HTMLLoader;
  import flash.net.URLRequest;
  import flash.net.URLVariables;
  import flash.utils.setTimeout;

  /**
   * Defines the base class used for displaying Facebook windows.
   * This class will resize automatically to the underlying HTMLControl.
   * This class should not be instantiated, but extended.
   *
   */
  public class AbstractWindow extends Sprite {

    /**
     * @private
     *
     */
    protected var html:HTMLLoader;

    /**
     * @private
     *
     */
    protected var distractor:Distractor;

    /**
     * @private
     *
     */
    protected var modalOverlay:Sprite;

    /**
     * @private
     *
     */
    protected var inLoad:Boolean;

    /**
     * Creates a new AbstractWindow instance.
     * This class is Abstract and should only be extended.
     *
     */
    public function AbstractWindow() {
      super();

      configUI();
    }

    /**
     * @private
     *
     */
    protected function configUI():void {
      distractor = new Distractor();
      distractor.text = 'Connecting to Facebook…';

      modalOverlay = new Sprite();
      modalOverlay.graphics.beginFill(0xffffff, 1);
      modalOverlay.graphics.drawRect(0,0,1,1);
    }

    /**
     * @private
     *
     */
    protected function setSize(width:Number, height:Number):void {
      html.stage.nativeWindow.width = width;
      html.stage.nativeWindow.height = height;
    }

    /**
     * @private
     *
     */
    protected function showWindow(req:URLRequest,
                    bounds:Rectangle = null
                    ):void {

      var initOptions:NativeWindowInitOptions
          = new NativeWindowInitOptions();

      initOptions.resizable = true;
      initOptions.maximizable = false;

      html = HTMLLoader.createRootWindow(true,
                         initOptions,
                         false,
                         bounds
                         );

      html.stage.nativeWindow.addEventListener(
                        Event.CLOSING,
                        handleWindowClosing,
                        false, 0, true
                        );

      html.stage.nativeWindow.addEventListener(
                        NativeWindowBoundsEvent.RESIZE,
                        handleWindowResize,
                        false, 0, true
                        );

      html.addEventListener(
                        Event.LOCATION_CHANGE,
                        handleLocationChange,
                        false, 0, true
                        );

      html.addEventListener(
                        Event.HTML_DOM_INITIALIZE,
                        handleHtmlDomInit,
                        false, 0, true
                        );
      html.load(req);

      showDistractor();

      setTimeout(focusWindow, 500);
    }

    /**
     * @private
     *
     */
    protected function focusWindow():void {
      if (html.stage.nativeWindow.closed == false) {
        html.stage.nativeWindow.activate();
      }
    }

    /**
     * @private
     *
     */
    protected function handleWindowClosing(event:Event):void {
      html.removeEventListener(
                        Event.COMPLETE,
                        handleHtmlComplete
                        );

      html.stage.nativeWindow.removeEventListener(
                        Event.CLOSING,
                        handleWindowClosing
                        );

      html.stage.nativeWindow.removeEventListener(
                        NativeWindowBoundsEvent.RESIZE,
                        handleWindowResize
                        );

      html.removeEventListener(
                        Event.LOCATION_CHANGE,
                        handleLocationChange
                        );

      html.removeEventListener(
                        Event.HTML_DOM_INITIALIZE,
                        handleHtmlDomInit
                        );

      hideDistractor();
      handleWindowClosed();
    }

    /**
     * @private
     *
     */
    protected function handleHtmlComplete(event:Event):void {
      inLoad = false;
    }

    /**
     * @private
     *
     */
    protected function handleWindowClosed():void { }

    /**
     * @private
     *
     */
    protected function handleLocationChange(event:Event):void {
      inLoad = true;
    }

    /**
     * @private
     *
     */
    protected function handleHtmlDomInit(event:Event):void {
      hideDistractor();
    }

    /**
     * @private
     *
     */
    protected function handleWindowResize(
                    event:NativeWindowBoundsEvent = null
                    ):void {

      distractor.x = html.stage.nativeWindow.bounds.width
               - distractor.width >> 1;
      distractor.y = html.stage.nativeWindow.bounds.height
               - distractor.height >> 1;

      modalOverlay.width = html.stage.nativeWindow.bounds.width;
      modalOverlay.height = html.stage.nativeWindow.bounds.height;
    }

    /**
     * @private
     *
     */
    protected function showDistractor():void {
      html.stage.addChild(modalOverlay);
      html.stage.addChild(distractor);
      handleWindowResize();
    }

    /**
     * @private
     *
     */
    protected function hideDistractor():void {
      if (distractor && html.stage.contains(distractor)) {
        html.stage.removeChild(distractor);
        html.stage.removeChild(modalOverlay);
      }
    }

    /**
     * @private
     *
     * Obtains the query string from the current HTML location
     * and returns its values in a URLVariables instance.
     *
     */
    protected function getURLVariables():URLVariables {
      var params:String;

      if (html.location.indexOf('?') != -1) {
        params = html.location.slice(html.location.indexOf('?')+1);
      } else if (html.location.indexOf('#') != -1) {
        params = html.location.slice(html.location.indexOf('#')+1);
      }
	  
      var vars:URLVariables = new URLVariables();
	  	if (params != null) { vars.decode(params); }
		  
      return vars;
    }
  }
}
