package
{
	import flash.net.FileReference;
	
	public interface ILoaderManager
	{
		function CreateTableRequest():ITableRequest;
		
		function addFileReference(i_hResource:int, i_fileReference:FileReference):void;
		function addFileUrl(i_hResource:int, i_url:String):void;
		function getFileType(i_hResource:int):String
		function getFileReference(i_hResource:int):FileReference;
		function getFileUrl(i_hResource:int):String
		function removeFileReference(i_hResource:int):void;
		
		function selectDomainBusiness(i_businessDomain:String, i_businessId:int):void;
		function submit(i_submitCallback:Function):Boolean;
		function request(i_tableRequest:ITableRequest, i_fromLastChangelist:Boolean, i_updateLastChangelist:Boolean, i_reqDeleted:Boolean, i_requestCallback:Function):Boolean;
		function persistRequest(i_persistBank:String, i_persistKey:String, i_tableRequest:ITableRequest, i_fromLastChangelist:Boolean, i_updateLastChangelist:Boolean, i_updateTables:Boolean, i_reqDeleted:Boolean, i_requestCallback:Function):Boolean;
	}
}