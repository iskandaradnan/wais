USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[GetSyncGroupMemberHubJobId]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[GetSyncGroupMemberHubJobId]
    @SyncGroupMemberId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT [hubJobId] FROM [dss].[syncgroupmember]
    WHERE [id] = @SyncGroupMemberId
    RETURN 0
END
GO
