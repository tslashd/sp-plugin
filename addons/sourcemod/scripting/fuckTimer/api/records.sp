public void GetRecords(HTTPResponse response, any pack, const char[] error)
{
    if (response.Status != HTTPStatus_OK && response.Status != HTTPStatus_NotFound)
    {
        delete view_as<DataPack>(pack);
        SetFailState("[Records.GetRecords] Something went wrong. Status Code: %d, Error: %s", response.Status, error);
        return;
    }

    view_as<DataPack>(pack).Reset();
    int userid = view_as<DataPack>(pack).ReadCell();
    int client = userid != 0 ? GetClientOfUserId(userid) : 0;
    delete view_as<DataPack>(pack);

    int iStyles = fuckTimer_GetStyles().Size;

    if (iStyles > MAX_STYLES)
    {
        iStyles = MAX_STYLES;
    }

    for (int i = 1; i <= iStyles; i++)
    {
        if (client > 0)
        {
            if (Player[client].Records[i] != null)
            {
                RecordData record;
                IntMapSnapshot snap = Player[client].Records[i].Snapshot();

                for (int j = 0; j < snap.Length; j++)
                {
                    Player[client].Records[i].GetArray(j, record, sizeof(record));
                    delete record.Details;
                }

                delete snap;
            }

            delete Player[client].Records[i];
        }
        else
        {
            if (Core.Records[i] != null)
            {
                RecordData record;
                IntMapSnapshot snap = Core.Records[i].Snapshot();

                for (int j = 0; j < snap.Length; j++)
                {
                    Core.Records[i].GetArray(j, record, sizeof(record));
                    delete record.Details;
                }

                delete snap;
            }

            delete Core.Records[i];
        }
    }

    if (response.Status == HTTPStatus_NotFound)
    {
        LogMessage("[Records.GetRecords] We found %d records for this map", 0);
        return;
    }

    JSONArray jMainRecords = view_as<JSONArray>(response.Data);

    if (client > 0 && fuckTimer_IsClientValid(client, true, true))
    {
        LogMessage("[Records.GetRecords] We found %d player records for \"%N\" for this map", jMainRecords.Length, client);
    }
    else
    {
        LogMessage("[Records.GetRecords] We found %d records for this map", jMainRecords.Length);
    }

    JSONObject jMainRecord = null;

    for (int i = 0; i < jMainRecords.Length; i++)
    {
        jMainRecord = view_as<JSONObject>(jMainRecords.Get(i));

        RecordData record;
        record.PlayerId = jMainRecord.GetInt("PlayerId");
        jMainRecord.GetString("Name", record.PlayerName, sizeof(RecordData::PlayerName));
        record.Style = view_as<Styles>(jMainRecord.GetInt("StyleId"));
        record.Level = jMainRecord.GetInt("Level");

        char sType[12];
        jMainRecord.GetString("Type", sType, sizeof(sType));

        switch (sType[0])
        {
            case 'C':
            {
                record.Type = TimeCheckpoint;
            }
            case 'S':
            {
                record.Type = TimeStage;
            }
            default:
            {
                record.Type = TimeMain;
            }
        }

        record.Tickrate = jMainRecord.GetFloat("Tickrate");
        record.Time = jMainRecord.GetFloat("Time");
        record.Rank = jMainRecord.GetInt("Rank");
        record.TimeInZone = jMainRecord.GetFloat("TimeInZone");
        record.Attempts = jMainRecord.GetInt("Attempts");
        record.Status = jMainRecord.GetInt("Status");
        record.StartPosition[0] = jMainRecord.GetFloat("StartPositionX");
        record.StartPosition[1] = jMainRecord.GetFloat("StartPositionY");
        record.StartPosition[2] = jMainRecord.GetFloat("StartPositionZ");
        record.EndPosition[0] = jMainRecord.GetFloat("EndPositionX");
        record.EndPosition[1] = jMainRecord.GetFloat("EndPositionY");
        record.EndPosition[2] = jMainRecord.GetFloat("EndPositionZ");
        record.StartAngle[0] = jMainRecord.GetFloat("StartAngleX");
        record.StartAngle[1] = jMainRecord.GetFloat("StartAngleY");
        record.StartAngle[2] = jMainRecord.GetFloat("StartAngleZ");
        record.EndAngle[0] = jMainRecord.GetFloat("EndAngleX");
        record.EndAngle[1] = jMainRecord.GetFloat("EndAngleY");
        record.EndAngle[2] = jMainRecord.GetFloat("EndAngleZ");
        record.StartVelocity[0] = jMainRecord.GetFloat("StartVelocityX");
        record.StartVelocity[1] = jMainRecord.GetFloat("StartVelocityY");
        record.StartVelocity[2] = jMainRecord.GetFloat("StartVelocityZ");
        record.EndVelocity[0] = jMainRecord.GetFloat("EndVelocityX");
        record.EndVelocity[1] = jMainRecord.GetFloat("EndVelocityY");
        record.EndVelocity[2] = jMainRecord.GetFloat("EndVelocityZ");

        if (record.Type == TimeCheckpoint || record.Type == TimeStage)
        {
            if (record.Details == null)
            {
                record.Details = new IntMap();
            }

            JSONArray jCSRecords = view_as<JSONArray>(jMainRecord.Get("*items"));
            JSONObject jCSRecord = null;

            for (int j = 0; j < jCSRecords.Length; j++)
            {
                jCSRecord = view_as<JSONObject>(jCSRecords.Get(j));

                CSDetails details;
                int iCSLevel = jCSRecord.GetInt(record.Type == TimeStage ? "Stage" : "Checkpoint");
                details.Time = jCSRecord.GetFloat("Time");

                if (record.Type == TimeStage)
                {
                    details.TimeInZone = jCSRecord.GetFloat("TimeInZone");
                    details.Attempts = jCSRecord.GetInt("Attempts");

                    details.StartPosition[0] = jCSRecord.GetFloat("StartPositionX");
                    details.StartPosition[1] = jCSRecord.GetFloat("StartPositionY");
                    details.StartPosition[2] = jCSRecord.GetFloat("StartPositionZ");
                    details.StartAngle[0] = jCSRecord.GetFloat("StartAngleX");
                    details.StartAngle[1] = jCSRecord.GetFloat("StartAngleY");
                    details.StartAngle[2] = jCSRecord.GetFloat("StartAngleZ");
                    details.StartVelocity[0] = jCSRecord.GetFloat("StartVelocityX");
                    details.StartVelocity[1] = jCSRecord.GetFloat("StartVelocityY");
                    details.StartVelocity[2] = jCSRecord.GetFloat("StartVelocityZ");
                    details.EndPosition[0] = jCSRecord.GetFloat("EndPositionX");
                    details.EndPosition[1] = jCSRecord.GetFloat("EndPositionY");
                    details.EndPosition[2] = jCSRecord.GetFloat("EndPositionZ");
                    details.EndAngle[0] = jCSRecord.GetFloat("EndAngleX");
                    details.EndAngle[1] = jCSRecord.GetFloat("EndAngleY");
                    details.EndAngle[2] = jCSRecord.GetFloat("EndAngleZ");
                    details.EndVelocity[0] = jCSRecord.GetFloat("EndVelocityX");
                    details.EndVelocity[1] = jCSRecord.GetFloat("EndVelocityY");
                    details.EndVelocity[2] = jCSRecord.GetFloat("EndVelocityZ");
                }
                else
                {
                    details.StartPosition[0] = jCSRecord.GetFloat("PositionX");
                    details.StartPosition[1] = jCSRecord.GetFloat("PositionY");
                    details.StartPosition[2] = jCSRecord.GetFloat("PositionZ");
                    details.StartAngle[0] = jCSRecord.GetFloat("AngleX");
                    details.StartAngle[1] = jCSRecord.GetFloat("AngleY");
                    details.StartAngle[2] = jCSRecord.GetFloat("AngleZ");
                    details.StartVelocity[0] = jCSRecord.GetFloat("VelocityX");
                    details.StartVelocity[1] = jCSRecord.GetFloat("VelocityY");
                    details.StartVelocity[2] = jCSRecord.GetFloat("VelocityZ");
                }

                record.Details.SetArray(iCSLevel, details, sizeof(details));

                delete jCSRecord;
            }

            delete jCSRecords;
        }

        if (client > 0)
        {
            if (Player[client].Records[record.Style] == null)
            {
                Player[client].Records[record.Style] = new IntMap();
            }

            Player[client].Records[record.Style].SetArray(record.Level, record, sizeof(record));
        }
        else
        {
            if (Core.Records[record.Style] == null)
            {
                Core.Records[record.Style] = new IntMap();
            }

            Core.Records[record.Style].SetArray(record.Level, record, sizeof(record));
        }

        delete jMainRecord;
    }

    if (client > 0)
    {
        Call_StartForward(Core.OnPlayerRecordsLoaded);
        Call_PushCell(client);
    }
    else
    {
        Call_StartForward(Core.OnServerRecordsLoaded);
    }

    Call_PushCell(jMainRecords.Length);
    Call_Finish();
}

void PostPlayerRecord(int client, bool firstRecord, JSONObject record)
{
    // For debugging
    char sFile[PLATFORM_MAX_PATH + 1];
    BuildPath(Path_SM, sFile, sizeof(sFile), "data/fucktimer/record_%s.txt", firstRecord ? "post" : "put");
    record.ToFile(sFile, 0x1F);
    
    if (firstRecord)
    {
        fuckTimer_NewAPIHTTPRequest("Records").Post(record, SendRecord, GetClientUserId(client));
    }
    else
    {
        fuckTimer_NewAPIHTTPRequest("Records").Put(record, SendRecord, GetClientUserId(client));
    }

    JSONArray jArr = view_as<JSONArray>(record.Get("Details"));
    JSONObject jObj = null;

    for (int i = 0; i < jArr.Length; i++)
    {
        jObj = view_as<JSONObject>(jArr.Get(i));
        delete jObj;
    }

    delete jArr;
    delete record;
}

public void SendRecord(HTTPResponse response, any userid, const char[] error)
{
    if (response.Status != HTTPStatus_OK && response.Status != HTTPStatus_Created)
    {
        SetFailState("[Records.SendRecord] Something went wrong. Status Code: %d, Error: %s", response.Status, error);
        return;
    }

    char sEndpoint[32];
    FormatEx(sEndpoint, sizeof(sEndpoint), "Ranks/MapId/%d", fuckTimer_GetCurrentMapId());
    fuckTimer_NewAPIHTTPRequest("Ranks").Get(RecalculateRanks);
}

public void RecalculateRanks(HTTPResponse response, any pack, const char[] error)
{
    if (response.Status != HTTPStatus_OK)
    {
        delete view_as<DataPack>(pack);
        SetFailState("[Records.RecalculateRanks] Something went wrong. Status Code: %d, Error: %s", response.Status, error);
        return;
    }

    fuckTimer_LoopClients(client, false, false)
    {
        fuckTimer_OnPlayerLoaded(client);
    }
}
