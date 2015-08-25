// by Dirty Haz

class DH_U_Menu {
movingEnable = false;
idd = 10000;
onLoad = "uiNamespace setVariable ['DH_U_Menu', (_this select 0)];";
onUnLoad = "";
class Controls {
class Bg: DH_RscPicture {
idc = -1;
x = 0.4 * safezoneW + safezoneX;
y = 0.28 * safezoneH + safezoneY;
w = 0.2 * safezoneW;
h = 0.52 * safezoneH;
text = "#(argb,8,8,3)color(0,0,0,0.7)";
};
class Client_Settings: DH_RscButton {
idc = -1;
x = 0.425 * safezoneW + safezoneX;
y = 0.32 * safezoneH + safezoneY;
w = 0.15 * safezoneW;
h = 0.08 * safezoneH;
text = "Clients Settings";
action = "closeDialog 0; call TAWVD_fnc_openTAWVD";
};
class Toggle_Heading: DH_RscButton {
idc = -1;
x = 0.425 * safezoneW + safezoneX;
y = 0.44 * safezoneH + safezoneY;
w = 0.15 * safezoneW;
h = 0.08 * safezoneH;
text = "Toggle Heading";
action = "closeDialog 0; execVM 'scripts\gc_display_heading\heading.sqf';";
};
class Ice_Man_Hud: DH_RscButton {
idc = -1;
x = 0.425 * safezoneW + safezoneX;
y = 0.56 * safezoneH + safezoneY;
w = 0.15 * safezoneW;
h = 0.08 * safezoneH;
text = "Status Hud";
action = "closeDialog 0; execVM 'INSui\staus_hud_toggle.sqf';";
};
class Close_Dialog: DH_RscButton {
idc = -1;
x = 0.425 * safezoneW + safezoneX;
y = 0.68 * safezoneH + safezoneY;
w = 0.15 * safezoneW;
h = 0.08 * safezoneH;
text = "Close Dialog";
action = "closeDialog 0;";
};
};
};