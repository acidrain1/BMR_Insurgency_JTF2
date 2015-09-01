createDialog "vehicleSystem";
waitUntil {!isNull (findDisplay 40000) && {dialog}};
	[["Air"], 80000, [5000, 5001, 5002, 5003]] call ICE_fnc_lbRefresh;	
	
private ["_pictureAir","_pictureArmor","_pictureCar","_pictureSupport","_ctrl","_pic"];
_side = getNumber (configFile >> "cfgVehicles" >> typeOf player >> "side");

switch (_side) do {
	case 0:{
		_pictureAir = "\A3\Air_F\Heli_Light_02\Data\UI\Heli_Light_02_CA.paa";
		_pictureArmor = "\A3\armor_f_gamma\MBT_02\Data\UI\MBT_02_Base_ca.paa";
		_pictureCar = "\A3\Soft_F\MRAP_02\Data\UI\MRAP_02_base_CA.paa";
		_pictureSupport = "\A3\soft_f_gamma\Truck_02\data\UI\Truck_02_box_CA.paa";
	};
	case 1:{
		_pictureAir = "\A3\air_f_beta\Heli_Transport_01\Data\UI\Heli_Transport_01_base_CA.paa";
		_pictureArmor = "\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa";
		_pictureCar = "\A3\Soft_F\MRAP_01\Data\UI\MRAP_01_Base_ca.paa";
		_pictureSupport = "\a3\soft_f_gamma\Truck_01\Data\UI\Truck_01_box_F_CA.paa";
	};
	case 2:{
		_pictureAir = "\A3\Air_F_EPB\Heli_Light_03\data\UI\Heli_Light_03_CA.paa";
		_pictureArmor = "\A3\Armor_F_EPB\MBT_03\Data\UI\MBT_03_Ca.paa";
		_pictureCar = "\A3\soft_f_beta\MRAP_03\Data\UI\MRAP_03_Base_ca.paa";
		_pictureSupport = "\A3\soft_f_gamma\Truck_02\data\UI\Truck_02_box_CA.paa";
	};
	case default {
		_pictureAir = "\A3\air_f_beta\Heli_Transport_01\Data\UI\Heli_Transport_01_base_CA.paa";
		_pictureArmor = "\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa";
		_pictureCar = "\A3\Soft_F\MRAP_01\Data\UI\MRAP_01_Base_ca.paa";
		_pictureSupport = "\a3\soft_f_gamma\Truck_01\Data\UI\Truck_01_box_F_CA.paa";
	};
};

{
	_ctrl = _x select 0;
	_pic = _x select 1;
	((uiNamespace getVariable "vSys") displayCtrl _ctrl) ctrlSetText format ["%1", _pic]; 
} forEach [
	 [5000, _pictureAir],
	 [5001, _pictureArmor],
	 [5002, _pictureCar],
	 [5003, _pictureSupport]	
];

if (player getVariable ["cancelCreate", true]) then {
	ctrlEnable [33333, false];
}else{
	ctrlEnable [33333, true];
};

if (player getVariable ["createEnabled", true]) then {
	ctrlEnable [44444, true];
}else{
	ctrlEnable [44444, false];
};

lbSetCurSel [80000, 0];