package com.codeofdoom.constants
{
	import com.codeofdoom.components.MarkerData;
	
	import mx.collections.ArrayCollection;
	
	public class GoogleConstants{
		public static const KEY:String = "ABQIAAAAdquh3wQ9NAMtig8KXdLBGhQKUXvDVnYZDT2CoIcf8TTPNZrvchR0MZ0u2989_KRPbt6dGbHLVDNOzA";
		public static const DEFAULTMARKERS:ArrayCollection = new ArrayCollection([{markerData:new MarkerData(40.6734284,-73.9827536,"Loki")},
														  {markerData:new MarkerData(40.6762938,-73.9801574,"Union Hall")},
														  {markerData:new MarkerData(40.679327,-73.9816741, "Sheep Station")},
														  {markerData:new MarkerData(40.6673291,-73.9878376,"Common Wealth")},
														  {markerData:new MarkerData(40.6686494,-73.9852173,"Dram Shop")},
														 ]);
	}
}