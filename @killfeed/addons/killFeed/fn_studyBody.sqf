
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

if (_killer isEqualTo _victim) then 
{
	[format["%1 died %2 ago of unknown causes",_victim,_time],10] call EPOCH_message;
} else {
	[format["%1 was killed %2 ago by %3 using %4 from %5",_victim,_time,_killer,_weapon,_range],10] call EPOCH_message;
};

