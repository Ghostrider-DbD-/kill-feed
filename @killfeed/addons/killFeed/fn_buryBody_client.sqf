/*
    Copyright 2020
    By Ghostrider-GRG-

	Things that need to happen on the client: animations
*/

params["_body"];

/* Ask the server to build the grave */
['setupGrave', _body, player] remoteExec["KF_fnc_buryBody",2];

/* run some animations and do a little sleep then notify the player the grave was made */
private _victim = _body getVariable["VICTIM_NAME","John Doe"];
player playMove "AinvPknlMstpSlayWrflDnon_medic";
[format[" %1 has been buried - May they rest in peace",_victim],10] call EPOCH_message;
uiSleep 5;
["The grave will despawn in 5 minutes or if you are more than 150 meters away",10] call EPOCH_message;
player playMoveNow "AmovPercMstpSlowWrflDnon_Salute";




