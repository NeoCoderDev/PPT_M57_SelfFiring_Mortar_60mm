/*
	FILE: fnc_putMine.sqf

	Name: tbd_mortars_120mm_fnc_putMine

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
		> [_this, 5, tbd_mortar_120mm_shell_he_charge_7] call tbd_mortars_120mm_fnc_putMine;

	Public:
		No
*/



params ["_box", "_nbr", "_mineClass"];

if !([_box, _nbr, _mineClass] call AS_M57_Mortar_fnc_canPut) exitWith {};

// Find the closest mine
// Get the partial classname
_mineClass = _mineClass select [0, count _mineClass - 1];

private _mine = "";

for "_i" from 1 to 7 do {
	private _shell = format["%1%2", _mineClass, _i];
	if ([_shell] call AS_M57_Mortar_fnc_isMineNearby) exitWith {_mine = _shell};
};

if (_mine == "") exitWith {};

// Set the box to the mine
_box setVariable [format["round_%1", _nbr], 1, true];
// Animate the box
private _b = format ["mine_%1_source", _nbr];
_box animateSource [_b, 0, true];

// Remove the mine
// Check player inventory first
private _magazines = magazines player;
if (_mine in _magazines) then {
	// Mine is in players inventory, remove it from it and add it to the box
	player removeItem _mine;
} else {
	private _nearby = nearestObjects [player, ["GroundWeaponHolder"], 3];
	private _holder = objNull;
	{
		if (_mine in magazineCargo _x) exitWith {_holder = _x};
	} forEach _nearby;

	if (!isNull _holder) then {
		private _oldMags = magazinesAmmoCargo _holder;
		private _i = _oldMags find ([_mine, 1]);
		_oldMags set [_i, "usedRound"];
		_oldMags = _oldMags - ["usedRound"];

		if (count (weaponCargo _holder) == 0) then {_holder addWeaponCargoGlobal ['FakeWeapon', 1];};
		clearMagazineCargoGlobal (_holder);
		{_holder addMagazineAmmoCargo [_x select 0, 1, _x select 1]} forEach _oldMags;
		if (count (weaponCargo _holder - ['FakeWeapon']) == 0) then {clearWeaponCargoGlobal _holder};
	};
};
