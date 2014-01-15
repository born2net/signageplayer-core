package
{
	public class Record
	{
		public var native_id:int = -1;
		public var changelist_id:int;
		public var change_type:int;
		
		public var status:int = 0; // 0 - nothing; 1-update; 2- added; 3-deleted
		public var conflict:Boolean = false; 
	}
}