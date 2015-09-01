/*
INS_SuicideBomber.sqf
by Jigsor
movement section by Zooloo75/Stealthstick
*/

if (!isServer) exitWith {};

private ["_delay","_ins_debug","_basePos","_safeZone_rad"];

if (DebugEnabled > 0) then {_ins_debug = true;}else{waitUntil {time > 60}; _ins_debug = false;};
_delay = true;
_basePos = getMarkerPos "Respawn_West";
_safeZone_rad = 600;// radius _basePos marker safe zone/spawn suicide bomber beyond this distance
sstBomber = ObjNull;
random_w_player4 = ObjNull;

"sstBomber" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"random_w_player4" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
{
	sleep 2;
	if (_delay) then {sleep 90;};
	waitUntil {sleep 2; isNull sstBomber || !(alive sstBomber)};
	if ((isNull sstBomber) || (not(alive sstBomber))) then
	{
		private "_random_sleep";
		if (_ins_debug) then
		{
			_random_sleep = [5,15] call BIS_fnc_randomInt;
			sleep _random_sleep;
		}
		else
		{
			_random_sleep = [420,900] call BIS_fnc_randomInt;
			sleep _random_sleep;
		};

		private ["_jig_bmbr_xcoor","_jig_bmbr_coor_ref","_jig_bmbr_ycoor","_bmbr_pos","_count","_VarHunterName","_unit","_targetSide","_explosiveClass","_runCode","_nearUnits","_explosive","_centerC","_class","_civgrp","_btarget"];	
		_centerC = createCenter civilian;
		_civgrp = createGroup Civilian;
		_bmbr_pos = [];
		_targetSide = WEST;
		_delay = false;
		_runCode = 1;
		_maxtype = (count suicide_bmbr_weps)-1;
		_explosiveClass = suicide_bmbr_weps select (round random _maxtype);
		_VarHunterName = "sstBomber";
		random_w_player4 = nil;

		publicVariableServer "random_w_player4";
		sleep 3;
		call find_bombee_fnc;
		sleep 3;

		if (isNil "random_w_player4") exitWith {_delay = true;};

		if (_ins_debug) then
		{
			diag_log text format ["Bomber West Human Target1: %1", random_w_player4];
			titletext ["INS_SuicideBomber.sqf running","plain down"];
		};

		_jig_bmbr_coor_ref = getPos random_w_player4;

		if (isNil "_jig_bmbr_coor_ref") exitWith {_delay = true;};
		if (_jig_bmbr_coor_ref distance _basePos < _safeZone_rad) exitWith {_delay = true;};

		_jig_bmbr_xcoor = (getPos random_w_player4 select 0);
		_jig_bmbr_ycoor = (getPos random_w_player4 select 1);
		if (_ins_debug) then {diag_log text format ["Random Player Bomber Target Pos : %1", _jig_bmbr_coor_ref];};

		_bmbr_pos = _bmbr_pos + [_jig_bmbr_xcoor,_jig_bmbr_ycoor] call bmbr_spawnpos_fnc;
		
		private ["_count"];
		_count = 0;
		
		while {_bmbr_pos isEqualTo []} do
		{
			_bmbr_pos = _bmbr_pos + [_jig_bmbr_xcoor,_jig_bmbr_ycoor] call bmbr_spawnpos_fnc;
			if (!(_bmbr_pos isEqualTo [])) exitWith {_bmbr_pos;};
			_count = _count + 1;
			if (_count > 3) exitWith {if (_ins_debug) then {hintsilent "suitable pos for sstBomber not found";}; _bmbr_pos = [];};
			sleep 4;
		};
		if (_bmbr_pos isEqualTo []) exitWith {_delay = true;};		

		_class = INS_civlist select (floor (random (count INS_civlist)));
		_unit = _civgrp createUnit [_class, _bmbr_pos, [], 0, "NONE"];
		sleep jig_tvt_globalsleep;
		
		_unit addeventhandler ["killed","(_this select 0) spawn {[_this] call remove_carcass_fnc}"];
		_unit addeventhandler ["killed",{_this call killed_ss_bmbr_fnc}];		
		
		_bmbrdir = [random_w_player4, _unit] call BIS_fnc_dirTo;
		
		_unit setDir _bmbrdir;
		[_unit] joinSilent _civgrp;
		_unit SetUnitPos "UP";		
		_unit setSkill ["endurance", 1];
		_unit setSkill ["spotTime", 0.8];
		_unit setSkill ["courage", 1];
		_unit setSkill ["spotDistance", 1];
		_unit allowFleeing 0;
		_unit disableAI "AUTOTARGET";
		_unit disableAI "FSM";
		_unit setVehicleVarName _VarHunterName; sstBomber = _unit;
		_unit Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarHunterName];
		sleep 3;

		// movment section
		while {alive sstBomber && _runCode isEqualTo 1} do
		{
			//_nearUnits = (getPos _unit) nearentities [["CAManBase"],105];
			_nearUnits = nearestObjects [(getPosATL _unit),["CAManBase"],105];//70
			_nearUnits = _nearUnits - [_unit];

			{
				if (!(side _x == _targetSide)) then {_nearUnits = _nearUnits - [_x];};
			} forEach _nearUnits;

			if(count _nearUnits > 0) then
			{
				_btarget = _nearUnits select 0;
				
				[_unit,_btarget] spawn {
					private ["_unit","_btarget"];
					_unit = _this select 0;
					_btarget = _this select 1;
					
					while {alive _unit and !isNull _btarget} do {
						_unit doMove (getPosATL _btarget);
						_unit setspeedMode "NORMAL";
						sleep 8;
					};
				};//Jig adding

				waitUntil {sleep 1; (_unit distance getPosATL (_nearUnits select 0) > 110) || (_unit distance getPosATL (_nearUnits select 0) < 17)};

				if (_unit distance getPosATL (_nearUnits select 0) > 110)
				exitWith
				{
				_runCode = 0;
				_unit setPos [0,0,0];
				_unit removeAllEventHandlers "killed";
				_unit removeAllEventHandlers "Animchanged";
				_unit setdamage 1;
				sleep 1;
				deleteVehicle _unit;
				sleep 1;
				};//Jig adding
				if(_unit distance (_nearUnits select 0) < 17)
				exitWith
				{
				_unit setspeedMode "full";
				_runCode = 0;
				_explosive = _explosiveClass createVehicle (position _unit);
				sleep jig_tvt_globalsleep;
				[_unit,_explosive] spawn {_unit = _this select 0; _explosive = _this select 1; nul = [_unit,"shout"] call mp_Say3D_fnc; sleep 2; _explosive setDamage 1; _unit addRating 2000;};
				[_explosive,_unit] spawn {_explosive = _this select 0; _unit = _this select 1; waitUntil {!alive _unit}; deleteVehicle _explosive; _unit removeAllEventHandlers "Animchanged";};
					_unitpos = (getPosATL _unit);
					if(round(random(1)) isEqualTo 0) then
					{
					_explosive attachTo [_unit,[-0.02,-0.07,0.042],"rightHand"];
					_unit setPos _unitpos;
					}
					else
					{
					_explosive attachTo [_unit,[-0.02,-0.07,0.042],"leftHand"];
					_unit setPos _unitpos;
					};
				};
			}
			else
			{
			_unit setPos [0,0,0];
			_unit removeAllEventHandlers "killed";
			_unit setdamage 1;
			sleep 1;
			deleteVehicle _unit;
			sleep 1;
			};// Jig adding else

			sleep 1;
		};
	};
};