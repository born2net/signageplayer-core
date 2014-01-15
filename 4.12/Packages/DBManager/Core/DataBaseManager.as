package
{
	public class DataBaseManager extends DataManager
	{

        public function get table_global_settings():Table_global_settings {	return m_selectedDataBase.m_tables["global_settings"]; }
        public function get table_resources():Table_resources {	return m_selectedDataBase.m_tables["resources"]; }
        public function get table_ad_local_packages():Table_ad_local_packages {	return m_selectedDataBase.m_tables["ad_local_packages"]; }
        public function get table_ad_local_contents():Table_ad_local_contents {	return m_selectedDataBase.m_tables["ad_local_contents"]; }
        public function get table_category_values():Table_category_values {	return m_selectedDataBase.m_tables["category_values"]; }
        public function get table_catalog_items():Table_catalog_items {	return m_selectedDataBase.m_tables["catalog_items"]; }
        public function get table_catalog_item_infos():Table_catalog_item_infos {	return m_selectedDataBase.m_tables["catalog_item_infos"]; }
        public function get table_catalog_item_resources():Table_catalog_item_resources {	return m_selectedDataBase.m_tables["catalog_item_resources"]; }
        public function get table_catalog_item_categories():Table_catalog_item_categories {	return m_selectedDataBase.m_tables["catalog_item_categories"]; }
        public function get table_player_data():Table_player_data {	return m_selectedDataBase.m_tables["player_data"]; }
        public function get table_boards():Table_boards {	return m_selectedDataBase.m_tables["boards"]; }
        public function get table_campaigns():Table_campaigns {	return m_selectedDataBase.m_tables["campaigns"]; }
        public function get table_campaign_channels():Table_campaign_channels {	return m_selectedDataBase.m_tables["campaign_channels"]; }
        public function get table_campaign_channel_players():Table_campaign_channel_players {	return m_selectedDataBase.m_tables["campaign_channel_players"]; }
        public function get table_campaign_timelines():Table_campaign_timelines {	return m_selectedDataBase.m_tables["campaign_timelines"]; }
        public function get table_campaign_events():Table_campaign_events {	return m_selectedDataBase.m_tables["campaign_events"]; }
        public function get table_campaign_boards():Table_campaign_boards {	return m_selectedDataBase.m_tables["campaign_boards"]; }
        public function get table_board_templates():Table_board_templates {	return m_selectedDataBase.m_tables["board_templates"]; }
        public function get table_board_template_viewers():Table_board_template_viewers {	return m_selectedDataBase.m_tables["board_template_viewers"]; }
        public function get table_campaign_timeline_chanels():Table_campaign_timeline_chanels {	return m_selectedDataBase.m_tables["campaign_timeline_chanels"]; }
        public function get table_campaign_timeline_channels():Table_campaign_timeline_channels {	return m_selectedDataBase.m_tables["campaign_timeline_channels"]; }
        public function get table_campaign_timeline_board_templates():Table_campaign_timeline_board_templates {	return m_selectedDataBase.m_tables["campaign_timeline_board_templates"]; }
        public function get table_campaign_timeline_board_viewer_chanels():Table_campaign_timeline_board_viewer_chanels {	return m_selectedDataBase.m_tables["campaign_timeline_board_viewer_chanels"]; }
        public function get table_campaign_timeline_board_viewer_channels():Table_campaign_timeline_board_viewer_channels {	return m_selectedDataBase.m_tables["campaign_timeline_board_viewer_channels"]; }
        public function get table_campaign_timeline_chanel_players():Table_campaign_timeline_chanel_players {	return m_selectedDataBase.m_tables["campaign_timeline_chanel_players"]; }
        public function get table_campaign_timeline_schedules():Table_campaign_timeline_schedules {	return m_selectedDataBase.m_tables["campaign_timeline_schedules"]; }
        public function get table_campaign_timeline_sequences():Table_campaign_timeline_sequences {	return m_selectedDataBase.m_tables["campaign_timeline_sequences"]; }
        public function get table_scripts():Table_scripts {	return m_selectedDataBase.m_tables["scripts"]; }
        public function get table_music_channels():Table_music_channels {	return m_selectedDataBase.m_tables["music_channels"]; }
        public function get table_music_channel_songs():Table_music_channel_songs {	return m_selectedDataBase.m_tables["music_channel_songs"]; }
        public function get table_branch_stations():Table_branch_stations {	return m_selectedDataBase.m_tables["branch_stations"]; }
        public function get table_ad_rates():Table_ad_rates {	return m_selectedDataBase.m_tables["ad_rates"]; }
        public function get table_station_ads():Table_station_ads {	return m_selectedDataBase.m_tables["station_ads"]; }
        public function get table_ad_out_packages():Table_ad_out_packages {	return m_selectedDataBase.m_tables["ad_out_packages"]; }
        public function get table_ad_out_package_contents():Table_ad_out_package_contents {	return m_selectedDataBase.m_tables["ad_out_package_contents"]; }
        public function get table_ad_out_package_stations():Table_ad_out_package_stations {	return m_selectedDataBase.m_tables["ad_out_package_stations"]; }
        public function get table_ad_in_domains():Table_ad_in_domains {	return m_selectedDataBase.m_tables["ad_in_domains"]; }
        public function get table_ad_in_domain_businesses():Table_ad_in_domain_businesses {	return m_selectedDataBase.m_tables["ad_in_domain_businesses"]; }
        public function get table_ad_in_domain_business_packages():Table_ad_in_domain_business_packages {	return m_selectedDataBase.m_tables["ad_in_domain_business_packages"]; }
        public function get table_ad_in_domain_business_package_stations():Table_ad_in_domain_business_package_stations {	return m_selectedDataBase.m_tables["ad_in_domain_business_package_stations"]; }
        public function DataBaseManager()
        {
        }
        
        public override function createDataBase(i_businessDomain:String, i_businessId:int):DataModuleBase
        {
        	var dataBase:DataModuleBase = super.createDataBase(i_businessDomain, i_businessId);
            dataBase.m_tableList = ["global_settings", "resources", "ad_local_packages", "ad_local_contents", "category_values", "catalog_items", "catalog_item_infos", "catalog_item_resources", "catalog_item_categories", "player_data", "boards", "campaigns", "campaign_channels", "campaign_channel_players", "campaign_timelines", "campaign_events", "campaign_boards", "board_templates", "board_template_viewers", "campaign_timeline_chanels", "campaign_timeline_channels", "campaign_timeline_board_templates", "campaign_timeline_board_viewer_chanels", "campaign_timeline_board_viewer_channels", "campaign_timeline_chanel_players", "campaign_timeline_schedules", "campaign_timeline_sequences", "scripts", "music_channels", "music_channel_songs", "branch_stations", "ad_rates", "station_ads", "ad_out_packages", "ad_out_package_contents", "ad_out_package_stations", "ad_in_domains", "ad_in_domain_businesses", "ad_in_domain_business_packages", "ad_in_domain_business_package_stations"];
            
            dataBase.m_tables["global_settings"] = new Table_global_settings(this);
            dataBase.m_tables["resources"] = new Table_resources(this);
            dataBase.m_tables["ad_local_packages"] = new Table_ad_local_packages(this);
            dataBase.m_tables["ad_local_contents"] = new Table_ad_local_contents(this);
            dataBase.m_tables["category_values"] = new Table_category_values(this);
            dataBase.m_tables["catalog_items"] = new Table_catalog_items(this);
            dataBase.m_tables["catalog_item_infos"] = new Table_catalog_item_infos(this);
            dataBase.m_tables["catalog_item_resources"] = new Table_catalog_item_resources(this);
            dataBase.m_tables["catalog_item_categories"] = new Table_catalog_item_categories(this);
            dataBase.m_tables["player_data"] = new Table_player_data(this);
            dataBase.m_tables["boards"] = new Table_boards(this);
            dataBase.m_tables["campaigns"] = new Table_campaigns(this);
            dataBase.m_tables["campaign_channels"] = new Table_campaign_channels(this);
            dataBase.m_tables["campaign_channel_players"] = new Table_campaign_channel_players(this);
            dataBase.m_tables["campaign_timelines"] = new Table_campaign_timelines(this);
            dataBase.m_tables["campaign_events"] = new Table_campaign_events(this);
            dataBase.m_tables["campaign_boards"] = new Table_campaign_boards(this);
            dataBase.m_tables["board_templates"] = new Table_board_templates(this);
            dataBase.m_tables["board_template_viewers"] = new Table_board_template_viewers(this);
            dataBase.m_tables["campaign_timeline_chanels"] = new Table_campaign_timeline_chanels(this);
            dataBase.m_tables["campaign_timeline_channels"] = new Table_campaign_timeline_channels(this);
            dataBase.m_tables["campaign_timeline_board_templates"] = new Table_campaign_timeline_board_templates(this);
            dataBase.m_tables["campaign_timeline_board_viewer_chanels"] = new Table_campaign_timeline_board_viewer_chanels(this);
            dataBase.m_tables["campaign_timeline_board_viewer_channels"] = new Table_campaign_timeline_board_viewer_channels(this);
            dataBase.m_tables["campaign_timeline_chanel_players"] = new Table_campaign_timeline_chanel_players(this);
            dataBase.m_tables["campaign_timeline_schedules"] = new Table_campaign_timeline_schedules(this);
            dataBase.m_tables["campaign_timeline_sequences"] = new Table_campaign_timeline_sequences(this);
            dataBase.m_tables["scripts"] = new Table_scripts(this);
            dataBase.m_tables["music_channels"] = new Table_music_channels(this);
            dataBase.m_tables["music_channel_songs"] = new Table_music_channel_songs(this);
            dataBase.m_tables["branch_stations"] = new Table_branch_stations(this);
            dataBase.m_tables["ad_rates"] = new Table_ad_rates(this);
            dataBase.m_tables["station_ads"] = new Table_station_ads(this);
            dataBase.m_tables["ad_out_packages"] = new Table_ad_out_packages(this);
            dataBase.m_tables["ad_out_package_contents"] = new Table_ad_out_package_contents(this);
            dataBase.m_tables["ad_out_package_stations"] = new Table_ad_out_package_stations(this);
            dataBase.m_tables["ad_in_domains"] = new Table_ad_in_domains(this);
            dataBase.m_tables["ad_in_domain_businesses"] = new Table_ad_in_domain_businesses(this);
            dataBase.m_tables["ad_in_domain_business_packages"] = new Table_ad_in_domain_business_packages(this);
            dataBase.m_tables["ad_in_domain_business_package_stations"] = new Table_ad_in_domain_business_package_stations(this);
            return dataBase;
        }

		public override function createHandles():void
		{
			createFieldHandles(table_campaign_timeline_chanel_players, "player_data");
			createFieldHandles(table_campaign_channel_players, "player_data");
			createFieldHandles(table_player_data, "player_data_value");
		}
	}
}

