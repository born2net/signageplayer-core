package
{
	import mx.collections.ArrayCollection;

	public interface IFacebookAlbumProvider
	{
		function get photoCreated():String;
		function get photoCaption():String;
		function get bigPhoto():String;
		function get smallPhoto():String;
	}
}