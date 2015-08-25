//Objectives\delivery.sqf mission by Jigsor

sleep 2;
private ["_newZone","_type","_rnum","_objmkr","_AA","_VarName","_grp","_vehgrp","_AAveh","_stat_grp","_inf_patrol","_AA_mob_patrol","_wp","_tskW","_tasktopicW","_taskdescW","_tskE","_tasktopicE","_taskdescE","_droppoint","_dropedcargo","_veh","_text","_deliverydone","_MHQ3DelReady","_Demo_Sphere","_cargoPos"];

_newZone = _this select 0;
_rnum = str(round (random 999));
_MHQ3DelReady = false;
_cargoPos = Del_box_Pos;
_deliverydone = 0;
deliveryfail = 0;
Demo_Loaded = false;
Demo_Unloaded = false;
Demo_Near = false;
Demo_End = false;
Task_Transport = [];

if (INS_op_faction > 2) then {
	_type = INS_Op4_Veh_AA select (round(random((count INS_Op4_Veh_AA)-1)));
}else{
	_type = _this select 1;
};

// Positional info
objective_pos_logic setPos _newZone;

_objmkr = createMarker ["ObjectiveMkr", _newZone];
"ObjectiveMkr" setMarkerShape "ELLIPSE";
"ObjectiveMkr" setMarkerSize [2, 2];
"ObjectiveMkr" setMarkerShape "ICON";
"ObjectiveMkr" setMarkerType "mil_dot";
"ObjectiveMkr" setMarkerColor "ColorRed";
"ObjectiveMkr" setMarkerText "Delivery Zone";

"deliveryfail" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"Task_Transport" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"Demo_Loaded" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"Demo_Unloaded" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

if (isNil "MHQ_3" || !Alive MHQ_3) then {// Create Helicopter MHQ_3 if it doesn't exist. Added to support Revive System(s) lacking MHQ's.
	sleep 8;// wait for possible vehRespawn script 
	if (isNil "MHQ_3" || !Alive MHQ_3) then	{
		if (!Alive MHQ_3) then {deleteVehicle MHQ_3; sleep 0.1;};

		private ["_dis","_mhq_3_pos","_heli","_HeliName","_actualPos"];
		_dis = 20;
		_mhq_3_pos = nil;
		_HeliName = "MHQ_3";

		while {isNil "_mhq_3_pos"} do {
			_mhq_3_pos = [_cargoPos, 5, _dis, 15, 0, 0.6, 0] call BIS_fnc_findSafePos;
			_dis = _dis + 5;
			sleep 0.1;
		};
	
		_heli = createVehicle ["I_Heli_Transport_02_F", _mhq_3_pos, [], 0, "NONE"];	sleep jig_tvt_globalsleep;
		_heli addEventHandler ["killed", "(_this select 0) spawn {[_this] call remove_carcass_fnc}"];
		[_heli] call paint_heli_fnc;
		_heli setVehicleVarName _HeliName; MHQ_3 = _heli;
		_heli Call Compile Format ["%1=_This ; PublicVariable ""%1""",_HeliName];
		sleep 3;
		_actualPos = (getPosATL MHQ_3);
		_cargoPos = [_actualPos, 5, 14, 5, 0, 0.6, 0] call BIS_fnc_findSafePos;
	};
};

[] spawn {
	Delivery_Box setVariable ["BTK_CargoDrop_ObjectLoaded", false];
	MHQ_3 setVariable ["BTK_CargoDrop_TransporterLoaded", false];

	//// Wait until loaded
	waitUntil {sleep 1; (Delivery_Box getVariable "BTK_CargoDrop_ObjectLoaded") && {(MHQ_3 getVariable "BTK_CargoDrop_TransporterLoaded")}};
	Demo_Loaded = true;
	publicVariable "Demo_Loaded";

	//// Wait until UNloaded
	waitUntil {sleep 0.5; !(Delivery_Box getVariable "BTK_CargoDrop_ObjectLoaded") && !(MHQ_3 getVariable "BTK_CargoDrop_TransporterLoaded")};
	Demo_Unloaded = true;
	publicVariable "Demo_Unloaded";
};

Delivery_Box setPos _cargoPos;
Delivery_Box hideObjectGlobal false;

_Demo_Sphere = createVehicle ["Sign_Sphere100cm_F", getPosATL Delivery_Box, [], 0, "CAN_COLLIDE"];
sleep jig_tvt_globalsleep;
_Demo_Sphere setPos [(getPos _Demo_Sphere select 0),(getPos _Demo_Sphere select 1),5];

waitUntil {sleep 1; alive MHQ_3};

Demo_Arrow = createVehicle ["Sign_Arrow_Large_Yellow_F", getPosATL MHQ_3, [], 0, "CAN_COLLIDE"];
sleep jig_tvt_globalsleep;
Demo_Arrow setPos [(getPos Demo_Arrow select 0),(getPos Demo_Arrow select 1),6];

private ["_newPos","_tmarker"];
_newPos = (getposATL MHQ_3);

if (!isNil "Task_Transport") then {deleteMarker "Task_Transport";};
_tmarker = createMarker ["Task_Transport", _newPos];
"Task_Transport" setMarkerShape "ICON";
"Task_Transport" setMarkerSize [2, 2];
"Task_Transport" setMarkerType "mil_dot";
"Task_Transport" setMarkerColor "ColorBlue";
"Task_Transport" setMarkerText "Task_Transport";
publicVariable "Task_Transport";
sleep 2;

[] spawn { while {not isNull Demo_Arrow} do { "Task_Transport" setmarkerpos getposATL MHQ_3; sleep 1; }; };

// create west task
_tskW = "tskW_Freight_Delivery" + _rnum;
_tasktopicW = "Deliver Supplies";
_taskdescW =  "Load and drop supply container to Delivery Zone Marker with MHQ_3. Supply container is next to MHQ_3 respawn point at base. Drop cargo within 750 meters of green smoke/Delivery Zone Marker. Check map for MHQ_3 Marker and look out for Anti Air defences. Pilot must unload cargo before exiting chopper.";
[_tskW,_tasktopicW,_taskdescW,WEST,[],"created",_newZone] call SHK_Taskmaster_add;
sleep 5;

// create east task
_tskE = "tskE_Freight_Delivery" + _rnum;
_tasktopicE = "Sabatoge Delivery";
_taskdescE =  "Intercept Mohawk supply delivery en route to Task Marker Delivery Zone.";
[_tskE,_tasktopicE,_taskdescE,EAST,[],"created",_newZone] call SHK_Taskmaster_add;

waitUntil {sleep 1; Demo_Loaded};

deleteVehicle Demo_Arrow; sleep 0.1;
deleteVehicle _Demo_Sphere; sleep 0.1;
MHQ_3 setDamage 0; sleep 0.1;

attach_MHQ3_mkr = {
	[] spawn { if (alive MHQ_3) then { "Task_Transport" setmarkerpos getposATL MHQ_3; }; };
};

"Task_Transport" addPublicVariableEventHandler 
{
	createMarker [((_this select 1) select 0), position ((_this select 1) select 1)];
	"Task_Transport" setMarkerShape "ICON";
	"Task_Transport" setMarkerSize [2, 2];	
	"Task_Transport" setMarkerType "mil_dot";
	"Task_Transport" setMarkerColor "ColorBlue";
	"Task_Transport" setMarkerText "Task_Transport";
	call attach_MHQ3_mkr;
};

_veh = MHQ_3;

waitUntil {sleep 0.5; (isPlayer (driver _veh)) && {(isEngineOn _veh) && (!isnull (driver _veh))}};

_MHQ3DelReady = true;
["MHQ_3 Pilot Ready", "JIG_MPhint_fnc"] call BIS_fnc_mp;
sleep 2;

_text = format ["MHQ_3 cargo loaded and engines on. Clear for dust off"];
[[_text],"JIG_MPsideChatWest_fnc"] call BIS_fnc_mp;
sleep 3;

// Spawn Objective Object
_newPos = [_newZone, 0, 75, 10, 0, 0.6, 0] call BIS_fnc_findSafePos;
_AA = [_newPos, 180, _type, INS_Op4_side] call bis_fnc_spawnvehicle;
sleep jig_tvt_globalsleep;
_AAveh = _AA select 0;
_vehgrp = _AA select 2;

_AAveh addeventhandler ["killed","(_this select 0) spawn {[_this] call remove_carcass_fnc}"];
{_x addEventHandler ["killed", "(_this select 0) spawn {[_this] call remove_carcass_fnc}"]} forEach (units _vehgrp);

_VarName = "DeliveryDefence";
_AAveh setVehicleVarName _VarName;
_AAveh Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarName];

// Spawn Objective enemy deffences
_grp = [_newZone,10] call spawn_Op4_grp;
_stat_grp = [_newZone,3] call spawn_Op4_StatDef;

_stat_grp setCombatMode "RED";

_inf_patrol=[_grp, position objective_pos_logic, 75] call BIS_fnc_taskPatrol;
_AA_mob_patrol=[_vehgrp, position objective_pos_logic, 125] call Veh_taskPatrol_mod;

if (DebugEnabled > 0) then {[_grp] spawn INS_Tsk_GrpMkrs;};

// Task Conditions

[_veh] spawn {
	private "_veh";
	_veh = _this select 0;
	for [{_loop=0}, {_loop<1}, {_loop=_loop}] do
	{
		if (Demo_Unloaded) then 
		{
			_loop = 1;
		};
		sleep 0.5;
		if ((isnull (driver _veh)) || (!alive _veh) || (!alive (driver _veh)) && {(Demo_Loaded)}) then
		{
			["MHQ_3 with cargo has been destroyed or pilot aborted", "JIG_MPhint_fnc"] call BIS_fnc_mp;
			sleep 3;
			
			_text = format ["MHQ_3 with cargo has been destroyed!"];
			[[_text],"JIG_MPsideChatWest_fnc"] call BIS_fnc_mp;
			[[_text],"JIG_MPsideChatEast_fnc"] call BIS_fnc_mp;

			deliveryfail = 1;
			publicVariable "deliveryfail";
			
			_loop = 1;
		};
		sleep 1;
	};
};

while {Demo_Loaded} do
{
	sleep 35;
	Demo_SFSmoke1 = createVehicle ["SmokeShellRed", getMarkerPos "ObjectiveMkr", [], 0, "CAN_COLLIDE"];
	Demo_SFSmoke1 setPos [(getPos Demo_SFSmoke1 select 0),(getPos Demo_SFSmoke1 select 1),50];
	Demo_SFSmoke2 = createVehicle ["SmokeShellRed", getMarkerPos "ObjectiveMkr", [], 0, "CAN_COLLIDE"];
	Demo_SFSmoke2 setPos [(getPos Demo_SFSmoke2 select 0),(getPos Demo_SFSmoke2 select 1),100];
	sleep jig_tvt_globalsleep;
	
	if (Demo_Unloaded) exitwith {};
	if (deliveryfail isEqualTo 1) exitwith {};
};

if (Demo_Unloaded) then
{
	waitUntil {sleep 1; (getPosatl Delivery_Box select 2) < 2 || deliveryfail isEqualTo 1};
	
	_droppoint = [ getMarkerPos "ObjectiveMkr" select 0, (getMarkerPos "ObjectiveMkr" select 1)];
	_dropedcargo = [ getPosatl Delivery_Box select 0, (getPosatl Delivery_Box select 1)];
	
	if ((_droppoint distance _dropedcargo < 750) && (deliveryfail isEqualTo 0) && {(alive _veh) && (alive (driver _veh))}) then
	{
		_text = format["Good job! Cargo delivered within range."];
		[[_text],"JIG_MPTitleText_fnc",true,nil,WEST] call BIS_fnc_mp;
		_deliverydone = 1;		
	};

	if (_droppoint distance _dropedcargo > 750 && (deliveryfail isEqualTo 0) && {(alive _veh) && (alive (driver _veh))}) then
	{
		_text = format["Cargo not delivered within range."];
		[[_text],"JIG_MPTitleText_fnc",true,nil,WEST] call BIS_fnc_mp;
		deliveryfail = 1;		
	}
	else
	{		
		if (isnull (driver _veh) || (!alive _veh) || (!alive (driver _veh))) then
		{
			_text = format["Transport is Down."];
			[[_text],"JIG_MPTitleText_fnc",true,nil,WEST] call BIS_fnc_mp;
			deliveryfail = 1;		
		};
	};
	
};

// Win - Loose
waitUntil {sleep 1; (deliveryfail isEqualTo 1 || _deliverydone isEqualTo 1)};

if (_deliverydone isEqualTo 1) then {
	[_tskW, "succeeded"] call SHK_Taskmaster_upd;
	[_tskE, "failed"] call SHK_Taskmaster_upd;
};
if (deliveryfail isEqualTo 1) then {
	[_tskE, "succeeded"] call SHK_Taskmaster_upd;
	[_tskW, "failed"] call SHK_Taskmaster_upd;
};

// clean up
"ObjectiveMkr" setMarkerAlpha 0;
"Task_Transport" setMarkerAlpha 0;

if (!isNull Demo_Arrow) then {deleteVehicle Demo_Arrow;}; sleep 0.1;
if (!isNull _Demo_Sphere) then {deleteVehicle _Demo_Sphere;};
sleep 90;

{deleteVehicle _x; sleep 0.1} forEach (units _grp);
{deleteVehicle _x; sleep 0.1} forEach (units _stat_grp);
{deleteVehicle _x; sleep 0.1} forEach (units _vehgrp);
deleteGroup _grp;
deleteGroup _stat_grp;
deleteGroup _vehgrp;

if (!isNull _AAveh) then {deleteVehicle _AAveh; sleep 0.1;};

{if (typeof _x in INS_Op4_stat_weps) then {deleteVehicle _x; sleep 0.1}} forEach (NearestObjects [objective_pos_logic, [], 40]);
{if (typeof _x in objective_ruins) then {deleteVehicle _x; sleep 0.1}} forEach (NearestObjects [objective_pos_logic, [], 30]);

Delivery_Box hideObjectGlobal true;
deleteMarker "ObjectiveMkr";

if (true) exitWith {sleep 20; nul = [] execVM "Objectives\random_objectives.sqf";};