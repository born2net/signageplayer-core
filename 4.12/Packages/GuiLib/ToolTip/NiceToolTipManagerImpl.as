package ToolTip
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.controls.ToolTip;
	import mx.core.IToolTip;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.EffectManager;
	import mx.events.DynamicEvent;
	import mx.events.EffectEvent;
	import mx.events.ToolTipEvent;
	import mx.managers.ISystemManager;
	import mx.managers.IToolTipManager2;
	import mx.managers.ToolTipManager;
	import mx.managers.ToolTipManagerImpl;
	import mx.resources.ResourceManager;
	import mx.styles.IStyleClient;
	
	import org.osmf.events.TimeEvent;
	
	import spark.components.Button;
	
	use namespace mx_internal;
	
	/**
	 * Manages a custom NiceToolTip that has an optional title, text, styles and placement.
	 * 
	 * Applies title, text, styles and placement to the tooltip using values defined in
	 * resource bundles.
	 *  
	 * Takes the value in tooltip or errorString on a component to lookup
	 * values for title, text, styles etc and applies it to the Tooltip.
	 * 
	 * Places the Tooltip based on the placement value and passes the placment
	 * to the Tooltip component so that it can draw itself accordingly
	 * 
	 * Overrides initializeTip and positionTip to add the required behaviour.
	 * 
	 * @TODO: Test that none of the default Flex ToolTip behaviour is broken.
	 * @version 0.1
	 * @author andy hulstkamp. www.hulstkamp.com
	 * 
	 */
	public class NiceToolTipManagerImpl extends ToolTipManagerImpl implements IToolTipManager2
	{
		public static var DEFAULT_TOOL_TIP_BUNDLE_NAME:String = "ToolTipBundle";
		
		private var _useDefaultImplementation:Boolean;
		
		private static var _instance:IToolTipManager2;
		
		private var  keepTimer:Timer;
		
		private var m_tooltipInfo:Object;
		
		//??? private var m_hidWhatIKnow:Boolean = true;
		//??? private var m_iKnow:Boolean = false;
		
		public function NiceToolTipManagerImpl()
		{
			super();
			
			keepTimer = new Timer(300, 1);
			keepTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onKeepTimerEnd);
			
			if (_instance)
				throw new Error("Instance already exists.");
		}
		
		/*??? 
		public function get hidWhatIKnow():Boolean
		{
			return m_hidWhatIKnow;
		}
		
		public function set hidWhatIKnow(i_hidWhatIKnow:Boolean):void
		{
			m_hidWhatIKnow = i_hidWhatIKnow;
		}

		
		public function get iKnow():Boolean
		{
			return m_iKnow;
		}
	
		public function set iKnow(i_iKnow:Boolean):void
		{
			m_iKnow = i_iKnow;
		}
		*/
		
		public function get useDefaultImplementation():Boolean
		{
			return _useDefaultImplementation;
		}

		public function set useDefaultImplementation(value:Boolean):void
		{
			if (value) {
				toolTipClass = ToolTip;
			} else {
				toolTipClass = NiceToolTip;
			}
			_useDefaultImplementation = value;
			
		}

		public static function getInstance():IToolTipManager2
		{
			if (!_instance)
				_instance = new NiceToolTipManagerImpl();
			_instance.toolTipClass = NiceToolTip;
			return _instance;
		}
		
		
		public static function get tooltipInfo():Object
		{
			return NiceToolTipManagerImpl(getInstance()).m_tooltipInfo;
		}
		
		public static function set tooltipInfo(i_tooltipInfo:Object):void
		{
			NiceToolTipManagerImpl(getInstance()).m_tooltipInfo = i_tooltipInfo;
		}
		
		
		override mx_internal function initializeTip():void {
			
			if (useDefaultImplementation) {
				super.initializeTip();
				return;
			}
			
			if (isError && currentToolTip is IStyleClient)
				IStyleClient(currentToolTip).setStyle("styleName", "errorTip");
			
			// Set the text of the tooltip.
			if (currentToolTip is IToolTip)
				assignResourcesToToolTip();
			
			sizeTip(currentToolTip);
			
			if (currentToolTip is IStyleClient)
			{
				// Set up its "show" and "hide" effects.
				if (showEffect)
					IStyleClient(currentToolTip).setStyle("showEffect", showEffect);
				if (hideEffect)
					IStyleClient(currentToolTip).setStyle("hideEffect", hideEffect);
			}
			
			if (showEffect || hideEffect)
			{
				currentToolTip.addEventListener(EffectEvent.EFFECT_END,
					effectEndHandler);
			}
		}
		
		override mx_internal function positionTip():void {
			
			if (useDefaultImplementation) {
				super.positionTip();
				return;
			}
			
			var x:Number;
			var y:Number;
			
			var screenWidth:Number = currentToolTip.screen.width;
			var screenHeight:Number = currentToolTip.screen.height;
			
			var targetPos:Point = currentTarget.localToGlobal(new Point(0, 0));
			var targetWidth:Number = currentTarget.width;
			var targetHeight:Number = currentTarget.height;
			var toolTipWidth:Number = currentToolTip.width;
			var toolTipHeight:Number = currentToolTip.height;
			var toLeft:Boolean;
			var toTop:Boolean;
			
			var sm:ISystemManager = getSystemManager(currentTarget);
			
			var ttPos:String = IStyleClient(currentToolTip).getStyle("placement");
			
			//Use the specified placement value to position the ToolTip but make sure
			//it can be displayed completely
			//If no placement value is set use automatic placement, prefer
			//right over left and bottom over top
			if (ttPos == "topLeft" || 
				ttPos == "bottomLeft" || 
				targetPos.x + targetWidth * .75 + toolTipWidth > screenWidth) {
				toLeft = true;
			}
			
			if (ttPos == "topLeft" ||
				ttPos == "topRight" ||
				targetPos.y + targetHeight/2 + toolTipWidth > screenHeight) {
				toTop = true;
			}
			
			//Position the ToolTip and let the ToolTip Component know wich placement
			//to use, so that the skin can draw itself accordingly
			if (toLeft && toTop) {
				IStyleClient(currentToolTip).setStyle("placement", "topLeft");
				x = targetPos.x + Math.max (20, targetWidth * .1 - 25);
				y = targetPos.y + targetHeight * .25;
			} 
			else if (toLeft && !toTop)
			{
				IStyleClient(currentToolTip).setStyle("placement", "bottomLeft");
				x = targetPos.x + Math.max (20, targetWidth * .1 - 25);
				y = targetPos.y + targetHeight * .75;
			} 
			else if (!toLeft && toTop) {
				IStyleClient(currentToolTip).setStyle("placement", "topRight");
				x = targetPos.x + targetWidth * .9 - 25;
				y = targetPos.y + targetHeight * .25;
			} 
			else 
			{
				IStyleClient(currentToolTip).setStyle("placement", "bottomRight");
				x = targetPos.x + targetWidth * .9 - 25;
				y = targetPos.y + targetHeight * .75;
			}
			
			var pos:Point = new Point(x, y);
			pos = DisplayObject(sm).localToGlobal(pos);
			pos = DisplayObject(sm.getSandboxRoot()).globalToLocal(pos);
			x = pos.x;
			y = pos.y;
			
			currentToolTip.move(x, y);
		}
		
		
		/**
		 * Assigns values from the resource bundle to the ToolTip.
		 * Uses the value of the tooltip property or the errosString property 
		 * on a component as the key to lookup resources.
		 */
		protected function assignResourcesToToolTip():void {
			
			if (!currentText || !currentToolTip)
				return;
			
			
			var tooltipItem:Object = null;
			if (m_tooltipInfo!=null)
			{
				tooltipItem = m_tooltipInfo[currentText];
			}
			
			if (tooltipItem==null)
			{
				currentToolTip.text = currentText;
				return;
			}
			else
			{
				NiceToolTip(currentToolTip).title = tooltipItem.title;
				currentToolTip.text = tooltipItem.description;
				NiceToolTip(currentToolTip).videoURL = tooltipItem.videoURL;
				//??? NiceToolTip(currentToolTip).iKnowCheckBox.selected = m_iKnow;
			}
		}
		
		override mx_internal function checkIfTargetChanged(displayObject:DisplayObject):void
		{
			if (!enabled)
				return;
			
			findTarget(displayObject);
			
			//trace(displayObject.toString());
			
			if (currentTarget == previousTarget)
				return;
			
			if (currentTarget==null)
			{
				keepTimer.start();
			}
			else
			{
				keepTimer.stop();
				targetChanged();
				previousTarget = currentTarget;
			}
		}
		
		override mx_internal function targetChanged():void
		{
			// Do lazy creation of the Timer objects this class uses.
			if (!initialized)
				initialize()
			
			var event:ToolTipEvent;
			
			if (previousTarget && currentToolTip)
			{
				if (currentToolTip is IToolTip)
				{
					event = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE);
					event.toolTip = currentToolTip;
					previousTarget.dispatchEvent(event);
				}
				else
				{
					if (hasEventListener(ToolTipEvent.TOOL_TIP_HIDE))
						dispatchEvent(new Event(ToolTipEvent.TOOL_TIP_HIDE));
				}
			}   
			
			reset();
			
			if (currentTarget)
			{
				// Don't display empty tooltips.
				if (currentText == "")
					return;

				/*???
				dispatchEvent(new Event("beforeCreateTip", false, true) );
				if (m_hidWhatIKnow && m_iKnow)
					return;
				*/
				
				// Dispatch a "startToolTip" event
				// from the object displaying the tooltip.
				event = new ToolTipEvent(ToolTipEvent.TOOL_TIP_START);
				currentTarget.dispatchEvent(event);
				
				if (showDelay == 0 || scrubTimer.running)
				{
					// Create the tooltip and start its showEffect.
					createTip();
					initializeTip();
					positionTip();
					showTip();
				}
				else
				{
					showTimer.delay = showDelay;
					showTimer.start();
					// After the delay, showTimer_timerHandler()
					// will create the tooltip and start its showEffect.
				}
			}
		}
		
		
		
		override mx_internal function systemManager_mouseDownHandler(event:MouseEvent):void
		{
			if (event.target is Button && event.target.name=="tipButton")
			{
				var toolTipEvent:ToolTipEvent = new ToolTipEvent("toolTipClick", true);
				toolTipEvent.toolTip = currentToolTip;
				previousTarget.dispatchEvent(toolTipEvent);
				
				reset();
			}
		}	
		
		
		private function onKeepTimerEnd(event:TimerEvent):void
		{
			targetChanged();
			previousTarget = currentTarget;
		}
		
		override mx_internal function createTip():void
		{
			super.createTip();
			if (currentToolTip!=null)
			{
				currentToolTip.addEventListener(MouseEvent.MOUSE_OVER,
					onToolTipMouseOver);
				currentToolTip.addEventListener(MouseEvent.MOUSE_OUT,
					onToolTipMouseOut);
			}
		}
		
		public function closeTooltip():void
		{
			/*
			if (m_hidWhatIKnow && m_iKnow)
			{
				reset();
			}
			*/
		}
		
		override mx_internal function reset():void
		{
			if (currentToolTip!=null)
			{
				currentToolTip.removeEventListener(MouseEvent.MOUSE_OVER,
					onToolTipMouseOver);
				currentToolTip.removeEventListener(MouseEvent.MOUSE_OUT,
					onToolTipMouseOut);
				
				NiceToolTip(currentToolTip).dispose();
			}
			super.reset();
		}
		
		
		private function onToolTipMouseOver(event:MouseEvent):void
		{
			keepTimer.stop();
		}

		private function onToolTipMouseOut(event:MouseEvent):void
		{
			keepTimer.start();
		}

	}
}