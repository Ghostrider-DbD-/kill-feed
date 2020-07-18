# Killfeed-for-Epoch

After downloading and decompression the files from github do the following:

SERVER:

    pack @killfeed\addons\killfeed using any good pbo tool.

Method 1.   
    copy killfeed.pbo into @epochhive\addons

Method 2.
    Add @killfeed to "-servermod=", for eaxample like this:  "_servermod=@epochhive;@killfeed" 

CLIENT [Mission.pbo]:
4. Unpack your mission.pbo (The mission pbo would be named epoch.Altis, epoch.Tanoa, etc.)
   copy the addons folder from epoch.mapname in the download into the folder for you mission.
5. Merge the contents of description.ext from your download into description.ext in your mission.
6. Merge the contents of \epoch_config\configs\CfgRemoteExec.hpp from your download with those in your mission
6. Merge the contents of \epoch_code\customs\EPOCH_custom_EH_Killed.sqf in yoru download with the same file in your mission.
6. Adjust configuration in addons\killNessages\/cfgJukkNessages.hpp to suit your needs.
7. Repack your miission .pbo.

BATTLEYE:

8. Merge remoteexec.txt to add the exception
9. Merge createVehicle.txt with your current file to add the exception
10. merge deleteVehicle.txt with your current file to add the exceptions

INFISTAR: No changes needed.


