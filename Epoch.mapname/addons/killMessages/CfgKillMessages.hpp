class CfgKillMessages {
	logPVPKills = 1;  //  set to 1 to log PVP kills in Redis
	enableStudyBody = 1;  // set to 1 to allow players to 'study' player corpses
	enableBuryBody = 1; // Set to 1 to allow players to bury bodies (players bodies only)

	class killMessages {
		showHint = 1;  //  set to 1 to show kill messages in a hint
		showSystemChat = 1;  //  Set to 1 to show kill messages in system chat
		showCutText = 1;  //  Set to 1 to show messages as a cut text.
		showEpochMessage = 0;  //  set to 1 to show messages using the EPOCH_message function
		showDynamicText = 0;  // Set to 1 to show messages using dynamic text using an adaptation of the method from Halv
		showDynamicText2 = 1;  //  Set to 1 to show messages as dynamic text using an alternative format addapted from Gr8
	};

	class studyBody {
		displaySystemChat = 1;      // Display info about corpse in side chat
		displayHint = 1;          // display info about corpse as Hint
		displayEpochMessage = 0;  // displayinfo about body as EPOCH_message
		displayCutText = 1;       // display infot about body as cutText
	};

	/*  Not really uesd yet but reserved for the future if needed */
	class burryBody {
		displaySystemChat = 1;      // Message player about grave using sideChat
		displayHint = 1;          // Message player about grave using Hint
		displayEpochMessage = 0;  // Message player about grave using EPOCH_message
		displayCutText = 1;       // Message player about grave using cutTet
	};
};