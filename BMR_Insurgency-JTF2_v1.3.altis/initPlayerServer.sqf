private["_player","_didJIP","_update","_intel","_text"];

_player = _this select 0;
_didJIP =  _this select 1;
_update = false;
_text = format["%1 joined the game!",name _player];

//[[_text],"JIG_MPsideChatWest_fnc"] call BIS_fnc_mp;
//[[_text],"JIG_MPsideChatEast_fnc"] call BIS_fnc_mp;

waitUntil {!isNil "JIPmkr_updateClient_fnc"};
call JIPmkr_updateClient_fnc;

waitUntil {!isNil "intel_Build_objs"};
if ((count intel_Build_objs) > 0) then {
	if (ObjNull in intel_Build_objs) then {
		{intel_Build_objs = intel_Build_objs - [objNull]} forEach intel_Build_objs;
		_update = true;
	};
};

{_intel = _x; [[_intel,current_cache_pos],"fnc_mp_intel",_player] spawn BIS_fnc_MP;} forEach intel_Build_objs;

if (_update) then {publicVariableServer "intel_Build_objs";};