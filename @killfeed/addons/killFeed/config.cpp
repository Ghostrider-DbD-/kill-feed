/*
    Copyright 2020
    By Ghostrider-GRG-
*/

class CfgPatches {
	class killFeed {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {
           // "epoch_server",
            //"a3_epoch_code"
        };
	};
};

class CfgBuild {
    class killFeed {
        build = 9;
        version = 0.19;
        date = "10-17-20";
    };
};

class CfgFunctions {
    class KF {
        class startUp {
            file="killFeed";
            class init {
                postInit = 1;
            };
        };
        class functions {
            file="killFeed";
            class killFeedHandleKilledMessages {};
            class killFeedHandlePlayerDeath {};
            class monitorGraves {};  //  Run on client
            class studyBody {};     //  Run on client
            class buryBody {};
            class buryBody_client {};
            class isZed {};
        };
    };
};