/*
    Copyright 2020
    By Ghostrider-GRG-

	Server-side events that need to be done to get the inventory of the player and add it to a grave then demarcate the grave site with a grave !
*/

params["_mode","_payload"];

switch (_mode) do 
{
	case 'setupGrave': {
		_payload params["_body","_player"];
		private _pos = getPosATL _body;
		private _crate = createVehicle["groundWeaponHolder",[_pos select 0, _pos select 1, (_pos select 2) + 0.1],[],0,"CAN_COLLIDE"];
		{
			if !(_x isEqualTo "") then 
			{
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

		_pos = _pos getPos[2.5,random(359)];
		private _grave = createVehicle[selectRandom ["Land_Grave_dirt_F","Land_Grave_forest_F","Land_Grave_rocks_F"],_pos,[],3,"CAN_COLLIDE"];
		_grave setVectorUp (surfaceNormal _pos);
		private _cutter = createVehicle["Land_ClutterCutter_medium_F",getPos _grave];
		_cutter setVectorUp (surfaceNormal getPos _cutter);
		deleteVehicle _body;
		removeFromRemainsCollector [_body];
		[_crate,_grave,_cutter] remoteExec ["KF_fnc_addMonitoredGrave",_player];
	};

	case 'deleteGrave': {
		{deleteVehicle _x} forEach _payload;
	};
};




