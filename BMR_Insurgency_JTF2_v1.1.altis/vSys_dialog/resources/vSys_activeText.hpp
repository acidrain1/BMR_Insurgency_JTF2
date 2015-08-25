class ICE_Air_Button: rscActiveText
{
	idc = 5000;
	x = 0.3575 * safezoneW + safezoneX;
	y = 0.31 * safezoneH + safezoneY;
	w = 0.03 * safezoneW;
	h = 0.03 * safezoneH;
	action = "[['Air'], 80000, [5000,5001,5002,5003]] call ICE_fnc_lbRefresh;";
};
class ICE_Armor_Button: rscActiveText
{
	idc = 5001;
	x = 0.4475 * safezoneW + safezoneX;
	y = 0.31 * safezoneH + safezoneY;
	w = 0.03 * safezoneW;
	h = 0.03 * safezoneH;
	action = "[['Armored'], 80000, [5001,5000,5002,5003]] call ICE_fnc_lbRefresh;";
};
class ICE_Cars_Button: rscActiveText
{
	idc = 5002;
	x = 0.5375 * safezoneW + safezoneX;
	y = 0.31 * safezoneH + safezoneY;
	w = 0.03 * safezoneW;
	h = 0.03 * safezoneH;
	action = "[['Car'], 80000, [5002,5001,5000,5003]] call ICE_fnc_lbRefresh;";
};
class ICE_Support_Button: rscActiveText
{
	idc = 5003;
	x = 0.6275 * safezoneW + safezoneX;
	y = 0.31 * safezoneH + safezoneY;
	w = 0.03 * safezoneW;
	h = 0.03 * safezoneH;
	action = "[['Support'], 80000, [5003,5001,5002,5000]] call ICE_fnc_lbRefresh;";
};
class ICE_Close_Button: rscActiveText
{
	idc = -1;
	text = "X"; 
	style = 0;
	colorText[] = {1,1,1,0.75};
	x = 0.65 * safezoneW + safezoneX;
	y = 0.2592 * safezoneH + safezoneY;
	w = 0.028 * safezoneW;
	h = 0.028 * safezoneH;
	action = "closeDialog 0";
};

    
