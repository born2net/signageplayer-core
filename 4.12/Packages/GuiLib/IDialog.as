package
{
	import mx.core.IUIComponent;
	
	public interface IDialog extends IUIComponent
	{
		function setOkCancelDlg(i_okCancelDlg:OkCancelDlg):void;
		function onOk():void;
		function onCancel():void;
		function onButton(i_name:String):void;
	}
}