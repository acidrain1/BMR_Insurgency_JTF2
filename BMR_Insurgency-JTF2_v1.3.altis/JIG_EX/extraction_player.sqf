/*
 extraction_player.sqf v1.11 by Jigsor
 handles map click pickup/dropoff points and group inventory.
 jig_ex_actid_show = _ex_caller addAction [("<t color=""#12F905"">") + ("Heli Extraction") + "</t>","JIG_EX\extraction_player.sqf",JIG_EX_Caller removeAction jig_ex_actid_show,1, false, true,"","player ==_target"];
 runs from JIG_EX\extraction_init.sqf and JIG_EX\respawnAddActionHE.sqf
*/

private ["_target","_caller","_action","_tempmkr1","_actual_ext_pos","_leaderPos","_outof_range_members","_tempmkr2","_actual_drop_pos"];

_target = _this select 0;  // Object that had the Action (also _target in the addAction command)
_caller = _this select 1;  // Unit that used the Action (also _this in the addAction command)
_action = _this select 2;  // ID of the Action

_target removeAction _action;

if ({_x in (items player + assignedItems player)}count ["ItemMap"] < 1) exitWith {hint "You cannot call for extraction without a map"; player addAction [("<t color=""#12F905"">") + ("Heli Extraction") + "</t>","JIG_EX\extraction_player.sqf",JIG_EX_Caller removeAction jig_ex_actid_show,1, false, true,"","player ==_target"];};

extractmkr = [];
dropmkr = [];

if (!isNil "extractmkr") then {deleteMarker "extractmkr";};	
_tempmkr1 = createMarker ["extractmkr", [0,0,0]];
_tempmkr1 setMarkerShape "ELLIPSE";
"extractmkr" setMarkerSize [1, 1];
"extractmkr" setMarkerShape "ICON";
"extractmkr" setMarkerType "mil_dot";//"mil_dot" , "EMPTY"
"extractmkr" setMarkerColor "Color3_FD_F";//"Color3_FD_F" , "ColorOrange"
"extractmkr" setMarkerText "Requested Extraction Position";
sleep 0.1;

if (!isNil "dropmkr") then {deleteMarker "dropmkr";};	
_tempmkr2 = createMarker ["dropmkr", [0,0,0]];
_tempmkr2 setMarkerShape "ELLIPSE";
"dropmkr" setMarkerSize [1, 1];
"dropmkr" setMarkerShape "ICON";
"dropmkr" setMarkerType "mil_dot";//"mil_dot" , "EMPTY"
"dropmkr" setMarkerColor "Color3_FD_F";//"Color3_FD_F" , "ColorOrange"
"dropmkr" setMarkerText "Requested Drop Off Position";
sleep 0.1;

hint "";
ex_group_ready =false;
GetClick = true;
openMap true;
waitUntil {visibleMap}; 
ctrlActivate ((findDisplay 12) displayCtrl 107);// map texture toggle
[] spawn {["Click on Map for Extraction Point or escape to cancel",0,.1,3,.005,.1] call bis_fnc_dynamictext;};
onMapSingleClick "'extractmkr' setMarkerPos _pos; GetClick = false; onMapSingleClick '';";
waituntil {!GetClick or !(visiblemap)};
if (!visibleMap) exitwith {hint "Evac on Standby"; ctrlActivate ((findDisplay 12) displayCtrl 107); openMap false; player addAction [("<t color=""#12F905"">") + ("Heli Extraction") + "</t>","JIG_EX\extraction_player.sqf",JIG_EX_Caller removeAction jig_ex_actid_show,1, false, true,"","player ==_target"]};

_actual_ext_pos = [];
_actual_ext_pos = _actual_ext_pos + call extraction_pos_fnc;
if (_actual_ext_pos isEqualTo []) exitWith {hint "Heli cannot land at you chosen position"; ctrlActivate ((findDisplay 12) displayCtrl 107); openMap false; player addAction [("<t color=""#12F905"">") + ("Heli Extraction") + "</t>","JIG_EX\extraction_player.sqf",JIG_EX_Caller removeAction jig_ex_actid_show,1, false, true,"","player ==_target"]};
mapAnimAdd [0.5, 0.1, markerPos "tempExtMarker"];
mapAnimCommit;
sleep 1.2;
openMap false;

sleep 0.9;

GetClick = true;
openMap true;
[] spawn {["Click on Map for Drop Point or escape to cancel",0,.1,3,.005,.1] call bis_fnc_dynamictext;};
onMapSingleClick "'dropmkr' setMarkerPos _pos; GetClick = false; onMapSingleClick '';";
waituntil {!GetClick or !(visiblemap)};
if (!visibleMap) exitwith {hint "Evac on Standby"; ctrlActivate ((findDisplay 12) displayCtrl 107); openMap false; player addAction [("<t color=""#12F905"">") + ("Heli Extraction") + "</t>","JIG_EX\extraction_player.sqf",JIG_EX_Caller removeAction jig_ex_actid_show,1, false, true,"","player ==_target"]};

_actual_drop_pos = [];
_actual_drop_pos = _actual_drop_pos + call drop_off_pos_fnc;
if (_actual_drop_pos isEqualTo []) exitWith {hint "Heli cannot land at you chosen position"; ctrlActivate ((findDisplay 12) displayCtrl 107); openMap false; player addAction [("<t color=""#12F905"">") + ("Heli Extraction") + "</t>","JIG_EX\extraction_player.sqf",JIG_EX_Caller removeAction jig_ex_actid_show,1, false, true,"","player ==_target"]};
mapAnimAdd [0.5, 0.1, markerPos "tempDropMkr"];
mapAnimCommit;
sleep 1.5;
ctrlActivate ((findDisplay 12) displayCtrl 107);// map texture toggle
openMap false;

if (getMarkerPos "extractmkr" distance getMarkerPos "dropmkr" < 500) exitWith {hint "Extraction and Drop Position is less then 500 meters appart. Try again."; player addAction [("<t color=""#12F905"">") + ("Heli Extraction") + "</t>","JIG_EX\extraction_player.sqf",JIG_EX_Caller removeAction jig_ex_actid_show,1, false, true,"","player ==_target"]};

[] spawn { call Ex_LZ_smoke_fnc };
if (JIG_EX_AmbRadio) then {	[] spawn { call AmbExRadio_fnc }; };

jig_ex_cancelid_show = 9998;
ext_caller_group = grpNull;
ext_caller_group = group player;
/*
{
	if (!isPlayer _x) then
	{
		ext_caller_group = ext_caller_group - [_x];
	};
} forEach (units ext_caller_group);
*/
_outof_range_members = [];
_leaderPos = position player;
{
	if (_x distance _leaderPos > JIG_EX_Group_Dis) then
	{
		_outof_range_members = _outof_range_members + [_x];
	};
} forEach (units ext_caller_group);

//{[_x] join grpNull;} foreach (units _outof_range_members); ext_caller_group = group player;

publicVariable "ext_caller_group";
sleep 3;
ex_group_ready = true;
publicVariable "ex_group_ready";
sleep 1;

if (ex_group_ready) then {sleep 6; jig_ex_cancelid_show = _caller addAction [("<t color=""#ED2744"">") + ("Cancel Extraction") + "</t>", {call Cancel_Evac_fnc}, 0, -9, false];};