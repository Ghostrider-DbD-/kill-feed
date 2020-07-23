
params["_corpse"];

private _tod =	_corpse getVariable["TOD",0];
private _killer = _corpse getVariable["KILLER","unknown"];
private _weapon = _corpse getVariable["WEAPON","mysterious force"];
private _distance = _corpse getVariable["DISTANCE",0];
private _victim = _corpse getVariable["VICTIM_NAME","John Doe"];
private["_time","_range"];
switch (true) do 
{
	case (_tod < 300): {_time = "less than 5 min"};
	case (_tod >= 300 && _tod < (60 * 20)): {_time = "between 5 and 20 minutes"};
	case (_tod >= (60 * 20) && _tod < (60 * 60)): {_time = "between 20 and 60 minutes"};
	case (_tod >= (60 * 60)): {_time = "more than 60 minutes"};
	default {_time = "not long ago"};
};
switch (true) do 
{
	case (_distance < 30): {_range = "really close"};
	case (_distance >= 30 && _distance < 100): {_range = "not too far away"};
	case (_distance >= 100 && _distance < 300): {_range = "well, it took some skill"};
	case (_distance >= 300 && _distance < 1000): {_range = "it was a good shot"};
	case (_distance >= 1000): {_range = "it was a great shot"};
	default {_range = "somewhere nearby"};
};

private _message = if (_killer isEqualTo _victim) then 
{
	format["%1 died %2 ago of unknown causes",_victim,_time];
} else {
	format["%1 was killed %2 ago by %3 using %4 from %5",_victim,_time,_killer,_weapon,_range];
};

private _parsedMessage = if (_killer isEqualTo _victim) then 
{
	_message 
} else {
	parseText format["
		<t size='1.25'align='center'shadow='1'color='#5882FA'>/%1</t><br/>
		<t size='1.25'align='Center'shadow='1'> Was Killed By</t><br/>
		<t size='1.25'align='Center'shadow='1'color='#c70000'>%2</t><br/>
		<t size='1'align='Center'shadow='1'> With Weapon:</t><br/>
		<t size='1'align='Center'shadow='1'> From Distance:</t><br/>
		<t size='1.25'align='Center'shadow='1'color='#FFCC00'>%4m</t><br/>",
		_victim,
		_killer,
		_weapon,
		_range
	];
};

private _cue = [];
{
	private _p = getNumber(missionConfigFile >> "CfgKillMessages" >> "studyBody" >> _x);
	//diag_log format["screening _x = %1 with _p = %2",_x,_p];
	if (_p == 1) then {_cue pushBack _x};
} forEach [
	"displaySystemChat",
	"displayHint",
	"displayEpochMessage",
	"displayCutText"
];
//diag_log format["_cue = %1",_cue];
{
	//diag_log format["_x = %1",_x];
	switch (_x) do
	{
		case "displaySystemChat": {systemChat _message};
		case "displayHint": {hint _parsedMessage};
		case "displayEpochMessage": {[_message,10] call EPOCH_message};
		case "displayCutText": {cutText [_parsedMessage,"PLAIN DOWN",10,false,true]};	
	};
} forEach _cue;

//[_message,10] call EPOCH_message;
