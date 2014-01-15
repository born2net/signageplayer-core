function Rec_ad_out_package()
{
    Record.call(this);

    this.ad_out_package_id;
    this.package_name = "Package";
    this.start_date =  new Date();
    this.end_date =  new Date();

}

extend(Record, Rec_ad_out_package);
