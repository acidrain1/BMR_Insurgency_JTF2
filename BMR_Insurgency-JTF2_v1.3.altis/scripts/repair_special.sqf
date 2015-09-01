/*
 Jigsor modified etent.sqf from A2 GITS Evolution by Eggbeast
 Special action for engineers to erect a farp. Engineer must have Repair truck or Bobcat with him.
 Adding array for support trucks in INS_definitions.sqf INS_W_PlayerEng
 jig_m_obj farp is placed in editor and moved to new farp location when built
 The farp will fully repair, refuel and rearm all vehicles.
*/

_player = _this select 1;
if (vehicle _player != player) exitWith {hint "You must be on foot to build farp."};

_trk=[];
_tpresent = 0;
_trk = (nearestObjects [player, ["Car","Truck","Tank"], 50]);
sleep 0.5;
_tcount = (count _trk);

if (_tcount < 1) exitWith {hint "Move closer to repair truck"};

_tk = 0;
while {_tk <= _tcount} do
{
	_ntk = (_trk select (_tk));
	_trktype = typeOf (vehicle _ntk);
	if (_trktype in INS_W_repairTruck) then
	{
		_tpresent = 1;
		_tk =_tcount;
	};
	_tk = _tk+1;
	sleep 1;
};

if (_tpresent <1) exitWith {hint localize "STR_M04t73"};

if (!isNull epad) then {deletevehicle epad;};
if (!isNull ebox) then {deletevehicle ebox;};
_mark = format["%1farp",(name player)];
deleteMarker _mark;

player playMove "AinvPknlMstpSnonWnonDnon_medicUp0";
sleep 3.0;
WaitUntil {animationState player != "AinvPknlMstpSnonWnonDnon_medicUp0"};

epad = "Land_HelipadSquare_F" createVehicle (position player);
_pos = position epad;

_pos2 = [_pos select 0,(_pos select 1) - 18,_pos select 2];
jig_m_obj setPos (position epad);
jig_m_obj setVectorUp [0,0,1];
_pos3 = [(_pos2 select 0)+3,(_pos2 select 1)+3,_pos2 select 2];
ebox = "Box_NATO_Wps_F" createVehicle _pos3;// basic nato ammo box

_mssg = format["%1's FARP",(name player)];
_medmark = createMarker [_mark, _pos];
_medmark setMarkerShape "ICON";
_medmark setMarkerType "b_hq";
_medmark setMarkerColor "ColorGreen";
_medmark setMarkerText _mssg;
_medmark setMarkerSize [0.5, 0.5];