package
{
	public interface IFacebookEventProvider extends IFacebookProvider
	{
		function get eventName():String;
		function get eventLocation():String;
		function get startTime():String;
		function get eventImage():String;
	}
}