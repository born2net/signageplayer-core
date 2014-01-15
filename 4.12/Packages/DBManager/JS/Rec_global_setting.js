function Rec_global_setting()
{
    Record.call(this);

    this.param_id = (-1);
    this.param_key = "";
    this.param_value = "";

}

extend(Record, Rec_global_setting);
