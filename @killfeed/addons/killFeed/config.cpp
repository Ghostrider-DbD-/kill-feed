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
        build = 6;
        version = 0.16;
        date = "7-26-20";
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
            class addMonitoredGrave {};  //  Run on client
            class killFeedHandleKilledMessages {};
            class killFeedHandlePlayerDeath {};
            class monitorGraves {};  //  Run on client
            class studyBody {};     //  Run on client
            class buryBody {};
            class buryBody_client {};
        };
    };
};