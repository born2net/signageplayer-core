function Rec_resource()
{
    Record.call(this);

    this.resource_id = (-1);
    this.resource_name = "Resource";
    this.resource_type;
    this.resource_pixel_width = 0;
    this.resource_pixel_height = 0;
    this.default_player;
    this.snapshot;
    this.resource_total_time = 0;
    this.resource_date_created;
    this.resource_date_modified;
    this.resource_trust = false;
    this.resource_public = false;
    this.resource_bytes_total = 0;
    this.resource_module = false;
    this.tree_path = "";
    this.access_key = 0;
    this.resource_html = false;

}

extend(Record, Rec_resource);
