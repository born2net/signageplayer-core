package
{
	public interface IFacebookFriendProvider extends IFacebookProvider
	{
		function get friendName():String;
		function get friendSex():String;
		function get friendImage():String;
	}
}