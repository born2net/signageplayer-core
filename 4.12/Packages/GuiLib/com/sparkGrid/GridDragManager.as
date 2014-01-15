package com.sparkGrid
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.DragSource;
	import mx.core.IFactory;
	import mx.core.IFlexDisplayObject;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.DataGrid;
	import spark.components.Group;
	import spark.components.gridClasses.IGridItemRenderer;
	import spark.events.GridEvent;

	public class GridDragManager
	{
		private var m_dataGrid:DataGrid;
		private var m_enabled:Boolean;
		private var m_stageX:Number;
		private var m_stageY:Number;
		private var m_items:Array;
		
		
		public function GridDragManager(i_dataGrid:DataGrid, i_enabled:Boolean)
		{
			m_dataGrid = i_dataGrid;
			m_enabled = i_enabled;
			m_dataGrid.addEventListener(GridEvent.GRID_MOUSE_DOWN, startDragDrop);
		}
		
		public function get enabled():Boolean
		{
			return m_enabled;
		}
		
		public function set enabled(i_enabled:Boolean):void
		{
			m_enabled = i_enabled;	
		}
		
		private function startDragDrop(event:GridEvent):void
		{
			if (m_enabled==false)
				return;
			
			if (DragManager.isDragging)
				return;
			
			var item:Object;
			if (event.ctrlKey==false)
			{
				var wasSelected:Boolean = false;
				if (m_items!=null)
				{
					for each(item in m_items)
					{
						if (item==m_dataGrid.selectedItem)
						{
							wasSelected = true;
							break;
						}
					}
				}
				if (wasSelected)
				{
					var selectedItems:Vector.<Object> = new Vector.<Object>;
					for each(item in m_items)
					{
						selectedItems.push( item ); 
					}
					m_dataGrid.selectedItems = selectedItems;
				}
			}
			
			m_items = new Array();
			for each(item in m_dataGrid.selectedItems)
			{
				m_items.push(item);
			}

			
			m_dataGrid.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			m_dataGrid.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			m_stageX = event.stageX;
			m_stageY = event.stageY;
			
		}		
		
		private function onMouseMove(event:MouseEvent):void
		{
			if (Math.abs(m_stageX-event.stageX)>5 || Math.abs(m_stageY-event.stageY)>5)
			{
				removeEventListeners();
				startRowDragDrop(event);
			}
		}
		

		private function onMouseUp(event:MouseEvent):void
		{
			removeEventListeners();
		}
		
		private function removeEventListeners():void
		{
			m_dataGrid.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			m_dataGrid.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		
		private function startRowDragDrop(event:MouseEvent):void
		{
			if (m_dataGrid.selectedItems==null || m_dataGrid.selectedItems.length==0)
				return;
			var i:int;
			var count:int;
			
			
			
			
			//var newIndex:int = IGridItemRenderer(event.itemRenderer).rowIndex;
			
			var ds:DragSource = new DragSource();
			ds.addHandler(copySelectedItemsForDragDrop, "itemsByIndex");
			
			ds.addData(m_items, "items");
			
			var proxy:Group = new Group();
			proxy.styleName = m_dataGrid;
			proxy.width = m_dataGrid.grid.width;
			DragManager.doDrag(m_dataGrid, ds, event, proxy as IFlexDisplayObject, 0, -m_dataGrid.columnHeaderGroup.height);
			
			
			
			//m_dataGrid.addEventListener(DragEvent.DRAG_COMPLETE, rowDragCompleteHandler);	
			
		}		
		
		private function copySelectedItemsForDragDrop():Vector.<Object>
		{
			// Copy the vector so that we don't modify the original
			// since selectedIndices returns a reference.
			var draggedIndices:Vector.<int> = m_dataGrid.selectedIndices.slice(0, m_dataGrid.selectedIndices.length);
			var result:Vector.<Object> = new Vector.<Object>(draggedIndices.length);
			
			// Sort in the order of the data source
			draggedIndices.sort(compareValues);
			
			// Copy the items
			var count:int = draggedIndices.length;
			for (var i:int = 0; i < count; i++)
				result[i] = m_dataGrid.dataProvider.getItemAt(draggedIndices[i]);  
			return result;
		}
		
		private function compareValues(a:int, b:int):int
		{
			return a - b;
		} 
		
		/*
		private function rowDragCompleteHandler(event:DragEvent):void
		{
			// Remove the dragged items only if they were drag moved to
			// a different list. If the items were drag moved to this
			// list, the reordering was already handles in the 
			// DragEvent.DRAG_DROP listener.
			if (event.action != DragManager.MOVE || 
				event.relatedObject == m_dataGrid)
				return;
			
			// Clear the selection, but remember which items were moved
			var movedIndices:Vector.<int> = m_dataGrid.selectedIndices;
			m_dataGrid.selectedIndices = new Vector.<int>();
			
			// Remove the moved items
			movedIndices.sort(compareValues);
			var count:int = movedIndices.length;
			for (var i:int = count - 1; i >= 0; i--)
			{
				m_dataGrid.dataProvider.removeItemAt(movedIndices[i]);
			}                
		}
		*/
	}
}