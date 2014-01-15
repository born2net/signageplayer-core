package
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class AdReportAir extends AdReport
	{
		public function AdReportAir(i_framework:IFramework, i_advertiseService:IAdvertisingService, i_businessDomain:String, i_businessId:int)
		{
			super(i_framework, i_advertiseService, i_businessDomain, i_businessId);
		}
		
		public override function exportReport():Boolean
		{
			if (m_filterReportData!=null)
			{
				var file:File = new File();
				file.browseForSave("Export report");
				file.addEventListener(Event.SELECT, onFileSelected);
			}
			return true;
		}
		
		private function appendLine(i_line:String, i_data:String):String
		{
			if (i_line!="")
				i_line += ", ";
			i_line += i_data;
			return i_line;
		}
		
		private function onFileSelected(event:Event):void
		{
			var text:String = "";
			var header:String = "";
			var firstTime:Boolean = true;
			for each(var stat:Object in m_filterReportData.source)
			{
				var line:String = "";
				
				if (m_aggregateDaily)
				{
					if (firstTime)
					{
						header = appendLine(header, "Date");
					}
					line = appendLine(line, String(stat.dateLabel));
				} 
				if (m_aggregateHourly)
				{
					if (firstTime)
					{
						header = appendLine(header, "Time");
					}
					line = appendLine(line, String(stat.timeLabel));
				}
				if (m_aggregatePackage)
				{
					if (firstTime)
					{
						header = appendLine(header, "Package");
					}
					line = appendLine(line, String(stat.packageName));
				}
				if (m_aggregateStation)
				{
					if (firstTime)
					{
						header = appendLine(header, "Station");
					}
					line = appendLine(line, String(stat.stationName));
				}
				if (m_aggregateContent)
				{
					if (firstTime)
					{
						header = appendLine(header, "Content");
					}
					line = appendLine(line, String(stat.contentName));
				}
				if (firstTime)
				{
					header = appendLine(header, "Counts");
					header = appendLine(header, "Duration");
					header = appendLine(header, "Avg MPixles");
				}
				line = appendLine(line, String(stat.counts));
				line = appendLine(line, String(stat.durationLabel));
				line = appendLine(line, String(stat.avgMP));
				if (m_aggregateDaily && m_aggregateHourly)
				{
					if (firstTime)
					{
						header = appendLine(header, "Rate");
					}					
					line = appendLine(line, String(stat.rate));
				}
				if (firstTime)
				{
					header = appendLine(header, "Price");
				}					
				line = appendLine(line, String(stat.price));
				
				if (firstTime)
				{
					text+=header + "\n";
				}
				text+=line + "\n";
				
				firstTime = false;
			}
				
			var file:File = File(event.target);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(text);
			fileStream.close();
		}
	}
}