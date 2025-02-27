#if defined _fuckTimer_maps_included
    #endinput
#endif
#define _fuckTimer_maps_included

typedef fuckTimer_OnGetMapTier = function void (int client, StringMap maps);

enum MapStatus {
    msInactive = 0,
    msActive = 1
}

forward void fuckTimer_OnZoneDownload(const char[] map, bool success);
forward void fuckTimer_OnMapDataLoaded();

native int fuckTimer_GetCurrentMapId();
native int fuckTimer_GetCurrentMapTier();
native MapStatus fuckTimer_GetCurrentMapStatus();

native int fuckTimer_GetMapTier(const char[] name);

/*
 *   StringMap must be closed/freed with delete (or CloseHandle) in callback.
 */
native void fuckTimer_GetMapTiers(int client = 0, const char[] name, fuckTimer_OnGetMapTier callback);

#if !defined REQUIRE_PLUGIN
public void __pl_fuckTimer_maps_SetNTVOptional()
{
    MarkNativeAsOptional("fuckTimer_GetCurrentMapId");
    MarkNativeAsOptional("fuckTimer_GetCurrentMapTier");
    MarkNativeAsOptional("fuckTimer_GetCurrentMapStatus");

    MarkNativeAsOptional("fuckTimer_GetMapTier");

    MarkNativeAsOptional("fuckTimer_GetMapTiers");
}
#endif

public SharedPlugin __pl_fuckTimer_maps = 
{
    name = "fuckTimer_maps",
    file = "maps.smx",
#if defined REQUIRE_PLUGIN
    required = 1,
#else
    required = 0,
#endif
};
