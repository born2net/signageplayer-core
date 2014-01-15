function Rec_ad_rate()
{
    Record.call(this);

    this.ad_rate_id;
    this.ad_rate_name = "Rate";
    this.ad_rate_map;
    this.hour_rate0 = 0;
    this.hour_rate1 = 0;
    this.hour_rate2 = 0;
    this.hour_rate3 = 0;

}

extend(Record, Rec_ad_rate);
