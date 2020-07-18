/*
    Copyright 2020
    By Ghostrider-GRG-
*/

onPlayerConnected {}; // seems this is needed or addMissionEventHandler "PlayerConnected" does not work. as of A3 1.60
addMissionEventHandler ["PlayerConnected", 
{
    params["_id","_uid","_name","_jip","_owner"];
    diag_log format["KILL_FEED: player %1 joining server, killfeed being configured",_name];
    if (isNil "KF_fnc_killFeedHandleKilledMessages") then {diag_log "KILL_FEED: client function not defined"};
	_owner publicVariableClient "KF_fnc_killFeedHandleKilledMessages";
    _owner publicVariableClient "KF_fnc_studyBody";
    _owner publicVariableClient "KF_fnc_buryBody";
}];

private _build = getNumber(configFile >> "CfgBuild" >> "killFeed" >> "build");
private _ver = getNumber(configFile >> "CfgBuild" >> "killFeed" >> "build");
private _date = getText(configFile >> "CfgBuild" >> "killFeed" >> "date");
diag_log format["KILL_FEED: Initialize | Version %1 | Build %2 | Date %3",_ver,_build,_date];