function Rec_ad_in_domain_business_package()
{
    Record.call(this);

    this.ad_in_domain_business_package_id;
    this.ad_in_domain_business_id;
    this.ad_package_id;
    this.accept_new_station = 0;
    this.suspend_modified_package_date = false;
    this.suspend_modified_content = false;

}

extend(Record, Rec_ad_in_domain_business_package);
