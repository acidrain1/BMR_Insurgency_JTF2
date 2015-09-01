//--- Spawn Protection ---//
#define SAFETY_ZONES	[["BASE BLUFOR", 250]]
#define MESSAGE			"DO NOT SHOOT in the base"
SPAWN_Restriction=["APERSBoundingMine_Range_Ammo","ATMine_Range_Ammo","DemoCharge_Remote_Ammo","SatchelCharge_Remote_Ammo","SLAMDirectionalMine_Wire_Ammo","APERSTripMine_Wire_Ammo","APERSMine_Range_Ammo","GrenadeHand","smokeshell","F_20mm_Green","F_20mm_Red","F_20mm_White","F_20mm_Yellow","F_40mm_Green","F_40mm_Cir","F_40mm_Red","F_40mm_White","F_40mm_Yellow","NLAW_F","R_TBG32V_F","R_PG32V_F","M_Titan_AP","SmokeShellBlue","SmokeShellGreen","SmokeShellOrange","SmokeShellPurple","SmokeShellRed","SmokeShell","SmokeShellYellow","G_40mm_SmokeBlue","G_40mm_SmokeGreen","G_40mm_SmokeOrange","G_40mm_SmokePurple","G_40mm_SmokeRed","G_40mm_Smoke","G_40mm_SmokeYellow","ClaymoreDirectionalMine_Remote_Ammo","mini_Grenade","GrenadeHand_stone","G_40mm_HE","M_NLAW_AT_F","M_Titan_AT","B_556x45_Ball","B_556x45_Ball_Tracer_Red","B_762x51_Ball","B_65x39_Caseless_green","B_65x39_Caseless","B_65x39_Caseless_green","B_65x39_Caseless","B_556x45_dual","B_556x45_Ball_Tracer_Yellow","B_556x45_Ball_Tracer_Green","B_408_Ball","B_45ACP_Ball","Sh_155mm_AMOS","Sh_82mm_AMOS","M_AT","M_PG_AT","B_127x99_Ball","B_762x51_Minigun_Tracer_Yellow_splash","B_762x51_Minigun_Tracer_Red_splash","B_65x39_Minigun_Caseless_Yellow_splash","B_9x21_Ball","B_65x39_Caseless_yellow","B_65x39_Caseless_yellow","B_65x39_Caseless","B_65x39_Caseless","B_127x108_Ball","B_762x51_Tracer_Green","IEDLandBig_Remote_Ammo","IEDUrbanBig_Remote_Ammo","B_762x51_Tracer_Yellow","B_762x51_Tracer_Red","B_762x54_Tracer_Green","B_762x51_Tracer_Green","Bo_GBU12_LGB","B_93x64_Ball","B_127x54_Ball","B_338_NM_Ball","B_338_Ball","IEDLandSmall_Remote_Ammo","IEDUrbanSmall_Remote_Ammo","","","","G_20mm_HE","G_40mm_HEDP","B_40mm_GPR","B_40mm_GPR_Tracer_Red","B_40mm_GPR_Tracer_Green","B_40mm_GPR_Tracer_Yellow","B_40mm_APFSDS","B_40mm_APFSDS_Tracer_Red","B_40mm_APFSDS_Tracer_Green","B_40mm_APFSDS_Tracer_Yellow"];

waitUntil {!isNull player};

player addEventHandler ["Fired", {
	if ({(_this select 0) distance getMarkerPos (_x select 0) < _x select 1} count SAFETY_ZONES > 0) then
	{
	_type = typeOf(_this select 6);

	if(_type in SPAWN_Restriction)then{
			hint format [" restricted ammo : %1", _type];
			deleteVehicle (_this select 6);
			titleText [MESSAGE, "PLAIN", 3];		
			};
	};
}];

_PlayerInAreas		= [];
_OldPlayerInAreas 	= [];
_TriggerList 	 	= [];
_Debug 				= false;

//--- Initialization for an area ---//
_MarkerName	 	= "BASE BLUFOR";
_Pos			 = getMarkerPos _MarkerName;
_SpawnProtection = createTrigger ["EmptyDetector",_Pos]; 
_SpawnProtection setTriggerArea [250,250,0,true]; 
_SpawnProtection setTriggerActivation ["ANY","PRESENT",true];
_SpawnProtection setTriggerStatements ["","",""];
_TriggerList set [ count _TriggerList, [_SpawnProtection, WEST]];
sleep 1;
while{true}do{
	{
	_InZoneArea = _x select 0;
	_InZoneArea = list _InZoneArea;
	_SideZone 	= _x select 1;
	{
//--- for infantry ---//
			if(side _x == _SideZone)then{
				_x allowDamage false;
				_PlayerInAreas set [count _PlayerInAreas, _x];
			};	
//--- for vehicle ---//
		if(side _x == _SideZone && ((_x isKindOf  "Air") ||(_x isKindOf  "Car")||(_x isKindOf  "Ship") ||(_x isKindOf  "Tank")||(_x isKindOf  "Helicopter")))then{
			if( count crew _x > 0)then{ 
					_friendlies = false;
					{
						if(side _x == _SideZone)then{_x allowDamage false;_PlayerInAreas set [count _PlayerInAreas, _x];};
					}forEach (crew _x);
				}else{_x allowDamage false;_PlayerInAreas set [count _PlayerInAreas, _x];};
			};
		}forEach _InZoneArea;
//--- Find the player who left the area and setDamage true ---//
		{
			if(!(_x in _PlayerInAreas))then{
				_x allowDamage true;
				if(_Debug)then{hint format ["left the area %1", _x];};
			}else{if(_Debug)then{hint format  ["in the area %1", _x];};};
		}forEach _OldPlayerInAreas;
	}foreach _TriggerList;
//--- refresh index---//
_OldPlayerInAreas = _PlayerInAreas;
_PlayerInAreas = [];
sleep 5;
};