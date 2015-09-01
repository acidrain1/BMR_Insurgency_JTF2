bon_recruit_barracks = _this select 0;
if (leader group player != player) exitWith {
	player sideChat "Only group leaders can recuit AI";
};
createDialog "RecruitUnitsDialog";