/*
    Copyright 2020
    By Ghostrider-GRG-

	Monitors graves made by the client on the client
*/

if (isNil "KF_graves") then {KF_graves = []};

while {true} do 
{
    uiSleep 10;
    if !(KF_graves isEqualTo []) then 
    {
		for "_i" from 1 to (count KF_graves) do 
		{
			private _grave = KF_graves deleteAt 0;
			_grave params["_objects","_deleteAt"];
			private _gravePos = getPos (_objects select 0);
			if (diag_tickTime > _deleteAt || _gravePos distance player > 150) then 
			{
				["deleteGrave",_objects] remoteExec["KF_fnc_buryBody",2];
			} else {
				KF_graves pushBack _grave;
			};
		};
    };
};