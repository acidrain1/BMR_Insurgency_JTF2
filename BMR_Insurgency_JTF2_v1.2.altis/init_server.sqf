//init_server.sqf by Jigsor

// Server Functions //
call compile preprocessFileLineNumbers "INSfncs\server_fncs.sqf";

// Weather //
if ((JIPweather isEqualTo 0) || {(JIPweather >3)}) then {
	[] spawn {
		waitUntil {time > 1};
		skiptime (((BTC_p_time - (daytime) +24) % 24) -24);
		86400 setOvercast (JIPweather/100);
		UIsleep 1;
		0 setFog 0;
		skipTime 24;
		sleep 1;
		simulWeatherSync;
	};
}else{
	if (JIPweather isEqualTo 2) then {
		[] execVM "scripts\real_weather.sqf"; skiptime ((BTC_p_time - (daytime) +24) % 24);
	}else{
		if (JIPweather !=1) then {
			[] execVM "scripts\randomWeather2.sqf"; skipTime (BTC_p_time -0.84);
		};
	};
};

// Custom EventHandlers //
if (isNil "ghst_Build_objs") then {ghst_Build_objs = [];};
if (isNil "intel_Build_objs") then {intel_Build_objs = [];};
if (isNil "activated_cache_pos") then {activated_cache_pos = [];};
if (isNil "paddscore") then {paddscore = 0;};

"BTC_to_server" addPublicVariableEventHandler BTC_m_fnc_only_server;
"ghst_Build_objs" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"activated_cache_pos" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"paddscore" addPublicVariableEventHandler {_data = _this select 1; (_data select 0) addScore (_data select 1);};
"PVEH_netSay3D" addPublicVariableEventHandler {private "_array"; _array = _this select 1; (_array select 0) say3D (_array select 1);};
"side_mission_mkrs" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};
"objective_list" addPublicVariableEventHandler {call compile format ["%1",_this select 1]};

// Editor object settings //
if (!isNil "MHQ_3") then {
	[MHQ_3] call paint_heli_fnc;
	if (INS_p_rev isEqualTo 0 or
	{INS_p_rev isEqualTo 2 or
	{INS_p_rev isEqualTo 4 or
	{INS_p_rev isEqualTo 5}}}) then
	{
		_nul = [MHQ_3, 60, 1, {[_this] call paint_heli_fnc;}] execVM "vehrespawn.sqf";
	};
};
{
	_x setVariable ["BTC_cannot_lift",1,true];
	_x setVariable ["BTC_cannot_drag",1,true];
	_x setVariable ["BTC_cannot_load",1,true];
	_x setvariable ["BTC_cannot_place",1,true];
} forEach INS_log_blacklist; // Set objects not liftable, not draggable, not loadable and not placeable with BTC Logistics
INS_flag setFlagTexture "images\bmrflag.paa";// your squad flag here or comment out for default Blufor flag
Delivery_Box hideObjectGlobal true;
[] spawn opfor_NVG;

// Param enabled scripts/settings //
if (Fatigue_ability < 1) then {{_x enableFatigue false;} forEach playableUnits;};
if (EnableEnemyAir > 0) then {0 = [] execVM "scripts\AirPatrolEast.sqf";};
if (DebugEnabled isEqualTo 1) then
{
	if (SuicideBombers isEqualTo 1) then {[] spawn {sleep 30; nul = [] execVM "scripts\INS_SuicideBomber.sqf";};};
}else{
	if (SuicideBombers isEqualTo 1) then {[] spawn {sleep 600; nul = [] execVM "scripts\INS_SuicideBomber.sqf";};};
};

// Clean up Maintenance //
[
	60,		// seconds to delete dead bodies (0 = don't delete)
	5*60,	// seconds to delete dead vehicles (0 = don't delete)
	2*60,	// seconds to delete dropped weapons (0 = don't delete)
	10*60,	// seconds to deleted planted explosives (0 = don't delete)
	0		// seconds to delete dropped smokes/chemlights (0 = don't delete)
] execVM 'scripts\repetitive_cleanup.sqf';

execVM "scripts\remove_boobyTraps.sqf";

// Friendly Fixed Wing Assets //
if (Airfield_opt) then
{
	if ((INS_op_faction isEqualTo 9) && (isClass(configFile >> "cfgPatches" >> "SUD_A10"))) then
	{
		_dirfw1 = getDir INS_fw_1;
		_fw1 = createVehicle ["SUD_A10", getPos INS_fw_1, [], 0, "NONE"];
		_fw1 setDir _dirfw1;[_fw1] call anti_collision;
		_nul = [_fw1, 2, 1, {[_this] call anti_collision}] execVM "vehrespawn.sqf";
	}else{
		if ((INS_op_faction isEqualTo 10) && (isClass(configFile >> "CfgVehicles" >> "RHS_A10"))) then
		{
			_dirfw1 = getDir INS_fw_1;
			_fw1 = createVehicle ["RHS_A10", getPos INS_fw_1, [], 0, "NONE"];
			_fw1 setDir _dirfw1;[_fw1] call anti_collision;
			_nul = [_fw1, 2, 1, {[_this] call anti_collision}] execVM "vehrespawn.sqf";
		}else{
			_dirfw1 = getDir INS_fw_1;
			_fw1 = createVehicle ["B_Plane_CAS_01_F", getPos INS_fw_1, [], 0, "NONE"];
			_fw1 setDir _dirfw1;[_fw1] call anti_collision;
			_nul = [_fw1, 2, 1, {[_this] call anti_collision}] execVM "vehrespawn.sqf";
		};
	};
};

// Tasks //
waitUntil {! isNil "SHK_Taskmaster_Tasks"};
if (DebugEnabled isEqualTo 1) then {
	[] spawn {
		sleep 2;
		tasks_handler = [] execVM "Objectives\random_objectives.sqf";
		waitUntil { scriptDone tasks_handler };
		if (EnemyAmmoCache isEqualTo 1) then {sleep 2; execVM "scripts\ghst_PutinBuild.sqf";};
		sleep 30;
		nul = [] execVM "Objectives\tasks_complete.sqf";
	};
}else{
	[] spawn {
		sleep 45;
		tasks_handler = [] execVM "Objectives\random_objectives.sqf";
		waitUntil { scriptDone tasks_handler };
		if (EnemyAmmoCache isEqualTo 1) then {sleep 2; execVM "scripts\ghst_PutinBuild.sqf";};
		sleep 75;
		nul = [] execVM "Objectives\tasks_complete.sqf";
	};
};

//BMR_server_initialized = true;publicVariable "BMR_server_initialized";