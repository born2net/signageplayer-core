function Rec_ad_local_content()
{
    Record.call(this);

    this.ad_local_content_id;
    this.ad_local_package_id;
    this.enabled = true;
    this.content_name = "";

}

extend(Record, Rec_ad_local_content);
