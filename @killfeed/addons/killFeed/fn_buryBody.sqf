/*
    Copyright 2020
    By Ghostrider-GRG-

	Server-side events that need to be done to get the inventory of the player and add it to a grave then demarcate the grave site with a grave !
*/
diag_log format["KF_fnc_buryBody: count _this = %2, _this = %1",_this, count _this];
private _mode = _this select 0;
private _body = _this select 1;
private _player = _this select 2;

private _list = ["_mode","body","_player"];
{
	diag_log format["Parameter %1 name %2 = %3",_forEachIndex,_list select _forEachIndex,_x];
} forEach [_mode,_body,_player];

diag_log format["KF_fnc_buryBody: _player object = %1",_player];

switch (_mode) do // Just in case there need to be more modes
{
	case 'setupGrave': {
		private _pos = getPosATL _body;
		private _crate = createVehicle["groundWeaponHolder",[_pos select 0, _pos select 1, (_pos select 2) + 0.1],[],0,"CAN_COLLIDE"];
		{
			private _itemAdded = false;
			private _quant = 1;
			//diag_log format["evaluating item %1",_x];
			if !(_x isEqualTo "") then 
			{
				private _item = _x;
				if (_item isKindOf ["Rifle", configFile >> "CfgWeapons"] || _item isKindOf ["Pistol", configFile >> "CfgWeapons"] || _item isKindOf ["Launcher", configFile >> "CfgWeapons"]) then
				{	_crate addWeaponCargoGlobal [_item,_quant]; 
					_itemAdded = true;
				};
				if (_item isKindOf ["Bag_Base", configFile >> "CfgVehicles"]) then 
				{
					_crate addBackpackCargoGlobal [_item,_quant]; 
					_itemAdded = true;
				};
				if (isClass(configFile >> "CfgMagazines" >> _item)) then 
				{
					_crate addMagazineCargoGlobal [_item,_quant]; 
					_itemAdded = true;
				};
				if (_item isKindOf ["Headgear_Base_F", configFile >> "CfgVehicle"]) then 
				{
					_crate addItemCargoGlobal [_item,1];
					_itemAdded = true;
				};
				if (_item isKindOf ["Vest_Base_F", configFile >> "CfgVehicle"]) then 
				{
					_crate addItemCargoGlobal [_item,1];
					_itemAdded = true;
				};
				if (_item isKindOf ["ItemCore", configFile >> "CfgWeapons"]) then 
				{
					_crate addItemCargoGlobal [_item,1];
					_itemAdded = true;
				};
				if (!_itemAdded && isClass(configFile >> "CfgVehicles" >> _item)) then 
				{
					_crate addItemCargoGlobal [_item,_quant];
					_itemAdded = true;
				};
				if ( !_itemAdded && isClass(configFile >> "CfgWeapons" >> _item)) then 
				{
					_crate addItemCargoGlobal [_item,1];
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

		_pos = _pos getPos[0.33,random(359)];
		private "_graveType";

		if (random (1) < 0.67) then 
		{
			_graveType = selectRandom ["Land_Grave_dirt_F","Land_Grave_forest_F","Land_Grave_rocks_F"];
			[format[" %1 has been buried - May they rest in peace",_body getVariable["VICTIM_NAME","John Doe"]],10] remoteExec["EPOCH_message",_player];			
		} else {
			_graveType = "Land_HumanSkull_F";
			[format["The remains were used for Sapper food - only a skull was left"],10] remoteExec["EPOCH_message",_player];			
		};

		private _grave = createVehicle[_graveType,_pos,[],0,"CAN_COLLIDE"];
		_grave setVectorUp (surfaceNormal _pos);
		private _cutter = createVehicle["Land_ClutterCutter_medium_F",getPos _grave];
		_cutter setVectorUp (surfaceNormal getPos _cutter);
		deleteVehicle _body;
		removeFromRemainsCollector [_body];
		private _graveEntry = [[_crate,_grave,_cutter], _player, diag_tickTime + 300];
		KF_graves pushBack _graveEntry;
	};
};




