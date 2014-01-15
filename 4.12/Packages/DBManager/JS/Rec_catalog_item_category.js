function Rec_catalog_item_category()
{
    Record.call(this);

    this.catalog_item_category_id = (-1);
    this.catalog_item_id = (-1);
    this.category_value_id = (-1);

}

extend(Record, Rec_catalog_item_category);
