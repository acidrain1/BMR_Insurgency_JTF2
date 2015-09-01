class ICE_request_button: RscButton
{
	idc = 44444;
	text = "Request";
	x = 0.609375 * safezoneW + safezoneX;
	y = 0.6596 * safezoneH + safezoneY;
	w = 0.0510417 * safezoneW;
	h = 0.042 * safezoneH;
	action = "_nul = [80000] spawn ICE_fnc_createVehicle;";
	tooltip = "Create the selected vehicle";
};

class ICE_cancel_Button: RscButton
{
	idc = 33333;
	text = "Cancel";
	x = 0.55 * safezoneW + safezoneX;
	y = 0.6596 * safezoneH + safezoneY;
	w = 0.0510417 * safezoneW;
	h = 0.042 * safezoneH;
	action = "player setVariable ['cancelCreate', true]";
	tooltip = "Cancel vehicle creation";
};