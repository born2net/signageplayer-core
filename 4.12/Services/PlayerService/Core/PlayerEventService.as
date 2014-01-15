package
{
	//ZWave ??? import com.hurlant.eval.Debug;
	//ZWave ??? import com.hurlant.eval.Evaluator;
	//ZWave ??? import com.hurlant.test.ILogger;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import mx.graphics.shaderClasses.ExclusionShader;
	import mx.utils.Base64Decoder;
	import mx.utils.ObjectUtil;

	public class PlayerEventService implements IPlayerEventService //, ILogger
	{
		private const NOT_COMPAILED:String = "Error: Script is not compailed.";
		
		protected var m_framework:IFramework;
		protected var m_dataBaseManager:DataBaseManager;
		private var m_eventHandlerMap:Dictionary = new Dictionary();

		//ZWave ??? private var m_evaluator:Evaluator;
		private var m_loader:Loader = null;
		private static var m_code:Object;
		
		private var m_log:String;
		private var m_lastError:String;
		
		public function PlayerEventService(i_framework:IFramework)
		{
			m_framework = i_framework;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
			//Debug.logger = this;
			m_log = "";
			m_lastError = "";
		}
		
		public function print(str:String):void
		{
			m_log += str;
		}
				
		/*???
		public function compile():String
		{
			m_code = null;
			m_log = "";
			
			if (m_loader!=null)
			{
				m_loader.unloadAndStop();
				m_loader = null;
			}
			m_evaluator = null;
			
			
			var src:String = "PlayerEventService.setCallback(this);\n"
				
			var keys:Array = m_dataBaseManager.table_scripts.getAllPrimaryKeys();
			
			if (keys.length==1)
			{
				var hScript:int = keys[0];
				var recScript:Rec_script = m_dataBaseManager.table_scripts.getRecord(hScript);
				var base64:Base64Decoder = new Base64Decoder();
				base64.decode(recScript.script_src);
				var decodedByteArr:ByteArray = base64.toByteArray();
				src += decodedByteArr.toString();
			}

			m_evaluator = new Evaluator();
			try
			{
				var bytes:ByteArray = m_evaluator.eval(src);
			}
			catch(e:Error)
			{
				return e.message;
			}
			var ret:Boolean = loadBytes(bytes);
			
			if (m_log=="")
				m_log = "Build succeeded.";
			
			return m_log;
		}
		
		
		public function get lastError():String
		{
			return m_lastError;
		}
		
		
		public function setVar(i_varName:String, i_value:Object):void
		{
			try
			{
				m_lastError = "";
				if (m_code!=null)
				{
					m_code[i_varName] = i_value;
					return;
				}
				m_lastError = NOT_COMPAILED;
			}
			catch(error:Error)
			{
				m_lastError = error.message;
			}
		}

		
		public function getVar(i_varName:String):Object
		{
			try
			{
				m_lastError = "";
				if (m_code!=null)
				{
					return m_code[i_varName];
				}
				m_lastError = NOT_COMPAILED;
			}
			catch(error:Error)
			{
				m_lastError = error.message;
			}
			return null;
		}
		
		
		public function callFunction(i_functionName:String, i_value:Number):Boolean
		{
			try
			{
				m_lastError = "";
				if (m_code!=null)
				{
					return m_code[i_functionName](i_value);
				}
				m_lastError = NOT_COMPAILED;
			}
			catch(error:Error)
			{
				m_lastError = error.message;
			}
			return false;
		}
*/

		
		public function registerEventHandler(i_eventHandler:IEventHandler):void
		{
			var eventHandlerList:Array = m_eventHandlerMap[i_eventHandler.senderName];
			if (eventHandlerList==null)
			{
				m_eventHandlerMap[i_eventHandler.senderName] = eventHandlerList = new Array();
			}
			eventHandlerList.push(i_eventHandler);
		}
		
		public function unregisterEventHandler(i_eventHandler:IEventHandler):void
		{
			var eventHandlerList:Array = m_eventHandlerMap[i_eventHandler.senderName];
			//???
		}
		
		
		public function sendEvent(i_senderName:String, i_eventName:String, i_eventParam:Object):void
		{
			var eventHandlerList:Array = m_eventHandlerMap[i_senderName];
			if (eventHandlerList==null)
				return;
			for each(var eventHandler:IEventHandler in eventHandlerList)
			{
				eventHandler.onEvent(i_eventName, i_eventParam);
			}
		}

		
		
		
		
		
		
		
		
		
		
		
		
		
		static public function setCallback(i_code:Object):void
		{
			m_code = i_code;
		}
		
		//////////////////
		
		private static var swf_start:Array = 
			[
				0x46, 0x57, 0x53, 0x09, 								// FWS, Version 9
				0xff, 0xff, 0xff, 0xff, 								// File length
				0x78, 0x00, 0x03, 0xe8, 0x00, 0x00, 0x0b, 0xb8, 0x00,	// size [Rect 0 0 8000 6000] 
				0x00, 0x0c, 0x01, 0x00, 								// 16bit le frame rate 12, 16bit be frame count 1 
				0x44, 0x11,												// Tag type=69 (FileAttributes), length=4  
				0x08, 0x00, 0x00, 0x00
			];
		
		private static var abc_header:Array = 
			[
				0x3f, 0x12,												// Tag type=72 (DoABC), length=next.
				//0xff, 0xff, 0xff, 0xff 								// ABC length, not included in the copy. 
			];
		
		private static var swf_end:Array =
			// the commented out code tells the player to instance a class "test" as a Sprite.
			[/*0x09, 0x13, 0x01, 0x00, 0x00, 0x00, 0x74, 0x65, 0x73, 0x74, 0x00, */ 0x40, 0x00]; // Tag type=1 (ShowFrame), length=0
		
		
		/**
		 * Wraps the ABC bytecode inside the simplest possible SWF file, for
		 * the purpose of allowing the player VM to load it.
		 *  
		 * @param bytes: an ABC file
		 * @return a SWF file 
		 * 
		 */
		public static function wrapInSWF(bytes:Array):ByteArray {
			// wrap our ABC bytecodes in a SWF.
			var out:ByteArray = new ByteArray;
			out.endian = Endian.LITTLE_ENDIAN;
			for (var i:int=0;i<swf_start.length;i++) {
				out.writeByte(swf_start[i]);
			}
			for (i=0;i<bytes.length;i++) {
				var abc:ByteArray = bytes[i];
				for (var j:int=0;j<abc_header.length;j++) {
					out.writeByte(abc_header[j]);
				}
				// set ABC length
				out.writeInt(abc.length);
				out.writeBytes(abc, 0, abc.length);
			}
			for (i=0;i<swf_end.length;i++) {
				out.writeByte(swf_end[i]);
			}
			// set SWF length
			out.position = 4;
			out.writeInt(out.length);
			// reset
			out.position = 0;
			return out;
		}
		/**
		 * Load the bytecodes passed into the flash VM, using
		 * the current application domain, or a child of it
		 *
		 * This probably always returns true, even when things fail horribly,
		 * due to the Loader logic waiting to parse the bytecodes until the 
		 * current script has finished running. 
		 * 
		 *
		public function loadBytes(bytes:*, inplace:Boolean=false):Boolean 
		{
			if (bytes is Array || (getType(bytes)==2)) {
				if (!(bytes is Array)) {
					bytes = [ bytes ];
				}
				bytes = wrapInSWF(bytes);
			}
			
			try 
			{
				var securityDomain:SecurityDomain = null;
				
				var c:LoaderContext = new LoaderContext();
				
				c.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				
				c.securityDomain = securityDomain;
				if (securityDomain == null && Security.sandboxType == Security.REMOTE)
					c.securityDomain = SecurityDomain.currentDomain;
				
				
				
				// If the AIR flag is available then set it to true so we can
				// load the module without a security error.
				if ("allowLoadBytesCodeExecution" in c)
					c["allowLoadBytesCodeExecution"] = true;			
				
				
				
				m_loader = new Loader();
				m_loader.loadBytes(bytes, c);
				return true;
			} 
			catch (e:*) 
			{
				Debug.print(e);
			} finally {
				//trace("done.");
				// darn it. the running of the bytes doesn't happen until current scripts are done. no try/catch can work
			}
			return false;
		}
		*/
		
		
		public static function isSWF(data:ByteArray):Boolean {
			var type:int = getType(data);
			return (type&1)==1;
		}
		/**
		 * getType.
		 * ripped from abcdump.as.
		 * 
		 * This looks at the array header and decides what it is.
		 * 
		 * (getType&1)==1 => it's  SWF
		 * (getType&2)==2 => it's  ABC
		 * (getType&4)==4)=> it's compressed
		 *  
		 * @param data
		 * @return 
		 * 
		 */
		public static function getType(data:ByteArray):int {
			data.endian = "littleEndian"
			var version:uint = data.readUnsignedInt()
			switch (version) {
				case 46<<16|14:
				case 46<<16|15:
				case 46<<16|16:
					return 2;
				case 67|87<<8|83<<16|9<<24: // SWC9
				case 67|87<<8|83<<16|8<<24: // SWC8
				case 67|87<<8|83<<16|7<<24: // SWC7
				case 67|87<<8|83<<16|6<<24: // SWC6
					return 5;
				case 70|87<<8|83<<16|9<<24: // SWC9
				case 70|87<<8|83<<16|8<<24: // SWC8
				case 70|87<<8|83<<16|7<<24: // SWC7
				case 70|87<<8|83<<16|6<<24: // SWC6
				case 70|87<<8|83<<16|5<<24: // SWC5
				case 70|87<<8|83<<16|4<<24: // SWC4
					return 1;
				default:
					return 0;
			}
		}

	}
}