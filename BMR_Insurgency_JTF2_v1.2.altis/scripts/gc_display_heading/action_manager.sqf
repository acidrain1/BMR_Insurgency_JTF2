// GeneralCarver Display Heading Script Action Manager Script
// Author: GeneralCarver
// Version: 2
// Date: 11/21/10
// Description: This script manages the display heading action.

// remove action from old body.
player removeaction gc_compass_actid_show;
gc_compass_actid_show = 9999;

// wait until player is alive again.
waituntil {alive player};

// re add action to player for compass.
// gc_compass_actid_show = player addAction ["Show Heading", "Scripts\gc_display_heading\heading.sqf", "", 6, false, true, "compass", ""];


// ======================================================================
// Change Log

/*
v1 - 11/4/10 - Released.
v2 - 11/21/10 - Fixed type-o in code above.
*/