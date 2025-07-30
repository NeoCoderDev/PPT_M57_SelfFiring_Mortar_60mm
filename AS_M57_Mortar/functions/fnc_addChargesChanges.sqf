/*
	FILE: fnc_addChargesChanges.sqf

	Name: tbd_mortars_120mm_fnc_addChargesChanges

	Author(s):
		ilbinek

	Description:
		Determines if a mine can be taken

	Parameters:
        _box    	- object    - The box
        _nbr    	- number    - Number of the mine  
		_mineClass 	- string - Classname of the mine

	Returns:
		Nothing

	Examples:
		> [_this, 5, tbd_mortar_120mm_shell_he_charge_7] call tbd_mortars_120mm_fnc_addChargesChanges;

	Public:
		No
*/

#define ADD_ACTION(var1,var2) [\
	_x,\
	"CONTAINER",\
	"Promena punjenja " + str var1,\
	nil,\
	"\a3\ui_f\data\igui\cfg\simpletasks\types\destroy_ca.paa",\
	{true},\
	{\
		params ["_unit", "", "_item", "_slot"];\
		switch _slot do {\
			case "UNIFORM_CONTAINER": {\
				["Promena punjenja", 1.5, {true}, {params ["_args"]; _args params ["_unit"]; _unit addItemToUniform format ["%1_%2", var2, var1]}, {params ["_args"]; _args params ["_unit", "_item"]; _unit addItemToUniform _item}, [_unit, _item]] call CBA_fnc_progressBar;\
			};\
			case "VEST_CONTAINER": {\
				["Promena punjenja", 1.5, {true}, {params ["_args"]; _args params ["_unit"]; _unit addItemToVest format ["%1_%2", var2, var1]}, {params ["_args"]; _args params ["_unit", "_item"]; _unit addItemToVest _item}, [_unit, _item]] call CBA_fnc_progressBar;\
			};\
			case "BACKPACK_CONTAINER": {\
				["Promena punjenja", 1.5, {true}, {params ["_args"]; _args params ["_unit"]; _unit addItemToBackpack format ["%1_%2", var2, var1]}, {params ["_args"]; _args params ["_unit", "_item"]; _unit addItemToBackpack _item}, [_unit, _item]] call CBA_fnc_progressBar;\
			};\
		};\
	},\
	true,\
	[]\
] call CBA_fnc_addItemContextMenuOption;

private _arr = ["AS_HE_M73_Krusik_0"];

{
	ADD_ACTION(0,"AS_HE_M73_Krusik")
	ADD_ACTION(1,"AS_HE_M73_Krusik")
	ADD_ACTION(2,"AS_HE_M73_Krusik")
	ADD_ACTION(3,"AS_HE_M73_Krusik")
	ADD_ACTION(4,"AS_HE_M73_Krusik")
} forEach _arr;
