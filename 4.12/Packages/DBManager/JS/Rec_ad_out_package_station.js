function Rec_ad_out_package_station()
{
    Record.call(this);

    this.ad_out_package_station_id;
    this.ad_out_package_id;
    this.ad_out_subdomain;
    this.ad_out_business_id;
    this.ad_out_station_id;
    this.days_mask = 127;
    this.hour_start = 0;
    this.hour_end = 23;

}

extend(Record, Rec_ad_out_package_station);
