/*
    Copyright 2020
    By Ghostrider-GRG-

	car accident: 
	fall to your death: KILL_FEED: EPOCH_custom_EH_Killed _this = [B Alpha 1-1:1 (Ghostrider),B Alpha 1-1:1 (Ghostrider),<NULL-object>,true]"
	die from bomb you detonated: "KILL_FEED: EPOCH_custom_EH_Killed _this = [B Alpha 1-1:1 (Ghostrider),B Alpha 1-1:1 (Ghostrider),B Alpha 1-1:1 (Ghostrider),true]"
	zed kills:  killFeed: _this = [B Alpha 1-1:1 (Ghostrider),B Alpha 1-1:1 (Ghostrider),<NULL-object>,true] || _sapperParts = []"
	too close to fireplace:  "KILL_FEED: EPOCH_custom_EH_Killed _this = [B Alpha 1-1:1 (Ghostrider),<NULL-object>,<NULL-object>,true]"
	Drowned:   KILL_FEED: EPOCH_custom_EH_Killed _this = [B Alpha 1-1:1 (Ghostrider),<NULL-object>,<NULL-object>,true]"
*/

params["_victim","_killer","_instigator"];

private _messages = [];
private _nameVictim = name _victim;
private _nameKiller = if (_killer isKindOf "Man") then {name _killer} else {if (_instigator isKindOf "Man") then {name _instigator} else {""}};
private _weapon = if !(isNull _killer) then {currentWeapon _killer} else {""};
private _manNear = nearestObjects[_victim,["Man"],30];
private _aliveMen = _manNear select {alive _x};
private _zedsNear = [];
{
	if (_x isKindOf "EPOCH_RyanZombie_1") then {_zedsNear pushBack _x} else {if (getText(configFile >> "CfgVehicles" >> typeOf _x >> "author") isEqualTo "Ryan") then {_zedsnear pushBack _x}};
} forEach _aliveMen;
private _sapperHeadsNear = nearestObjects[_victim,["SapperHead_SIM_EPOCH","SapperCorpse_SIM_EPOCH"],30];
private _text = "";
private _strText = "";
private _dynaText = "";
private _dyna2Text = "";
private _logText = "";
diag_log format["KILL_FEED_CLIENT: _victim = %1 | _killer = %2 | _instigator = %3 | _zedsNear %4 | _sapperHeadsNear = %5",_victim,_killer,_instigator,_zedsNear,_sapperHeadsNear];
// Pull the settings from the config
{
	private _p = getNumber(missionConfigFile >> "CfgKillMessages" >> _x);
	if (_p == 1) then {_messages pushBack _x};
} forEach [
	"showHint",
	"showSystemChat",
	"showCutText",
	"showEpochMessage",
	"showDynamicText",
	"showDynamicText2"
];

switch (true) do 
{
	// the player blew themselves up somehow
	case (_victim isEqualTo _instigator): {
		private _selfDestruct = [
			"%1 killed themselves in an explosion",
			"%1 tripped on something explosive",
			"%1 died - should not have dropped that explosive!"
		];
		_text = format[selectRandom _selfDestruct,_nameVictim];
		_strText = parseText format["<t align 'Center' shadow='2'>%1</t>",_text];
		_dynaText = format["<t size='0.70' align='left' shadow='1'>%1</t>",_text];
		_dyna2Text = _dynaText;				
		_logText = format["KILL_FEED <self-destruct>: %1",_text];
	};

	// If the player killed themselves in an unknown way like a fall, car accident or colision with building parts then handle it here
	case ( ((_victim isEqualTo _killer) || (isNull _killer)) && _zedsNear isEqualTo [] && _sapperHeadsNear isEqualTo []): {
		private "_unknown";
		if (surfaceIsWater (getPos _victim)) then 
		{
			_unknown = [
				"%1 probably drowned",
				"%1 probably died from hypothermia",
				"%1 most likely dove without scuba gear",
				"%1 could have sought one too many shelfish"
			];
		} else {
			private _firePlaces = nearestObjects[getPosATL _victim,["FirePlace_02_EPOCH","FirePlaceOn_EPOCH"],3];
			private _litFirePlaces = _firePlaces select {inflamed _x};
			private _flames = nearestObjects[getPosATL _victim,["test_EmptyObjectForFireBig"],3];
			diag_log format["_firePlaces = %1 | _litFirePlaces = %2 | _flames = %3",_firePlaces,_litFirePlaces,_flames];
			if (!(_litFirePlaces isEqualTo []) || !(_flames isEqualTo [])) then
			{
				_unknown = [
					"%1 died from smoke inhallation",
					"%1 died from one too many burns",
					"%1 died - just wandered to close to the flames",
					"%1 died - well, fire will do that"
				];
			} else {
				_unknown = [
					"%1 died for unknown reasons",
					"%1 died due to a misshap",
					"%1 died - oops something just happened",
					"%1 died - well, its Arma"
				];
			};
		};
		_text = format[selectRandom _unknown,_nameVictim];
		_strText = parseText format["<t align 'Center' shadow='2'>%1</t>",_text];
		_dynaText = format["<t size='0.70' align='left' shadow='1'>%1</t>",_text];
		_dyna2Text = _dynaText;				
		_logText = format["KILL_FEED <unknown>: %1",_text];
	};

	// Sappers exploded nearby
	case (!(isPlayer _killer) && !(_sapperHeadsNear isEqualTo []) && (_zedsNear isEqualTo [])): {
		_text = format["%1 may have been killed by a sapper",_nameVictim];
		_strText = parseText format["<t align 'Center' shadow='2'>%1</t>",_text];
		_dynaText = format["<t size='0.70' align='left' shadow='1'>%1</t>",_text];
		_dyna2Text = _dynaText;				
		_logText = format["KILL_FEED <sappers>: %1",_text];
	};

	// Zeds nearby 
	case (_victim isEqualTo _killer && !(_zedsNear isEqualTo [])): {
		private _zedFood = [
			"%1 was eaten by zombies",
			"%1 is a zombies dinner",
			"%1 has fed the hoards",
			"%1 has joined the ranks fo the undead"
		];
		_strText = parseText format["<t align 'Center' shadow='2'>%1</t>",_text];
		_dynaText = format["<t size='0.70' align='left' shadow='1'>%1</t>",_text];
		_dyna2Text = _dynaText;				
		_logText = format["KILL_FEED <zeds>: %1",_text];
	};

	// killed by another player or by AI
	case (_instigator isKindOf "Man" && !(_victim isEqualTo _killer)): {
		private _vehicle = vehicle _killer;
		private _wepDisplayName = getText(configFile >> "CfgWeapons" >> _weapon >> "displayName");
		private _wepPic = getText(configFile >> "CfgWeapons" >> _weapon >> "picture");
		private _distance = _victim distance _killer;
		private _enemyType = if (isPlayer _killer) then {"Player"} else {"AI"};	
		_text = format["%1 was killed by %5 - %2 with %3 from %4m | isBurnt = %6",_nameVictim, _nameKiller, _wepDisplayName, _distance, _enemyType,_isBurnt];		
		_logText = format["KILL_FEED <Man>: %1",_killer];
		if (vehicle _killer isEqualTo _killer) then // killer was on foot 
		{
			_strText = parseText format ["
				<t size='1.25'align='center'shadow='1'color='#5882FA'>/%6 - %1</t><br/>
				<t size='1.25'align='Center'shadow='1'>Killed:</t><br/>
				<t size='1.25'align='Center'shadow='1'color='#c70000'>%2</t><br/>
				<t size='1'align='Center'shadow='1'>With Weapon:</t><br/>
				<img size='5'shadow='1' image='%3'/><br/>
				<t size='1.25'align='Center'shadow='1'>[</t><t size='1.25'align='Center'shadow='1'color='#FFCC00'>%4</t><t size='1.25'align='Center'shadow='1'>]</t><br/>
				<t size='1'align='Center'shadow='1'>Distance:</t><br/>
				<t size='1.25'align='Center'shadow='1'color='#FFCC00'>%5m</t><br/>",
				_nameKiller,
				_nameVictim,
				_wepPic,
				_wepDisplayName,
				_distance,
				_enemyType
			];
			_dynaText = format["
				<t size='0.75'align='left'shadow='1'color='#5882FA'>%6 - %1</t>
				<t size='0.75'align='left'shadow='1'>  Killed  </t>
				<t size='0.75'align='left'shadow='1'color='#c70000'>%2</t><br/>
				<t size='0.45'align='left'shadow='1'> With: </t>
				<t size='0.5'align='left'shadow='1'color='#FFCC00'>%3</t>
				<t size='0.45'align='left'shadow='1'> - Distance: </t>
				<t size='0.5'align='left'shadow='1'color='#FFCC00'>%4m</t><br/>
				<img size='2.5'align='left'shadow='1'image='%5'/>
				",
				_nameKiller,
				_nameVictim,
				_wepDisplayName,
				_distance,
				_wepPic,
				_enemyType				
			];
			_dyna2Text = format["
				<t align='left'size='0.9'color='#5882FA'>%5 - %1 </t>
				<img size='1.0'align='left' image='%2'/>
				<t align='left'size='0.9'color='#c70000'> %3 </t>
				<t align='left'size='0.9'color='#FFCC00'>[%4m]</t>
				",
				_nameKiller,
				_wepPic,
				_nameVictim,
				_distance,
				_enemyType
			];
			_logText = format["KILL_FEED <INFANTRY>: %1",_text];
		} else {  //  _killer must be in a vehicle
			if (['horn',toLower _weapon] call BIS_fnc_inString) then 
			{
				// Killer is driver 
				_weapon = _vehicle;
			};

			_strText = parseText format ["
				<t size='1.25'align='center'shadow='1'color='#5882FA'>%5 - %1</t><br/>
				<t size='1'align='Center'shadow='1'>Killed:</t><br/>
				<t size='1.25'align='Center'shadow='1'color='#c70000'>%2</t><br/>
				<t size='1'align='Center'shadow='1'>With Weapon:</t><br/>
				<t size='1.25'align='Center'shadow='1'>[</t><t size='1.25'align='Center'shadow='1'color='#FFCC00'>%3</t><t size='1.25'align='Center'shadow='1'>]</t><br/>
				<t size='1'align='Center'shadow='1'>Distance:</t><br/>
				<t size='1.25'align='Center'shadow='1'color='#FFCC00'>%4m</t><br/>",
				_nameKiller,
				_nameVictim,
				_wepDisplayName,
				_distance,
				_enemyType
			];
			_dynaText = format["
				<t size='0.75'align='left'shadow='1'color='#5882FA'>%5 - %1</t>
				<t size='0.75'align='left'shadow='1'>  Killed  </t>
				<t size='0.75'align='left'shadow='1'color='#c70000'>%2</t><br/>
				<t size='0.45'align='left'shadow='1'> With: </t>
				<t size='0.5'align='left'shadow='1'color='#FFCC00'>%3</t>
				<t size='0.45'align='left'shadow='1'> - Distance: </t>
				<t size='0.5'align='left'shadow='1'color='#FFCC00'>%4m</t><br/>
				",
				_nameKiller,
				_nameVictim,
				_wepDisplayName,
				_distance,
				_enemyType			
			];
			_dyna2Text = format["
				<t align='left' size='0.9' color='#5882FA'  shadow='1'>%5 - %1 </t>
				<t align='left' size='0.9' color='#FFFFFF' shadow='1'> Killed </t>
				<t align='left' size='0.9' color='#c70000'> %2 </t>
				<t align='left' size='0.9' color='#FFFFFF'> With  </t>
				<t align='left' size='0.9' color='#FFCC00'>[%3]</t>	
				<t align='left' size='0.9' color='FFCC00'> Distance  </t>			
				<t align='left'size='0.9'color='#FFCC00'>%4m</t>
				",
				_nameKiller,
				_nameVictim,
				_wepDisplayName,				
				_distance,
				_enemyType
			];
			_logText = format["KILL_FEED <TURRET>: %1",_text];
		};
	};
};

{
	switch (_x) do 
	{
		case "showHint": {hint _strText};
		case "showSystemChat": {systemChat _text};
		case "showCutText": {cutText[_text,"PLAIN DOWN",-1,false,false]};
		case "showEpochMessage": {[_text,10] call EPOCH_message};
		case "showDynamicText": {
			[_dynaText,[safezoneX + 0.01 * safezoneW,2.0],[safezoneY + 0.02 * safezoneH,0.3],30] spawn BIS_fnc_dynamicText};
		case "showDynamicText2": {
			[_dyna2Text,[safezoneX + 0.01 * safezoneW,2.0],[safezoneY + 0.02 * safezoneH,0.3],30] spawn BIS_fnc_dynamicText;
		};
	};
} forEach _messages;

diag_log _logText;