function Rec_catalog_item_info()
{
    Record.call(this);

    this.catalog_item_id = (-1);
    this.info0 = "";
    this.info1 = "";
    this.info2 = "";
    this.info3 = "";

}

extend(Record, Rec_catalog_item_info);
