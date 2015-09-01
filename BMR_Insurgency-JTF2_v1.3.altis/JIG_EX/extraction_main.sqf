/*
 extraction_main.sqf v1.13 by Jigsor is WIP
 null = [] execVM "JIG_EX\extraction_main.sqf";
 runs in JIG_EX\extraction_init.sqf 
*/

if (!isServer) exitWith {};
[] spawn
{
	private ["_range","_poscreate","_speed","_SAdir","_spwnairdir","_randomAltitudes","_maxalt","_height","_type","_vehicle","_veh","_vel","_vehgrp","_VarName","_wp0","_wp1","_wp2","_evacComplete""_availableSeats","_ext_caller_group_count","_chopper_to_small","_vehgrp_units","_gunners_removed","_crewEvacHeliW1","_has_gunner_pos","_without_gunner_pos","_randomTypes","_maxtype","_switch_driver","_animateDoors"];

	evac_toggle = false;publicVariable "evac_toggle";
	sleep 0.3;
	_evacComplete = false;
	_chopper_to_small = false;
	_gunners_removed = false;
	//_crewEvacHeliW1 = [];
	_ext_caller_group_count = [];
	_ext_caller_group_count = grpNull;	
	_vehgrp = grpNull;
	EvacHeliW1 = ObjNull;	
	ex_group_ready = false;
	_has_gunner_pos = ["B_Heli_Transport_01_F","B_Heli_Transport_01_camo_F","kyo_MH47E_base"];
	_without_gunner_pos = ["I_Heli_Transport_02_F","CH49_Mohawk_FG","B_Heli_Light_01_F"];
	_helcat_types = ["AW159_Transport_Camo"];
	_chinook_types = ["kyo_MH47E_Ramp","kyo_MH47E_HC"];// ("kyo_MH47E_base" unsupported)
	
	"ext_caller_group" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};//Allows group members to update on the fly 
	"EvacHeliW1" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};	
	"ex_group_ready" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
	"JIG_EX_Caller" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};	
	sleep 5;
	
	while {!ex_group_ready} do {sleep 3;};
	waitUntil {sleep 0.9; count units ext_caller_group > 0};//wait until Evac group has units
	ex_group_ready = false;
	publicVariable "ex_group_ready";
	call Evac_Spawn_Loc;
	waitUntil {!isNull EvacSpawnPad};	
	["Evac Inbound", "JIG_EX_MPhint_fnc", nil, [], false, nil, nil, ext_caller_group] call BIS_fnc_mp;// Everything is now ready. Next code block creates chopper and performs Evac/Cleanup.
	sleep 1;

	if ((isNull EvacHeliW1) || (not(alive EvacHeliW1))) then
	{
		_poscreate = getMarkerPos "EvacSpawnMkr";
		_speed = 60;// starting speed
		_SAdir = getDir EvacSpawnPad;// Velocity Direction
		_spwnairdir = [getPosATL EvacSpawnPad, getPosATL EvacLZpad] call BIS_fnc_dirTo;// Spawn Direction
		_randomAltitudes = [35,45,55];// random altitudes
		_maxalt = (count _randomAltitudes)-1;// count random altitudes
		_height = _randomAltitudes select (round random _maxalt);// select random altitude
		if (JIG_EX_Random_Type) then
		{
			_randomTypes = JIG_EX_Chopper_Type;
			_maxtype = (count _randomTypes)-1;// count random types
			_type = _randomTypes select (round random _maxtype);// select random type
		}
		else
		{
			_type = JIG_EX_Chopper_Type select 0;// select default type
		};

		_vehicle = [getPosATL EvacSpawnPad, _SAdir, _type, JIG_EX_Side] call bis_fnc_spawnvehicle;
		sleep 0.1;
		_veh = _vehicle select 0;

		_vel = velocity _veh;
		_veh setpos [(_poscreate select 0) + (sin (_spwnairdir -180)), (_poscreate select 1) + (cos (_spwnairdir -180)), _height];		
		_veh setVelocity [(_vel select 0)+(sin _SAdir*_speed),(_vel select 1)+ (cos _SAdir*_speed),(_vel select 2)];

		_vehgrp = _vehicle select 2 ;// original group of vehicle
		_veh enableCopilot false;
		_veh addeventhandler ["killed","_this call remove_carcass_fncJE"];
		{_x addeventhandler ["killed", {"_this call remove_carcass_fncJE"}]} forEach (units _vehgrp);

		_veh allowdamage JIG_EX_damage;

		_VarName = "EvacHeliW1";
		_veh setVehicleVarName _VarName;
		_veh Call Compile Format ["%1=_This ; PublicVariable ""%1""",_VarName];

		// emptyPositions Returns the number of given positions in the vehicle. Positions can be "Commander", "Driver", "Gunner" or "Cargo"
		_availableSeats = EvacHeliW1 emptyPositions "Cargo";// debug console confirms this count

		if (!(alive _veh) or !(canMove _veh)) then {["We've lost Evac", "JIG_EX_MPhint_fnc", nil, [], false, nil, nil, ext_caller_group] call BIS_fnc_mp;};

		if (not (JIG_EX_gunners)) then
		{
			//if ((_type == "B_Heli_Transport_01_F") || (_type == "B_Heli_Transport_01_camo_F")) then
			if (_type in _has_gunner_pos) then
			{
				// remove gunners from GhostHawk. //player moveInTurret [vehicle,[0]];
				[EvacHeliW1 turretUnit [ 0 ]] join grpNull;// most all seem to use [ 0 ] as copilot
				deleteVehicle (EvacHeliW1 turretUnit [ 0 ]);
				[EvacHeliW1 turretUnit [ 1 ]] join grpNull;
				deleteVehicle (EvacHeliW1 turretUnit [ 1 ]);
				[EvacHeliW1 turretUnit [ 2 ]] join grpNull;
				deleteVehicle (EvacHeliW1 turretUnit [ 2 ]);

				if (_type in _chinook_types) then
				{	/*
					[_vehgrp] spawn {					
						private "_vehgrp";						
						_vehgrp = this select 0;
						for [{_j=0},{_j<count units _vehgrp},{_j=_j+1}] do {
							_dude = units _vehgrp select _j;
							_rolearray = assignedVehicleRole _dude;
							if ((_rolearray select 0) != "Driver") then {
								deleteVehicle _dude;
							};
							sleep 0.01;
						};
					};
					*/
					// remove gunners from Chinook types.
					[EvacHeliW1 turretUnit [ 3 ]] join grpNull;			
					deleteVehicle (EvacHeliW1 turretUnit [ 3 ]);
					[EvacHeliW1 turretUnit [ 4 ]] join grpNull;
					deleteVehicle (EvacHeliW1 turretUnit [ 4 ]);				
				};
				_gunners_removed = true;
			};
			if (_type in _helcat_types) then
			{
				[EvacHeliW1 turretUnit [ 0 ]] join grpNull;// most all seem to use [ 0 ] as copilot
				deleteVehicle (EvacHeliW1 turretUnit [ 0 ]);
			};
		};

		_animateDoors = [] spawn {[EvacHeliW1] call animate_doors_fnc;};

		// Set Evac helicopter waypoints and move to evacuation LZ.
		_wp0 = _vehgrp addWaypoint [getPosATL EvacLZpad, 1];
		_wp0 setWaypointType "LOAD";
		_wp0 setWaypointSpeed "NORMAL";
		_wp0 setWaypointBehaviour "CARELESS";
		_wp0 setWaypointCombatMode "BLUE";// Never fire
		_wp0 setWaypointStatements ["true","doStop EvacHeliW1; EvacHeliW1 land 'LAND'; hint 'This is RED DOG, stay clear of LZ, get aboard asap when we are down!';"];	

		EvacHeliW1 setdamage 0;
		EvacHeliW1 setfuel 1;
		sleep 0.1;

		if (({alive _x and !captive _x} count units ext_caller_group) > _availableSeats) then
		{
			_ext_caller_group_count = _ext_caller_group_count + [{count units ext_caller_group}];
			for "_i" from 1 to _availableSeats do
			{
				_ext_caller_group_count = _ext_caller_group_count - [_x];
			} forEach units _ext_caller_group_count;
			_chopper_to_small = true;
		};// needs testing with multiple players in full chopper

		if (not (isNull EvacHeliW1)) then
		{
			if (_chopper_to_small) then
			{
				waitUntil {sleep 1.2; {_x in EvacHeliW1} count units ext_caller_group == {alive _x and !captive _x} count units ext_caller_group || {_x in EvacHeliW1} count units ext_caller_group <= count (units _ext_caller_group_count) || (isNull EvacHeliW1) || ((count crew EvacHeliW1) < 1)};//working?
				//[_vehgrp] join (group JIG_EX_Caller);
			}
			else
			{
				waitUntil {sleep 0.9; {_x in EvacHeliW1} count units ext_caller_group == {alive _x and !captive _x} count units ext_caller_group || (isNull EvacHeliW1) || ((count crew EvacHeliW1) < 1)};//working				
			};
		};

		if ((isNull EvacHeliW1) || ((count crew EvacHeliW1) < 1)) then
		{
			if (alive _veh) exitWith {{ deleteVehicle _x; sleep 0.1} forEach (units _vehgrp); deleteVehicle _veh; _evacComplete = true; deleteMarker "tempDropMkr";};
		};

		deleteMarker "tempExtMarker";

		if (not (_evacComplete)) then
		{
			_vehgrp_units = (units _vehgrp);
			_vehgrp_leader = (leader _vehgrp);
			[_vehgrp_leader] join (group JIG_EX_Caller);		

			// Remove all previous waypoints.
			_wPArray = waypoints (group EvacHeliW1);		
			for "_i" from 0 to (count _wPArray -1) do {
				deleteWaypoint [(group EvacHeliW1), _i]
			};
			EvacHeliW1 setdamage 0;
			EvacHeliW1 setfuel 1;
			sleep 0.1;
			_animateDoors = [] spawn {[EvacHeliW1] call animate_doors_fnc;};
			sleep 2;

			// Set Evac helicopter waypoints and move to Drop Off LZ.
			(leader group EvacHeliW1) action ["engineOn", EvacHeliW1];// neccessary
			sleep 2;
			EvacHeliW1 doMove (position EvacLZpad);
			(leader group EvacHeliW1) doMove (getPosATL DropLZpad);
			sleep 2;
			_wp1 = (group EvacHeliW1) addWaypoint [(getPosATL DropLZpad), 1];		
			_wp1 setWaypointType "MOVE";
			_wp1 setWaypointSpeed "NORMAL";
			_wp1 setWaypointBehaviour "CARELESS";
			_wp1 setWaypointCombatMode "GREEN";// Hold fire - defend only.
			_wp1 setWaypointStatements ["true","doStop EvacHeliW1; EvacHeliW1 land 'LAND'; hint 'LZ In Sight'; [] spawn {call Drop_LZ_smoke_fnc;}; [] spawn {waitUntil {sleep 1; (getPosatl EvacHeliW1 select 2) < 4}; [EvacHeliW1] call animate_doors_fnc;}; EvacHeliW1 engineOn true;"];//use flare// EvacHeliW1 action ['useWeapon', EvacHeliW1, driver EvacHeliW1, 0];

			waitUntil {sleep 1; {_x in EvacHeliW1} count units ext_caller_group < 2};//wait until all players dissembark

			EvacHeliW1 setdamage 0;
			EvacHeliW1 setfuel 1;
			sleep 0.1;

			if (JIG_EX_gunners) then
			{
				{unassignVehicle (_x);(_x) action ["EJECT", vehicle _x]; sleep 0.5} foreach (units ext_caller_group);// Unassign leader/driver and all crew from player group.				
				{[_x] join (group EvacHeliW1); sleep 0.5;} forEach _vehgrp_units;// Ensures original AI crew joins their own group //_x join grpNull;
				[_vehgrp_leader] join (group EvacHeliW1);
				_vehgrp_leader assignAsDriver EvacHeliW1;
				[_vehgrp_leader] orderGetIn true;
			};
			if (!(JIG_EX_gunners)) then
			{
				_switch_driver = true;
				while {_switch_driver} do {
					if (_type in _without_gunner_pos) then
					{
						{unassignVehicle (_x);(_x) action ["EJECT", vehicle _x]; [_x] join (group EvacHeliW1); sleep 0.5} foreach (units ext_caller_group);
						//{unassignVehicle (_x);(_x) action ["EJECT", vehicle _x]; [_x] join grpNull; sleep 0.5; [_x] join (group EvacHeliW1); sleep 0.5} foreach (units ext_caller_group); 
						[_vehgrp_leader] join (group EvacHeliW1);					
						_vehgrp_leader assignAsCommander EvacHeliW1;		
						[_vehgrp_leader] orderGetIn true;
						{[_x] join (group EvacHeliW1); sleep 0.5;} forEach _vehgrp_units;// Ensures original AI crew joins their own group						
						_switch_driver = false;
					};
					if (_type in _helcat_types) then
					{
						_vehgrp_leader = driver EvacHeliW1;
						{
							unassignVehicle (_x);
							sleep 0.1;
							(_x) action ["EJECT", vehicle _x];
							sleep 0.1;
							[_x] join (group EvacHeliW1);
							sleep 6;
						} foreach (units ext_caller_group);
						[_vehgrp_leader] join grpNull;
						[_vehgrp_leader] join (group EvacHeliW1);
						_vehgrp_leader assignAsDriver EvacHeliW1;
						//[_vehgrp_leader] orderGetIn true;
						_vehgrp_leader moveInDriver EvacHeliW1;
						_switch_driver = false;
					};// working on hosted server
					if ((_type in _chinook_types) and (_type in _has_gunner_pos)) then
					{
						{unassignVehicle (_x);(_x) action ["EJECT", vehicle _x]; (_x) setPos [(getPosATL EvacHeliW1 select 0) - 8, (getPosATL EvacHeliW1 select 1) + 8, 0]; sleep 0.5} foreach (units ext_caller_group);// Unassign leader/driver and all crew from player group, reposition.
						{[_x] join (group EvacHeliW1); sleep 0.5;} forEach _vehgrp_units;// Ensures original AI crew joins their own group
						[_vehgrp_leader] join (group EvacHeliW1);
						_vehgrp_leader assignAsDriver EvacHeliW1;
						//[_vehgrp_leader] orderGetIn true;
						_vehgrp_leader moveInDriver EvacHeliW1;//less realistic than orderGetIn but more reliable					
						_switch_driver = false;
					};
					/*
					//if ((!isDedicated) and (_type in _has_gunner_pos)) then
					if (_type in _has_gunner_pos) then
					{
						[driver EvacHeliW1] join grpNull;
						{unassignVehicle (_x);(_x) action ["EJECT", vehicle _x]; [_x] join (group EvacHeliW1); sleep 0.5} foreach (units EvacHeliW1);
						{unassignVehicle (_x);(_x) action ["EJECT", vehicle _x]; [_x] join (group EvacHeliW1); sleep 0.5} foreach (units ext_caller_group);
						{[_x] join (group EvacHeliW1); sleep 0.5;} forEach _vehgrp_units;// Ensures original AI crew joins their own group
						[_vehgrp_leader] join (group EvacHeliW1);
						_vehgrp_leader assignAsDriver EvacHeliW1;
						[_vehgrp_leader] orderGetIn true;
						_switch_driver = false;
					};
					*/
					//if ((isDedicated) and (_type in _has_gunner_pos)) then
					if (_type in _has_gunner_pos) then
					{
						{unassignVehicle (_x); (_x) action ["getOut", vehicle _x]; [_x] join (group EvacHeliW1); sleep 0.5} foreach (units ext_caller_group);						
						{[_x] join (group EvacHeliW1); sleep 0.5;} forEach _vehgrp_units;// Ensures original AI crew joins their own group
						if (not (isNull _vehgrp_leader)) then
						{
							[_vehgrp_leader] join (group EvacHeliW1);
							_vehgrp_leader assignAsDriver EvacHeliW1;
							_vehgrp_leader moveInDriver EvacHeliW1;
							//[_vehgrp_leader] orderGetIn true;
						};
						_switch_driver = false;
						/*
						//[driver EvacHeliW1] join grpNull;
						{unassignVehicle (_x);(_x) action ["EJECT", vehicle _x]; sleep 0.5} foreach (units ext_caller_group);
						{[_x] join (group EvacHeliW1); sleep 0.5;} forEach _vehgrp_units;// Ensures original AI crew joins their own group
						//[_vehgrp_leader] join (group EvacHeliW1);
						//_vehgrp_leader assignAsDriver EvacHeliW1;
						//[_vehgrp_leader] orderGetIn true;
						*/
					};
				};
			};

			deleteMarker "tempDropMkr";
			sleep 2;

			// Move Evac helicopter back towards original pick up location and delete itself.
			waitUntil {!isNull driver EvacHeliW1 || isNull EvacHeliW1};

			if (isNull EvacHeliW1) exitWith {{ deleteVehicle _x; sleep 0.1} forEach (units _vehgrp); deleteVehicle _veh; sleep 0.1; deleteVehicle EvacSpawnPad; sleep 0.1; deleteVehicle EvacLZpad; sleep 0.1; deleteMarker "tempDropMkr"; sleep 0.1; deleteMarker "tempExtMarker"; sleep 0.1; _evacComplete = true; evac_toggle = true; publicVariable "evac_toggle";};

			{EvacHeliW1 lock 2} forEach playableunits;
			if (not (JIG_EX_damage)) then {_veh allowdamage true;};//allow damage after drop off needed to complete script in some cases.
			
			// I cannot get the pilot to fly off after drop off on dedi. Its Probably due to group name shared as vehicle name. However, script continues as normal. 
			group _veh setGroupOwner 1;
			_vehgrp_leader action ["engineOn", EvacHeliW1];
			(leader group EvacHeliW1) action ["engineOn", EvacHeliW1];// working without this
			driver EvacHeliW1 action ["engineOn", EvacHeliW1];
			//EvacHeliW1 engineon true;
			sleep 0.1;
			_animateDoors = [] spawn {[EvacHeliW1] call animate_doors_fnc;};
			sleep 2;
			EvacHeliW1 doMove (position EvacLZpad);
			(leader group EvacHeliW1) doMove (position EvacLZpad);
			sleep 2;

			//_wp2 = (group EvacHeliW1) addWaypoint [(getPos EvacHeliW1), 0];//works on local server
			_wp2 = (group _vehgrp_leader) addWaypoint [(getPos EvacHeliW1), 0];//testing on DS
			_wp2 setWaypointType "MOVE";
			_wp2 setWaypointPosition [(position EvacLZpad), 1];
			(group EvacHeliW1) setCurrentWaypoint _wp2;

			if (alive _veh) then
			{
				sleep JIG_EX_Despawn_Time;
				{deleteVehicle _x; sleep 0.1} forEach (units _vehgrp);
				{deleteVehicle _x; sleep 0.1} forEach (units EvacHeliW1);
				deleteVehicle _veh;
				_evacComplete = true;
			};
		};

		// Cleanup residual markers/objects if any and flip Evac toggle switch.
		if (!isNil "tempDropMkr") then {deleteMarker "tempDropMkr";};
		_veh removeEventHandler ["Engine", 0];

		if (_evacComplete) exitWith {deleteVehicle EvacSpawnPad; sleep 0.2; deleteVehicle EvacLZpad; evac_toggle = true; publicVariable "evac_toggle";};//working

		waitUntil {sleep 1; (!alive _veh) || ((count crew _veh) < 1) || (!canmove _veh)};
		if (((count crew _veh) < 1) && (alive _veh)) then {_veh setDamage 1};
		{
			if (alive _x) then {_x setDamage 1; sleep 0.1}
		} forEach (crew _veh);// original crew
		if (!alive _veh) then
		{
			{
				if (alive _x) then {_x setDamage 1; sleep 0.1}
			} forEach (units EvacHeliW1);
		}
		else
		{
			_veh setDamage 1;
			{
				if (alive _x) then {_x setDamage 1; sleep 0.1}
			} forEach (units EvacHeliW1);
		};

		if (!isNil "EvacSpawnMkr") then {deleteMarker "EvacSpawnMkr";};	sleep 0.1;
		if (not (isNull EvacSpawnPad)) then {deleteVehicle EvacSpawnPad;}; sleep 0.1;
		if (not (isNull EvacLZpad)) then {deleteVehicle EvacLZpad;}; sleep 0.1;
		evac_toggle = true;
		publicVariable "evac_toggle";
		sleep 1.2;
		["Evac on Standby", "JIG_EX_MPhint_fnc", nil, [], false, nil, nil, ext_caller_group] call BIS_fnc_mp;
	};
	if (true) exitwith {};
};