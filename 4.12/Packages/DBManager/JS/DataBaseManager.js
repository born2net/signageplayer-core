includeJS('https://js.signage.me/Table_global_settings.js');
includeJS('https://js.signage.me/Rec_global_setting.js');
includeJS('https://js.signage.me/Table_resources.js');
includeJS('https://js.signage.me/Rec_resource.js');
includeJS('https://js.signage.me/Table_ad_local_packages.js');
includeJS('https://js.signage.me/Rec_ad_local_package.js');
includeJS('https://js.signage.me/Table_ad_local_contents.js');
includeJS('https://js.signage.me/Rec_ad_local_content.js');
includeJS('https://js.signage.me/Table_category_values.js');
includeJS('https://js.signage.me/Rec_category_value.js');
includeJS('https://js.signage.me/Table_catalog_items.js');
includeJS('https://js.signage.me/Rec_catalog_item.js');
includeJS('https://js.signage.me/Table_catalog_item_infos.js');
includeJS('https://js.signage.me/Rec_catalog_item_info.js');
includeJS('https://js.signage.me/Table_catalog_item_resources.js');
includeJS('https://js.signage.me/Rec_catalog_item_resource.js');
includeJS('https://js.signage.me/Table_catalog_item_categories.js');
includeJS('https://js.signage.me/Rec_catalog_item_category.js');
includeJS('https://js.signage.me/Table_player_data.js');
includeJS('https://js.signage.me/Rec_player_data.js');
includeJS('https://js.signage.me/Table_boards.js');
includeJS('https://js.signage.me/Rec_board.js');
includeJS('https://js.signage.me/Table_campaigns.js');
includeJS('https://js.signage.me/Rec_campaign.js');
includeJS('https://js.signage.me/Table_campaign_channels.js');
includeJS('https://js.signage.me/Rec_campaign_channel.js');
includeJS('https://js.signage.me/Table_campaign_channel_players.js');
includeJS('https://js.signage.me/Rec_campaign_channel_player.js');
includeJS('https://js.signage.me/Table_campaign_timelines.js');
includeJS('https://js.signage.me/Rec_campaign_timeline.js');
includeJS('https://js.signage.me/Table_campaign_events.js');
includeJS('https://js.signage.me/Rec_campaign_event.js');
includeJS('https://js.signage.me/Table_campaign_boards.js');
includeJS('https://js.signage.me/Rec_campaign_board.js');
includeJS('https://js.signage.me/Table_board_templates.js');
includeJS('https://js.signage.me/Rec_board_template.js');
includeJS('https://js.signage.me/Table_board_template_viewers.js');
includeJS('https://js.signage.me/Rec_board_template_viewer.js');
includeJS('https://js.signage.me/Table_campaign_timeline_chanels.js');
includeJS('https://js.signage.me/Rec_campaign_timeline_chanel.js');
includeJS('https://js.signage.me/Table_campaign_timeline_channels.js');
includeJS('https://js.signage.me/Rec_campaign_timeline_channel.js');
includeJS('https://js.signage.me/Table_campaign_timeline_board_templates.js');
includeJS('https://js.signage.me/Rec_campaign_timeline_board_template.js');
includeJS('https://js.signage.me/Table_campaign_timeline_board_viewer_chanels.js');
includeJS('https://js.signage.me/Rec_campaign_timeline_board_viewer_chanel.js');
includeJS('https://js.signage.me/Table_campaign_timeline_board_viewer_channels.js');
includeJS('https://js.signage.me/Rec_campaign_timeline_board_viewer_channel.js');
includeJS('https://js.signage.me/Table_campaign_timeline_chanel_players.js');
includeJS('https://js.signage.me/Rec_campaign_timeline_chanel_player.js');
includeJS('https://js.signage.me/Table_campaign_timeline_schedules.js');
includeJS('https://js.signage.me/Rec_campaign_timeline_schedule.js');
includeJS('https://js.signage.me/Table_campaign_timeline_sequences.js');
includeJS('https://js.signage.me/Rec_campaign_timeline_sequence.js');
includeJS('https://js.signage.me/Table_scripts.js');
includeJS('https://js.signage.me/Rec_script.js');
includeJS('https://js.signage.me/Table_music_channels.js');
includeJS('https://js.signage.me/Rec_music_channel.js');
includeJS('https://js.signage.me/Table_music_channel_songs.js');
includeJS('https://js.signage.me/Rec_music_channel_song.js');
includeJS('https://js.signage.me/Table_branch_stations.js');
includeJS('https://js.signage.me/Rec_branch_station.js');
includeJS('https://js.signage.me/Table_ad_rates.js');
includeJS('https://js.signage.me/Rec_ad_rate.js');
includeJS('https://js.signage.me/Table_station_ads.js');
includeJS('https://js.signage.me/Rec_station_ad.js');
includeJS('https://js.signage.me/Table_ad_out_packages.js');
includeJS('https://js.signage.me/Rec_ad_out_package.js');
includeJS('https://js.signage.me/Table_ad_out_package_contents.js');
includeJS('https://js.signage.me/Rec_ad_out_package_content.js');
includeJS('https://js.signage.me/Table_ad_out_package_stations.js');
includeJS('https://js.signage.me/Rec_ad_out_package_station.js');
includeJS('https://js.signage.me/Table_ad_in_domains.js');
includeJS('https://js.signage.me/Rec_ad_in_domain.js');
includeJS('https://js.signage.me/Table_ad_in_domain_businesses.js');
includeJS('https://js.signage.me/Rec_ad_in_domain_business.js');
includeJS('https://js.signage.me/Table_ad_in_domain_business_packages.js');
includeJS('https://js.signage.me/Rec_ad_in_domain_business_package.js');
includeJS('https://js.signage.me/Table_ad_in_domain_business_package_stations.js');
includeJS('https://js.signage.me/Rec_ad_in_domain_business_package_station.js');


// test

function DataBaseManager()
{
    DataManager.call(this);
}

extend(DataManager, DataBaseManager);


DataBaseManager.prototype.table_global_settings = function() { return this.m_selectedDataBase.m_tables['global_settings']; }
DataBaseManager.prototype.table_resources = function() { return this.m_selectedDataBase.m_tables['resources']; }
DataBaseManager.prototype.table_ad_local_packages = function() { return this.m_selectedDataBase.m_tables['ad_local_packages']; }
DataBaseManager.prototype.table_ad_local_contents = function() { return this.m_selectedDataBase.m_tables['ad_local_contents']; }
DataBaseManager.prototype.table_category_values = function() { return this.m_selectedDataBase.m_tables['category_values']; }
DataBaseManager.prototype.table_catalog_items = function() { return this.m_selectedDataBase.m_tables['catalog_items']; }
DataBaseManager.prototype.table_catalog_item_infos = function() { return this.m_selectedDataBase.m_tables['catalog_item_infos']; }
DataBaseManager.prototype.table_catalog_item_resources = function() { return this.m_selectedDataBase.m_tables['catalog_item_resources']; }
DataBaseManager.prototype.table_catalog_item_categories = function() { return this.m_selectedDataBase.m_tables['catalog_item_categories']; }
DataBaseManager.prototype.table_player_data = function() { return this.m_selectedDataBase.m_tables['player_data']; }
DataBaseManager.prototype.table_boards = function() { return this.m_selectedDataBase.m_tables['boards']; }
DataBaseManager.prototype.table_campaigns = function() { return this.m_selectedDataBase.m_tables['campaigns']; }
DataBaseManager.prototype.table_campaign_channels = function() { return this.m_selectedDataBase.m_tables['campaign_channels']; }
DataBaseManager.prototype.table_campaign_channel_players = function() { return this.m_selectedDataBase.m_tables['campaign_channel_players']; }
DataBaseManager.prototype.table_campaign_timelines = function() { return this.m_selectedDataBase.m_tables['campaign_timelines']; }
DataBaseManager.prototype.table_campaign_events = function() { return this.m_selectedDataBase.m_tables['campaign_events']; }
DataBaseManager.prototype.table_campaign_boards = function() { return this.m_selectedDataBase.m_tables['campaign_boards']; }
DataBaseManager.prototype.table_board_templates = function() { return this.m_selectedDataBase.m_tables['board_templates']; }
DataBaseManager.prototype.table_board_template_viewers = function() { return this.m_selectedDataBase.m_tables['board_template_viewers']; }
DataBaseManager.prototype.table_campaign_timeline_chanels = function() { return this.m_selectedDataBase.m_tables['campaign_timeline_chanels']; }
DataBaseManager.prototype.table_campaign_timeline_channels = function() { return this.m_selectedDataBase.m_tables['campaign_timeline_channels']; }
DataBaseManager.prototype.table_campaign_timeline_board_templates = function() { return this.m_selectedDataBase.m_tables['campaign_timeline_board_templates']; }
DataBaseManager.prototype.table_campaign_timeline_board_viewer_chanels = function() { return this.m_selectedDataBase.m_tables['campaign_timeline_board_viewer_chanels']; }
DataBaseManager.prototype.table_campaign_timeline_board_viewer_channels = function() { return this.m_selectedDataBase.m_tables['campaign_timeline_board_viewer_channels']; }
DataBaseManager.prototype.table_campaign_timeline_chanel_players = function() { return this.m_selectedDataBase.m_tables['campaign_timeline_chanel_players']; }
DataBaseManager.prototype.table_campaign_timeline_schedules = function() { return this.m_selectedDataBase.m_tables['campaign_timeline_schedules']; }
DataBaseManager.prototype.table_campaign_timeline_sequences = function() { return this.m_selectedDataBase.m_tables['campaign_timeline_sequences']; }
DataBaseManager.prototype.table_scripts = function() { return this.m_selectedDataBase.m_tables['scripts']; }
DataBaseManager.prototype.table_music_channels = function() { return this.m_selectedDataBase.m_tables['music_channels']; }
DataBaseManager.prototype.table_music_channel_songs = function() { return this.m_selectedDataBase.m_tables['music_channel_songs']; }
DataBaseManager.prototype.table_branch_stations = function() { return this.m_selectedDataBase.m_tables['branch_stations']; }
DataBaseManager.prototype.table_ad_rates = function() { return this.m_selectedDataBase.m_tables['ad_rates']; }
DataBaseManager.prototype.table_station_ads = function() { return this.m_selectedDataBase.m_tables['station_ads']; }
DataBaseManager.prototype.table_ad_out_packages = function() { return this.m_selectedDataBase.m_tables['ad_out_packages']; }
DataBaseManager.prototype.table_ad_out_package_contents = function() { return this.m_selectedDataBase.m_tables['ad_out_package_contents']; }
DataBaseManager.prototype.table_ad_out_package_stations = function() { return this.m_selectedDataBase.m_tables['ad_out_package_stations']; }
DataBaseManager.prototype.table_ad_in_domains = function() { return this.m_selectedDataBase.m_tables['ad_in_domains']; }
DataBaseManager.prototype.table_ad_in_domain_businesses = function() { return this.m_selectedDataBase.m_tables['ad_in_domain_businesses']; }
DataBaseManager.prototype.table_ad_in_domain_business_packages = function() { return this.m_selectedDataBase.m_tables['ad_in_domain_business_packages']; }
DataBaseManager.prototype.table_ad_in_domain_business_package_stations = function() { return this.m_selectedDataBase.m_tables['ad_in_domain_business_package_stations']; }



DataBaseManager.prototype.createDataBase = function(i_businessDomain, i_businessId)
{
    var dataModule = this.createDataModule(i_businessDomain, i_businessId);
    dataModule.m_tableList = ["global_settings", "resources", "ad_local_packages", "ad_local_contents", "category_values", "catalog_items", "catalog_item_infos", "catalog_item_resources", "catalog_item_categories", "player_data", "boards", "campaigns", "campaign_channels", "campaign_channel_players", "campaign_timelines", "campaign_events", "campaign_boards", "board_templates", "board_template_viewers", "campaign_timeline_chanels", "campaign_timeline_channels", "campaign_timeline_board_templates", "campaign_timeline_board_viewer_chanels", "campaign_timeline_board_viewer_channels", "campaign_timeline_chanel_players", "campaign_timeline_schedules", "campaign_timeline_sequences", "scripts", "music_channels", "music_channel_songs", "branch_stations", "ad_rates", "station_ads", "ad_out_packages", "ad_out_package_contents", "ad_out_package_stations", "ad_in_domains", "ad_in_domain_businesses", "ad_in_domain_business_packages", "ad_in_domain_business_package_stations"];


            dataModule.m_tables["global_settings"] = new Table_global_settings(this);
            dataModule.m_tables["resources"] = new Table_resources(this);
            dataModule.m_tables["ad_local_packages"] = new Table_ad_local_packages(this);
            dataModule.m_tables["ad_local_contents"] = new Table_ad_local_contents(this);
            dataModule.m_tables["category_values"] = new Table_category_values(this);
            dataModule.m_tables["catalog_items"] = new Table_catalog_items(this);
            dataModule.m_tables["catalog_item_infos"] = new Table_catalog_item_infos(this);
            dataModule.m_tables["catalog_item_resources"] = new Table_catalog_item_resources(this);
            dataModule.m_tables["catalog_item_categories"] = new Table_catalog_item_categories(this);
            dataModule.m_tables["player_data"] = new Table_player_data(this);
            dataModule.m_tables["boards"] = new Table_boards(this);
            dataModule.m_tables["campaigns"] = new Table_campaigns(this);
            dataModule.m_tables["campaign_channels"] = new Table_campaign_channels(this);
            dataModule.m_tables["campaign_channel_players"] = new Table_campaign_channel_players(this);
            dataModule.m_tables["campaign_timelines"] = new Table_campaign_timelines(this);
            dataModule.m_tables["campaign_events"] = new Table_campaign_events(this);
            dataModule.m_tables["campaign_boards"] = new Table_campaign_boards(this);
            dataModule.m_tables["board_templates"] = new Table_board_templates(this);
            dataModule.m_tables["board_template_viewers"] = new Table_board_template_viewers(this);
            dataModule.m_tables["campaign_timeline_chanels"] = new Table_campaign_timeline_chanels(this);
            dataModule.m_tables["campaign_timeline_channels"] = new Table_campaign_timeline_channels(this);
            dataModule.m_tables["campaign_timeline_board_templates"] = new Table_campaign_timeline_board_templates(this);
            dataModule.m_tables["campaign_timeline_board_viewer_chanels"] = new Table_campaign_timeline_board_viewer_chanels(this);
            dataModule.m_tables["campaign_timeline_board_viewer_channels"] = new Table_campaign_timeline_board_viewer_channels(this);
            dataModule.m_tables["campaign_timeline_chanel_players"] = new Table_campaign_timeline_chanel_players(this);
            dataModule.m_tables["campaign_timeline_schedules"] = new Table_campaign_timeline_schedules(this);
            dataModule.m_tables["campaign_timeline_sequences"] = new Table_campaign_timeline_sequences(this);
            dataModule.m_tables["scripts"] = new Table_scripts(this);
            dataModule.m_tables["music_channels"] = new Table_music_channels(this);
            dataModule.m_tables["music_channel_songs"] = new Table_music_channel_songs(this);
            dataModule.m_tables["branch_stations"] = new Table_branch_stations(this);
            dataModule.m_tables["ad_rates"] = new Table_ad_rates(this);
            dataModule.m_tables["station_ads"] = new Table_station_ads(this);
            dataModule.m_tables["ad_out_packages"] = new Table_ad_out_packages(this);
            dataModule.m_tables["ad_out_package_contents"] = new Table_ad_out_package_contents(this);
            dataModule.m_tables["ad_out_package_stations"] = new Table_ad_out_package_stations(this);
            dataModule.m_tables["ad_in_domains"] = new Table_ad_in_domains(this);
            dataModule.m_tables["ad_in_domain_businesses"] = new Table_ad_in_domain_businesses(this);
            dataModule.m_tables["ad_in_domain_business_packages"] = new Table_ad_in_domain_business_packages(this);
            dataModule.m_tables["ad_in_domain_business_package_stations"] = new Table_ad_in_domain_business_package_stations(this);
}


DataBaseManager.prototype.createHandles = function()
{
    self2 = this;
	self2.createFieldHandles(self2.table_campaign_timeline_chanel_players(), "player_data");
	self2.createFieldHandles(self2.table_campaign_channel_players(), "player_data");
	self2.createFieldHandles(self2.table_player_data(), "player_data_value");
}

