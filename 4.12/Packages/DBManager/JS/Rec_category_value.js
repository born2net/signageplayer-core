function Rec_category_value()
{
    Record.call(this);

    this.category_value_id = (-1);
    this.parent_category_value_id = (-1);
    this.category_value = "Category";

}

extend(Record, Rec_category_value);
