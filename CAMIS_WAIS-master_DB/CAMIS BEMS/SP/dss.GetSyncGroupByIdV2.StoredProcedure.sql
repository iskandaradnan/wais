USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[GetSyncGroupByIdV2]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[GetSyncGroupByIdV2]
    @SyncGroupId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT
    [id],
    [name],
    [subscriptionid],
    [schema_description],
    [state],
    [hub_memberid],
    [conflict_resolution_policy],
    [sync_interval],
    [lastupdatetime],
    [ocsschemadefinition],
    [hubhasdata],
    [ConflictLoggingEnabled],
    [ConflictTableRetentionInDays]
    FROM [dss].[syncgroup]
    WHERE [id] = @SyncGroupId
END
GO
