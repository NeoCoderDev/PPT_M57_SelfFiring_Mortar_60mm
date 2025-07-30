/*
	FILE: fnc_loadShell.sqf

	Name: tbd_mortars_main_fnc_loadShell

	Description:
		Tries to load a shell into the mortar and immediately fires it

	Parameters:
		_obj    - object    - The mortar  
		_turret - number    - The turret number
		_shell  - string    - The shell className

	Returns:
		nothing
*/

params ["_obj", "_turret", "_shell"];

[0.5, [_obj, _turret, _shell], {
	private _obj = _this#0#0;
	private _turret = _this#0#1;
	private _shell = _this#0#2;

	private _magazines = magazines player;
	if (_shell in _magazines) then {
		player removeItem _shell;
		[_obj, _turret, _shell] remoteExec ["tbd_mortars_main_fnc_remoteLoadID", 2];
		[_obj, _turret, _shell] call AS_M57_Mortar_fnc_fireShell;
	} else {
		private _nearby = nearestObjects [player, ["GroundWeaponHolder"], 3];
		private _holder = objNull;
		{
			if (_shell in (magazineCargo _x)) exitWith {_holder = _x};
		} forEach _nearby;

		if (!isNull _holder) then {
			private _oldMags = magazinesAmmoCargo _holder;
			private _i = _oldMags find ([_shell, 1]);
			_oldMags set [_i, "usedRound"];
			_oldMags = _oldMags - ["usedRound"];

			if (count (weaponCargo _holder) == 0) then { _holder addWeaponCargoGlobal ['FakeWeapon', 1]; };
			clearMagazineCargoGlobal (_holder);
			{ _holder addMagazineAmmoCargo [_x select 0, 1, _x select 1] } forEach _oldMags;
			if (count (weaponCargo _holder - ['FakeWeapon']) == 0) then { clearWeaponCargoGlobal _holder };

			[_obj, _turret, _shell] remoteExec ["tbd_mortars_main_fnc_remoteLoadID", 2];
			[_obj, _turret, _shell] call AS_M57_Mortar_fnc_fireShell;
		} else {
			hint localize "STR_TBD_MORTAR_NO_SHELL";
		};
	};
}, {hint localize "STR_TBD_MORTAR_LOADING_ABORTED"}, localize "STR_TBD_MORTAR_LOADING", {true}, ["isNotInside"]] call ACE_common_fnc_progressBar;
