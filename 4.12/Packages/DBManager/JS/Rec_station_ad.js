function Rec_station_ad()
{
    Record.call(this);

    this.branch_station_id;
    this.advertising_network;
    this.advertising_description = "";
    this.advertising_keys = "";
    this.ad_rate_id;

}

extend(Record, Rec_station_ad);
