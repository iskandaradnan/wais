USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[UpdateSyncGroupHubHasData]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[UpdateSyncGroupHubHasData]
    @syncGroupId uniqueidentifier,
    @hasData bit
AS
BEGIN
    UPDATE [dss].[syncgroup]
    SET
        [hubhasdata] = @hasData
    WHERE [id] = @syncGroupId
END
GO
