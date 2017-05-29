#include <sourcemod>
#include <colors>
#include <cstrike>

#define CHOICE1 "#choice1"
#define CHOICE2 "#choice2"
#define VERSION "1.5.3"

int Number;
int RespawnNumber[MAXPLAYERS +1];
int RespawnLeft[MAXPLAYERS +1];

ConVar g_cvNumber;
ConVar g_cvMenu;
ConVar g_cvVIPVersion;

public Plugin myinfo = {
	name = "VIPRespawns",
	author = "Hypr & BaroNN",
	description = "Gives VIP players some respawns per map.",
	version = VERSION,
	url = "https://github.com/condolent/viprespawns"
};

public void OnPluginStart() {
	
	g_cvNumber = CreateConVar("respawn_amount", "3", "Amount of times a user is allowed to respawn per map");
	g_cvMenu = CreateConVar("enable_vip_menu", "1", "Enable the VIP-menu called with !vip?\n(0 = Disable, 1 = Enable)", _, true, 0.0, true, 1.0);
	g_cvVIPVersion = CreateConVar("viprespawn_version", VERSION, "The version of VIPRespawns you're running.", FCVAR_DONTRECORD);
	Number = g_cvNumber.IntValue;
	
	AutoExecConfig(true, "viprespawns");
	RegAdminCmd("sm_vipspawn", sm_vipspawn, ADMFLAG_RESERVATION);
	RegAdminCmd("sm_spawnsleft", sm_spawnsleft, ADMFLAG_RESERVATION);
	
	// Menu
	if(g_cvMenu.IntValue == 1) {
		RegAdminCmd("sm_vip", sm_vip, ADMFLAG_RESERVATION);
	} else {
		PrintToServer("Someone tried opening the VIP-menu, but it's disabled in the config!");
	}
}

public void OnMapStart() {
	
	for(new i = 1; i <= MaxClients;  i++) {
		
		RespawnNumber[i] = 0;
		RespawnLeft[i] = Number;
	}
	
}

// !vip
public Action sm_vip(int client, int args) {
	
	char buff[128];
	Format(buff, sizeof(buff), "Respawns left: %d", RespawnLeft[client]);
	
	Menu menu = new Menu(MenuHandler1, MENU_ACTIONS_ALL);
	menu.SetTitle("VIP Menu");
	menu.AddItem(CHOICE1, "Respawn");
	menu.AddItem(CHOICE2, buff, ITEMDRAW_DISABLED);
	menu.Display(client, 20);
	
	return Plugin_Handled;
	
}

public int MenuHandler1(Menu menu, MenuAction action, int client, int param2) {
	
	char name[MAX_NAME_LENGTH];
	GetClientName(client, name, sizeof(name));
	
	switch(action) {
		
		case MenuAction_Start:
		{
			//CPrintToChat(client, "[{green}VIPRespawns{default}] Opening menu...");
		}
		case MenuAction_Display:
		{
			char buffer[255];
			Format(buffer, sizeof(buffer), "VIP Menu", client);
			
			Panel panel = view_as<Panel>(param2);
			panel.SetTitle(buffer);
			//CPrintToChat(client, "[{green}VIPRespawns{default}] Client %d was sent menu with panel %x", name, param2);
		}
		case MenuAction_Select:
		{
			char info[32];
			menu.GetItem(param2, info, sizeof(info));
			if(StrEqual(info, CHOICE1)) {
				if(GetClientTeam(client) != CS_TEAM_SPECTATOR) {
					// Just make sure player is alive
					if(!IsPlayerAlive(client)) {
						// Has player reached the respawn limit? If not, execute!
						if(RespawnNumber[client] < Number) {
							CS_RespawnPlayer(client);
							RespawnNumber[client] += 1;
							RespawnLeft[client] -= 1;
							CPrintToChatAll("[{green}VIPRespawns{default}] %s used a Respawn!", name);	
						} else {
							CPrintToChat(client, "[{green}VIPRespawns{default}] You have used all your respawns!");
						}
					} else {
						CPrintToChat(client, "[{green}VIPRespawns{default}] You cannot respawn when alive!");
					}
				} else {
					CPrintToChat(client, "[{green}VIPRespawns{default}] You cannot respawn as spectator..");
				}
			} 
			if(StrEqual(info, CHOICE2)) {
				// Print to server console if someone actually managed to select this option somehow.. (Debugging purposes)
				PrintToServer("Client %d selected %s even though it's disabled..", name, info);
			}
		}
		case MenuAction_DrawItem:
		{
			int style;
			char info[32];
			menu.GetItem(param2, info, sizeof(info), style);
			
			if(StrEqual(info, CHOICE2)) {
				return ITEMDRAW_DISABLED;
			} else {
				return style;
			}
		}
		
	}
	return 0;
}

public Action sm_spawnsleft(int client, int args) {
	
	CPrintToChat(client, "[{green}VIPRespawns{default}] You have %d respawns left!", RespawnLeft[client]);
	
	return Plugin_Handled;
}

public Action sm_vipspawn(int client, int args) {
	
	char name[MAX_NAME_LENGTH];
	GetClientName(client, name, sizeof(name));
	
	if(GetClientTeam(client) != CS_TEAM_SPECTATOR) {
		// Make sure client is alive
		if (!IsPlayerAlive(client)) {
			
			// Check how many times client has respawned
			if(RespawnNumber[client] < Number) {
				
				CS_RespawnPlayer(client);
				RespawnNumber[client] += 1;
				RespawnLeft[client] -= 1;
				CPrintToChatAll("[{green}VIPRespawns{default}] %s used a Respawn!", name);
				
			} else {
				CPrintToChat(client, "[{green}VIPRespawns{default}] You have used all your respawns!");
			}
			
		} else {
			CPrintToChat(client, "[{green}VIPRespawns{default}] You cannot respawn when alive!");
		}
	} else {
		CPrintToChat(client, "[{green}VIPRespawns{default}] You cannot respawn as spectator..");
	}
	
	return Plugin_Handled;
}

public void OnConfigsExecuted() {
	
}