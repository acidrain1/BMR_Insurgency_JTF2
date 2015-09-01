private ["_listBox","_vehClass","_className","_delay","_veh","_color","_mrk","_displayName","_dropPos","_dropPos_grnd","_mpc","_landingPos","_landingDir"];

player setVariable ["cancelCreate", false];
if (player getVariable ["createEnabled", True]) then {
	_listBox = _this select 0;
	_className = lbData [_listBox, lbCurSel _listBox];
	_displayName = lbText [_listBox, lbCurSel _listBox];
	_vehClass = getText (configFile >> "cfgVehicles" >> _className >> "vehicleClass");
	player setVariable ["createEnabled", false];

	switch (_vehClass) do {
		case "Air":{_delay = 60 * 1;};
		case "Armored":{_delay = 60 * 0.5;};
		case "Car":{_delay = 60 * 0.5;};
		case "Support":{_delay = 60 * 0.5;};
		default {_delay = 60 * 1;};
	};

	ctrlEnable [33333, true];
	ctrlEnable [44444, false];
	player sideChat format ["You've requested a %1. The vehicle will arrive via paradrop in %2 seconds.", _displayName, _delay];

	for "_i" from 0 to _delay do {
	  sleep 1;
		((uiNamespace getVariable "vSys") displayCtrl 60000) progressSetPosition (_i / _delay);
		if (player getVariable ["cancelCreate", true]) exitWith {
			ctrlEnable [33333, false];
			ctrlEnable [44444, true];
			player setVariable ["createEnabled", true];
			player sideChat "You've cancelled creation of the vehicle";
			((uiNamespace getVariable "vSys") displayCtrl 60000) progressSetPosition 0;
		};
	};

	if (!(player getVariable "cancelCreate")) then {
        ((uiNamespace getVariable "vSys") displayCtrl 60000) progressSetPosition 0;
		//_veh = createVehicle [_className, [0,0,0], [], 0, "FLY"];
		_veh = createVehicle [_className, [0,0,0], [], 0, "NONE"];
		_chute = createVehicle ["NonSteerable_Parachute_F", getMarkerPos "AirDrop", [], 0, "FLY"];
		_veh attachTo [_chute, [0,0,0]];
		deleteMarkerLocal "AirDrop";
		ctrlEnable [33333, false];
		ctrlEnable [44444, false];
		player setVariable ["createEnabled", false];
		player setVariable ["cancelCreate", true];
		player sideChat format ["Your %1 has been para dropped.", _displayName];
		_dropPos = getPosATL _veh;
		_dropPos_grnd = getPosASL _veh;
		[_dropPos,_dropPos_grnd,_veh] spawn AirDrop_smoke_fnc;

		waitUntil {getPosATL _veh select 2 < 1};
		detach _veh;
		deleteVehicle _chute;

		_landingDir = getDir _veh;
		_landingPos = getPosATL _veh;
		deleteVehicle _veh;
		_veh = createVehicle [_className, _landingPos, [], 0, "NONE"];
		_veh setDir _landingDir;

		player sideChat format ["Your %1 has touched down.", _displayName];
		_color = [side player, true] call bis_fnc_sidecolor;
		_mrk = createMarkerLocal [format ["%1", random 10000], _veh];
		_mrk setMarkerShapeLocal "ICON";
		_mrk setMarkerTypeLocal "mil_dot";
		_mrk setMarkerSizeLocal [1,1];
		_mrk setMarkerColorLocal _color;

		while {alive _veh} do {
		  sleep 1;
			switch (canMove _veh) do {
				case true:{
					_mrk setMarkerPosLocal getPosATL _veh;
					_mrk setMarkerColorLocal _color;
					if (count crew _veh == 0) then {
						_mrk setMarkerTextLocal format ["%1", _displayName];
					}else{
						_mrk setMarkerTextLocal format ["%1 [%2] - %3", _displayName, count crew _veh, {name _x} forEach crew _veh];
					};
				};
				case false:{
					_mrk setMarkerColorLocal "colorRed";
					if (count crew _veh == 0) then {
						_mrk setMarkerTextLocal format ["Immobilized %1", _displayName];
					}else{
						_mrk setMarkerTextLocal format ["Immobilized %1 [%2] - %3", _displayName, count crew _veh, {name _x} forEach crew _veh];
					};
				};
			};
		};

		if (!alive _veh) then {
			deleteMarker _mrk;
			sleep 60;
			deleteVehicle _veh;
		};
	};
};