package
{
	import Controls.ProgressBar;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;

	public class EmbeddedResource extends PlayerModule
	{
		protected var m_source:String;
		protected var m_resourceService:IResourceService;
		protected var m_hResource:int = -1;
			
 [Bindable]	protected var m_maintainAspectRatio:Boolean = false;
		
 
 		private var m_progress:ProgressBar;
 
 
		public function EmbeddedResource()
		{
		}
		
		
		/************************************/
		/* implements IPlayer				*/
		/************************************/			
		public override function load(i_data:XML):void
		{
			super.load(i_data);
			m_data = i_data;	
			if (XMLList(i_data.Resource.@hResource).length()>0)
			{
				m_hResource = int(i_data.Resource.@hResource);
				
				loadResource();
				
				if (XMLList(i_data.Resource.AspectRatio.@maintain).length()>0)
				{
					m_maintainAspectRatio = (i_data.Resource.AspectRatio.@maintain=="1");	
				}
			}
		}
		
		
		protected function loadResource():void
		{
			if (m_resourceService!=null)
			{
				if (m_resourceService is IResourceServiceAir)
				{
					if (IResourceServiceAir(m_resourceService).isLocalResource(m_hResource))
					{
						source = m_resourceService.getPathFromHandle(m_hResource);
					}
					else
					{
						var src:String = m_resourceService.getPathFromHandle(m_hResource);
						if (src==null)
							return; //???
						
						var cachingItem:ICachingItem = IResourceServiceAir(m_resourceService).getCachingItem(m_hResource)
						if (cachingItem!=null)
						{
							cachingItem.addEventListener(ProgressEvent.PROGRESS, onCachingItemProgress);
							cachingItem.addEventListener(Event.COMPLETE, onCachingItemComplete);
							cachingItem.addEventListener(IOErrorEvent.IO_ERROR, onCachingItemFail);
						}
						else
						{
							source = src;
						}
					}
				}
				else
				{
					source = m_resourceService.getPathFromHandle(m_hResource);
				}
			}
		}

		
		protected function createProgress():void
		{
			m_progress = new ProgressBar();
			m_progress.width = 100;
			m_progress.height = 10;
			m_progress.alpha = 0.4;
			addElement(m_progress);	
			invalidateDisplayList();
		}
		
		protected function removeProgress():void
		{
			try
			{
				if (m_progress!=null && contains(m_progress))
				{
					removeElement(m_progress);
					m_progress = null;
				}
			}
			catch(error:Error)
			{
				
			}
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (m_progress!=null)
			{
				m_progress.move((width-m_progress.width)/2, (height-m_progress.height)/2); 
			}	
		}
		
		
		private function onCachingItemProgress(i_event:ProgressEvent):void
		{
			if (stage==null)
				return;
			
			if (m_progress==null)
			{
				createProgress();
			}
			
			var percentage:int = int((i_event.bytesLoaded / i_event.bytesTotal) * 100);
			m_progress.value = (i_event.bytesLoaded / i_event.bytesTotal);
		}

		private function onCachingItemComplete(i_event:Event):void
		{
			removeProgress();
			i_event.target.removeEventListener(ProgressEvent.PROGRESS, onCachingItemProgress);
			i_event.target.removeEventListener(Event.COMPLETE, onCachingItemComplete);
			i_event.target.removeEventListener(IOErrorEvent.IO_ERROR, onCachingItemFail);
			source = m_resourceService.getPathFromHandle(m_hResource);
		}
		
		private function onCachingItemFail(i_event:Event):void
		{
			i_event.target.removeEventListener(ProgressEvent.PROGRESS, onCachingItemProgress);
			i_event.target.removeEventListener(Event.COMPLETE, onCachingItemComplete);
			i_event.target.removeEventListener(IOErrorEvent.IO_ERROR, onCachingItemFail);
		}
		
		
		public override function save():XML
		{
			var xmlResource:XML = <Resource/>;
			xmlResource.@hResource = m_hResource;
			
			xmlResource.AspectRatio.@maintain = (m_maintainAspectRatio ? "1" : "0");			
			
			return xmlResource;
		}
		
		
		private function onResourceDownloaded(i_event:ResourceEvent):void
		{
			m_framework.EventBroker.removeEventListener(ResourceEvent.EVENT_RESOURCE_DOWNLOADED, onResourceDownloaded);
			source = m_resourceService.getPathFromHandle(m_hResource);
		}
		

		public function set source(i_source:String):void
		{
			m_source = i_source;
			invalidateProperties();
		}
		
		public function get hResource():int
		{
			return m_hResource;
		}
		
		public function set hResource(i_hResource:int):void
		{
			m_hResource = i_hResource;
			m_playerLoader.modified = true;
			loadResource();
		}
		

		public function get maintainAspectRatio():Boolean
		{
			return m_maintainAspectRatio; 
		}
		
		public function set maintainAspectRatio(i_maintainAspectRatio:Boolean):void
		{
			m_playerLoader.modified = true;
			m_maintainAspectRatio = i_maintainAspectRatio;
		}
		
		/************************************/
		/* Class Implementaion				*/
		/************************************/
		public override function initModule():void
		{
			super.initModule();
			m_resourceService = m_framework.ServiceBroker.QueryService("ResourceService") as IResourceService;
			if (m_hResource!=-1)
			{
				source = m_resourceService.getPathFromHandle(m_hResource);
			}
		}
	}
}