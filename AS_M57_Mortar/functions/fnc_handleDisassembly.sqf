params ["_tripod", "_staticWeapon"];

// Dobavi sve magazine sa municijom iz oružja
private _mags = magazinesAmmo _staticWeapon;

{
	// Ako je granata klase TBD_2B25_HE
	if (_x#0 == "AS_HE_M73_Krusik") then {
		private _mineClass = "AS_HE_M73_Krusik";

		// Pokušaj da ubaciš minu u prsluk ili ranac
		if ((player canAddItemToVest _mineClass) || (player canAddItemToBackpack _mineClass)) then {
			if (player canAddItemToVest _mineClass) then {
				player addItemToVest _mineClass;
			} else {
				player addItemToBackpack _mineClass;
			};
		} else {
			// Ako nema mesta, stvori je na zemlji
			private _nearby = nearestObjects [player, ["GroundWeaponHolder"], 3];
			private _holder = objNull;
			if (count _nearby > 0) then {
				_holder = _nearby#0;
			};
			if (isNull _holder) then {
				_holder = "GroundWeaponHolder" createVehicle (getPosATL player);
			};
			_holder setPosATL (getPosATL player);
			_holder addMagazineCargoGlobal [_mineClass, 1];
		};
	};
} forEach _mags;
