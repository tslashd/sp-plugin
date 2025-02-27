#if defined _fuckTimer_timer_included
    #endinput
#endif
#define _fuckTimer_timer_included

#define OFFSET_START 0
#define OFFSET_END 1
#define OFFSET_MAX 2

enum struct CSDetails
{
    float Time;
    int GoodGains;
    int SyncCount;
    int Speed;
    int SpeedCount;
    int Jumps;

    float StartPosition[3];
    float StartAngle[3];
    float StartVelocity[3];

    // Following block will only used for stages
    int Attempts;
    float TimeInZone;
    float EndPosition[3];
    float EndAngle[3];
    float EndVelocity[3];

    // Variables for Offset calculation
    float Fraction;
    float Offset[OFFSET_MAX]; // 0 - Start, 1 - End
    bool GetOffset;
}

/**
 * We use TimeType here to keep forward parameters amount lower and we don't really need another enum here.
 */
forward void fuckTimer_OnClientTimerStart(int client, int bonus, TimeType type, int level);

/**
 * This will not called when you enter/leave the start/end zone. Level means the old level with the specific time.
 */
forward void fuckTimer_OnClientZoneTouchStart(int client, bool stop, int bonus, TimeType type, int level, float time, float timeInZone, int attempts);

/**
 * This will not called when you enter/leave the start/end zone.
 */
forward void fuckTimer_OnClientZoneTouchEnd(int client, int bonus, TimeType type, int level);

/**
 * Value of each AnyMap details value is the CSDetails enum struct, get the enum struct with AnyMap.GetArray.
 */
forward void fuckTimer_OnClientTimerEnd(int client, StringMap record);

/**
 * For TimeMain is the level parameter useless, it just return the current running time.
 *
 */
native float fuckTimer_GetClientTime(int client, TimeType type, int level = 0);
native bool fuckTimer_IsClientTimeRunning(int client);

/**
 * We don't need TimeType here(?), because level 0 is non-staged maps and 1 (or higher) are the stage levels.
 */
native float fuckTimer_GetClientTimeInZone(int client, int level = 0);
native int fuckTimer_GetClientAttempts(int client, int level = 0);
native float fuckTimer_GetClientSync(int client, int level = 0);
native int fuckTimer_GetClientAVGSpeed(int client, int level = 0);
native int fuckTimer_GetClientJumps(int client, int level = 0);

native int fuckTimer_GetClientCheckpoint(int client);
native int fuckTimer_GetClientStage(int client);
native int fuckTimer_GetClientBonus(int client);

native int fuckTimer_GetClientValidator(int client);

/*
 * Bonus 0 is the normal path, all above 0 is the bonus level
 */
native int fuckTimer_GetAmountOfCheckpoints(int bonus = 0);

/*
 * Bonus 0 is the normal path, all above 0 is the bonus level
 */
native int fuckTimer_GetAmountOfStages(int bonus = 0);
native int fuckTimer_GetAmountOfBonus();

native int fuckTimer_ResetClientTimer(int client);

#if !defined REQUIRE_PLUGIN
public void __pl_fuckTimer_timer_SetNTVOptional()
{
    MarkNativeAsOptional("fuckTimer_GetClientTime");
    MarkNativeAsOptional("fuckTimer_IsClientTimeRunning");
    MarkNativeAsOptional("fuckTimer_GetClientTimeInZone");
    MarkNativeAsOptional("fuckTimer_GetClientAttempts");
    MarkNativeAsOptional("fuckTimer_GetClientSync");
    MarkNativeAsOptional("fuckTimer_GetClientAVGSpeed");
    MarkNativeAsOptional("fuckTimer_GetClientJumps");

    MarkNativeAsOptional("fuckTimer_GetClientCheckpoint");
    MarkNativeAsOptional("fuckTimer_GetClientStage");
    MarkNativeAsOptional("fuckTimer_GetClientBonus");

    MarkNativeAsOptional("fuckTimer_GetClientValidator");

    MarkNativeAsOptional("fuckTimer_GetAmountOfCheckpoints");
    MarkNativeAsOptional("fuckTimer_GetAmountOfStages");
    MarkNativeAsOptional("fuckTimer_GetAmountOfBonus");

    MarkNativeAsOptional("fuckTimer_ResetClientTimer");
}
#endif

public SharedPlugin __pl_fuckTimer_timer = 
{
    name = "fuckTimer_timer",
    file = "timer.smx",
#if defined REQUIRE_PLUGIN
    required = 1,
#else
    required = 0,
#endif
};
