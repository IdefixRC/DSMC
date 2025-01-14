cdata =
{
	DSMC_Title_MAIN			= _("DSMC CUSTOMIZATION PANEL - ALL CHANGES TAKE EFFECT AFTER DCS RESTART!"),
	DSMC_Help_MAIN			= _("To work DSMC require ALWAYS that the mission has the tag 'DSMC' in the first 4 letters of the .miz file name"),	
	DSMC_Title_SAVE			= _("Saved scenery file (.miz) preferences"),
	--MOBJ_txt				= _("Keeps demolished briges, building and scenery object"),
	CRST_txt				= _("Keeps destroyed vehicles & aircraft wreckage"),
	--WTHR_txt				= _("Update saved scenery weather based on real climate average data"),
	SPWN_txt				= _("Keeps spawned vehicles, crates & static object"),
	SLOT_txt				= _("Automatically create clients slot on heliports"),	
	SLOT_ab_txt				= _("Automatically create clients slot on airbases"),	
	SLOT_txt_Help			= _("Airbase slot creation require mission designer to follow specific rules, check manual!"),	
	--TMUP_txt				= _("Change next scenery simulation date & time"),
	TMUP_cont_TRUE			= _("Saved scenery start at end of current mission (continous time)"),
	TMUP_cont_FALSE			= _("Saved scenery start the next day, random hour (staged time)"), 
	TMUP_cont_REAL			= _("Saved scenery start on real world date, same time as original mission"), 
	
	DSMC_Title_SRV			= _("Multiplayer options"),
	ATRL_txt				= _("Multiplayer option to autosave with defined frequency the scenery"), 
	ATRL_time_txt			= _("Autosave every (minutes): "), 
	ATRL_Help_txt			= _("Autosave option require, and automatically perform, desanitization of 'MissionScripting.lua'"), 
	
	--WRHS_txt_help			= _("Logistic & resource system options"),
	--WRHS_txt				= _("Keep depleted and added items from warehouses & airbases"), 	
	
	DSMC_Title_AIE			= _("Real time simulation enhancement options"),
	TRPS_txt				= _("Enable troops transport & crate logistic with CTLD by Ciribob"),
	DCSR_txt				= _("Enable integrated CSAR script by Ciribob"),
	--TRPS_setup				= _("CTLD is set with real slingload setup: crates must be slingloaded"),	
	DSMC_Help_AIE_1			= _("Beware: these version are heavily modified. Check manual for instructions"),	
	--DSMC_Help_AIE_2			= _("- it doesn't require setup: logistic, troops and helos are automatically recognized"),
	--DSMC_Help_AIE_3			= _("- any FARP or warehouse is set as logistic unit"),
	--DSMC_Help_AIE_4			= _("- APC or IFV vehicle are preloaded with infantry squads, disembarkable using CA (1st unit only)"),
	--DSMC_Help_AIE_5			= _("Beware: only full-infantry groups will be extractable!"),	
	
	DEBUG_txt				= _("Enable detail debug mode. WARNING: activate only for reproduce a bug"),
	DEBUG_help				= _("When DEBUG mode is active, the reload options works with minutes instead of hours! so choosing '3' mean reload every 3 minutes"),
}
