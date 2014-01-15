package
{
	import com.facebook.graph.FacebookWeb;
	import com.facebook.graph.core.AbstractFacebook;
	import com.facebook.graph.data.FacebookSession;
	import com.facebook.graph.net.FacebookRequest;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import flash.net.URLRequestDefaults;
	
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	import view.LoginWindow;
	
	
	public class FacebookApp extends FacebookWeb
	{
		private var m_container:IVisualElementContainer;
		private var m_loginWindow:LoginWindow;
		
		private var m_loginStatus:int = 0;
		
		private var m_requestQueryList:Array = new Array();
		private var m_requestApiList:Array = new Array();
		
		private var m_user:String;
		private var m_password:String;
		private var m_appId:String;
		
		public function FacebookApp(i_appId:String)
		{
			m_appId = i_appId;
		}
		
		public function doLogin(i_user:String, i_password:String, i_container:IVisualElementContainer):void
		{
			if (m_user == i_user && m_password == i_password)
				return;
			m_user = i_user;
			m_password = i_password;
				
			m_loginStatus= 1;
			
			m_container = i_container;
			
			logout(onLogin);
		}
		
		
		private function onLogin(i_result:Boolean):void
		{
			m_loginStatus = 2;
			
			URLRequestDefaults.useCache = false;
			
			URLRequestDefaults.manageCookies = false;
			URLRequestDefaults.cacheResponse = false;
			
			init(m_appId, onLoginInit);
		}
		
		private function onLoginInit(session:Object, fail:Object):void 
		{
			m_loginStatus = 3;
			
			var permissions:Array = ['publish_stream','create_event','rsvp_event','sms','offline_access','email','read_insights','read_stream','user_about_me',
				'user_activities','user_birthday','user_education_history','user_events', 'friends_events','user_groups','user_hometown', 'friends_hometown',
				'user_interests','user_likes','user_location','friends_location', 'user_notes','user_online_presence',
				'user_photo_video_tags','user_photos','user_relationships','user_religion_politics','user_status',
				'user_videos','user_website','user_work_history','read_friendlists','read_requests','user_notes'];
			
			m_loginWindow = login(m_user, m_password, onLoginDone, null, permissions);
			m_container.addElement(m_loginWindow);
			
		}
		
		private function onLoginDone(session:Object, fail:Object):void 
		{
			if (session!=null)
			{
				if (UIComponent(m_container).contains(m_loginWindow))
				{
					m_container.removeElement(m_loginWindow);
					m_container = null;
				}
				m_loginStatus = 4;
				
				var requestQuery:Object;
				while((requestQuery=m_requestQueryList.pop())!=null)
				{
					fqlQuery(requestQuery.query, requestQuery.callback, requestQuery.values);
				}
				
				var requestApi:Object;
				while((requestApi=m_requestApiList.pop())!=null)
				{
					api(requestApi.method, requestApi.callback, requestApi.params, requestApi.requestMethod);
				}				
			}
		}
		
		
		public function facebookQuery(query:String, callback:Function=null, values:Object=null):void 
		{
			if (m_loginStatus==4)
			{
				fqlQuery(query, callback, values);
			}
			else
			{
				var requestQuery:Object = new Object();
				requestQuery.query = query;
				requestQuery.callback = callback;
				requestQuery.values = values;
				
				m_requestQueryList.push(requestQuery);
			}
		}
		
		
		public function facebookApi(method:String, callback:Function = null, params:* = null, requestMethod:String = 'GET'):void
		{
			if (m_loginStatus==4)
			{
				api(method, callback, params, requestMethod);
			}
			else
			{
				var requestApi:Object = new Object();
				requestApi.method = method;
				requestApi.callback = callback;
				requestApi.params = params;
				requestApi.requestMethod = requestMethod;
				
				m_requestApiList.push(requestApi);
			}			
		}
	}
}