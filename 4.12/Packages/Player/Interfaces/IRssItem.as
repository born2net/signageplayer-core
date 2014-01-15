package
{
	public interface IRssItem
	{
		function get xml():XML;
		function getMediaPath():String; // ??? if there more then 1 media, i need to add getMediaCount() and i_index 
		function getMediaDuration():Number;
	}
}