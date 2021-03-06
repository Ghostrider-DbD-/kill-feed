/*
	Merge this with Epoch.mapname\epoch_config\Configs\CfgActionMenu\CfgActionMenu_target.hpp
*/

class studyBody 
{
	condition = "!([dyna_cursorTarget] call KF_fnc_isZed) && ((dyna_isDeadPlayer || (!(alive dyna_cursorTarget) && (dyna_cursorTarget isKindOf 'Man'))) && 	(getNumber(missionConfigFile >> 'CfgKillMessages' >> 'enableStudyBody') == 1))";
	action = "[dyna_cursorTarget] call KF_fnc_studyBody";
	icon = "\x\addons\a3_epoch_community\icons\skull.paa";
	toolTip = "Study Body";
};

class burryBody 
{
	condition = "!([dyna_cursorTarget] call KF_fnc_isZed) && ((dyna_isDeadPlayer || (!((dyna_cursorTarget getVariable['AI_SLOT', -1]) != -1) && !(alive dyna_cursorTarget) && (dyna_cursorTarget isKindOf 'Man'))) && (getNumber(missionConfigFile >> 'CfgKillMessages' >> 'enableBuryBody') == 1))";
	action = "[dyna_cursorTarget] spawn KF_fnc_buryBody_client";
	icon = "\x\addons\a3_epoch_community\icons\Halloween_masks\skullhead_icon_ca.paa";
	toolTip = "Burry Body";
};
