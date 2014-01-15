function Rec_ad_in_domain_business_package_station()
{
    Record.call(this);

    this.ad_in_domain_business_package_station_id;
    this.ad_in_domain_business_package_id;
    this.ad_package_station_id;
    this.accept_status = 0;
    this.suspend_modified_station = false;

}

extend(Record, Rec_ad_in_domain_business_package_station);
