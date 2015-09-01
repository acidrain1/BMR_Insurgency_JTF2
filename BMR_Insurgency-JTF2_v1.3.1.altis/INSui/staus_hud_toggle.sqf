//staus_hud_switch.sqf by Jig

private ["_run", "_SHhandle"];

_run = true;

if (status_hud_running) exitWith
	{
	("ICE_Layer" call BIS_fnc_rscLayer) cutText ["","PLAIN"];
	status_hud_running = false;
	};

_SHhandle = [] spawn ICE_HUD;
status_hud_running = true;

while {_run} do 
	{
	if (!alive player) then 
		{
		("ICE_Layer" call BIS_fnc_rscLayer) cutText ["","PLAIN"];
		status_hud_running = false;
		_run = false;
		};

	if (status_hud_running) then 
		{
		} else 
		{
		("ICE_Layer" call BIS_fnc_rscLayer) cutText ["","PLAIN"];
		_run = false;
		};

	 uiSleep 1
	};
