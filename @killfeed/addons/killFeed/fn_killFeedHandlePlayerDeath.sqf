/*
    Copyright 2020
    By Ghostrider-GRG-
*/
private _logPVPkills = getNumber(missionConfigFile >> "CfgKillMessages" >> "logPVPKills");
diag_log format["KILL_FEED: _logPVPkills = %1",_logPVPkills];
if (_logPVPkills == 1) then 
{
	if (isPlayer (_this select 1)) then 
	{
		params["_victim","_killer"];
		private _logMsg = format["%1 killed %2 with %3 from %4",name _killer,name _victim, _killer distance _victim,currentWeapon _killer];
		["PVP_KILLS",_logMsg] call EPOCH_fnc_server_hiveLog;
	};
};

diag_log format["isNumber enableStudyBody = %1",isNumber(missionConfigFile >> "CfgKillMessages" >> "enableStudyBody")];
if ( getNumber(missionConfigFile >> "CfgKillMessages" >> "enableStudyBody") == 1) then 
{
	params["_victim","_killer"];
	_victim setVariable["TOD",diag_tickTime];
	if !(isNull _killer) then 
	{
		_victim setVariable["KILLER",name _killer,true];
		_victim setVariable["WEAPON",currentWeapon _killer,true];
		_victim setVariable["DISTANCE",_killer distance _victim,true];
	};
	_victim setVariable["VICTIM_NAME",name _victim,true];
};
_this remoteExec["KF_fnc_killFeedHandleKilledMessages",-2];