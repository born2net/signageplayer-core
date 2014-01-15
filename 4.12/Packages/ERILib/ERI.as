package
{
	import flash.net.SharedObject;

	public class ERI
	{
		private static var m_domain:String = null;
		private static var m_resellerId:int = 1;
		
		public static function decrypt(i_eri:String):void
		{
			var eriSharedObject:SharedObject = SharedObject.getLocal("eri", "/", false);
			var args:String = RC4.decrypt(i_eri, "3768562244942638");
			var argArray:Array = args.split(",");
			if (argArray.length==1)
			{
				eriSharedObject.data.domain = "galaxy.signage.me";
				m_resellerId = int(args);
			}
			else if (argArray.length==2)
			{
				eriSharedObject.data.domain = argArray[0];
				m_resellerId = int(argArray[1]);
			}
			else
				eriSharedObject.data.domain = "galaxy.signage.me";
			
			if (m_resellerId==0) // 0 - not valid eri
				m_resellerId = 1;
			
			eriSharedObject.data.resellerId = m_resellerId;
			
			eriSharedObject.flush();
		}
		
		public static function encrypt():String
		{
			var eriSharedObject:SharedObject = SharedObject.getLocal("eri", "/", false);
			return RC4.encrypt(domain + "," + eriSharedObject.data.resellerId.toString(), "3768562244942638");
		}
		
		public static function get domain():String
		{
			var eriSharedObject:SharedObject = SharedObject.getLocal("eri", "/", false);
			return (eriSharedObject.data.domain!=null) ? eriSharedObject.data.domain : m_domain;
		}

		public static function set domain(i_domain:String):void
		{
			var eriSharedObject:SharedObject = SharedObject.getLocal("eri", "/", false);
			eriSharedObject.data.domain = i_domain;
			eriSharedObject.flush();
		}
		
		public static function get resellerId():int
		{
			var eriSharedObject:SharedObject = SharedObject.getLocal("eri", "/", false);
			return (eriSharedObject.data.resellerId!=null) ? eriSharedObject.data.resellerId : m_resellerId;
		}
		
		public static function set resellerId(i_resellerId:int):void
		{
			var eriSharedObject:SharedObject = SharedObject.getLocal("eri", "/", false);
			eriSharedObject.data.resellerId = i_resellerId;
			eriSharedObject.flush();
		}
	}
}
