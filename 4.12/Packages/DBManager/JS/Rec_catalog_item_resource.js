function Rec_catalog_item_resource()
{
    Record.call(this);

    this.catalog_item_resource_id = (-1);
    this.catalog_item_id = (-1);
    this.resource_id = (-1);
    this.resource_group = 0;

}

extend(Record, Rec_catalog_item_resource);
