package
{
	import flash.utils.Dictionary;
	
	public class CatalogService implements ICatalogService
	{
		private var m_framework:IFramework;
		private var m_dataBaseManager:DataBaseManager;
		
		private var m_CatalogItems:Dictionary = new Dictionary();
		
		public function CatalogService(i_framework:IFramework)
		{
			m_framework = i_framework;
			m_dataBaseManager = m_framework.ServiceBroker.QueryService("DataBaseManager") as DataBaseManager;
		}
		
		public function sync():void //??? 
		{
			m_CatalogItems = m_dataBaseManager.table_catalog_item_resources.getKeysByFK("catalog_item_id");
		}
		
		public function getResourceList(i_hCatalogItem:int):Array
		{
			return m_CatalogItems[i_hCatalogItem];
		}
		
		public function queryItemList(i_categories:Array):Array
		{
			var categoryItemMap:Dictionary = new Dictionary(); 
			var itemCategoryKeys:Array = m_dataBaseManager.table_catalog_item_categories.getAllPrimaryKeys();
			for each(var hCategoryValue:int in i_categories)
			{
				for each(var hCatalogItemCategory:int in itemCategoryKeys)
				{
					var recCatalogItemCategory:Rec_catalog_item_category = m_dataBaseManager.table_catalog_item_categories.getRecord(hCatalogItemCategory);
					if (recCatalogItemCategory.category_value_id==hCategoryValue)
					{
						categoryItemMap[recCatalogItemCategory.catalog_item_id] = recCatalogItemCategory.catalog_item_id;
					}
				}
			}
			var items:Array = [];
			for each(var hCatalogItem:int in categoryItemMap)
			{
				items.push(hCatalogItem);
			}
			
			return items;
		}
	}
}