INS_intro = {
	// Bluefor Intro by Jigsor
	disableSerialization;
	showCinemaBorder false;
	//cameraEffectEnableHUD false;
	enableRadio false;
	setViewDistance 1100;
	if (daytime > 18.00 || daytime < 5.75) then {camUseNVG true};
	_text = [  [format["%1", name player],"color='#F73105'"], ["", "<br/>"], ["Welcome to", "color='#F73105'"], ["", "<br/>"],  [format["BMR Insurgency %1", toUpper (worldName)], "color='#0059B0' font='PuristaBold'"] ];
	_randomtrack = (floor(random 4));
	switch (_randomtrack) do
	{
		case 0 : {0 = [] spawn { playMusic ["LeadTrack05_F", 1]; sleep 33; playMusic ""; };};
		case 1 : {0 = [] spawn { playMusic ["AmbientTrack01a_F", 32]; sleep 33; playMusic ""; };};
		case 2 : {0 = [] spawn { playMusic ["LeadTrack01_F_Bootcamp", 59]; sleep 35; playMusic ""; };};
	};
	_cam = "camera" camCreate [(position camstart select 0) - 5, (position camstart select 1) + 5, (position camstart select 2) + 80];
	_cam camPreload 5;
	_cam camSetTarget player;
	waitUntil {preloadCamera [(position camstart select 0) - 5, (position camstart select 1) + 5, (position camstart select 2) + 80];};
	_cam cameraEffect ["internal", "BACK"];
	["BIS_ScreenSetup",true] call BIS_fnc_blackIn;
	_camPos = [(getPosatl INS_flag select 0) - 1, (getPosatl INS_flag select 1) + 1, (getTerrainHeightASL (position INS_flag)) + 20];
	_cam camSetPos [(_camPos select 0) - 120, (_camPos select 1) + 100, _camPos select 2];
	_cam camCommit 25;
	sleep 10;
	titleRsc ["bmr_intro", "PLAIN"];
	[_text, safezoneX - 0.01, safeZoneY + (1 - 0.125) * safeZoneH, true, "<t align='right' size='1.0' font='PuristaLight'>%1</t>"] spawn BIS_fnc_typeText2;
	sleep 7;
	waitUntil {camcommitted _cam};
	[] spawn {[jig_anode,2] call fnc_lightningStrike;};
	_cam camSetPos [position player select 0, position player select 1, 2.2];
	_cam camCommit 3;
	playSound "introfx";
	player sideChat "Press U key for Graphic Settings, Digital Heading and HUD";
	player sideChat "Initialization Complete";
	waitUntil {camcommitted _cam};
	player cameraEffect ["terminate","back"];
	setViewDistance -1;
	camDestroy _cam;
	enableRadio true;
	if (INS_environment < 1) then {enableEnvironment false;};
	//cameraEffectEnableHUD true;
};
INS_intro_op4 = {
	// Opfor Intro by Jigsor
	disableSerialization;
	showCinemaBorder false;
	enableRadio false;
	//cameraEffectEnableHUD false;
	setViewDistance 1800;
	if (daytime > 18.00 || daytime < 5.75) then {camUseNVG true};
	titleRsc ["bmr_intro", "PLAIN"];
	_text = [  [format["%1", name player],"color='#F73105'"], ["", "<br/>"], ["Welcome to", "color='#F73105'"], ["", "<br/>"],  [format["BMR Insurgency %1", toUpper (worldName)], "color='#0059B0' font='PuristaBold'"] ];
	
	_randomtrack = (floor(random 4));
	switch (_randomtrack) do
	{
		case 0 : {0 = [] spawn { playMusic ["LeadTrack05_F", 1]; sleep 33; playMusic ""; };};
		case 1 : {0 = [] spawn { playMusic ["AmbientTrack01a_F", 32]; sleep 33; playMusic ""; };};
		case 2 : {0 = [] spawn { playMusic ["LeadTrack01_F_Bootcamp", 36]; sleep 32.9; playMusic ""; };};
		case 3 : {0 = [] spawn { playMusic ["Track06_CarnHeli", 1]; sleep 33; playMusic ""; };};
	};
	_centPos = getPosATL center;
	_offsetPos = [_centPos select 0, _centPos select 1, (_centPos select 2) + 300];	
	_cam = "camera" camCreate [(position center select 0) + 240, (position center select 1) + 100, 450];
	_cam camPreload 5;
	_cam camSetTarget _offsetPos;
	waitUntil {preloadCamera [(position center select 0) + 240, (position center select 1) + 100, 450];};
	_cam cameraEffect ["internal", "BACK"];
	["BIS_ScreenSetup",true] call BIS_fnc_blackIn;	
	_cam camSetPos [(position center select 0) - 240, (position center select 1) + 100, 450];
	_cam camCommit 15;
	sleep 5;	
	[_text, safezoneX - 0.01, safeZoneY + (1 - 0.125) * safeZoneH, true, "<t align='right' size='1.0' font='PuristaLight'>%1</t>"] spawn BIS_fnc_typeText2;
	UIsleep 2;
	waitUntil {camcommitted _cam};
	player cameraEffect ["terminate","back"];
	UIsleep 0.5;
	player sideChat "Initialization Complete";	
	player sideChat "Press U key for Graphic Settings, Digital Heading and HUD";	
	setViewDistance -1;
	camDestroy _cam;
	enableRadio true;
	if (INS_environment < 1) then {enableEnvironment false;};
	//cameraEffectEnableHUD true;
};
fnc_lightningStrike = {
	// lightning strike on intro
	private ["_delay","_bolt","_light","_class","_lightning"];
    _target = _this select 0;
    _delay = _this select 1;

    sleep _delay;
    _pos = getPos _target;
    _bolt = createvehicle ["LightningBolt",_pos,[],0,"can collide"];
    _bolt setposatl _pos;
    _bolt setdamage 1;

    _light = "#lightpoint" createvehiclelocal _pos;
    _light setposatl [_pos select 0,_pos select 1,(_pos select 2) + 10];
    _light setLightDayLight true;
    _light setLightBrightness 300;
    _light setLightAmbient [0.05, 0.05, 0.1];
    _light setlightcolor [1, 1, 2];

    sleep 0.1;
    _light setLightBrightness 0;
    sleep (random 0.1);

    _class = ["lightning1_F","lightning2_F"] call BIS_fnc_selectRandom;
    _lightning = _class createvehiclelocal [100,100,100];
    _lightning setdir (random 360);
    _lightning setpos _pos;

    for "_i" from 0 to 1 do {
        _light setLightBrightness (100 + random 100);
    };

    deletevehicle _lightning;
    deletevehicle _light;
    //_target setDamage 1;
};
JIG_placeSandbag_fnc = {
	// Player action place sandbag barrier. by Jigsor
	private ["_player","_dist","_zfactor","_zvector"];
	
	_player = _this select 1;
	if(vehicle _player != player) exitWith {hint "You must be on foot to place sandbag."};
	
	_dist = 2;
	_zfactor = 1;
	_zvector = ((_player weaponDirection (primaryWeapon _player)) select 2) * 3;
	
	if (not (isNull MedicSandBag)) then {deletevehicle MedicSandBag;};
    MedicSandBag = createVehicle ["Land_BagFence_Round_F",[(getposATL _player select 0) + (sin(getdir _player) * _dist), (getposATL _player select 1) + (cos(getdir _player) * _dist)], [], 0, "CAN_COLLIDE"];
	
	MedicSandBag setposATL [(getposATL _player select 0) + (sin(getdir _player) * _dist), (getposATL _player select 1) + (cos(getdir _player) * _dist), (getposATL _player select 2) + _zvector + _zfactor];
    MedicSandBag setDir getDir (_this select 1) - 180;
	if ((getPosATL MedicSandBag select 2) > (getPosATL _player select 2)) then {MedicSandBag setPos [(getPosATL MedicSandBag select 0), (getPosATL MedicSandBag select 1), (getPosATL _player select 2)];};
	
    (_this select 1) removeAction (_this select 2);
    _id = MedicSandBag addAction ["Remove Sandbag", {call JIG_removeSandbag_fnc}];
};
JIG_removeSandbag_fnc = {
	// Player action remove sandbag barrier. by Jigsor
	deleteVehicle (_this select 0);
	_id = (_this select 1) addAction ["Place Sandbag", {call JIG_placeSandbag_fnc}, 0, -9, false];
};
JIG_UGVdrop_fnc = {
	// Player action UGV para drop. by Jigsor
	private ["_player"];
	_player = _this select 1;
	/*// Require UAV backpack
	if (!(backpack _player isKindof "B_UAV_01_backpack_F")) exitWith {hint "You cannot call UGV without UAV backpack"; (_this select 1) removeAction (_this select 2); _id = player addAction ["UGV Air Drop", {call JIG_UGVdrop_fnc}, 0, -9, false];};
	if (backpack _player isKindof "B_UAV_01_backpack_F") then {hint ""; _player removeWeapon "B_UAVTerminal"; _player addWeapon "B_UAVTerminal";};
	*/
	_player removeWeapon "B_UAVTerminal"; _player addWeapon "B_UAVTerminal";
	ghst_ugvsupport = [(getmarkerpos "ugv_spawn"),"B_UGV_01_rcws_F",3,30] execvm "scripts\ghst_ugvsupport.sqf";
};
X_fnc_returnVehicleTurrets = {
	/*
		File: fn_returnVehicleTurrets.sqf
		Author: Joris-Jan van 't Land
		Description:
		Function return the path to all turrets and sub-turrets in a vehicle.
		Parameter(s):
		_this select 0: vehicle config entry (Config)
		Returns:
		Array of Scalars and Arrays - path to all turrets
	*/
	if ((count _this) < 1) exitWith {[]};
	private ["_entry"];
	_entry = _this select 0;
	if ((typeName _entry) != (typeName configFile)) exitWith {[]};
	private ["_turrets", "_turretIndex"];
	_turrets = [];
	_turretIndex = 0;
	for "_i" from 0 to ((count _entry) - 1) do {
		private ["_subEntry"];
		_subEntry = _entry select _i;
		if (isClass _subEntry) then {
			private ["_hasGunner"];
			_hasGunner = [_subEntry, "hasGunner"] call X_fnc_returnConfigEntry;
			if (!(isNil "_hasGunner")) then {
				if (_hasGunner == 1) then {
					_turrets set [count _turrets, _turretIndex];
					if (isClass (_subEntry >> "Turrets")) then {
						_turrets set [count _turrets, [_subEntry >> "Turrets"] call X_fnc_returnVehicleTurrets];
					} else {
						_turrets set [count _turrets, []];
					};
				};
			};
			_turretIndex = _turretIndex + 1;
		};
	};
	_turrets
};
INS_maintenance_veh = {
	// code by Xeno
	private ["_config","_count","_i","_magazines","_object","_type","_type_name"];

	_object = (nearestObjects [position player, ["LandVehicle","Air"], 10]) select 0;
	if (!Alive _object) exitWith {hint "The vehicle has been destroyed";};
	_type = typeof _object;
	hint format ["%1 under maintenance",typeof _object];
	_reload_time = 2;

	_object action ["engineOff", _object];
	if (!alive _object) exitWith {};
	_object setFuel 0;
	_object setVehicleAmmo 1;

	_magazines = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

	if (count _magazines > 0) then {
		_removed = [];
		{
			if (!(_x in _removed)) then {
				_object removeMagazines _x;
				_removed set [count _removed, _x];
			};
		} forEach _magazines;
		{
			sleep _reload_time;
			if (!alive _object) exitWith {};
			_object addMagazine _x;
		} forEach _magazines;
	};

	_turrets = [configFile >> "CfgVehicles" >> _type >> "Turrets"] call X_fnc_returnVehicleTurrets;

	_reloadTurrets = {
		private ["_turrets", "_path"];
		_turrets = _this select 0;
		_path = _this select 1;

		private ["_i"];
		_i = 0;
		while {_i < (count _turrets)} do {
			private ["_turretIndex", "_thisTurret"];
			_turretIndex = _turrets select _i;
			_thisTurret = _path + [_turretIndex];
			
			_magazines = _object magazinesTurret _thisTurret;
			if (!alive _object) exitWith {};
			_removed = [];
			{
				if (!(_x in _removed)) then {
					_object removeMagazinesTurret [_x, _thisTurret];
					_removed set [count _removed, _x];
				};
			} forEach _magazines;
			if (!alive _object) exitWith {};
			{
				sleep _reload_time;
				if (!alive _object) exitWith {};
				_object addMagazineTurret [_x, _thisTurret];
				sleep _reload_time;
				if (!alive _object) exitWith {};
			} forEach _magazines;
			
			if (!alive _object) exitWith {};
			
			[_turrets select (_i + 1), _thisTurret] call _reloadTurrets;
			_i = _i + 2;
			if (!alive _object) exitWith {};
		};
	};

	if (count _turrets > 0) then {
		[_turrets, []] call _reloadTurrets;
	};

	if (!alive _object) exitWith {};

	_object setVehicleAmmo 1;

	sleep _reload_time;
	if (!alive _object) exitWith {};
	_object setDamage 0;
	sleep _reload_time;
	if (!alive _object) exitWith {};
	while {fuel _object < 0.99} do {
		_object setFuel 1;
		sleep 0.01;
	};
	sleep _reload_time;
	if (!alive _object) exitWith {};

	reload _object;
	hint "Maintenance complete";
};
BTC_repair_wreck = {
	_object = (nearestObjects [position player, ["LandVehicle","Air"], 10]) select 0;
	if (damage _object != 1) exitWith {hint "Use the maintenance action!"};
	BTC_to_server = [0,_object];publicVariableServer "BTC_to_server";
};
JIG_load_VA_profile = {
	if (!isNil {profilenamespace getvariable "bis_fnc_saveInventory_data"}) then {
		private ["_name_index","_VA_Loadouts_Count"];
		_VA_Loadouts_Count = count (profilenamespace getvariable "bis_fnc_saveInventory_data");	
		_name_index = 0;
		for "_i" from 0 to (_VA_Loadouts_Count/2) -1 do	{
			[_i,_name_index] spawn {
				private ["_name_index","_loadout_name"];
				_name_index = _this select 1;
				_loadout_name = profilenamespace getvariable "bis_fnc_saveInventory_data" select _name_index;
				_id = INS_Wep_box addAction	[("<t color=""#00ffe9"">") + ("Load " + format ["%1",_loadout_name]) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[player,[profilenamespace, format ["%1", _loadout_name]]],BIS_fnc_loadInventory],8,true,true,"","true"];
				sleep 15;
				INS_Wep_box removeAction _id;
			};
			_name_index = _name_index + 2;
		};
	};
};
JIG_p_actions_resp = {
	// Add player actions. by Jigsor
	waitUntil {sleep 1; Alive player};
	private "_playertype";
	_playertype = typeOf (vehicle player);
	// Engineer
	if (_playertype in INS_W_PlayerEng) then {player addAction [("<t color=""#12F905"">") + ("Construct FARP") + "</t>","scripts\repair_special.sqf",0,1, false, true,"test2"];};
	// JTAC
	if (_playertype in INS_W_PlayerJTAC) then {null = [player, 500, true, 3] execVM "JWC_CASFS\addAction.sqf";};
	// Medic
	if (_playertype in INS_W_PlayerMedic) then	{MedicSandBag = ObjNull; _id = player addAction ["Place Sandbag", {call JIG_placeSandbag_fnc}, 0, -9, false];};
	// UAV Operator
	if (_playertype in INS_W_PlayerUAVop) then
	{
		myhuntiraction = player addAction ["use HuntIR", "scripts\myhuntir.sqf", [], 1, false, true, "", "true"]; lck_markercnt=0;
		_id = player addAction ["UGV Air Drop", {call JIG_UGVdrop_fnc}, 0, -9, false];
	};
	// Sniper/Marksman/Spotter
	if (_playertype in INS_W_PlayerSniper) then
	{
		player RemoveAllEventHandlers "Fired";
		_id = player addAction ["Bullet Camera On", {call INS_bullet_cam}, 0, -9, false];
	};
	// All players mission settings
	if (Fatigue_ability < 1) then {player enableFatigue false;};
	true
};
PVPscene_POV = {
	// Limit 3rd person view to vehicles only
	[(_this select 0)] spawn {		
		while {alive (_this select 0)} do {
			if (cameraView == "External") then 
			{
				if (player isEqualTo vehicle player) then {player switchCamera "Internal";};
			};
			sleep 0.1;
		};
	};
};	
JIG_transfer_fnc = {
	// teleport by Jigsor	
	_dest = (_this select 3) select 0;
	_dir = random 359;	

	switch (typeName _dest) do {		  
		case "ARRAY": {player setPos [(position _dest select 0)-10*sin(_dir),(position _dest select 1)-10*cos(_dir)]};
		case "OBJECT": {player setPos [(getPosATL _dest select 0)-10*sin(_dir),(getPosATL _dest select 1)-10*cos(_dir)]};
		case "STRING": {player setPos [(getMarkerPos _dest select 0)-10*sin(_dir),(getMarkerPos _dest select 1)-10*cos(_dir)]};
	};
};
//killedInfo_fnc = {	
//	// Generates killed by whom, weapon used and distance from killer message. by Jigsor	
//	_poorSoul = _this select 0;
//	_killer = _this select 1;
//
//	[_poorSoul,_killer] spawn {
//		_poorSoul = _this select 0;
//		_killer = _this select 1;
//		if (!isNull _killer) then {
//			_killerName = name _killer;
//			_killerWeapon = currentWeapon _killer;
//			_killerWeaponName = getText (configFile >> "CfgWeapons" >> _killerWeapon >> "displayName");
//			_distance = _poorSoul distance _killer;
//			sleep 7;
//			_text = format ["Killed by %1, from %2 meters, with %3",_killerName, str(_distance), str(_killerWeaponName)];
//			copyToClipboard str(_text);
//			cutText [_text,"PLAIN"];			
//		};
//	};	
//};
JIG_intel_found = {
	// Remove intel addaction, grab intel animation, delete intel object, creates intel maker, update JIP intel marker state, global sidechat player name found intel, add 2 points to caller. by Jigsor	
	_host = _this select 0;
	_caller = _this select 1;
	_id = _this select 2;
	_pos_info = _this select 3;
	_callerName = name _caller;
	_text = format ["%1, found intel",_callerName];

	_host removeaction _id;

	_caller playaction "putdown";
	for "_i" from 0 to 1 do {
		_state = animationstate _caller;
		waituntil {_state != animationstate _caller};
	};

	deletevehicle _host;
	sleep 0.1;
	[[_text],"JIG_MPsideChatWest_fnc"] call BIS_fnc_mp;	

	_distance = [10,400] call BIS_fnc_randomInt; // Minimum intel marker range 10m. Maximum intel marker range 400m.
	_direction = [0,359] call BIS_fnc_randomInt; // Random direction between 0 and 359 degrees.
	_randomPos = [_pos_info, _distance, _direction] call BIS_fnc_relPos; // The position at the random distance and random direction from current_cache_pos.  

	_rnum = str(round (random 999));
	_dis_str = str(_distance);
	_VarName = ("intel_mkr" + _rnum);
	_mkr_txt = (_dis_str + " meters");
	_pScore = 2;

	_intel_mkr = createMarker [_VarName, _randomPos];
	_intel_mkr setMarkerShape "ELLIPSE";
	_intel_mkr setMarkerSize [1, 1];
	_intel_mkr setMarkerShape "ICON";
	_intel_mkr setMarkerType "hd_unknown";
	_intel_mkr setMarkerText _mkr_txt;
	sleep 0.1;

	all_intel_mkrs pushBack _intel_mkr;
	[all_intel_mkrs] call JIPmkr_updateServer_fnc;
	publicVariable "all_intel_mkrs";
	sleep 0.1;

	_caller addrating 200;
	_caller addScore _pScore;
	paddscore = [_caller, _pscore];
	publicVariableServer "paddscore";
	[West,"HQ"] sideChat "+2 points";
	true
};
Op4_spawn_pos = {
	// Initial Op4 spawn position by Jigsor
	private ["_op4_player","_posnotfound","_random_w_player","_basePos","_missionPlayers","_movelogic","_blufor_speed","_playerPos","_cooX","_cooY","_wheX","_wheY","_Op4RandomPos","_counter","_spawnPos","_centerPos","_dis"];

	disableSerialization;
	_op4_player = _this select 0;
	_posnotfound = false;
	_random_w_player = nil;
	_basePos = getMarkerPos "Respawn_West";
	_missionPlayers = playableUnits;
	if (INS_p_rev > 4) then {_movelogic = false;}else{_movelogic = true;};

	titleCut["", "BLACK out",2];

	_missionPlayers = _missionPlayers - [_op4_player];// exclude player calling the script
	if (count _missionPlayers > 0) then
	{
		{
			_blufor_speed = speed _x;
			_pos = (getPos _x);
			if ((_blufor_speed > 8) || (_pos select 2 > 4) || {(side _x == east)}) then {_missionPlayers = _missionPlayers - [_x];};
		} foreach _missionPlayers;// exclude east players, players in moving vehicles, above ground players such as players in aircraft or in high structures
	}else{
		_posnotfound = true;
	};

	if (count _missionPlayers > 0) then
	{
		_random_w_player = _missionPlayers select (floor (random (count _missionPlayers)));
		_missionPlayers = _missionPlayers - ["_random_w_player"];
		while {!isNil "_random_w_player" && {_random_w_player distance _basePos < 500}} do {
			_random_w_player = _missionPlayers select (floor (random (count _missionPlayers)));
			_missionPlayers = _missionPlayers - ["_random_w_player"];
		};
	};// exclude players to close to blufor base

	if (!isNil "_random_w_player") then
	{
		// Move Op4 Base within 250 to 500 meters of blufor player
		_playerPos = getPos _random_w_player;
		_cooX = _playerPos select 0;
		_cooY = _playerPos select 1;
		_wheX = [250,500] call BIS_fnc_randomInt;
		_wheY = [250,500] call BIS_fnc_randomInt;
		_Op4RandomPos = [_cooX+_wheX,_cooY+_wheY,0];
		_counter = 0;
		_spawnPos = _Op4RandomPos isFlatEmpty [8,384,0.5,2,0,false,ObjNull];

		while {(count _spawnPos) < 1} do {
			_spawnPos = _Op4RandomPos isFlatEmpty [5,384,0.9,2,0,false,ObjNull];
			_counter = _counter + 1;
			if (_counter > 5) exitWith {_posnotfound = true;};
			sleep 0.2;
		};
		if (count _spawnPos > 0) exitWith {
			if (_movelogic) then {BTC_r_base_spawn setPos _spawnPos;};
			"Respawn_East" setMarkerPos _spawnPos;
			_op4_player setPos _spawnPos;
			titleCut["", "BLACK in",1];
		};
	}else{
		_posnotfound = true;
	};

	if (_posnotfound) then
	{
		// Move Op4 Base to center
		_centerPos = getPosATL center;
		_cooX = _centerPos select 0;
		_cooY = _centerPos select 1;
		_dis = 400;
		_wheX = random (_dis*2)-_dis;
		_wheY = random (_dis*2)-_dis;
		_Op4RandomPos = [_cooX+_wheX,_cooY+_wheY,0];
		_spawnPos = _Op4RandomPos isFlatEmpty [10,384,0.5,2,0,false,ObjNull];

		while {(count _spawnPos) < 1} do {
			_spawnPos = _Op4RandomPos isFlatEmpty [5,384,0.9,2,0,false,ObjNull];
			sleep 0.2;
		};
		if (_movelogic) then {BTC_r_base_spawn setPos _spawnPos;};
		"Respawn_East" setMarkerPos _spawnPos;
		_op4_player setPos _spawnPos;
		titleCut["", "BLACK in",1];
	};
	true
};
INS_bullet_cam = {
	// add bullet cam
	//http://killzonekid.com/arma-scripting-tutorials-a-simple-bullet-cam/
	player addEventHandler ["Fired", {
		_null = _this spawn {
			_missile = _this select 6;
			_cam = "camera" camCreate (position player);
			_cam cameraEffect ["External", "Back"];
			waitUntil {
				if (isNull _missile) exitWith {true};
				_cam camSetTarget _missile;
				_cam camSetRelPos [0,-3,0];
				_cam camCommit 0;
			};
			sleep 0.4;
			_cam cameraEffect ["Terminate", "Back"];
			camDestroy _cam;
		};
	}];
	(_this select 1) removeAction (_this select 2);
	_id = (_this select 1) addAction ["Bullet Camera Off", {call JIG_removeBulletCam_fnc}, 0, -9, false];
};
JIG_removeBulletCam_fnc = {
	// remove bullet cam 
	(_this select 1) removeAction (_this select 2);
	(_this select 1) RemoveAllEventHandlers "Fired";
	_id = (_this select 1) addAction ["Bullet Camera On", {call INS_bullet_cam}, 0, -9, false];	
};
AirDrop_smoke_fnc = {
	// Pops Smoke,Flare and Chemlight at vehicle reward air drop position
	private ["_dropPos","_dropPos_grnd","_smokeColor","_chemLight1","_smoke1","_i","_flrObj","_veh"];
	
	_dropPos = _this select 0;
	_dropPos_grnd = _this select 1;
	_veh = _this select 2;
	_smokeColor = "SmokeShellBlue";
	
	_chemLight1 = createVehicle ["Chemlight_green", _dropPos_grnd, [], 0, "NONE"];
	sleep 1;
	
	_flrObj = "F_20mm_Red" createvehicle ((_veh) ModelToWorld [0,100,200]);
	_flrObj setVelocity [1,1,-10];
	sleep 0.1;
	
	_i = 0;
	while {_i < 2} do {
		_smoke1 = createVehicle [_smokeColor, [(_dropPos select 0) + 2, (_dropPos select 1) + 2, 55], [], 0, "NONE"];			
		_i = _i + 1;
		sleep 20;
	};
	
	deleteVehicle _chemLight1;
	true
};
JIG_circling_cam = {
	// Circling camera by Jigsor
	_pos = _this select 0;
	_dir = random 359;
	_maxRotation = (_dir + 45);// 360
	_camHeight = 15;
	_camDis = -30;
	_interval = 1;
	_delay = 0.01;	
	_logic_pos = [_pos select 0, _pos select 1, (_pos select 2) + 3];
	_camPos = [_pos select 0, _pos select 1, (_pos select 2) + _camHeight];
	
	_logic = createVehicle ["Land_ClutterCutter_small_F", _logic_pos, [], 0, "CAN_COLLIDE"];
	_logic setDir _dir;	
	
	_cam = "camera" camCreate _camPos;
	_cam camSetPos _camPos;
	_cam camSetTarget _logic;
	_cam camCommit 0;
	waitUntil {camcommitted _cam};

	_cam attachto [_logic, [0,_camDis,_camHeight] ];
	
	_cam cameraEffect ["internal", "BACK"];

	while {_dir < _maxRotation} do {
		_dir = _dir + _interval;
		_logic setDir _dir;
		sleep _delay;
	};

	camDestroy _cam;
	deleteVehicle _logic;
	player cameraEffect ["terminate", "BACK"];
	true
};
JIG_map_click = {
	// Air drop vehicle reward mapclick position by Jigsor
	if (player getVariable "createEnabled") then
	{	
		private "_marker";
		if !(getMarkerColor "AirDrop" isEqualTo "") then {deleteMarkerLocal "AirDrop";};
		hint "";
		GetClick = true;
		openMap true;
		waitUntil {visibleMap}; 
		[] spawn {["Click on Map for Vehicle Drop Point",0,.1,3,.005,.1] call bis_fnc_dynamictext;};
		onMapSingleClick "			
			_marker=createMarkerLocal ['AirDrop', _pos ];
			'AirDrop' setMarkerShapeLocal 'ICON';
			'AirDrop' setMarkerSizeLocal [1, 1];
			'AirDrop' setMarkerTypeLocal 'mil_dot';
			'AirDrop' setMarkerColorLocal 'Color3_FD_F';
			'AirDrop' setMarkerTextLocal 'Vehicle Air Drop Location';
			GetClick = false;
			onMapSingleClick '';
		";
		waituntil {!GetClick or !(visiblemap)};
		if (!visibleMap) exitwith {[] call JIG_map_click};
		mapAnimAdd [0.5, 0.1, markerPos 'AirDrop'];
		mapAnimCommit;
		sleep 1.2;
		openMap false;

		[] spawn {call ICE_fnc_UIinit;};	
	}else{
		(_this select 0) removeAction (_this select 2);
	};
	true
};
INS_AI_revive = {
	// Initialize Quick Revive for all group members including AI.
	if (INS_p_rev isEqualTo 4) then {		
		private ["_pA","_aiA"];
		_pA = [];
		_aiA = [];
		_grp = group player;
		
		if (count bon_recruit_queue > 0) then { waitUntil {sleep 1; count bon_recruit_queue < 1}; };		
		{if (isPlayer _x) then {_pA pushback _x;}else{_aiA pushback _x;};} forEach (units _grp);
		if (count _pA > 0) then {["btc_qr_fnc_unit_init", _grp] call BIS_fnc_MP;};
		{_x call btc_qr_fnc_unit_init;} forEach _aiA;
	};
};