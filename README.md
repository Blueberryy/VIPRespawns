# VIPRespawns [![Chat on Gitter](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/VIPRespawns/Lobby)
Sourcemod plugin for CS:GO. Allowing players with A-flag respawn x times per map!  
[AlliedMods](https://forums.alliedmods.net/showthread.php?p=2523408#post2523408)

## Usage
Players with the `a`-flag gets (per default) 3 respawns per map.  
To respawn, you simply use the command `!vipspawn` when dead.  
You can also check how many respawns you have left via `!spawnsleft`.  
A menu available via `!vip`, as long as it has not been disabled in config.

## Downloads
[Releases](https://github.com/condolent/VIPRespawns/releases)

## Installation
Simply download the `viprespawn.smx` file via the link above and drag the file to `/addons/sourcemod/plugins`.

Then execute command in server console:  
`sm plugins load viprespawn`

To mod the plugin you will need the `colors` include.

## Configuration
The config-file is located in `root/csgo/cfg/sourcemod/viprespawns.cfg`. In there you can change some options. For now, you can only change the amount of respawns per map is allowed.

This is how the config looks like:
```
// This file was auto-generated by SourceMod (v1.8.0.5998)
// ConVars for plugin "viprespawn.smx"

// Enable the VIP-menu called with !vip?
// (0 = Disable, 1 = Enable)
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
enable_vip_menu "1"

// Amount of times a user is allowed to respawn per map
// -
// Default: "3"
respawn_amount "3"

// Users with this flag are allowed to use the respawn command.
// Correct flagnames needs to be used: http://bit.ly/2rFMTtW
// -
// Default: "ADMFLAG_RESERVATION"
respawn_flag "ADMFLAG_RESERVATION"
```


### Credits
Props to [B2SX](https://forums.alliedmods.net/member.php?u=265974) for creating the base-code for respawns!  
What I did was clean the code a bit and added some more end-user friendly properties.
