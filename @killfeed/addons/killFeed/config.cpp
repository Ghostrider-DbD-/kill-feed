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
        build = 3;
        version = 0.14;
        date = "7-21-20";
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
            class studyBody {};
            class buryBody {};
            class buryBody_client {};
        };
    };
};