package com.codeofdoom.utils
{
	import com.codeofdoom.components.MarkerData;
	
	import mx.collections.ArrayCollection;
	
	public class MapUtils
	{
		public static function getMarkerDataByLatAndLng(lat:Number,lng:Number,arr:ArrayCollection):Object{
			for each (var o:Object in arr){
				var md:MarkerData = o["markerData"];
				if (md.lat == lat && md.lng == lng)
					return o;
			}
			return null;
		}
		
		

	}
}