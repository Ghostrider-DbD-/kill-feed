/*
    Copyright 2020
    By Ghostrider-GRG-
*/

params["_corpse"];
private _tod =	_corpse getVariable["TOD",0];
private _killer = _corpse getVariable["KILLER","unknown"];
private _weapon = _corpse getVariable["WEAPON","mysterious force"];

if (isClass(configFile >> "CfgWeapons" >> _weapon)) then 
{
	_weapon = getText(configFile >> "CfgWeapons" >> _weapon >> "displayName");
};

private _distance = _corpse getVariable["DISTANCE",-1];

private _time = "_time undefined";
private _range = "_range undefined";
private _victim = "_victim undefined";
private _message = "_message undefined";
private _cutTextMessage = "_cutTtextMessage undefined";
private _parsedMessage = "_parsedMessage undefined";

 if (_corpse isKindOf "Epoch_Female_base_F" || _corpse isKindOf "Epoch_Man_base_F") then 
{
	_victim = _corpse getVariable["VICTIM_NAME","John Doe"];
} else {
	_victim = "NPC";
};

switch (true) do 
{
	case (_tod >= 0 && _tod < 300): {_time = "The wound is still oozing"};
	case (_tod >= 300 && _tod < (60 * 20)): {_time = "The body is warm"};
	case (_tod >= (60 * 20) && _tod < (60 * 60)): {_time = "The body is cool"};
	case (_tod >= (60 * 60)): {_time = "The body is cold and stiff"};
	default {_time = "Not long ago"};
};
switch (true) do 
{
	case (_distance < 30): {_range = "really close"};
	case (_distance >= 30 && _distance < 100): {_range = "Not too far away"};
	case (_distance >= 100 && _distance < 300): {_range = "It took some skill"};
	case (_distance >= 300 && _distance < 1000): {_range = "It was a good shot"};
	case (_distance >= 1000): {_range = "It was a great shot"};
	default {_range = "Somewhere nearby"};
};

if (_killer isEqualTo _victim) then 
{
	_message = format["%1 died of unknown causes and the %2",_victim,_time];
} else {
	_message = format["%1 was killed by %3 using %4 from %5 %2",_victim,_time,_killer,_weapon,_range];
};


private _cue = [];
{
	private _p = getNumber(missionConfigFile >> "CfgKillMessages" >> "studyBody" >> _x);
	if (_p == 1) then {_cue pushBack _x};
	diag_log format["evauating param %1 = %2",_forEachIndex,_x];
} forEach [
	"displaySystemChat",
	"displayHint",
	"displayEpochMessage",
	"displayCutText"
];

{
	switch (_x) do
	{
		if (isNil "_message") then {_message = "_message undefined"} else {if (_message isEqualTo "") then {_message = "_message = ''"}};
		diag_log format["evaluating studyBody message %1 with _message = %2",_x,_message];

		case "displaySystemChat": {
			systemChat _message;
		};
		case "displayHint": {
			if (_killer isEqualTo _victim) then 
			{
				_parsedMessage = format["
					<t size='1.25'align='center'shadow-'1'color='#5882FA'>%1 died</t><br/>
					<t size='1.25'align='center'shadow='1'color='#FFFFFF'>Of Unknown Causes</t><br/>				
					<t size='1.25'align='center'shadow='1'color='#FFFFFF'>%2</t>
					",
					_victim,
					_time
				]; 
			} else {
				_parsedMessage = format["
						<t size='1.25'align='center'shadow='1'color='#5882FA'>%1</t><br/>
						<t size='1.25'align='Center'shadow='1'> Was Killed By </t>
						<t size='1.25'align='Center'shadow='1'color='#6B8E23'>%2</t><br/>
						<t size='1'align='Center'shadow='1'> With Weapon: </t>
						<t size='1'align='Center'shadow='1' color='#ff0000'> %3 </t><br/>
						<t size='1'align='Center'shadow='1'> From Distance: </t>
						<t size='1.25'align='Center'shadow='1'color='#FFCC00'>%4</t><br/>",
						_victim,
						_killer,
						_weapon,
						_range
					];
			};		
			diag_log format["studyBody: _parsedMessage = %1",_parsedMessage];
			hint parseText _parsedMessage;
			[] spawn {uisleep 10;  hint ""};
		};

		case "displayEpochMessage": {
			[_message,10] call EPOCH_message;
		};
		
		case "displayCutText": {
			if (_killer isEqualTo _victim) then 
			{
				_cutTextMessage = format["
					<t size='1.25'align='center'shadow-'1'color='#5882FA'>%1 died</t><br/>
					<t size='1.25'align='center'shadow='1'color='#FFFFFF'>Of Unknown Causes</t><br/>				
					<t size='1.25'align='center'shadow='1'color='#FFFFFF'>%2</t>
					",
					_victim,
					_time
				];
			} else {
				_cutTextMessage = format["
					<t size='1.25'align='center'shadow='1'color='#5882FA'>%1</t><br/>
					<t size='1.25'align='Center'shadow='1'> Was Killed By</t>
					<t size='1.25'align='Center'shadow='1'color='#6B8E23'>%2</t><br/>
					<t size='1'align='Center'shadow='1'> With Weapon:</t>
					<t size='1.25'align='Center'shadow='1'color='#6B8E23'>%3</t><br/>	
					<t size='1'align='Center'shadow='1'> From Distance:</t><br/>
					<t size='1.25'align='Center'shadow='1'color='#FFCC00'>%4</t><br/>",
					_victim,
					_killer,
					_weapon,
					_range
				];
			};	
			diag_log format["studyBody: _cutTextMessage = %1",_cutTextMessage];	
			cutText [_cutTextMessage,"PLAIN DOWN",1,false,true];
			[] spawn {uiSleep 10; cutText ["","PLAIN_DOWN",1,false,false]};
		};	
	};
	
} forEach _cue;
diag_log _message;
