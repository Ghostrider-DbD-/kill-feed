
private _target = cursorTarget;
private _targetCN = typeOf _target;
private _isZed = ["ryan",_targetCN] call BIS_fnc_inString;
diag_log format["fn_isZed: %1 typename %2 | isZed = %3",_target,_targetCN,_isZed];
_isZed