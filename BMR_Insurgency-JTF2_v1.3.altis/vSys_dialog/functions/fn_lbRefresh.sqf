private ["_vehArray","_listBox","_index","_cfg","_sel","_className","_displayName","_scope","_sideVehicle","_sidePlayer","_vehClass","_picture"];

_vehArray = _this select 0;
_listBox = _this select 1;
_ctrlArray = _this select 2;
_cfg = configFile >> "cfgVehicles";
_sidePlayer = getNumber (_cfg >> typeOf player >> "side");
lbClear _listBox;

for "_i" from 0 to (count (_cfg) - 1) do {
    _sel = _cfg select _i;

	if (isClass _sel) then {	
		_className = configName _sel;
		_displayName = getText (_sel >> "displayName");
		_sideVehicle = getNumber (_sel >> "side");
		_vehClass = getText (_sel >> "vehicleClass");
		_picture = getText (_sel >> "picture");
		_scope = getNumber (_sel >> "scope");

		if (_scope >= 2 && {_sideVehicle == _sidePlayer && {_vehClass in _vehArray}}) then {
			_index = lbAdd [_listBox, _displayName];
			lbSetPicture [_listBox, _index, _picture];
			lbSetData [_listBox, _index, _classname];
			lbSetToolTip [_listBox, _index, _displayName];
        };
	};
};

{
	if (_forEachIndex == 0) then {
		((uiNamespace getVariable "vSys") displayCtrl _x) ctrlSetTextColor [(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69]),(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75]),(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5]),0.85];	
	}else{
		((uiNamespace getVariable "vSys") displayCtrl _x) ctrlSetTextColor [1,1,1,1];
	};
} forEach _ctrlArray;