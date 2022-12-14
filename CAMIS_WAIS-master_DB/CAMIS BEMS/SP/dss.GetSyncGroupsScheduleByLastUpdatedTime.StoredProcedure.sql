USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[GetSyncGroupsScheduleByLastUpdatedTime]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[GetSyncGroupsScheduleByLastUpdatedTime]
    @LastUpdatedTime DATETIME
AS
BEGIN
    SELECT
        [id],
        [sync_interval],
        [sync_enabled],
        [lastupdatetime]
    FROM [dss].[syncgroup]
    WHERE [lastupdatetime] >= @LastUpdatedTime
END
GO
