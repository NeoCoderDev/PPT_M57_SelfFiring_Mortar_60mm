params ["_mortar", "_index", "_shellClass"];

// Ubaci granatu
_mortar addMagazineTurret [_shellClass, [0]];

// Provera da li postoji gunner
private _gunner = gunner _mortar;

if (isNull _gunner) then {
    // Pokreće se samo na dedicated serveru
    if (isServer) then {
        private _grp = createGroup civilian;
        private _unit = _grp createUnit ["AS_M57_AI_Helper", getPosATL _mortar, [], 0, "NONE"];

        // Zapamti trenutni azimut i elevaciju
        private _oldDir = getDir _mortar;
        private _oldUp = vectorUp _mortar;

        _unit moveInGunner _mortar;

        // Sakrij i onesposobi AI
        _unit hideObjectGlobal true;
        _unit disableAI "ALL";
        _unit allowDamage false;

        // Opali oružje
        _mortar selectWeaponTurret ["AS_M57_weapon", [0]];
        _mortar fire "AS_M57_weapon";

        // Vraćanje tačne orijentacije cevi
        _mortar setDir _oldDir;
        _mortar setVectorUp _oldUp;

        // Ukloni AI posle kratkog vremena
        [{ deleteVehicle (_this#0) }, [_unit], 1] call CBA_fnc_waitAndExecute;
    } else {
        // Ako nije server, zatraži izvršenje na serveru
        [_mortar, _index, _shellClass] remoteExec ["AS_M57_Mortar_fnc_fireShell", 2];
    };
} else {
    // Ako postoji gunner – opali odmah
    _mortar selectWeaponTurret ["AS_M57_weapon", [0]];
    _mortar fire "AS_M57_weapon";
};
