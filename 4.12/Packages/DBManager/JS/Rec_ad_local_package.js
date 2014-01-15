function Rec_ad_local_package()
{
    Record.call(this);

    this.ad_local_package_id;
    this.enabled = true;
    this.package_name = "Package";
    this.use_date_range = false;
    this.start_date =  new Date();
    this.end_date =  new Date();

}

extend(Record, Rec_ad_local_package);
