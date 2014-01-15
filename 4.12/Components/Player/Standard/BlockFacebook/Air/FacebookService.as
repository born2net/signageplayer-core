package
{
	public class FacebookService
	{
		private var m_facebookAccounts:Object = new Object();
		
		public function FacebookService()
		{
		}
		
		
		public function openFacebookApp(i_appId:String):FacebookApp
		{
			if (i_appId==null || i_appId=="")
				return null;
			
			var facebookAccount:FacebookApp = m_facebookAccounts[i_appId];
			if (facebookAccount==null)
			{
				m_facebookAccounts[i_appId] = facebookAccount = new FacebookApp(i_appId);
			}
			return facebookAccount;
		}
	}
}