class vehicleSystem 
{
    idd = 40000;
    movingenable = true;
    onLoad = "uiNamespace setVariable ['vSys', (_this select 0)]"; 

	class Controls
	{
		#include "vSys_backGrounds.hpp"
		#include "vSys_text.hpp"
		#include "vSys_activeText.hpp"
		#include "vSys_buttons.hpp"
		#include "vSys_listBoxes.hpp"
		#include "vSys_progressBars.hpp"
	}
};

	
	
	
	

