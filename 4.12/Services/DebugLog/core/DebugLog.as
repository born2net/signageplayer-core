package
{
	import Menu.SparkMenuBarItemRenderer;
	import Menu.SparkToolBar;
	
	import Tree.DefaultTreeItemRenderer;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.core.UIComponentGlobals;
	import mx.managers.SystemManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.WebService;
	import mx.states.State;
	import mx.utils.ObjectUtil;
	
	import spark.components.Application;
	import spark.components.TextInput;

	
	public class DebugLog extends EventDispatcher implements IDebugLog
	{ 
		private var m_framework:IFramework;
		private var m_trace:ArrayCollection = new ArrayCollection();
		private var m_params:Object = new Object();
		
		private var m_showAlert:Boolean;
		private var m_debugLogService:WebService = new WebService();
		private var m_reportError:ReportError;
		private var m_keys:String = null;
		private var m_count:int = 0;
		private var m_index:int = 0;
		private var m_stackTrace:String = null;
		
		public function DebugLog(i_framework:IFramework, i_showAlert:Boolean)
		{
			m_framework = i_framework;
			m_showAlert = i_showAlert;
			
			if (Capabilities.isDebugger)
				m_showAlert = true;
			
			m_debugLogService.useProxy = false;
			m_debugLogService.addEventListener(FaultEvent.FAULT, onWebServiceFault);
			var masterServerUrl:String = m_framework.StateBroker.GetState("MasterServerUrl") as String;
			m_debugLogService.loadWSDL(masterServerUrl+"DebugLogService.asmx?wsdl");
			m_debugLogService.AddLogs.addEventListener("result", onAddLogs);
			
			setParam("count", "0");
		}
		
		public function initDebug(i_stage:Stage):void
		{
			if (i_stage!=null)
			{
				i_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				i_stage.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				i_stage.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			try
			{
				if (m_keys==null)
				{
					m_keys = "Keys: ";
					addTrace(m_keys);
				}
				else
				{
					m_keys += ", ";
				}
				m_keys += event.keyCode;
				if (event.altKey)
				{
					m_keys += "+Alt";
				}
				if (event.ctrlKey)
				{
					m_keys += "+Ctrl";
				}
				if (event.shiftKey)
				{
					m_keys += "+Shift";
				}
				updateTrace(m_keys);
			}
			catch(er:Error)
			{
				// Ignore
			}
		}
		
		private function onFocusOut(event:FocusEvent):void
		{
			try
			{
				m_keys = null;
				var info:String = "FocusOut: \n";
				if (event.target!=null)
				{
					info += "From: " + event.target.toString() + "\n";
				}				
				if (event.relatedObject!=null)
				{
					info += "To: " + event.relatedObject.toString() + "\n";
				}
				info += "\n";
				addTrace(info);
			}
			catch(er:Error)
			{
				// Ignore
			}
		}
		
		private function onClick(event:Event):void
		{
			try
			{
				m_keys = null;
				var p:DisplayObject = event.target as DisplayObject;
				var info:String = "Click: " + p.toString() + "\n";
				
				while(p!=null)
				{
					if (p is IDataRenderer)
					{
						if (IDataRenderer(p).data!=null)
						{
							if (Object(p).data is XML)
							{
								info += XML(Object(p).data).toXMLString();
							}
							else
							{
								info += getObjectInfo( Object(p).data );
							}
							break;
						}
					}
					else if (p is TextInput)
					{
						info += Object(p).id + "=" + Object(p).text;
						break;
					}
					p = p.parent;
				}
				
				info += "\n";
				addTrace(info);
			}
			catch(er:Error)
			{
				// Ignore
			}
		}
		
		
		public function set showAlert(i_showAlert:Boolean):void
		{
			m_showAlert = i_showAlert;
		}
		
		public function get showAlert():Boolean
		{
			return m_showAlert;
		}
		
		private function addTrace(i_info:String):void
		{
			trace(i_info);
			m_trace.addItem(i_info);
			if (m_trace.length>30)
			{
				m_trace.removeItemAt(0);
			}
			m_index++;
			setParam("index", m_index.toString());
		}
		
		private function updateTrace(i_info:String):void
		{
			trace(i_info);
			if (m_trace.length>0)
			{
				m_trace.setItemAt(i_info, m_trace.length-1);
			}
		}
		
		
		private function getObjectInfo(i_object:Object):String
		{
			var info:String = "";
			var comma:String = "";
			var props:Object = ObjectUtil.getClassInfo(i_object);
			for each (var p:QName in props.properties)
			{
				var propName:String = p.localName;
				var propValue:Object = i_object[propName];
				info += (comma + propName + "=" + propValue);
				comma = ", ";
			}   
			return info;
		}

		
		private function onWebServiceFault(event:FaultEvent):void
		{
			// Probebly there is no internet connection, so just ignore.
		}
		
				
		private function onAddLogs(event:ResultEvent):void
		{
		}

		
		public function setParam(i_param:String, i_value:String):void
		{
			m_params[i_param] = i_value;
		}
		
		
		public function addInfo(i_message:String):void
		{
			addTrace("Info: " + i_message);
		}

		public function addWarning(i_message:String):void
		{
			addTrace("Warning: " + i_message);
		}

		public function addError(i_message:String):void
		{
			var detailMessage:String = i_message + "\n" + getStackTrace();
			
			
			addTrace("Error: " + i_message);
			
			if (m_count<3)
			{
				m_count++;
				setParam("count", m_count.toString());
				ReportError.sendEmail(m_framework, detailMessage, m_trace, m_params, "", "");
			}
			
			if (m_showAlert)
			{
				if (m_reportError==null)
				{
					m_reportError = ReportError.Create(m_framework, detailMessage, m_trace, m_params);
				}
			}
			
			dispatchEvent( new DebugLogEvent(DebugLogEvent.MESSAGE, i_message, "Error") );
		}
		
		public function addException(error:Error):void
		{
			addError("Exception: " + error.message + "\n" + error.getStackTrace() );
		}
		
		public function flush():void 
		{
		}
		
		private function getStackTrace():String
		{
			if (m_stackTrace==null)
			{
				try { throw new Error(); }
				catch (e:Error) { m_stackTrace = e.getStackTrace(); }
			}
			return m_stackTrace;
		}
		
		public function setStackTrace(i_stackTrace:String):void
		{
			m_stackTrace = i_stackTrace;
		}
	}
}