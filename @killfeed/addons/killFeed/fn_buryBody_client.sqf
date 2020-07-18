

params["_body"];
private _victim = _body getVariable["VICTIM_NAME","John Doe"];
player playMove "AinvPknlMstpSlayWrflDnon_medic";
['setupGrave',[_body,player]] remoteExec["KF_fnc_buryBody",2];
uiSleep 5;
[format[" %1 has been buried - May they rest in peace",_victim],10] call EPOCH_message;
["The grave will despawn in 5 minutes or if you are more than 150 meters away",10] call EPOCH_message;
player playMoveNow "AmovPercMstpSlowWrflDnon_Salute";
private _start = diag_tickTime;
while { (player distance _grave) < 150 && (diag_tickTime - _start) < 300} do 
{
	systemChat format["Waited for %1 distance is %2",diag_tickTime - _start,player distance _grave];
	uiSleep 5;
};
['deleteGrave',[player]] remoteExec["KF_fnc_buryBody",2];


