function Rec_ad_out_package_content()
{
    Record.call(this);

    this.ad_out_package_content_id;
    this.ad_out_package_id;
    this.resource_id;
    this.player_data_id;
    this.duration = 5;
    this.reparations_per_hour = 12;

}

extend(Record, Rec_ad_out_package_content);
