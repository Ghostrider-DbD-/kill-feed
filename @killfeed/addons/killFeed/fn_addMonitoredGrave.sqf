/*
    Copyright 2020
    By Ghostrider-GRG-

	Adds a grave to the list of graves monitored by the client
*/

if (isNil "KF_graves") then {KF_graves = []};
KF_graves pushBack [_this,diag_tickTime +3060];