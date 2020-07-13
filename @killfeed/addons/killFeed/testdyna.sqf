_nameKiller = "dead";
_nameVictim = "trigger";
_wepPic = getText(configFile >> "CfgWeapons" >> "hgun_Pistol_heavy_01_F" >> "picture");
_distance = 100;

_dyna2Text = format["
    <t align='left'size='0.9'color='#5882FA'>%1 </t>
    <img size='1.0'align='left' image='%2'/>
    <t align='left'size='0.9'color='#c70000'> %3 </t>
    <t align='left'size='0.9'color='#FFCC00'>[%4m]</t>
    ",
    _nameKiller,
    _wepPic,
    _nameVictim,
    _distance
];
[_dyna2Text,[safezoneX + 0.01 * safezoneW,2.0],[safezoneY + 0.01 * safezoneH,0.3],30,0.5] spawn BIS_fnc_dynamicText;