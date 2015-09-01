//Objectives\capture_n_hold.sqf by Jigsor

sleep 2;
private ["_newZone","_type","_rnum","_cap_rad","_VarName","_uncaped","_caped","_ins_debug","_objmkr","_outpost","_grp","_stat_grp","_handle","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE","_manArray","_text","_rwave","_hold_rad"];

_newZone = _this select 0;
_type = _this select 1;
_rnum = str(round (random 999));
_cap_rad = 25;
_hold_rad = 50;
_VarName = "OutPost1";
_uncaped = true;
_caped = true;
if (DebugEnabled < 1) then {_ins_debug = false;}else{_ins_debug = true;};

// Positional info
objective_pos_logic setPos _newZone;

_objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Capture and Hold";

// Spawn Objective Object
_outpost = createVehicle [_type, _newZone, [], 0, "None"];
sleep jig_tvt_globalsleep;

_outpost setDir (random 359);
_outpost setVectorUp [0,0,1];
_outpost setVehicleVarName _VarName;
_outpost Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarName];

// Spawn Objective enemy deffences
_grp = [_newZone,10] call spawn_Op4_grp;
_stat_grp = [_newZone,3] call spawn_Op4_StatDef;

_stat_grp setCombatMode "RED";

_handle=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;

if (_ins_debug) then {[_grp] spawn INS_Tsk_GrpMkrs;};

// create west task
_tskW = "tskW_Cap_n_Hold" + _rnum;
_tasktopicW = "Capture Outpost";
_taskdescW =  "Capture and Hold Outpost. Stay within a 50 meter radius of objective center once captured for duration of timer.";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_Cap_n_Hold" + _rnum;
_tasktopicE = "Defend Outpost";
_taskdescE =  "Defend and Hold Outpost";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

while {_uncaped} do
{
	_manArray = (position objective_pos_logic) nearentities [["CAManBase"], _cap_rad];

	{
		if ((!(side _x == INS_Blu_side)) || (captiveNum _x == 1)) then
		{
			_manArray = _manArray - [_x];
		};
	} foreach _manArray;

	if ((count _manArray) > 0) exitWith {_uncaped = false};
	sleep 4;
};

if (isNil "timesup") then {timesup = false;};
"timesup" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

_text = format ["Outpost Captured. Enemy reinforcements are in route."];
[[_text],"JIG_MPsideChatWest_fnc"] call BIS_fnc_mp;

//[[[time,false,6," Hold Outpost"],"scripts\Timer.sqf"],"BIS_fnc_execVM",true] call BIS_fnc_MP;//with JIP persistance
[[[time,false,6," Hold Outpost"],"scripts\Timer.sqf"],"BIS_fnc_execVM"] call BIS_fnc_MP;// without JIP persistance

_rwave = [_newZone,_ins_debug] spawn {

	private ["_newZone","_start_dis","_start_pos1","_midLength","_midDir","_midPos","_pointC","_ins_debug","_rgrp1","_newPosw","_wp"];

	_newZone = _this select 0;
	_ins_debug = _this select 1;
	makewave = true;
	curvePositionsArray = [];
	wave_grp = createGroup INS_Op4_side;

	"makewave" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

	while {makewave} do
	{
		//Thanks to Larrow for this next block. Creates 2D obtuse isosceles triangle points.
		_start_dis = [400,500] call BIS_fnc_randomInt;
		_start_pos1 = [_newZone, 10, _start_dis, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
		_midLength = ( _newZone distance _start_pos1 ) / 2;
		_midDir = [ objective_pos_logic, _start_pos1 ] call BIS_fnc_relativeDirTo;
		_midPos = [ _newZone, _midLength, _midDir ] call BIS_fnc_relPos;
		_pointC = [ _midPos, _midLength - 1, _midDir + 90 ] call BIS_fnc_relPos;

		if (count curvePositionsArray > 0) then {curvePositionsArray = curvePositionsArray - curvePositionsArray;};

		curvePositionsArray = [_start_pos1,_newZone,_pointC,12,false,_ins_debug] call rej_fnc_bezier;

		private "_count";
		_count = 0;

		while {curvePositionsArray isEqualTo []} do
		{
			curvePositionsArray = [_start_pos1,_newZone,_pointC,12,false,_ins_debug] call rej_fnc_bezier;
			if (!(curvePositionsArray isEqualTo [])) exitWith {curvePositionsArray;};
			_count = _count + 1;
			if (_count > 3) exitWith {if (_ins_debug) then {hintsilent "Empty curvePositionsArray";}; curvePositionsArray = [];};
			sleep 3;
		};
		if (curvePositionsArray isEqualTo []) exitWith {makewave = false; publicVariable "makewave";};

		if (count curvePositionsArray > 0) then
		{
			_rgrp1 = [_start_pos1,6] call spawn_Op4_grp;

			for "_i" from 0 to (count curvePositionsArray) -1 do {

				private "_newPosx";
				_newPosx = (curvePositionsArray select 0);

				_wp = _rgrp1 addWaypoint [_newPosx, 0];
				_wp setWaypointType "MOVE";
				_wp setWaypointSpeed "NORMAL";
				_wp setWaypointBehaviour "AWARE";
				_wp setWaypointFormation "COLUMN";
				_wp setWaypointCompletionRadius 20;

				curvePositionsArray = curvePositionsArray - [_newPosx];
				sleep 0.2;
			};
			sleep 60;
			if (!makewave) exitWith {};
		};
	};

	sleep 20;
	{deleteVehicle _x; sleep 0.1} forEach (units _rgrp1);
	{deleteVehicle _x; sleep 0.1} forEach (units wave_grp);
	deleteGroup _rgrp1; sleep 0.1;
	deleteGroup wave_grp; sleep 0.1;
};

while {_caped} do
{
	_manArray = (position objective_pos_logic) nearentities [["CAManBase","Landvehicle"],_hold_rad];

	{
		if ((!(side _x == INS_Blu_side)) || (captiveNum _x == 1)) then
		{
			_manArray = _manArray - [_x];
		};
	} foreach _manArray;

	if ((count _manArray) < 1) exitWith	{
		makewave = false;publicVariable "makewave"; sleep 2;
		killtime = true;publicVariable "killtime"; sleep 2;
		[_tskE, "succeeded"] call SHK_Taskmaster_upd;
		[_tskW, "failed"] call SHK_Taskmaster_upd;
		_caped = false;
	};

	if (timesup) exitWith {
		makewave = false;publicVariable "makewave"; sleep 2;
		[_tskW, "succeeded"] call SHK_Taskmaster_upd;
		[_tskE, "failed"] call SHK_Taskmaster_upd;
		_caped = false;
	};
	sleep 4;
};

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
sleep 90;

if (!isNull _outpost) then {deleteVehicle _outpost; sleep 0.1;};
{deleteVehicle _x; sleep 0.1} forEach (units _grp);
{deleteVehicle _x; sleep 0.1} forEach (units _stat_grp);
deleteGroup _grp;
deleteGroup _stat_grp;

{if (typeof _x in INS_men_list) then {deleteVehicle _x; sleep 0.1}} forEach (NearestObjects [objective_pos_logic, [], 40]);
{if (typeof _x in INS_Op4_stat_weps) then {deleteVehicle _x; sleep 0.1}} forEach (NearestObjects [objective_pos_logic, [], 40]);
{if (typeof _x in objective_ruins) then {deleteVehicle _x; sleep 0.1}} forEach (NearestObjects [objective_pos_logic, [], 30]);

deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};