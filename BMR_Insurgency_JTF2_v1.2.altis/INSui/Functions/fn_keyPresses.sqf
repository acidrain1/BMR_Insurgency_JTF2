// by Dirty Haz

disableSerialization;

private ["_handled", "_D", "_Key", "_Shift", "_Ctrl", "_Alt"];

_D = _this select 0;
_Key = _this select 1;
_Shift = _this select 2;
_Ctrl = _this select 3;
_Alt = _this select 4;
_handled = false;

keyPress_U = false;

switch (_Key) do {

// U
case 22: {
if (!_Shift && !_Ctrl && !_Alt) then {
if (!keyPress_U) then {keyPress_U = true; _handled = true; closeDialog 0; createDialog "DH_U_Menu";} else {keyPress_U = false;};
};
};

};

_handled = true;