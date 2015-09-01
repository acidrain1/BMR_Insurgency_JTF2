//commom_fncs.sqf by Jigsor

// Global hint
JIG_MPhint_fnc = { hint _this };
JIG_MPsideChatWest_fnc = { [West,"HQ"] SideChat (_this select 0); };
JIG_MPsideChatEast_fnc = { [East,"HQ"] SideChat (_this select 0); };
JIG_MPTitleText_fnc = {
	if (isDedicated) exitWith {};
	_text = _this select 0;
	copyToClipboard str(_text);
	sleep 3;
	cutText [_text,"PLAIN"];
};
Hide_Mkr_fnc = {
	private ["_mkrarray","_hidden_side"];

	_mkrarray = _this select 0;
	_hidden_side = _this select 1;

	if (side player == _hidden_side) then {
		{
			_x setmarkeralphalocal 0;
		} foreach _mkrarray;
	};
};
JIPmkr_updateServer_fnc = {
	// Stores all current intel markers' states to variable "IntelMarkers". by Jigsor
	private ["_JIPmkr","_coloredMarkers"];

	_JIPmkr = _this select 0;
	{
		if (isNil {server getVariable "IntelMarkers"}) then 
		{
			_coloredMarkers=[];
			_coloredMarkers set [count _coloredMarkers,_x];
			server setvariable ["IntelMarkers",_coloredMarkers,true];
		}else{
			_coloredMarkers=server getvariable "IntelMarkers";
			if (isnil "_coloredMarkers") then {_coloredMarkers=[];};
			_coloredMarkers set [count _coloredMarkers,_x];
			server setvariable ["IntelMarkers",_coloredMarkers,true];
		};
	}foreach _JIPmkr;
	true
};
Op4_restore_loadout = {
	_caller = _this select 1;
	[_caller] execVM "scripts\DefLoadoutOp4.sqf";
};
mhq_actions_fnc = {
	// Add action for VA and quick VA profile to respawned MHQs. by Jigsor
	private ["_veh","_var"];

	_veh = _this select 0;
	_var = _this select 1;

	switch (true) do {
		case (_var isEqualTo "MHQ_1") : {_veh addAction [("<t color=""#F56618"">") + ("Load VA profile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],JIG_load_VA_profile_MHQ1], 1, true, true, "", "true"]; _veh addAction[("<t color='#ff1111'>") + ("Open Virtual Arsenal") + "</t>",{["Open",true] call BIS_fnc_arsenal;}];};
		case (_var isEqualTo "MHQ_2") : {_veh addAction [("<t color=""#F56618"">") + ("Load VA profile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],JIG_load_VA_profile_MHQ2], 1, true, true, "", "true"]; _veh addAction[("<t color='#ff1111'>") + ("Open Virtual Arsenal") + "</t>",{["Open",true] call BIS_fnc_arsenal;}];};
		case (_var isEqualTo "MHQ_3") : {_veh addAction [("<t color=""#F56618"">") + ("Load VA profile") + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[],JIG_load_VA_profile_MHQ3], 1, true, true, "", "true"]; _veh addAction[("<t color='#ff1111'>") + ("Open Virtual Arsenal") + "</t>",{["Open",true] call BIS_fnc_arsenal;}];};
		case (_var isEqualTo "Opfor_MHQ") : {_veh addAction [("<t color=""#12F905"">") + ("Deploy MHQ") + "</t>","scripts\deployOpforMHQ.sqf",nil,1, false, true, "", "side _this != INS_Blu_side"];};
		//case (_var isEqualTo "Opfor_MHQ") : {_veh addAction [("<t color=""#12F905"">") + ("Deploy MHQ") + "</t>","scripts\deployOpforMHQ.sqf",nil,1, false, true, "", "side _this != INS_Blu_side"]; _veh addAction [("<t color=""#12F905"">") + ("Restore Loadout") + "</t>",{call Op4_restore_loadout},nil,1, false, true, "", "side _this != INS_Blu_side"];};
		case (_var isEqualTo "") : {};
	};
};
JIG_load_VA_profile_MHQ1 = {
	if (!isNil {profilenamespace getvariable "bis_fnc_saveInventory_data"}) then {
		private ["_name_index","_VA_Loadouts_Count"];
		_VA_Loadouts_Count = count (profilenamespace getvariable "bis_fnc_saveInventory_data");
		_name_index = 0;
		for "_i" from 0 to (_VA_Loadouts_Count/2) -1 do	{
			[_i,_name_index] spawn {
				private ["_name_index","_loadout_name"];
				_name_index = _this select 1;
				_loadout_name = profilenamespace getvariable "bis_fnc_saveInventory_data" select _name_index;		
				_id = MHQ_1 addAction [("<t color=""#00ffe9"">") + ("Load " + format ["%1",_loadout_name]) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[player,[profilenamespace, format ["%1", _loadout_name]]],BIS_fnc_loadInventory],8,true,true,"","true"];
				sleep 15;
				MHQ_1 removeAction _id;
			};
			_name_index = _name_index + 2;
		};
	};
};
JIG_load_VA_profile_MHQ2 = {
	if (!isNil {profilenamespace getvariable "bis_fnc_saveInventory_data"}) then {
		private ["_name_index","_VA_Loadouts_Count"];
		_VA_Loadouts_Count = count (profilenamespace getvariable "bis_fnc_saveInventory_data");
		_name_index = 0;
		for "_i" from 0 to (_VA_Loadouts_Count/2) -1 do	{
			[_i,_name_index] spawn {
				private ["_name_index","_loadout_name"];
				_name_index = _this select 1;
				_loadout_name = profilenamespace getvariable "bis_fnc_saveInventory_data" select _name_index;		
				_id = MHQ_2 addAction [("<t color=""#00ffe9"">") + ("Load " + format ["%1",_loadout_name]) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[player,[profilenamespace, format ["%1", _loadout_name]]],BIS_fnc_loadInventory],8,true,true,"","true"];
				sleep 15;
				MHQ_2 removeAction _id;
			};
			_name_index = _name_index + 2;
		};
	};
};
JIG_load_VA_profile_MHQ3 = {
	if (!isNil {profilenamespace getvariable "bis_fnc_saveInventory_data"}) then {
		private ["_name_index","_VA_Loadouts_Count"];
		_VA_Loadouts_Count = count (profilenamespace getvariable "bis_fnc_saveInventory_data");
		_name_index = 0;
		for "_i" from 0 to (_VA_Loadouts_Count/2) -1 do {
			[_i,_name_index] spawn {
				private ["_name_index","_loadout_name"];
				_name_index = _this select 1;
				_loadout_name = profilenamespace getvariable "bis_fnc_saveInventory_data" select _name_index;		
				_id = MHQ_3 addAction [("<t color=""#00ffe9"">") + ("Load " + format ["%1",_loadout_name]) + "</t>","=BTC=_revive\=BTC=_addAction.sqf",[[player,[profilenamespace, format ["%1", _loadout_name]]],BIS_fnc_loadInventory],8,true,true,"","true"];
				sleep 15;
				MHQ_3 removeAction _id;
			};
			_name_index = _name_index + 2;
		};
	};
};
mp_Say3D_fnc = {
	// code by Twirly
	private ["_obj","_snd"];

	_obj = _this select 0;//object
	_snd = _this select 1;//sound

	PVEH_netSay3D = [_obj,_snd];
	publicVariable "PVEH_netSay3D";

	if (not isDedicated) then {_obj say3D _snd};
	true
};
fnc_mp_intel = {
	// Intel addaction. by Jigsor
	private ["_intelobj","_cachepos"];

	_intelobj = _this select 0;
	_cachepos = _this select 1;

	if (!isNull _intelobj) then {
		_intelobj addAction ["<t color='#ffff00'>Grab Intel</t>", "call JIG_intel_found", _cachepos, 6, true, true, "",""];
		intel_objArray pushBack _intelobj;
	};
	if (ObjNull in intel_objArray) then {{intel_objArray = intel_objArray - [objNull]} foreach intel_objArray;};
	publicVariable "intel_objArray";
	true
};
INS_end_mssg = {
	if (!isDedicated) then
	{
		[] spawn {
		playSound "MagnusOpus";
		titleText [format["It Was an Honor to Serve with You, %1", name player], "Plain"];
		titleFadeOut 15;
		};
	}else{
		sleep 24;
	};
	true
};
hv_tower_effect = {
	if (isDedicated) exitWith {true};
	private ["_emitter","_source","_lightningpos"];
	_emitter = objective_pos_logic;
	_lightningpos = [position objective_pos_logic select 0,position objective_pos_logic select 1,10];

	_source = "#particlesource" createVehiclelocal (getPos objective_pos_logic);
	_source setParticleCircle [0,[0,0,0]];
	_source setParticleRandom [0,[0.25,0.25,0], [0.175,0.175,0],0,0.25,[0,0,0,0.1],0,0];

	_source setParticleParams [["\A3\data_f\blesk1",1,0,1],"","SpaceObject",1,0.4,_lightningpos,[0,0,3],0,10,7.9,0.075,[1.2, 2, 4],[[0.1,0.1,0.1,1],[0.25,0.25,0.25,0.5],[0.5,0.5,0.5,0]],[0.08,0,0,0,0,0,5],0.5,0,"","",_emitter];
	_source setDropInterval 0.1;

	_i = 0;
	while {_i < 3} do {
		drop ["\A3\data_f\blesk1","","SpaceObject",1,0.1,_lightningpos,[0,0,3],0,10,7.9,0.075,[1.2,2,4],[[0.1,0.1,0.1,1],[0.25,0.25,0.25,0.5],[0.5,0.5,0.5,0]],[0.08,0,0,0,0,0,5],0.5,0,"","",""];
		_i = _i + 1;
		sleep 0.1;
	};
	true
};
SVAGLOBAL = {
	// Rearm UAVs by Das Attorney. Not yet implemented into mission.
    if (local (_this select 0)) then {
        (_this select 0) setVehicleAmmo (_this select 1);
    }else{
        [_this,"SVAGLOBAL",_this select 0,FALSE] call BIS_fnc_MP;
    };
};
JIG_base_protection = {
	private "_defend";
	_defend = [(_this select 0)] spawn {
		private "_unit";
		_unit = _this select 0;
		if (isDedicated && {isPlayer _unit}) exitWith {};
		if (isDedicated) then {
			sleep 0.899;
			(vehicle _unit) call BIS_fnc_neutralizeUnit;
		}else{
			if (!isServer && {local player && _unit == player}) exitWith {
				private ["_intrude_pos","_trigPos","_dis1","_dis2"];
				_intrude_pos = (getPosATL _unit);
				_trigPos = (position trig_alarm1init);
				_dis1 = (_intrude_pos distance _trigPos);

				for '_i' from 10 to 1 step -1 do {
					hint format ["You have entered a protected zone. You've got %1 seconds to leave", _i];
					uiSleep 1;
				}; hint "";
				sleep 0.13;

				_intrude_pos = (getPosATL _unit);
				_dis2 = (_intrude_pos distance _trigPos);
				if (_dis2 <= _dis1) then {(vehicle _unit) call BIS_fnc_neutralizeUnit;};
			};
			if (local player && _unit == player) then {
				private ["_intrude_pos","_trigPos","_dis1","_dis2"];
				_intrude_pos = (getPosATL _unit);
				_trigPos = (position trig_alarm1init);
				_dis1 = (_intrude_pos distance _trigPos);

				for '_i' from 10 to 1 step -1 do {
					hint format ["You have entered a protected zone. You've got %1 seconds to leave", _i];
					uiSleep 1;
				}; hint "";
				sleep 0.13;

				_intrude_pos = (getPosATL _unit);
				_dis2 = (_intrude_pos distance _trigPos);
				if (_dis2 <= _dis1) then {(vehicle _unit) call BIS_fnc_neutralizeUnit;};
			}else{
				sleep 0.899;
				(vehicle _unit) call BIS_fnc_neutralizeUnit;
			};
		};
	};
	true
};
switchMoveEverywhere = compileFinal " _this select 0 switchMove (_this select 1); ";
INS_BluFor_Siren = compileFinal " if (isServer) then {
	[INS_BF_Siren,""siren""] call mp_Say3D_fnc;
	[[""Enemy Presence Detected at Base!""],""JIG_MPsideChatWest_fnc""] call BIS_fnc_mp;
	[INS_BF_Siren2,""siren""] call mp_Say3D_fnc;
	alarm1On = false;
}; ";