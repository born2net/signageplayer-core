package
{
	import Tree.*;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.XMLListCollection;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.ISystemManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import spark.core.NavigationUnit;

	public class TreeEx extends Tree
	{
		protected var m_autoDispose:Boolean = true;
		protected var m_disposed:Boolean = false;
		protected var m_iconMap:Object = new Object();
		
		public function TreeEx()
		{
			super();
			//??? itemEditor = new ClassFactory(TreeItemEditor);
			//???!!! editorXOffset = 28;
			/*???
			addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			*/
			if (iconField!=null)
			{
				iconFunction = onTreeItemIcon;
			}
		}
		
		
		protected override function item_mouseDownHandler(event:MouseEvent):void
		{
			var sm:ISystemManager = systemManager;
			if (sm!=null && sm.stage!=null)
			{
				setFocus();
			}
			
			super.item_mouseDownHandler(event);
		}
		
		/*???
        private function onFocusIn(event:FocusEvent):void
        {
			refreshRenderers();
        }

        private function onFocusOut(event:FocusEvent):void
        {
			refreshRenderers();
        }
        */
		
		protected override function createChildren():void
		{
			super.createChildren();
			if (m_autoDispose)
				addEventListener(FlexEvent.REMOVE, onRemove);
			
			var css:CSSStyleDeclaration = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("TreeEx" );
			setStyle("selectionColor", css.getStyle("focusInSelectorColor"));
			setStyle("rollOverColor", css.getStyle("focusInSelectorColor"));
			
			
			
			var openFolderIcon:Class = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration(".icons").getStyle("openFolderIcon");
			var closeFolderIcon:Class = FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration(".icons").getStyle("closeFolderIcon");
			setStyle("folderOpenIcon", openFolderIcon);
			setStyle("folderClosedIcon", closeFolderIcon);
			
			addTreeIcon("folderOpenIcon", openFolderIcon);
			addTreeIcon("folderClosedIcon", closeFolderIcon);
		}
		
		public function insertItemAtPath(i_treePath:String, i_parent:Object, i_collection:ArrayCollection, i_item:Object):void
		{ 
			if (i_treePath!="")
			{
				var pathList:Array = i_treePath.split("/");
				 
				for each(var folderName:String in pathList)
				{
					var folderItem:Object = null;
					for each(var child:Object in i_collection)
					{
						if (child.label==folderName)
						{
							folderItem = child;
							break;
						}
					}
					
					if (folderItem==null)
					{
						folderItem = new Object();
						folderItem.name = "Folder";
						folderItem.label = folderName;
						folderItem.parent = i_parent;
						i_collection.addItem(folderItem);
					}
					
					if (folderItem.children==null)
					{
						folderItem.children = new ArrayCollection();
					}
					

					i_parent = folderItem;
					i_collection = folderItem.children;
				}
			}
			i_item.parent = i_parent;
			i_collection.addItem(i_item);
		}
		
		public function createFolder(i_treePath:String, i_parent:Object):void
		{
			if (i_treePath!="")
			{
				var pathList:Array = i_treePath.split("/");
				
				for each(var folderName:String in pathList)
				{
					var folderItem:Object = null;
					for each(var child:Object in i_parent.children)
					{
						if (child.label==folderName)
						{
							folderItem = child;
							break;
						}
					}					
					if (folderItem==null)
					{
						folderItem = new Object();
						folderItem.parent = i_parent;
						folderItem.name = "Folder";
						folderItem.label = folderName;
						folderItem.icon = "folderClosedIcon";
						folderItem.children = new ArrayCollection();
						ArrayCollection(i_parent.children).addItem(folderItem);
					}
					i_parent = folderItem;
				}
			}
		}
		
		private function onRemove(event:FlexEvent):void
		{
			dispose();
		}

		public function addNode(i_node:XML):void
		{
			dataProvider.addItem(i_node);
			
			/*???!!!
			// Fix Bug 148: Can't Delete Item From tree. (workaround to Flex issue) ???  
			var dp:Object = dataProvider; 
			dataProvider = dp; 
			*/
		}
		
		public function removeNode(i_node:Object):void
		{
			var list:IList = dataProvider as IList;
			if (list!=null)
			{
				var index:int = list.getItemIndex(i_node);
				list.removeItemAt(index);
			}
		}
		
		public function addTreeIcon(i_iconName:String, i_iconClass:Class):void
		{
			m_iconMap[i_iconName] = i_iconClass;
		}
		
		

		public function expandItemParents(i_item:Object):void
		{ 
			if (i_item!=null)
			{
				expandItemParents(i_item.parent);
				if (i_item.name=="Folder")
				{
					expandItem(i_item, true);
				}
			}
		}
		
		
		public function expandAll(i_collection:ArrayCollection):void
		{
			for each(var item:Object in i_collection)
			{
				if (item.name=="Folder" && ArrayCollection(item.children).length>0)
				{
					expandItem(item);
					expandAll(item.chidren);
				}
			}
		}
		
		private function onTreeItemIcon(i_item:Object, a2:Object, a3:Object):Object
		{
			if (i_item==null)
				return null;
			var iconName:String = i_item[iconField];
			var iconClass:Class = m_iconMap[iconName];
			return iconClass;
		}		 	

		public function dispose():void
		{
			if (m_disposed==false)
			{
				m_disposed = true;
				if (m_autoDispose)
				{
					removeEventListener(FlexEvent.REMOVE, onDispose);
				}
				onDispose();
			}
		}
		
		public function scrollToBottom():void
		{
			layout.verticalScrollPosition += layout.getVerticalScrollPositionDelta(NavigationUnit.END);
		}
		
		protected function onDispose():void
		{ 
			/*???
			removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			*/
		}
	}
}