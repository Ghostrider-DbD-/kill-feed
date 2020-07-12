/*
    Copyright 2020
    By Ghostrider-GRG-
*/

params["_victim","_killer","_instigator"];

private _messages = [];
private _nameVictim = name _victim;
private _nameKiller = if (_killer isKindOf "Man") then {name _killer} else {if (_instigator isKindOf "Man") then {name _instigator} else {""}};
private _weapon = if !(isNull _killer) then {currentWeapon _killer} else {""};
private _text = "";
private _strText = "";
private _dynaText = "";
private _dyna2Text = "";
private _logText = "";

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
	// If the player killed themselves somehow then handle it here
	case (_victim isEqualTo _killer || isNull _killer): {
		private _sapperParts = nearestObjects[player,["SapperHead_SIM_EPOCH","SapperCorpse_SIM_EPOCH"],5];
		if (_sapperParts isEqualTo []) then 
		{
			private _unknown = [
				"%1 died for unknown reasons",
				"%1 died due to a misshap",
				"%1 died - oops something just happened"
			];
			_text = format[selectRandom _unknown,_nameVictim];
			_strText = parseText format["<t align 'Center' shadow='2'>%1</t>",_text];
			_dynaText = format["<t size='0.70' align='left' shadow='1'>%1</t>",_text];
			_dyna2Text = _dynaText;				
			_logText = format["KILL_FEED <unknown>: %1",_text];
		} else {
			_text = format["%1 may have been killed by a sapper",_nameVictim];
			_strText = parseText format["<t align 'Center' shadow='2'>%1</t>",_text];
			_dynaText = format["<t size='0.70' align='left' shadow='1'>%1</t>",_text];
			_dyna2Text = _dynaText;				
			_logText = format["KILL_FEED <sappers>: %1",_text];
		};
	};

	// If the player was killed by another player or by AI handle it here
	case ((_killer isKindOf "Man" || _instigator isKindOf "Man") && !(_victim isEqualTo _killer)): {  
		private _vehicle = vehicle _killer;
		private _wepDisplayName = getText(configFile >> "CfgWeapons" >> _weapon >> "displayName");
		private _wepPic = getText(configFile >> "CfgWeapons" >> _weapon >> "picture");
		private _distance = _victim distance _killer;
		_text = format["%1 was killed by %2 with %3 from %4m",_nameVictim, _nameKiller, _wepDisplayName, _distance];
		if (_killer isKindOf "Man") then // killer was on foot 
		{
			_strText = parseText format ["
				<t size='1.25'align='center'shadow='1'color='#5882FA'>%1</t><br/>
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
				_distance
			];
			_dynaText = format["
				<t size='0.75'align='left'shadow='1'color='#5882FA'>%1</t>
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
				_wepPic					
			];
			_dyna2Text = format["
				<t align='left'size='0.9'color='%5'>%1 </t>
				<img size='1.0'align='left' image='%2'/>
				<t align='left'size='0.9'color='%6'> %3 </t>
				<t align='left'size='0.9'color='%7'>[%4m]</t>
				",
				_nameKiller,
				_wepPic,
				_nameVictim,
				_distance,
				_killerNameColor,
				_victimNameColor,
				_distanceColor
			];
			_logText = format["KILL_FEED <INFANTRY>: %1",_text];
		} else {  //  _killer must be in a vehicle
			if (['horn',toLower _weapon] call BIS_fnc_inString) then 
			{
				// Killer is driver 
				_weapon = _vehicle;
			};
			_strText = parseText format ["
				<t size='1.25'align='center'shadow='1'color='#5882FA'>%1</t><br/>
				<t size='1'align='Center'shadow='1'>Killed:</t><br/>
				<t size='1.25'align='Center'shadow='1'color='#c70000'>%2</t><br/>
				<t size='1'align='Center'shadow='1'>With Weapon:</t><br/>
				<t size='1.25'align='Center'shadow='1'>[</t><t size='1.25'align='Center'shadow='1'color='#FFCC00'>%3</t><t size='1.25'align='Center'shadow='1'>]</t><br/>
				<t size='1'align='Center'shadow='1'>Distance:</t><br/>
				<t size='1.25'align='Center'shadow='1'color='#FFCC00'>%4m</t><br/>",
				_nameKiller,
				_nameVictim,
				_wepDisplayName,
				_distance
			];
			_dynaText = format["
				<t size='0.75'align='left'shadow='1'color='#5882FA'>%1</t>
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
				_distance				
			];
			_dyna2Text = format["
				<t align='left' size='0.9' color='#5882FA'  shadow='1'>%1 </t>
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
				_distance
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
		case "showDynamicText": {[_dynaText,[safezoneX + 0.01 * safezoneW,2.0],[safezoneY + 0.01 * safezoneH,0.3],30,0.5] spawn BIS_fnc_dynamicText};
		case "showDynamicText2": {
			[_dyna2Text,[safezoneX + 0.01 * safezoneW,2.0],[safezoneY + 0.01 * safezoneH,0.3],30,0.5] spawn BIS_fnc_dynamicText;
		};
	};
} forEach _messages;

//diag_log _logText;

