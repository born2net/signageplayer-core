function Rec_catalog_item()
{
    Record.call(this);

    this.catalog_item_id = (-1);
    this.item_name = "Item";
    this.ad_local_content_id = (-1);

}

extend(Record, Rec_catalog_item);
