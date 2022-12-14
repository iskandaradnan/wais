USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[GetConcurrentSyncTaskCount]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[GetConcurrentSyncTaskCount]
AS
BEGIN
    SELECT COUNT(*) AS 'SyncTaskCount'
    FROM [dss].[task]
    WHERE [type] = 2 AND [state] = -1 -- type:2:sync
END
GO
