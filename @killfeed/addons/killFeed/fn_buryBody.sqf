

params["_body"];

player playMove "AinvPknlMstpSlayWrflDnon_medic";

private _crateType = getText(missionConfigFile >> "CfgKillFeed" >> "crateType");
private _pos = getPOsATL _body;
private _crate = createVehicle["groundWeaponHolder",[_pos select 0, _pos select 1, (_pos select 2) + 0.1],[],0,"CAN_COLLIDE"];
{
	if !(_x isEqualTo "") then 
	{
		diag_log format["_x = %1",_x];
		switch (true) do 
		{
			case (isClass(configFile >> "CfgMagazines" >> _x)): {
				_crate addMagazineCargoGlobal [_x,1];
			};
			case (isClass(configFile >> "CfgWeapons" >> _x)): {
				if (_x isKindOf "ItemCore") then 
				{
					_crate addItemCargoGlobal[_x,1];
				} else {
					_crate addWeaponCargoGlobal[_x,1];
				};
			};
			case (isClass(configFile >> "CfgVehicles" >> _x)): {
				if (_x isKindOf "Bag_Base") then {
					_crate addBackpackCargoGlobal [_x,1];
				} else {
					_crate addItemCargoGlobal [_x,1];
				};
			};
		};
	};
} forEach 	
	(assignedItems _body)+
	(primaryWeaponItems _body)+
	(handgunItems _body)+
	(secondaryWeaponItems _body)+
	(uniformItems _body)+
	(vestItems _body)+
	(backpackItems _body)+
	[primaryWeapon _body,handgunWeapon _body,secondaryWeapon _body,uniform _body,vest _body,backpack _body,headgear _body,goggles _body];

_pos = _pos getPos[2.0,random(359)];
private _grave = createVehicle[selectRandom ["Land_Grave_dirt_F","Land_Grave_forest_F","Land_Grave_rocks_F"],_pos,[],3,"CAN_COLLIDE"];
_grave setVectorUp (surfaceNormal _pos);
private _victim = _body getVariable["VICTIM_NAME","John Doe"];
[format[" %1 has been buried - May they rest in peace",_victim],10] call EPOCH_message;
deleteVehicle _body;
removeFromRemainsCollector [_body];
uiSleep 5;

["The grave will despawn in 5 minutes",10] call EPOCH_message;
[] spawn{
	uiSleep 300;
	{deleteVehicle _x} forEach [_crate,_clutter,_grave];
};
player playMoveNow "AmovPercMstpSlowWrflDnon_Salute";



