package 
{
	import flash.display.NativeWindowSystemChrome;
	import flash.filesystem.File;
	
	import mx.controls.SWFLoader;
	import mx.core.IVisualElementContainer;
	import mx.core.Window;

	public class SplashWindow extends Window
	{
		private var m_splashFile:String;
		private var m_swfLoader:SWFLoader;
		
		public function SplashWindow(i_splashFile:String)
		{
			super();
			m_splashFile = i_splashFile;
			title = "RebootScreen";
			showTitleBar = false;
			showStatusBar = false;
			showGripper = false;
			resizable = false;
			systemChrome = NativeWindowSystemChrome.NONE;
			setStyle("gripperPadding", 0); 
			setStyle("headerHeight", 0);
			setStyle("borderThickness", 0);
			setStyle("cornerRadius", 0);
			setStyle("backgroundColor", 0);
		}

		protected override function createChildren():void
		{
			super.createChildren();
			nativeWindow.alwaysInFront = true;
			
			var file:File = new File(m_splashFile);
			if (file.exists==false)
				return;
			
			m_swfLoader = new SWFLoader();
			m_swfLoader.percentHeight = 100;
			m_swfLoader.percentWidth = 100;
			m_swfLoader.setStyle("verticalCenter", 0);
			m_swfLoader.setStyle("horizontalCenter", 0);
			m_swfLoader.source  = file.nativePath;
			IVisualElementContainer(this).addElement(m_swfLoader);
		}

		public override function close():void
		{
			if (m_swfLoader!=null)
			{
				m_swfLoader.unloadAndStop();
				IVisualElementContainer(this).removeElement(m_swfLoader);
				m_swfLoader = null;
			}
			super.close();
		}
	}
}