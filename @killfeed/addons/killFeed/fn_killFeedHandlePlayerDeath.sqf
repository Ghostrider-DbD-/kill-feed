/*
    Copyright 2020
    By Ghostrider-GRG-
*/

if ( (getNumber(missionConfigFile >> "" >> "logPVPKills") == 1)) then 
{
	if (isPlayer (_this select 1)) then 
	{
		params["_victim","_killer"];
		private _logMsg = format["%1 killed %2 with %3 from %4",name _killer,name _victim, _killer distance _victim,currentWeapon _killer];
		["PVP_KILLS",_logMsg] call EPOCH_fnc_server_hiveLog;
	};
};
_this remoteExec["KF_fnc_killFeedHandleKilledMessages",-2];