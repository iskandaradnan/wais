USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dss].[ResetSyncGroupMemberHubState]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[ResetSyncGroupMemberHubState]
    @SyncGroupMemberID	UNIQUEIDENTIFIER,
    @MemberHubState		INT,
    @ConditionalMemberHubState INT
AS
BEGIN
    SET NOCOUNT ON

    UPDATE [dss].[syncgroupmember]
    SET
        [hubstate] = @MemberHubState,
        [hubstate_lastupdated] = GETUTCDATE()
    WHERE [id] = @SyncGroupMemberID AND [hubstate] = @ConditionalMemberHubState

    SELECT @@ROWCOUNT
END
GO
