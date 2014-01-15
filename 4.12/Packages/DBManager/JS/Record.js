function Record()
{
    this.self = this;
    this.native_id = -1;
    this.changelist_id = -1;
    this.change_type = 0;
    this.status = 0; // 0 - nothing; 1-update; 2- added; 3-deleted
    this.conflict = false;
};
